# Cryptographic Attacks

Repository containing my Sage and/or Python implementations of attacks on popular ciphers and public key cryptosystems.

# Overview

TODO: Update description to something that better reflects the purpose of this repository, as a lot has changed from "RSA-Attacks".

# Currently Implemented Attacks

## Public (Asymmetric) Key Cryptographic Schemes

### RSA

#### Finished

1. Generalized Hastad's broadcast attack
2. Common modulus attack
3. Wiener's Attack for Small Public Exponent
4. Franklin-Reiter Related Message Attack
5. Blinding attack on Unpadded RSA
6. Fault attack on RSA-CRT
7. Coron's simplification of Coppersmith's root finding algorithm for bivariate polynomials in Z[x, y]

#### Unfinished
1. Partial Key Recovery Attack with bits of `d` known

### Diffie Hellman

#### Finished

1. Pohlig-Hellman attack for finding discrete logarithms in cyclic multiplicative groups with smooth order
2. Pohlig-Hellman attack for finding discrete logarithms in elliptic curve additive groups with smooth order

## Symmetric Key Ciphers 

### AES

#### Finished

1. Byte-at-a-time ECB decryption
2. AES-CBC Padding Oracle

### Note:

SageMath is available on both Windows and Un*x.

To install SageMath on Windows, download an installer from the following link: https://github.com/sagemath/sage-windows/releases

To install on Ubuntu and other Linux distros, I believe `sudo apt install sagemath`, or something along those lines will get the job done.

SageMath also has a presence in the cloud:

SageMathCell:  
http://sagecell.sagemath.org/  (useful as a quick go-to for evaluating Sage code without the need to save, also be mindful of no external connections)

CoCalc:  
https://cocalc.com/  (optimal for hosting personal projects in the cloud)

You may also host your own SageMath server 

# Future Works

### Existing Attacks
1. Add Coppersmith's Short Pad Attack as an extension to Franklin-Reiter 
2. Add OpenSSL parsing support
3. Add explanations as comments
4. Optimize existing attack scripts

### Future Attacks
1. Boneh-Durfee
2. BLS rogue public key attack
3. Fault attack on standard (non-CRT) RSA
4. Small-subgroup confinement attack on Diffie-Hellman
5. Linear / differential cryptanalysis against DES/AES
6. Invalid point attacks on Elliptic Curve Diffie-Hellman
7. State recovery on linear congruential generators (LCGs), truncated and non-truncated
8. State recovery on linear feedback shift registers (LFSRs)

### Miscellaneous
1. Update this README to better reflect the significant changes that have been made to this repository since a month ago.
2. (Maybe) Add more general purpose scripts that may prove useful for breaking some cryptographic schemes

Feel free to let me know if there are any bugs.

# Frequently Asked Questions

Q: Why use SageMath instead of pure Python?

A: Most of modern public key cryptography has some roots in Abstract Algebra (particularly group and ring theory) as well as number theory.  Sage provides excellent support for both fields of mathematics and provides many useful, time-saving functions so that the vast majority of time can be spent on implementing the actual attack algorithms rather than the structures that they are dependent upon.

# Relevant Links

https://en.wikipedia.org/wiki/Coppersmith%27s_attack  
https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf
