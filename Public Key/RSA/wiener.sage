import math

def recover(e,N):
    cf = convergents(e/N)
    G.<x> = ZZ['x']
    for index, k in enumerate(cf[1:]):
        d0 = k.denominator()
        k = k.numerator()
        if k != 0 and (e * d0 - 1) % k == 0:
            
            phi = (e*d0 - 1) //k
            s = (N-phi+1)
            f = x^2 - s*x + N
            b = f.discriminant()
            if b > 0 and b.is_square():
                d = d0
                
                roots = list(zip(*f.roots()))[0]
                if len(roots) == 2 and prod(roots) == N:
                    print("[x] Recovered! \nd = %0x" %d)
                    return d
            else:
                continue
    print("[] Could not determine the value of d with the parameters given. Make sure that d < 1/3 * N ^ 0.25")
    return -1
    

def wiener(c,e,N):
    d = recover(e,N)
    return hex(Integer(pow(c,d,N)))

def test():
    
    e = 0x0285f8d4fe29ce11605edf221868937c1b70ae376e34d67f9bb78c29a2d79ca46a60ea02a70fdb40e805b5d854255968b2b1f043963dcd61714ce4fc5c70ecc4d756ad1685d661db39d15a801d1c382ed97a048f0f85d909c811691d3ffe262eb70ccd1fa7dba1aa79139f21c14b3dfe95340491cff3a5a6ae9604329578db9f5bcc192e16aa62f687a8038e60c01518f8ccaa0befe569dadae8e49310a7a3c3bddcf637fc82e5340bef4105b533b6a531895650b2efa337d94c7a76447767b5129a04bcf3cd95bb60f6bfd1a12658530124ad8c6fd71652b8e0eb482fcc475043b410dfc4fe5fbc6bda08ca61244284a4ab5b311bc669df0c753526a79c1a57
    n = 0x02aeb637f6152afd4fb3a2dd165aec9d5b45e70d2b82e78a353f7a1751859d196f56cb6d11700195f1069a73d9e5710950b814229ab4c5549383c2c87e0cd97f904748a1302400dc76b42591da17dabaf946aaaf1640f1327af16be45b8830603947a9c3309ca4d6cc9f1a2bcfdacf285fbc2f730e515ae1d93591ccd98f5c4674ec4a5859264700f700a4f4dcf7c3c35bbc579f6ebf80da33c6c11f68655092bbe670d5225b8e571d596fe426db59a6a05aaf77b3917448b2cfbcb3bd647b46772b13133fc68ffabcb3752372b949a3704b8596df4a44f085393ee2bf80f8f393719ed94ab348852f6a5e0c493efa32da5bf601063a033beaf73ba47d8205db

    c = 0xcdbfc1c1bd22b604bdcd69e1dfc08d1f707846b75ea990802e65a4f5160d6132b2fae418e07b03e50df2458d4929d079f7838476fde4a16a5e2ac3daec262da689b3e9948b2eb880367bf7ddeb23288035f87937dabf5b44f3ebe8fa30bf568e87d9dbc309fe696f833617827cfdd1d082454de9cde9783d3c9ab372aade90285f94dbdae4a080edc58917050ba40b7b0b81cedd4d5a26091ecd2a4e746d1207ea0ef6f0dc893472359ff9b564374502b7d38e7ca880e436dec306a28c77d259b23eed5391d989dc1549813c48c78a7700ffa4778bad6ecf30e54cc1762f2ded99db01a9e887f44125d55ae75415e730c9ab7481df68206cb1022bdb93971a
    
    m = wiener(c,e,n)
    print(m)
test()
