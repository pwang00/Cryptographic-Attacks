import random

def franklin_reiter(c_array, N, r, e=3):
	P.<x> = PolynomialRing(Zmod(N))
	c1, c2 = c_array
	equations = [x ^ e - c1, (x + r) ^ e - c2]
	g1, g2 = equations
	print(type(g1))
	return -composite_gcd(g1,g2).coefficients()[0]

def composite_gcd(g1,g2):
	return g1.monic() if g2 == 0 else composite_gcd(g2, g1 % g2)

def test():
	N = random_prime(2^50) * random_prime(2^50)
	m = int("hello".encode("hex"),16)
	r = random.randint(0,N)
	c_array = [pow(m,3,N),pow(m+r,3,N)]
	print(franklin_reiter(c_array,N,r))

test()
