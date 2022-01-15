def pkcs7(data, blocksize):
    return data.decode("latin1") + chr(blocksize - len(data) % blocksize) * ((blocksize - len(data) % blocksize))

if __name__ == "__main__":
    print(repr(pkcs7("Yellow Submarin"*2, 16)))
