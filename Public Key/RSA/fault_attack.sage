# This file contains an implementation of a fault attack on RSA-CRT signatures 

def generate_params(target_bitlen=1024, e=65537):
    p = random_prime(2^target_bitlen//2, proof=False)
    q = random_prime(2^target_bitlen//2, proof=False)

    N = p * q
    d = inverse_mod(e, (p - 1) * (q - 1))
    dp = d % (p - 1)
    dq = d % (q - 1)

    qinv = inverse_mod(q, p)
    pinv = inverse_mod(p, q)
    return N, p, q, dp, dq, e, qinv, pinv


# Signature method that flips a random bit in dq with probability error_prob

def sign(m, N, p, q, e, dp, dq, qinv, pinv, error_prob=1):
    s1 = Integer(pow(m, dp, p))
    s2 = Integer(pow(m, dq, q))
    
    if random() > 1 - error_prob:
        s2 ^^= 2 ^ randint(2, 512)

    s = (s1 * q * qinv) + (s2 * p * pinv) % N

    return s

# The attacker will already know m1 since he's trying to obtain signatures for them
# With sufficently high probability, gcd(s1 - m1, N) will reveal one of the factors of N
def factor_n(s1, e, m1, N):
    p = 1
    q = gcd(s1^e - m1, N)
    if q != 1:
        p = N // q

    return p, q

def test():
    N, p, q, dp, dq, e, qinv, pinv = generate_params()
    m1 = randint(0, 2^512)
    
    # Waaaaaaaaayy too many parameters for a simple function, will definitely simplify
    # In the near future

    s1 = sign(m1, N, p, q, e, dp, dq, qinv, pinv)

    p, q = factor_n(s1, e, m1, N)

    if p != N and q != N:
        print("[x] Obtained factors for N!")
    print(p, q)

if __name__ == "__main__":
    test()

