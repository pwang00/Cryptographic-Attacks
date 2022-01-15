from Crypto.Cipher import AES
from os import urandom
from random import randint
from pkcs7 import pkcs7
from base64 import b64decode

key_size = 16
key = open("key").read()

unknown = """Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc
        28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5
        IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCB
        JIGp1c3QgZHJvdmUgYnkK"""

def oracle(data, keysize = key_size):
    cipher = AES.new(key, AES.MODE_ECB)
    data = pkcs7(data + b64decode(unknown), keysize)
    return cipher.encrypt(data)


if __name__ == "__main__":
    print(oracle("A"*32))	