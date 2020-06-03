

def projective_sum(E, P, Q):
	Xp, Yp, Zp = P
	Xq, Yq, Zq = Q

	if P != Q:
		Xr = F((Xp*Zq - Xq*Zp)*(Zp*Zq * (Yp*Zq - Yq*Zp)^2 - (Xp*Zq - Xq*Zp)^2 * (Xp*Zq + Xq*Zp)))
		Yr = F(Zp*Zq*(Xq*Yp - Xp*Yq)*(Xp*Zq - Xq*Zp)^2 - (Yp*Zq - Yq*Zp)*((Yp*Zq - Yq*Zp)^2 * Zp*Zq - (Xp*Zq + Xq*Zp)*(Xp*Zq - Xq*Zp)^2))
		Zr = F(Zp*Zq * (Xp*Zq - Xq*Zp)^3)
	elif P == Q:
		a = E.a4()
		Xr = 2*a^2*Yp*Zp^3 - 12*a*Xp*Yp*Zp^2 - 16*Xp*Yp^3 + 18*Xp^2*Yp*Zp
		Yr = a^3*Zp^4 - 9*a^2*Xp*Zp^3 - 12*a*Xp*Yp^2*Zp + 27*a*Xp^2*Zp^2 + 36*Xp^2*Yp^2 - 8*Yp^4 - 27*Xp^3*Zp
		Zr = 8*Yp^3*Zp
	return (Xr/Zr, Yr/Zr)

if __name__ == "__main__":
	F = GF(23)
	E = EllipticCurve(F, [2, 1])

	P = E((4, 2))
	Q = E((10, 20))
	R = P + Q

	Xp, Yp, Zp = P
	Xq, Yq, Zq = Q

	print(projective_sum(E, P, Q))

