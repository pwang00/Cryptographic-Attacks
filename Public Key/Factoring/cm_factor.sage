import sys
from utils import *

sys.setrecursionlimit(100000000)

def cm_factor(N, D, B=32, debug=True):
    """
    Implements a simplified version of Cheng's 4p - 1 elliptic curve complex multiplication based factorization algorithm.
    Targets moduli where one (or many) prime factors satisfies the equality 4p_i - 1 = D * s^2, where D is a squarefree integer
    and s is a randomly generated one between an upper and lower bound.
    
    Original paper title: I want to break square-free: The 4p - 1 factorization method and its RSA backdoor viability 
    Link: https://crocs.fi.muni.cz/_media/public/papers/2019-secrypt-sedlacek.pdf
    
    :param N: integer to be factored
    :param D: squarefree integer satisfying 4p - 1 = D * s^2
    :param B: number of iterations to run the algorithm for
    :param debug: switches debugging information on/off
    :return: a tuple corresponding to p, q, or failure (-1)
    """

    # If D is not squarefree then we terminate immediately.
    assert D.is_squarefree(), "D must be squarefree."

    # Computes the -Dth Hilbert polynomial modulo N and quotient ring Q = Z_N[x] / <H_{-D, N}>

    Z_N = Zmod(N)
    P = Z_N[x]
    H = P(hilbert_class_polynomial(-D))
    Q = P.quotient_ring(H)

    # j is the equivalence class corresponding to [X] in Q.
    j = Q(x)

    # The paper claims that we can treat both 1728 - j and H as polynomials in Z_N[X] and calculate the inverse of
    # 1728 - j and H via egcd. This doesn't quite work off the shelves, so we instead accomplish this by treating 
    # 1728 - j as an element of Q = Z_N[x] / <H_{-D, n}> and lifting it back into the base ring.  
    # Sage implements this via the .lift() method.

    if debug:
        print("Calculating inverse mod of 1728 - j with H...")

    try:
        k = j * polynomial_inv_mod((1728 - j).lift(), H)
    except ValueError as e:
        r = gcd(int(e.args[1].lc()), N)
        return int(r), int(N // r)

    # Constructs an elliptic curve described by the equation y^2 = x^3 + ax + b where a = 3k and b = 2k over Q.
    # This is so we can calculate the division polynomial psi_n(a, b, x_i) later.
    E = EllipticCurve(Q, [3*k, 2*k])

    for i in range(B):

        # Obtains a random element from Z_N for the division polynomial.
        x_i = Z_N.random_element()

        if debug:
            print("Calculating division polynomial with x_i...")

        # Calculates the division polynomial modulo n: psi_n(a, b, x_i)
        z = E.division_polynomial(N, x=Q(x_i))

        # If our egcd implementation throws an exception, then we know that the r polynomial during the computation
        # has no inverse; we return this polynomial in our exception and then take the gcd of its leading coefficient with N.
        # Otherwise we take the gcd of d and N normally.
        try:
            d, _, _ = polynomial_egcd(z.lift(), H)
        except ValueError as e:
            r = gcd(int(e.args[1].lc()), N)
            return int(r), int(N // r)

        r = gcd(int(d), N)

        # Ensure that the factorization is nontrivial: i.e. r != 1 and r != N
        if 1 < r < N:
            return r, N // r
    
    return -1

if __name__ == "__main__":
    D = 419
    # Generates a modulus N = pq where 4p - 1 = Ds^2.

    print("Generating modulus...")
    p = generate_cm_prime(D)
    q = random_prime(1<<1024, proof=False)

    N = p * q
    print("Factoring...")
    r, s = cm_factor(N, D)
    assert r * s == N
    print(f"Factorization successful! N = {r} * {s}")