# Sage does not implement xgcd or modular multiplicative inverses for polynomials over composite rings, so 
# We just roll our own implementation here (which is really adapted pseudocode from Wikipedia)

def polynomial_egcd(a, b):
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1

    while r != 0:
        try:
            q = old_r // r
            old_r, r = r, old_r - q * r
            old_s, s = s, old_s - q * s
            old_t, t = t, old_t - q * t
        except:
            raise ValueError("No inverse for r in Q.", r)

    return old_r, old_s, old_t

def polynomial_inv_mod(a, b):
    g, s, _ = polynomial_egcd(a, b)

    if g.degree() > 1:
        raise ValueError("No polynomial inverse exists.")

    return s * g.lc()**-1