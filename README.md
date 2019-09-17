# Cryptographic-Attacks

Repository containing my Sage and/or Python implementations of attacks on popular ciphers and public key cryptosystems.

# Overview

RSA is a highly popular public key cryptosystem (PKC) that is used in scenarios ranging from secure communications to data encryption.  Due to its popularity, it has been subject to rigorous cryptanalysis to ensure that it is up to standard.  Several attacks have, under certain conditions, compromised the security of RSA in the 30+ years that the cryptosystem has existed.  Thus, understanding the attacks is crucial to avoid trivial mistakes when choosing RSA parameters.  

Capture the Flag competitions (CTF) are one of the most common ways of educating players on RSA attacks, and the files in this repository are intended to be a proof-of-concept of these attacks, which appear often (albeit with several twists) on CTFs.  

# Currently Implemented Attacks

## RSA 

1. Generalized Hastad's broadcast attack (Sage) 
2. Common modulus attack (Sage/Python)
3. Partial Key Recovery Attack (Unfinished) (Sage)
4. Wiener's Attack for Small Public Exponent (Sage)
5. Franklin-Reiter Related Message Attack (Sage)

### Note:

Sage is regarded as being very difficult to install on Windows, since users need to download both VirtualBox and the Sage virtual machine in order to use its features.  Luckily, it does have a presence in the cloud.

Below are two official cloud-based sage sites:

SageMathCell:  
http://sagecell.sagemath.org/  (useful as a quick go-to for evaluating Sage code without the need to save)

CoCalc:  
https://cocalc.com/  (optimal for hosting personal projects in the cloud)

** Having been dead for over 2 years, I am now back!

# Future Works

1. Finish implementing Partial Key Recovery and Coppersmith's method for finding small roots of multivariate polynomial defined over a ring
2. Add Coppersmith's Short Pad Attack as an extension to Franklin-Reiter 
3. Add Python implementations of existing programs
4. Add OpenSSL parsing support
4. Include explanations into each RSA attack

Feel free to let me know if there are any bugs.


# Relevant Links

https://en.wikipedia.org/wiki/Coppersmith%27s_attack  
https://www.iacr.org/archive/crypto2007/46220372/46220372.pdf
