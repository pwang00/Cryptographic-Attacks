# Sage does not implement xgcd or modular multiplicative inverses for polynomials over composite rings, so 
# We just roll our own implementation here (which is really adapted pseudocode from Wikipedia)
import random
from sage.all import *

def polynomial_egcd(f, g):
    """
    Calculates the polynomial inverse of f with respect to g.
    :param f: a univariate polynomial.
    :param g: a univariate polynomial.
    :return: a polynomial h such that f*h = 1 (mod g)
    """    
    old_r, r = f, g
    old_s, s = 1, 0
    old_t, t = 0, 1

    while r != 0:
        try:
            q = old_r // r
            old_r, r = r, old_r - q * r
            old_s, s = s, old_s - q * s
            old_t, t = t, old_t - q * t
        except:
            raise ValueError("No inverse for r in Q.", r)

    return old_r, old_s, old_t

def polynomial_inv_mod(f, g):
    """
    Calculates the polynomial inverse of f with respect to g.
    :param f: a univariate polynomial.
    :param g: a univariate polynomial.
    :return: a polynomial h such that f*h = 1 (mod g)
    """    
    g, s, _ = polynomial_egcd(f, g)

    if g.degree() > 1:
        raise ValueError("No polynomial inverse exists.")

    return s * g.lc()**-1

def generate_cm_prime(D, n=512):
    """
    Generates an approximately 2n-bit prime p such that 4p - 1 = D * s^2
    :param D: a squarefree integer.
    :param n: bit-length of s.
    :return: prime p
    """
    assert D.is_squarefree(), "D must be squarefree."

    while True:
        s = randint(2**n, 2**(n + 1) - 1)
        t = D * s**2 + 1
        p = t // 4

        if is_prime(p) and t % 4 == 0:
            return p