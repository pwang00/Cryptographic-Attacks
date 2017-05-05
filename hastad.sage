"""
Sage implementation of Hastad's broadcast attack on large public exponent / small private key
"""

import binascii

def hastad(ciphertexts, moduli, e=3):
    """
    Performs a Hastad's attack on non-padded ciphertexts
    M = Message
    ciphertexts = ciphertext array
    moduli = moduli array
    """
    if len(moduli) == len(ciphertexts) == e:
            raise RuntimeError("Moduli and ciphertext arrays have to be equal in length, and contain at least as many elements as e")

    M = crt(ciphertexts, moduli).nth_root(e)
            return M

def convert_to_int(message):
    return int(message.encode("hex"),16)

def decode(message):
    return message.decode("hex")


""" Test / Proof of Correctness """

m = convert_to_int("hello")
e = 3

ciphertexts = []
moduli = []

for i in range(e):
    p = random_prime(1000000000000000000000)
    q = random_prime(1000000000000000000000)
    n = p*q
    c = Integer(pow(m, e, n))
    moduli.append(Integer(n))
    ciphertexts.append(c)
    print(moduli,ciphertexts)

assert hastad(ciphertexts,moduli,e) == m

#TODO: Add detection and solver for linear padding


