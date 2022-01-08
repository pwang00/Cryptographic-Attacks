def partial_key_recovery(e,d0,N):
    
    bitlen = len(bin(d0).replace("0b",""))+1
    print(d0,bitlen)

    t = (e * d0) % N

    G.<p> = PolynomialRing(Zmod(2^bitlen))

    for k in range(1,e):
        s = -((e * d0 - 1 - k - k*N) // k) % (2 ^ bitlen)
        print(s)
        f = p^2 - s*p + N
        if len(f.small_roots()) == 0:
            print(k,f.small_roots())
        else:
            print(f.small_roots())
            print("roots:",find_roots(f,2^bitlen,N))
    #e*d0 = 1 + k (N-s+1) mod len(bin(n))

def find_roots(f,b,N):
    G.<x,y> = PolynomialRing(Zmod(b))
    for p0 in f.small_roots():
        print(p0,f.small_roots())
        q0 = (inverse_mod(Integer(p0),b) * Integer(p0)) % b
        print(q0)
        g = (b*x + p0) * (b*y + q0) - N
        '''Needs broken fix below'''
        if prod(g.small_roots()) == N:
            return g.roots()
    return -1        

def test():
    p = 23
    q = 71
    e = 23

    N = 1633
    phi = (p - 1) * (q - 1)
    d = inverse_mod(e,phi)
    d0 = int(bin(d)[-len(bin(d))//4:],2)
    partial_key_recovery(e,d0,N)
test()
