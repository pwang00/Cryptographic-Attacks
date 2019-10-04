# Sage already comes built-in with a discrete logarithm function that uses a Pohlig-Hellman / BSGS backend. 
# However, it can never hurt to implement the algorithm yourself for sake of understanding.

def generate_params(threshold=2^, num_factors=100, e=6):
	""" Generates the public and private parameters for Diffie-Hellman """

	# Generates 100 primes and multiplies them together to form a modulus 
	p = prod([random_prime(threshold, proof=False) for i in range(num_factors)])

	F = GF(p)
	g, a, b = [F(randint(0, p)) for i in range(3)]

	A, B = F(g^a), F(g^b)
	
	return A, B, F


# The Pohlig-Hellman attack on Diffie-Hellman works as such:
# Given the public keys of Alice and Bob, as well as the multiplicative order
# Of the group, 

def break_params():
	A, B, F = generate_params()



