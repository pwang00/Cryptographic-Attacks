import itertools

def coppersmith_bivariate(p, X, Y, k = 2, i_0 = 0, j_0 = 1, debug=True):
    """
    Implements Coron's simplification of Coppersmith's algorithm in the bivariate case: 
    https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf

    Per the paper, Coron's simplification relies on the following result:

    Given some p(x, y) in Z[x, y], we can fix some arbitrary integer n and construct a lattice of polynomials 
    that are multiples of p(x, y) and n, and then reduce this lattice to obtain a polynomial h(x, y) with small coefficients such that 
    if h(x_0, y_0) = 0 (mod n) for some arbitrary integer n, then h(x_0, y_0) = 0 over Z holds as well. 

    :param p: bivariate polynomial p(x, y) in Z[x, y]
    :param X: Bound for root x_0 of p
    :param Y: Bound for root y_0 of p
    :param k: Determines size of the M matrix and the corresponding lattice L_2.
    :param i_0: index such that 0 <= i_0 <= deg(p), used to generate monomials x^(i + i_0)*y^(j + j_0)
    :param j_0: index such that 0 <= j_0 <= deg(p), used to generate monomials x^(i + i_0)*y^(j + j_0)
    :param debug: Turns on debugging information
    :return: The small roots x_0, y_0 of h(x, y) such that |x_0| <= X, |y_0| <= Y, and h(x_0, y_0) = 0 over Z
    """
    if len(p.variables()) != 2:
        raise ValueError("Given polynomial is not bivariate.")

    # We want to make sure that XY < W = max_ij(p_ij x^i y^j), otherwise there may not be a solution.
    d = max(p.degree(x), p.degree(y))
    W = 0

    if debug:
        print(f"Attempting to find small roots for the given polynomial over Z...")
        print(f"With parameters k = {k}, i_0 = {i_0}, j_0 = {j_0}")

    # Iterate through all the monomials of p to calculate W
    for term in p:
        p_ij, m = term
        i, j = m.degree(x), m.degree(y)
        W = max(W, p_ij * X^i * Y^j)
    
    if debug and X * Y > W^(2/(3*d)):
        print("Warning: XY > W^(2/(3*d)); a solution may not be found.")
    

    prods = list(itertools.product(range(k), range(k)))[::-1]
    prods_kd = list(itertools.product(range(k + d), range(k + d)))[::-1]
    terms = sorted([x^(i + i_0)*y^(j + j_0) for i, j in prods], reverse=True)
    
    # Generates a temporary polynomial via expanding (1 + x + x^2 + ... + x^n)(1 + y + y^2 + ... + y^n)
    # Later filters out the monomial terms whose degrees in x and y independently exceed 
    # the highest order term across all x^(i + i_0)*y^(j + j_0).
    f = sum(x^i for i in range(terms[0].degree() // 2 + 2))
    f *= f(x=y)
    
    highest_order = terms[0]
    d2 = max(highest_order.degree(x), highest_order.degree(y))

    # Make sure the left block of M corresponds to the coefficients of
    # the monomials that we care about; the ones we do are stored in `terms`
    # and the others are stored in `rest`.
    # We restrict the maximum degree independently in x, y of all terms to be less than that 
    # of the highest order term across all x^(i + i_0)*y^(j + j_0).
    rest = [t for t in list(zip(*list(f)))[1] if max(t.degree(x), t.degree(y)) <= d2 and t not in terms]
    s_terms = terms + rest    

    # Builds the matrix S and calculates n = |det S|.
    X_dim, Y_dim = k^2, k^2
    S = Matrix(ZZ, X_dim, Y_dim)

    # Puts the coefficients corresponding to each monomial in order for every row of S.
    for r, (a, b) in enumerate(prods):
        s_ab = x^a * y^b * p
        coeffs, mons = zip(*list(s_ab))
        s_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([s_dict[t] if t in s_dict else 0 for t in terms])
        S[r] = row

    n = det(S)

    # Builds the matrix M as described in the paper, which is k^2 + (k + d)^2 x (k + d)^2
    # The first k^2 rows of M consist of the coefficients of the polynomials s_ab(xX, yY) where
    # 0 <= a, b <= d.
    X_dim, Y_dim = k^2 + (k + d)^2, (k + d)^2

    # Puts the coefficients corresponding to each monomial in order for every row of S.    
    M = Matrix(ZZ, X_dim, Y_dim)
    for r, (a, b) in enumerate(prods):
        s_ab = x^a * y^b * p
        coeffs, mons = zip(*list(s_ab))
        s_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([s_dict[t] * t(x=X, y=Y) if t in s_dict else 0 for t in s_terms])
        M[r] = row

    # The next (k + d)^2 rows consist of the coefficients of the polynomials r_ab where
    # 0 <= a, b <= k + d.  Again, the coefficients for each r_ab are inserted in order corresponding
    # To each monomial term.

    for r, (i, j) in zip(range(k^2, X_dim), prods_kd):
        r_ab = x^i * y^j * n
        coeffs, mons = zip(*list(r_ab))
        r_dict = {k: v for k, v in zip(mons, coeffs)}
        row = vector([n * t(x=X, y=Y) if t in r_dict else 0 for t in s_terms])
        M[r] = row

    # Coron describes a triangularization algorithm to triangularize M, but claims that obtaining the
    # Hermite normal form of M works as well, so we do the latter since Sage already has it implemented.
    M = M.hermite_form()

    # As mentioned above, `rest` contains the monomials other than the k^2 ones we chose at the beginning.
    l = len(rest)

    # Performs LLL on L_2
    L_2 = M[list(range(k^2, k^2 + l)), list(range(k^2, k^2 + l))].LLL()

    # The first row of the LLL-reduced L_2 contains a short vector of coefficients b_1
    # corresponding to the coefficients of a polynomial h(x, y) that is not a multiple of p(x, y).
    # Irreducibility of p(x, y) implies that p(x, y) and h(x, y) are algebraically independent 
    # and that they share a root (x_0, y_0).

    # Builds h(x, y) by summing the products of monomials and their coefficient terms, and dividing out by 
    # the extra factors of X^i*Y^j.
    h = sum(coeff * term // (X^term.degree(x) * Y^term.degree(y)) for (coeff, term) in zip(L_2[0], rest))

    # Takes the resultant of h(x, y) and p(x, y).
    q = h.resultant(p, variable=y)
    
    # Obtains the roots x_i of q as a univariate polynomial in x over Z if they exist.  Sage implements this via .roots()
    # Then finds roots for q(x_i, y) as a univariate polynomial in y over Z if they exist.
    roots_x = q.univariate_polynomial().roots(multiplicities=False)

    roots_y = []
    for x_0 in roots_x:
        y_0 = p(x=x_0).univariate_polynomial().roots(multiplicities=False)
        roots_y.append(y_0[0] if y_0 else None)

    if debug and len(roots_x) > 0 and len(roots_y) > 0:
        print(f"Found roots for p:  x = {roots_x}, y = {roots_y}.")

    return roots_x, roots_y
    

if __name__ == "__main__":

    # Factors N = pq given the most significant bits of p and q.
    P.<x, y> = PolynomialRing(ZZ)
    prime_size = 512
    p = random_prime(1<<prime_size, proof=False)
    q = random_prime(1<<prime_size, proof=False)

    N = p * q

    # Lower bits of p
    lower = 300
    bits = prime_size - lower
    mask = 1 << bits
    # How many MSBs we want to preserve
    # p // mask * mask zeros out log_2(mask) number of LSBs of p 
    
    p_0 = (p // mask)
    q_0 = N // (p_0 * mask) // mask

    X, Y = mask << 1, mask << 1
    poly = (x + p_0 * mask)*(y + q_0 * mask) - N

    print("--Given arguments--")
    print(f"Size of primes: {prime_size}")
    print(f"Number of known MSBs of p: {bits}")
    print(f"N = {N}")
    print("\n")
    res = coppersmith_bivariate(poly, X, Y, k=4)
    print("\n")
    if not res:
        raise ValueError("No roots found.")
    
    x_s, y_s = res
    p_r, q_r = 0, 0

    # We need to check every combination of roots to find one such that (p_0 * 2^k + x_0)(q_0 * 2^k + y_0) = N.
    
    for x_0, y_0 in itertools.product(x_s, y_s):
        p_r = p_0 * mask + x_0
        q_r = q_0 * mask + y_0

        if p_r * q_r == N:
            print(f"Successfully factored N!")
            print(f"p = {p_r}")
            print(f"q = {q_r}")
            break

    assert p_r * q_r == N, "Recovered values were incorrect."



