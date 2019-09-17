"""
Sage implementation of Hastad's broadcast attack for small public exponent and multiple message/ciphertext pairs
"""

import binascii
import random

def hastad(ciphertexts, moduli, e=3):
    """
    Performs a Hastad's attack on non-padded ciphertexts
    M = Message
    ciphertexts = ciphertext array
    moduli = moduli array
    """

    if not (len(moduli) == len(ciphertexts) == e):
            raise RuntimeError("Moduli and ciphertext arrays have to be equal in length, and contain at least as many elements as e")

    M = crt(ciphertexts, moduli).nth_root(e)
    return M

def linear_padding(ciphertexts, moduli, pad_array, const_array=(), e=3, eps=1/8):
    if not(len(ciphertexts) == len(moduli) == len(pad_array) == len(const_array) == e):
        raise RuntimeError("Moduli and ciphertext arrays have to be equal in length, and contain at least as many elements as e")

    '''
    Initialization with placeholders
    ciphertexts: ciphertext array
    T_array: Chinese Remainder Theorem coefficients
    moduli: Modulus array
    pad_array: Linear coefficient of padding applied to the message during encryption
    const_array: constant pad added to message during encryption (optional)
    '''
    T_array = [Integer(0)]*e
    crt_array = [Integer(0)]*e
    polynomial_array = []

    for i in range(e):
        crt_array = [0]*e
        crt_array[i] = 1
        T_array[i] = Integer(crt(crt_array,moduli))

    G.<x> = PolynomialRing(Zmod(prod(moduli)))
    for i in range(e):
        polynomial_array += [T_array[i]*((pad_array[i]*x+const_array[i])^e - Integer(ciphertexts[i]))] #Representation of polynomial f(x) = (A*x + b) ^ e - C where (A*x + b) is the padding polynomial

    g = sum(polynomial_array).monic()  #Creates a monic polynomial from the sum of the individual polynomials
    roots = g.small_roots(epsilon=eps)
    return roots[0] if len(roots) >= 1 else -1


def convert_to_int(message):
    return int(message.encode("hex"),16)

def decode(message):
    return message.decode("hex")

""" Test / Proof of Correctness """

def test_no_padding():
    m = convert_to_int("hello")
    e = 3
    bound = 2^1024
    ciphertexts = []
    moduli = []

    for i in range(e):
        p = random_prime(bound,proof=false)
        q = random_prime(bound,proof=false)
        n = p*q
        c = Integer(pow(m, e, n))
        moduli += [Integer(n)]
        ciphertexts += [c]

    assert hastad(ciphertexts,moduli,e) == m
    print("Success! The recovered message is equal to: " + hex(m)[2:].decode("hex"))

    return 0

def test_linear_padding():
    moduli = []
    ciphertexts = []
    pad_array = []
    const_array = []
    e = 3
    pad_bound = 2^512
    prime_bound = 2^1024
    m = convert_to_int("p00rth0_th3_p00r")

    for i in range(e):
        pad = random.randint(0,pad_bound)
        constant = random.randint(0,pad_bound)
        pad_array += [pad]
        const_array += [constant]
        p = random_prime(prime_bound,proof=false)
        q = random_prime(prime_bound,proof=false)
        n = p*q
        moduli += [n]
        ciphertexts.append(pow(pad * m + constant,e,n))

    assert linear_padding(ciphertexts, moduli, pad_array, const_array) == m
    print("Success!")
    return 0
