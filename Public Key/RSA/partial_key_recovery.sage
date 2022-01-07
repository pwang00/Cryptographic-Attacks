# Implements Coron's simplification of Coppersmith's algorithm
# Essentially the idea is to find a polynomial h(x, y) with small coefficients such that 
# If h(x_0, y_0) = 0 (mod n) for some arbitrary integer n, then h(x_0, y_0) = 0 over Z holds as well.