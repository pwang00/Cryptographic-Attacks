from oracle import oracle
from itertools import product

def break_ecb(data):
    
    known_bytes = ""
    for j in range(1, len(data) + 1):
        seen = oracle(data[:-j])
        for i in range(256):
            payload = data[:-j]+known_bytes+chr(i)	
            if oracle(payload)[:len(data)] == seen[:len(data)]:
                known_bytes += chr(i)
                break
    print(known_bytes)

if __name__ == "__main__":
    data = "A"*512
    break_ecb(data)