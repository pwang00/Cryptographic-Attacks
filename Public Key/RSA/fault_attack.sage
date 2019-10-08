# This file contains an implementation of a fault attack on RSA-CRT signatures 

def generate_params(target_bitlen=1024, e=65537):
	p = random_prime(2^target_bitlen//2, proof=False)
	q = random_prime(2^target_bitlen//2, proof=False)

	N = p * q
	dp = d % (p - 1)
	dq = d % (q - 1)

	qinv = inverse_mod(q, p)
	
	return N, dp, dq, e, q_inv


# Signature method that flips a random bit in dq with probability 0.5

def sign(m, N, p, q, e, dp, dq, qinv, error_prob=1):
	s1 = pow(m, dp, p)
	s2 = pow(m, dq, q)
	
	if random() > 1 - error_prob:
		s2 ^^= 2^randint(0, 512)
	
	h = (qinv * (s1 - s2)) % p
	s = s2 + h * q

	return s

# The attacker will already know m1 and m2 since he's trying to obtain signatures for them
# With sufficently high probability, gcd(s1 - m1, s2 - m2) will reveal one of the factors of N
def factor_n(s1, s2, m1, m2, N):
	q = gcd(s1 - m1, s2 - m2)
	if q != 1:
		p = N // q

	return p, q

def test():
	N, dp, dq, e, q_inv = generate_params()
	m1 = randint(0, 2^512)
	m2 = randint(0, 2^512)
	
	# Waaaaaaaaayy too many parameters for a simple function, will definitely simplify
	# In the near future

	s1 = sign(m, N, p, q, e, dp, dq, qinv)
	s2 = sign(m, N, p, q, e, dp, dq, qinv)

	factor_n(s1, s2, m1, m2)

	if p != N or q != N:
		print("[x] Obtained factors for N!")


if __name__ == "__main__":
	test()

