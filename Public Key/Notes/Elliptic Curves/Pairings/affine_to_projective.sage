def projective_sum(E, P, Q):
    Xp, Yp, Zp = P
    Xq, Yq, Zq = Q

    if P != Q:
        Xr = F((Xp*Zq - Xq*Zp)*(Zp*Zq * (Yp*Zq - Yq*Zp)^2 - (Xp*Zq - Xq*Zp)^2 * (Xp*Zq + Xq*Zp)))
        Yr = F(Zp*Zq*(Xq*Yp - Xp*Yq)*(Xp*Zq - Xq*Zp)^2 - (Yp*Zq - Yq*Zp)*((Yp*Zq - Yq*Zp)^2 * Zp*Zq - (Xp*Zq + Xq*Zp)*(Xp*Zq - Xq*Zp)^2))
        Zr = F(Zp*Zq * (Xp*Zq - Xq*Zp)^3)
    else:
        a = E.a4()
        Xr = 2*Yp*Zp^5*a^2 + 12*Xp^2*Yp*Zp^3*a + 18*Xp^4*Yp*Zp - 16*Xp*Yp^3*Zp^2
        Yr = -Zp^6*a^3 - 9*Xp^2*Zp^4*a^2 - 27*Xp^4*Zp^2*a + 12*Xp*Yp^2*Zp^3*a - 27*Xp^6 + 36*Xp^3*Yp^2*Zp - 8*Yp^4*Zp^2
        Zr = 8*Yp^3*Zp^3

    return (Xr/Zr, Yr/Zr)

if __name__ == "__main__":
    F = GF(23)
    E = EllipticCurve(F, [2, 1])

    P = E((4, 2))
    Q = E((4, 2))
    R = P + Q
    print(R)

    Xp, Yp, Zp = P
    Xq, Yq, Zq = Q

    print(projective_sum(E, P, Q))

