# Sage already comes built-in with a discrete logarithm function that uses a Pohlig-Hellman / BSGS backend. 
# However, it can never hurt to implement the algorithm yourself for sake of understanding.


def generate_params(B=2^10, num_factors=8):
    """ Generates the public and private parameters for Diffie-Hellman """

    # Generates num_factors primes and multiplies them together to form a modulus 
    p = 1

    # Apparently it's possible to generate curves of desired order using complex multiplication,
    # but that's out of scope for this script.  Instead, we'll set a bound on the private keys based on $B$.

    while not is_prime(p):
        p = 2 * prod([random_prime(B, proof=False) for i in range(num_factors)]) + 1

    F = GF(p)

    a4 = randint(0, num_factors * B)
    a6 = randint(0, num_factors * B)
    kA = randint(0, p)
    kB = randint(0, p)

    E = EllipticCurve(F, [a4, a6])
    G = E.gens()[0]

    PA = kA * G
    PB = kB * G
    
    assert PA * kB == PB * kA
    return G, PA, E

# The Baby-Step Giant Step (BSGS) algorithm helps reduce the complexity of calculating the discrete logarithm
# g_i^x_i mod p_i = h_i to O(sqrt(p_i)) instead of O(p_i) with traditional brute force.  The way BSGS works is that
# We rewrite the discrete logarithm x_i in terms of im + j, where m = ceil(sqrt(n)).  This allows for a meet-in-the-middle
# style calculation of $x$--namely, we first calculate g^j mod p for every 0 <= j < m, and then calculate g^i mod p for 
# 0 <= j <= p, multiplying by a^-m for every y not equal to 

def BSGS(G, PA, n, E):

    # Normally ceil(sqrt(n)) should work but for some reason some test cases break this
    M = ceil(sqrt(n)) + 1
    y = PA
    log_table = {}
    
    for j in range(M):
        log_table[j] = (j, j * G)

    inv = -M * G
    
    for i in range(M):
        for x in log_table:
            if log_table[x][1] == y:
                return i * M + log_table[x][0]
    
        y += inv
        
    return None

# The Pohlig-Hellman attack on Diffie-Hellman works as such:
# Given the generator, public keys of either Alice or Bob, as well as the multiplicative order
# Of the group (which in Diffie-Hellman is p - 1 due to prime modulus), 
# one can factor the group order (which by construction here is B-smooth) into 
# Small primes.  By Lagrange's theorem, we have that


def pohlig_hellman_EC(G, PA, E, debug=True):
    """ Attempts to use Pohlig-Hellman to compute discrete logarithm of A = g^a mod p"""
    
    # This code is pretty clunky, naive, and unoptimized at the moment, but it works.

    n = E.order() 
    factors = [p_i ^ e_i for (p_i, e_i) in factor(n)]
    crt_array = []

    if debug:
        print("[x] Factored #E(F_p) into %s" % factors)

    for p_i in factors:
        g_i = G * (n // p_i)
        h_i = PA * (n // p_i)
        x_i = BSGS(g_i, h_i, p_i, E)
        if debug and x_i != None:
            print("[x] Found discrete logarithm %d for factor %d" % (x_i, p_i))
            crt_array += [x_i]
        
        elif x_i == None:
            print("[] Did not find discrete logarithm for factor %d" % p_i)


    return crt(crt_array, factors)

def test():

    # Not sure why B is here, it isn't even used
    print("Generating parameters...")
    G, PA, E = generate_params()
    print("Attempting Pohlig-Hellman factorization with \nG = %s\nPA = %s\nE is an %s\n" 
        % (G, PA, E))
    kA = pohlig_hellman_EC(G, PA, E)
    assert kA * G == PA
    print("[x] Recovered scalar kA such that PA = G * kA through Pohlig-Hellman: %d" % kA)

if __name__ == "__main__":
    test()