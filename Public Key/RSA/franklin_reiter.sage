import random
import binascii

def coppersmith_short_pad(C1, C2, N, e = 3, eps = 1/100):
	P.<x, y> = PolynomialRing(Zmod(N))
	P2.<y> = PolynomialRing(Zmod(N))

	g1 = (x^e - C1).change_ring(P2)
	g2 = ((x + y)^e - C2).change_ring(P2)
 
	# Finds resultant of g1 and g2 in the polynomial ring Z_N[y]
	res = g1.resultant(g2)

	# coppersmith's small_roots only works over univariate polynomial rings, so we 
	# convert the resulting polynomial to its univariate form and take the coefficients modulo N
	# Then we can call the sage's small_roots function and obtain the delta between m_1 and m_2.


	roots = res.univariate_polynomial().change_ring(Zmod(N))\
		.small_roots(epsilon = epsilon)

	return roots[0]

def franklin_reiter(C1, C2, N, r, e=3):
	P.<x> = PolynomialRing(Zmod(N))
	equations = [x ^ e - C1, (x + r) ^ e - C2]
	g1, g2 = equations
	return -composite_gcd(g1,g2).coefficients()[0]

def recover_message(C1, C2, N, e = 3):
	delta = coppersmith_short_pad(C1, C2, N)
	recovered = franklin_reiter(C1, C2, N, delta)
	return recovered
	
def composite_gcd(g1,g2):
	return g1.monic() if g2 == 0 else composite_gcd(g2, g1 % g2)

def test():
	N = random_prime(2^50) * random_prime(2^50)
	m = int(binascii.hexlify(b"hello"), 16)
	r = random.randint(0,2^8)
	C1 = pow(m,3,N)
	C2 = pow(m+r,3,N)
	print(recover_message(C1, C2, N))

if __name__ == "__main__":
	test()
