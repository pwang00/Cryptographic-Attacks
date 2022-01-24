# Sage already comes built-in with a discrete logarithm function that uses a Pohlig-Hellman / BSGS backend. 
# However, it can never hurt to implement the algorithm yourself for sake of understanding.


def generate_params(B=2^10, num_factors=15):
    """ Generates the public and private parameters for Diffie-Hellman """

    # Generates num_factors primes and multiplies them together to form a modulus 
    p = 1

    # Currently the best way I can think of to generate primes p such that p - 1 is B-smooth
    while not is_prime(p):
        p = 2 * prod([random_prime(B, proof=False) for i in range(num_factors)]) + 1

    F = GF(p)
    g, a, b = [F(randint(0, p)) for i in range(3)]

    A, B = g^a, g^b
    
    assert A^b == B^a and gcd(g, p - 1) == 1
    return g, A, B, F

# The Baby-Step Giant Step (BSGS) algorithm helps reduce the complexity of calculating the discrete logarithm
# g_i^x_i mod p_i = h_i to O(sqrt(p_i)) instead of O(p_i) with traditional brute force.  The way BSGS works is that
# We rewrite the discrete logarithm x_i in terms of im + j, where m = ceil(sqrt(n)).  This allows for a meet-in-the-middle
# style calculation of $x$--namely, we first calculate g^j mod p for every 0 <= j < m, and then calculate g^i mod p for 
# 0 <= j <= p, multiplying by a^-m for every y not equal to 

def BSGS(g, A, n, G):
    # Normally ceil(sqrt(n)) should work but for some reason some test cases break this
    m = ceil(sqrt(n)) + 1
    y = A
    log_table = {}

    for j in range(m):
        log_table[j] = (j, g^j)

    inv = g^-m
    
    for i in range(m):
        for x in log_table.keys():
            if log_table[x][1] == y:
                return i * m + log_table[x][0]
    
        y *= inv

    return None

# The Pohlig-Hellman attack on Diffie-Hellman works as such:
# Given the generator, public keys of either Alice or Bob, as well as the multiplicative order
# Of the group (which in Diffie-Hellman is p - 1 due to prime modulus), 
# one can factor the group order (which by construction here is B-smooth) into 
# Small primes.  By Lagrange's theorem, we have that


def pohlig_hellman(g, A, F, debug=True):
    """ Attempts to use Pohlig-Hellman to compute discrete logarithm of A = g^a mod p"""
    
    # This code is pretty clunky, naive, and unoptimized at the moment, but it works.

    p = F.order() 
    factors = [p_i ^ e_i for (p_i, e_i) in factor(F.order() - 1)]
    crt_array = []

    if debug:
        print("[x] Factored |F_p| = p - 1 into %s" % factors)

    for p_i in factors:
        g_i = g ^ ((p - 1) // p_i)
        h_i = A ^ ((p - 1) // p_i)
        x_i = BSGS(g_i, h_i, p_i, GF(p_i))
        if debug and x_i != None:
            print("[x] Found discrete logarithm %d for factor %d" % (x_i, p_i))
            crt_array += [x_i]
        elif x_i == None:
            print("[] Did not find discrete logarithm for factor %d" % p_i)


    return crt(crt_array, factors)

def test():

    # Not sure why B is here, it isn't even used
    print("Generating parameters...")
    g, A, B, F = generate_params()
    print("Attempting Pohlig-Hellman factorization with \ng = %d\nA = %d\nF is a finite field with order %d\n" 
        % (g, A, F.order()))
    a = pohlig_hellman(g, A, F)
    assert g^a == A
    print("[x] Recovered exponent a such that g^a = A through Pohlig-Hellman: %d" % a)

if __name__ == "__main__":
    test()

# Test case that broke BSGS (missed calculating the discrete logarithm for p = 2 apparently)

#F = GF(57709937095736748707766266121061070270736984391755037161746092145800428699901267064992500100452120323)
#g = F(6862230423439704800599635372588241766443241516687730839067524319148439812277727596294137046769507421)
#A = F(35109578903356652282583091316434534076329783688364219256182342958633264942467664701017935316905285284)
    
