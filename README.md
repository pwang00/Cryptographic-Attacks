# Cryptographic Attacks

Repository containing my Sage and/or Python implementations of attacks on popular ciphers and public key cryptosystems.  

# Overview

As of yet, there are implementations for attacks against RSA, Diffie-Hellman and its elliptic curve variant, AES-ECB, and AES-CBC.  There are also miscellaneous factoring attacks, which may be applicable for targeting many public key schemes, and some notes on topics such as elliptic curve pairings.  I plan to finish all existing public key attacks in the future and significantly expand attack support for symmetric key primitives, as the latter has been relatively lacking for the past few years.  Additionally, I aim to add more general purpose algorithms in the domains of factoring, state recovery for non-cryptographically secure PRNG (such as ones that use linear congruential generators or linear-feedback shift registers), and more, the reason being that doing so should allow for more flexibility when attacking cryptographic primitives.

# Currently Implemented Attacks

## Public Key Cryptographic Schemes

### RSA

- [x] [Generalized Hastad's broadcast attack](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/hastad.sage)
- [x] [Common modulus attack](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/common_modulus.py)
- [x] [Wiener's attack for small d](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/wiener.sage)
- [x] [Blinding attack on Unpadded RSA signatures](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/blinding.sage)
- [x] [Fault attack on RSA-CRT](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/fault_attack.sage)
- [x] [Franklin-Reiter related message attack + Coppersmith short pad attack](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/coppersmith_short_pad.sage)
- [x] [Coron's simplification of Coppersmith's root finding algorithm for bivariate polynomials in Z[x, y]](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/RSA/coron.sage)
- [ ] Partial key recovery attack with bits of d known

### Diffie-Hellman

- [x] [Pohlig-Hellman attack for finding discrete logarithms in cyclic multiplicative groups with smooth order](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/Diffie%20Hellman/pohlig_hellman.sage)
- [x] [Pohlig-Hellman attack for finding discrete logarithms in elliptic curve additive groups with smooth order](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/Diffie%20Hellman/pohlig_hellman_EC.sage)
- [ ] Small-subgroup confinement attack

### Factoring algorithms (applicable for many public key primitives)
- [x] [Cheng's 4p - 1 = Ds^2 elliptic curve complex multiplication based factoring](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/Factoring/cm_factor.sage)

### Elliptic Curves
- [ ] MOV attack for curves of low embedding degree

## Symmetric Key Ciphers 

### AES

- [x] [Byte-at-a-time ECB decryption](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Symmetric%20Key/AES/byte_at_a_time/break_ecb.py)
- [x] [AES-CBC Padding Oracle](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Symmetric%20Key/AES/padding_oracle/padding_oracle.py)

# Installing SageMath

SageMath is available on both Windows and Un*x.

To install SageMath on Windows, download an installer from the following link: https://github.com/sagemath/sage-windows/releases

To install on Ubuntu and other Linux distros, I believe `sudo apt install sagemath`, or something along those lines will get the job done.

SageMath also has a presence in the cloud:

* [SageMathCell](http://sagecell.sagemath.org/): (useful as a quick go-to for evaluating Sage code without the need to save, also be mindful of no external connections)

* [CoCalc](https://cocalc.com/): (optimal for hosting personal projects in the cloud)

It is also possible to host a personal SageMath server, though I have never tried this.

# Current Notes

The [Notes](https://github.com/pwang00/Cryptographic-Attacks/tree/master/Public%20Key/Notes/) directory contains my notes on miscellaneous cryptography-related topics.  As of now, I have written up a [summary](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/Notes/Elliptic%20Curves/Pairings/Pairings_For_Beginners_Notes.pdf) of the first few chapters of Craig Costello's [Pairings for Beginners](https://static1.squarespace.com/static/5fdbb09f31d71c1227082339/t/5ff394720493bd28278889c6/1609798774687/PairingsForBeginners.pdf) and a SageMath [script](https://github.com/pwang00/Cryptographic-Attacks/blob/master/Public%20Key/Notes/Elliptic%20Curves/Pairings/affine_to_projective.sage) demonstrating elliptic curve point addition and doubling in projective coordinates.

# Future Works

### Existing Attacks
1. Implement the small-subgroup confinement attack for Diffie-Hellman and its Elliptic Curve counterpart.
2. Implement the MOV attack for elliptic curves of low embedding degree.

### Future Attacks
1. Boneh-Durfee attack for d < N^0.292
2. BLS rogue public key attack
3. Fault attack on standard (non-CRT) RSA
4. Small-subgroup confinement attack on Diffie-Hellman
5. Linear / differential cryptanalysis against DES/AES
6. Invalid point attacks on Elliptic Curve Diffie-Hellman
7. State recovery on linear congruential generators (LCGs), truncated and non-truncated
8. State recovery on linear feedback shift registers (LFSRs)

### Miscellaneous
1. Add docstrings to each attack to better describe their functionalities.
2. Add more general purpose scripts that may prove useful for breaking some cryptographic schemes
3. Improve overall code quality, efficiency, and consistency

Feel free to let me know if there are any bugs.

# Frequently Asked Questions

Q: Why use SageMath instead of pure Python?

A: Sage provides many convenient number-theoretic functions and constructors for algebraic structures commonly used by or used against cryptographic primitives, such as groups, polynomial rings, fields, and elliptic curves.  This saves a lot of time since it allows focus to be placed solely on implementing attacks and useful general purpose algorithms rather than the structures that they depend upon.

# Relevant Links

* [General overview of Coppersmith's attack](https://en.wikipedia.org/wiki/Coppersmith%27s_attack)
* [Coron's simplification of Coppersmith's algorithm](https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf)
* [Cheng's 4p - 1 elliptic curve complex multiplication based factoring](https://crocs.fi.muni.cz/_media/public/papers/2019-secrypt-sedlacek.pdf)
* [Craig Costello's Pairings for Beginners](https://static1.squarespace.com/static/5fdbb09f31d71c1227082339/t/5ff394720493bd28278889c6/1609798774687/PairingsForBeginners.pdf)
* [20 years of attacks on RSA](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf)

