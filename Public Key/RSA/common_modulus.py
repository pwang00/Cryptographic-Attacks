import binascii
from fractions import gcd

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise ValueError('Modular inverse does not exist.')
    else:
        return x % m

def common_modulus(c1, c2, e1, e2, N):
    if gcd(e1, e2) != 1:
        raise ValueError("e1 and e2 must be coprime")
    s1 = modinv(e1,e2)
    s2 = (gcd(e1,e2) - e1 * s1) / e2
    temp = modinv(c2, N)
    m1 = pow(c1,s1,N)
    m2 = pow(temp,-s2,N)
    return (m1 * m2) % N
    #print((s1 * e1 + s2 * e2)%n)

def test():
    m = int("hello".encode("hex"),16)
    n = 8574590275353150468066547476183381115398889704640798625862515118366969210809173375959624391568226984506878991189446348229752268497137248682204584792705299
    e1 = 7
    e2 = 11
    m_recovered = common_modulus(pow(m,e1,n),pow(m,e2,n),e1,e2,n)
    assert m_recovered == m
    print("Success!")
    return 0

test()
