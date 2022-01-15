from Crypto.Cipher import AES
from os import urandom
from base64 import b64decode
from pkcs7 import pkcs7
import random

BLOCKSIZE = 16

def xor(ctr, plaintext):
    return bytearray((ctr[i] ^ plaintext[i] for i in range(len(ctr))))

def encrypt(key, ptext):
    iv = urandom(16)
    c = AES.new(key, AES.MODE_CBC, iv)
    return iv + c.encrypt(bytes(pkcs7(ptext, BLOCKSIZE), "latin1"))

def decrypt(key, ctext):
    iv = ctext[:16]
    c = AES.new(key, AES.MODE_CBC, iv)
    return c.decrypt(ctext)

def is_valid_pad(data):
    return data[-data[-1]:].decode("latin1") == data[-1] * chr(data[-1])

def oracle(data):
    key = open("key", "rb").read()
    return is_valid_pad(decrypt(key, data))
        
def choose_message():
    key = open("key", "rb").read()
    data = encrypt(key, b64decode(random.choice(open("data").readlines())))
    return data

def set_pad(Cn_1, I, lbound, target_pad):
    for i in range(15, lbound, -1):
        t = target_pad ^ target_pad - 1
        Cn_1[i] = Cn_1[i] ^ t
        I[i] = Cn_1[i] ^ target_pad
    return Cn_1, I
    
def pkcs7_unpad(data):
    return data[:-data[-1]]
    
def break_cbc(iv, prevblock, target):
    P = bytearray(16)
    prevblock = bytearray(prevblock)
    Cn_1 = bytearray(urandom(16))
    index = BLOCKSIZE - 1
    pad = 1
    I = bytearray(16)
    while index >= 0:
        for guess in range(256):
            Cn_1[index] = guess
            concat = iv + Cn_1 + target
            if oracle(concat):
                Cn_1, I = set_pad(Cn_1, I, index - 1, pad + 1)
                break
        pad += 1
        index -= 1
    
    P = xor(prevblock, I)
    return P

def padding_oracle(data):
    iv = data[:16]
    data = [data[i:i+16] for i in range(16, len(data), 16)]
    prev_block = iv
    recovered = bytearray()
    for block in data:
        recovered += break_cbc(iv, prev_block, block)
        prev_block = block
    
    return pkcs7_unpad(recovered)

if __name__ == "__main__":
    msg = choose_message()
    print(padding_oracle(msg))
    
