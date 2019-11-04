# Cryptographic-Attacks

Repository containing my Sage and/or Python implementations of attacks on popular ciphers and public key cryptosystems.

# Overview

RSA is a highly popular public key cryptosystem (PKC) that is used in scenarios ranging from secure communications to data encryption.  Due to its popularity, it has been subject to rigorous cryptanalysis to ensure that it is up to standard.  Several attacks have, under certain conditions, compromised the security of RSA in the 30+ years that the cryptosystem has existed.  Thus, understanding the attacks is crucial to avoid trivial mistakes when choosing RSA parameters.  

Capture the Flag competitions (CTF) are one of the most common ways of educating players on RSA attacks, and the files in this repository are intended to be a proof-of-concept of these attacks, which appear often (albeit with several twists) on CTFs.  

# Currently Implemented Attacks

## Public (Asymmetric) Key Cryptographic Schemes

### RSA

1. Generalized Hastad's broadcast attack
2. Common modulus attack
3. Partial Key Recovery Attack (Unfinished)
4. Wiener's Attack for Small Public Exponent
5. Franklin-Reiter Related Message Attack
6. Blinding attack on Unpadded RSA
7. Fault attack on RSA-CRT

### Diffie Hellman

1. Pohlig-Hellman attack for finding discrete logarithms in cyclic groups with smooth order

## Symmetric Key Ciphers 

### AES

1. Byte-at-a-time ECB decryption
2. AES-CBC Padding Oracle

### Note:

Sage is regarded as being very difficult to install on Windows, since users need to download both VirtualBox and the Sage virtual machine in order to use its features.  Luckily, it does have a presence in the cloud.

Below are two official cloud-based sage sites:

SageMathCell:  
http://sagecell.sagemath.org/  (useful as a quick go-to for evaluating Sage code without the need to save)

CoCalc:  
https://cocalc.com/  (optimal for hosting personal projects in the cloud)

** Having been dead for over 2 years, I am now back!

# Future Works

### Existing Attacks
1. Finish implementing Partial Key Recovery and Coppersmith's method for finding small roots of multivariate polynomial defined over a ring
2. Add Coppersmith's Short Pad Attack as an extension to Franklin-Reiter 
3. Add Elliptic Curve support for Pohlig-Hellman
4. Add OpenSSL parsing support
5. Add explanations as comments
6. Optimize existing attack scripts

### Future Attacks
1. (Maybe) Boneh-Durfee
2. BLS Rogue Public Key Attack
3. Fault attack on standard (non-CRT) RSA
4. Small-subgroup confinement attack on Diffie-Hellman
5. Linear / Differential cryptanalysis against DES/AES

### Miscellaneous
1. Update this README to better reflect the significant changes that have been made to this repository since a month ago.

Feel free to let me know if there are any bugs.

# Frequently Asked Questions

Q: Why use SageMath instead of pure Python?

A: Most of modern public key cryptography has some roots in Abstract Algebra (particularly group and ring theory) as well as number theory.  Sage provides excellent support for both fields of mathematics and provides many useful, time-saving functions so that the vast majority of time can be spent on implementing the actual attack algorithms rather than the structures that they are dependent upon.

# Relevant Links

https://en.wikipedia.org/wiki/Coppersmith%27s_attack  
https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf
