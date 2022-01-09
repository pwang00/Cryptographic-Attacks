import random

def generate_private_params(e=65537, bits=1024):
    while 1:
        p = random_prime(2^bits, proof=False)
        q = random_prime(2^bits, proof=False)

        N = p * q
        phi = (p - 1) * (q - 1)

        if gcd(phi, e) != 1:
            continue
        
        d = inverse_mod(e, phi)
        return N, d


def sign_message(m, N, d, deny=range(0, 10000)):
    # deny is the range of messages that the signer refuses to sign.
    if m in deny:
        raise ValueError("Wait that's illegal")
    s = pow(m, d, N)
    return s

def test():
    m = 10001
    m2 = 10002
    e = 65537
    target_m = 2

    N, d = generate_private_params()

    s1 = sign_message(m, N, d)
    s2 = sign_message(m2, N, d)
    r = random.randint(0, N)

    # Let's say the attacker wants to obtain a signature of m = 2.  Obviously he can't do this directly since the sender won't allows a signature for 2.
    # However, this does little to stop the attacker, who can pick an `r` in Z_n and request a signature $s$ for $r^e * m$.  
    # The signer doesn't know the attacker's intentions and assumes that because the message is not in a list of banned ones
    # It is safe to sign.  The attacker can then calculate the desired signature of $m$ by simply taking ((r^-1 mod N) * s) mod N.

    s_r = inverse_mod(r, N) * sign_message(pow(r, e, N) * target_m, N, d)
    sig_of_2 = sign_message(2, N, d, deny=[])

    assert sig_of_2 == s_r

    return s_r

if __name__ == "__main__":
    test()
