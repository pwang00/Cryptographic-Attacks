# Implements Coron's simplification of Coppersmith's algorithm in the bivariate case: 
# https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf

# Per the paper, Coppersmith's algorithm relies on two core theorems:

# Theorem 1: 

# Given some p(x) = 0 (mod N) with N unknown, any root x_0 with |x_0| < N^(1/d) with d = deg(p) can be found in polynomial time.
# This may be done by building a lattice of solutions to p(x) and then reducing the lattice via LLL.  This was simplified by 
# Howgrave-Graham, who instead build directly a lattice of polynomials that are multiples of both p(x) and N; via LLL, obtain a new 
# polynomial h(x) such that h(x_0) = 0 (mod N^k), and if h has small enough coefficients, then h(x_0) = 0 over Z holds as well. 

# Theorem 2:

# Given some p(x, y) in Z[x, y], we can fix some arbitrary integer n and construct a lattice of polynomials 
# that are multiples of p(x, y) and n, and then reduce this lattice to obtain a polynomial h(x, y) with small coefficients such that 
# if h(x_0, y_0) = 0 (mod n) for some arbitrary integer n, then h(x_0, y_0) = 0 over Z holds as well.

# Inputs:

# X, Y, p(x, y)

# Outputs: The small roots x_0, y_0 of h(x, y) such that |x_0| <= X, |y_0| <= Y, and h(x_0, y_0) = 0 over Z

import itertools

def coppersmith_bivariate(p, X, Y, debug=True):


    if debug:
        print(f"Attempting to find small roots for polynomial {p} over Z...")
        
    # We want to make sure that XY < W = max_ij(p_ij x^i y^j), otherwise there may not be a solution.
    d = max(p.degree(x), p.degree(y))
    W = 0

    w = len(p.coefficients())

    # Iterate through all the monomials of p to calculate W
    for term in p:
        p_ij, m = term
        i, j = m.degree(x), m.degree(y)
        W = max(W, p_ij * X^i * Y^j)
    
    if debug and X * Y > W^(2/(3*d)):
        print("Warning: XY > W^(2/(3*d)); a solution may not be found.")

    k = 2

    # i_0, j_0 satisfy 0 <= i_0, j_0 <= d
    i_0, j_0 = (1, 1)
    
    prods = list(itertools.product(range(k), range(k)))[::-1]
    prods_kd = list(itertools.product(range(k + d), range(k + d)))[::-1]
    terms = sorted([x^(i + i_0)*y^(j + j_0) for i, j in prods], reverse=True)
    
    f = sum(x^i for i in range(terms[0].degree() // 2 + 2))
    f *= f(x=y)
    
    highest_order = terms[0]
    d2 = max(highest_order.degree(x), highest_order.degree(y))

    # Make sure the left block of M corresponds to the coefficients of
    # the monomials that we care about
    rest = [t for t in list(zip(*list(f)))[1] if max(t.degree(x), t.degree(y)) <= d2 and t not in terms]
    s_terms = terms + rest    
    
    r_terms = sorted([x^i*y^j for i, j in prods_kd], reverse=True)

    # Builds the matrix S and calculates n = |det S|; since S is triangular with diagonal
    # a, this evaluates to a^(k^2).
    # We start with a matrix 
    X_dim, Y_dim = k^2, k^2
    S = Matrix(ZZ, X_dim, Y_dim)

    for r, (a, b) in enumerate(prods):
        s_ab = x^a * y^b * p
        coeffs, mons = zip(*list(s_ab))
        s_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([s_dict[t] if t in s_dict else 0 for t in terms])
        S[r] = row

    n = det(S)
    # Builds the matrix M by stacking the S and R blocks.  The S block is 
    X_dim, Y_dim = k^2, (k + d)^2
    
    M = Matrix(ZZ, X_dim, Y_dim)
    for r, (a, b) in enumerate(prods):
        s_ab = x^a * y^b * p
        coeffs, mons = zip(*list(s_ab))
        s_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([s_dict[t] * t(x=X, y=Y) if t in s_dict else 0 for t in s_terms])
        M[r] = row

    R = Matrix(ZZ, (k + d)^2, Y_dim)

    for r, (i, j) in zip(range((k + d)^2), prods_kd):
        r_ab = x^i * y^j * n
        coeffs, mons = zip(*list(r_ab))
        r_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([n * t(x=X, y=Y) if t in r_dict else 0 for t in s_terms])
        R[r] = row

    R = R.echelon_form()

    # M after stacking is now k^2 + (k + d)^2 by (k + d)^2.
    M = M.stack(R).hermite_form()

    l = len(rest)
    L_2 = M[list(range(k^2, k^2 + l)), list(range(k^2, k^2 + l))]
    
    L_2 = L_2.LLL()
    h = sum(coeff * term // (X^term.degree(x) * Y^term.degree(y)) for (coeff, term) in zip(L_2[0], rest))
    q = h.resultant(p, variable=y)
    
    roots_x = q.univariate_polynomial().roots(multiplicities=False)
    roots_y = []
    for x_0 in roots_x:
        y_0 = p(x=x_0).univariate_polynomial().roots(multiplicities=False)
        roots_y.append(y_0[0] if y_0 else None)

    if debug and len(roots_x) > 0 and len(roots_y) > 0:
        print(f"Found roots for p:  x = {roots_x}, y = {roots_y}.")

    return roots_x, roots_y
    

if __name__ == "__main__":
    P.<x, y> = PolynomialRing(ZZ)
    p = 127*x*y - 1207*x - 1461*y + 21

    print(coppersmith_bivariate(p, 30, 20))