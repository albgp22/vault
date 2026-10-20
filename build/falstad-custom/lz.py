# lz-string compressToEncodedURIComponent / decompressFromEncodedURIComponent (port of lz-string 1.4.4)
KEY = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-$"

def _compress(uncompressed, bits, getc):
    if uncompressed is None:
        return ""
    dictionary = {}
    to_create = set()
    w = ""
    enlarge_in = 2
    dict_size = 3
    num_bits = 2
    data = []
    val = 0
    pos = 0

    def write_bit(b):
        nonlocal val, pos
        val = (val << 1) | b
        if pos == bits - 1:
            pos = 0
            data.append(getc(val))
            val = 0
        else:
            pos += 1

    def write_bits(n, value):
        for _ in range(n):
            write_bit(value & 1)
            value >>= 1

    def emit_w():
        nonlocal enlarge_in, num_bits
        if w in to_create:
            c = ord(w[0])
            if c < 256:
                write_bits(num_bits, 0)
                write_bits(8, c)
            else:
                write_bits(num_bits, 1)
                write_bits(16, c)
            enlarge_in -= 1
            if enlarge_in == 0:
                enlarge_in = 2 ** num_bits
                num_bits += 1
            to_create.discard(w)
        else:
            write_bits(num_bits, dictionary[w])
        enlarge_in -= 1
        if enlarge_in == 0:
            enlarge_in = 2 ** num_bits
            num_bits += 1

    for c in uncompressed:
        if c not in dictionary:
            dictionary[c] = dict_size
            dict_size += 1
            to_create.add(c)
        wc = w + c
        if wc in dictionary:
            w = wc
        else:
            emit_w()
            dictionary[wc] = dict_size
            dict_size += 1
            w = c
    if w != "":
        emit_w()
    write_bits(num_bits, 2)
    while True:
        val = val << 1
        if pos == bits - 1:
            data.append(getc(val))
            break
        pos += 1
    return "".join(data)

def compress_uri(s):
    return _compress(s, 6, lambda a: KEY[a])

def decompress_uri(inp):
    inp = inp.replace(" ", "+")
    rev = {ch: i for i, ch in enumerate(KEY)}
    length = len(inp)
    reset_value = 32
    getnext = lambda i: rev[inp[i]]
    dictionary = {0: 0, 1: 1, 2: 2}
    enlarge_in = 4
    dict_size = 4
    num_bits = 3
    result = []
    data_val = getnext(0)
    data_pos = reset_value
    data_index = 1

    def read_bits(n):
        nonlocal data_val, data_pos, data_index
        bitsv = 0
        power = 1
        maxpower = 2 ** n
        while power != maxpower:
            resb = data_val & data_pos
            data_pos >>= 1
            if data_pos == 0:
                data_pos = reset_value
                data_val = getnext(data_index) if data_index < length else 0
                data_index += 1
            bitsv |= (1 if resb > 0 else 0) * power
            power <<= 1
        return bitsv

    nxt = read_bits(2)
    if nxt == 0:
        c = chr(read_bits(8))
    elif nxt == 1:
        c = chr(read_bits(16))
    else:
        return ""
    dictionary[3] = c
    w = c
    result.append(c)
    while True:
        if data_index > length:
            return ""
        cc = read_bits(num_bits)
        if cc == 0:
            dictionary[dict_size] = chr(read_bits(8)); cc = dict_size; dict_size += 1; enlarge_in -= 1
        elif cc == 1:
            dictionary[dict_size] = chr(read_bits(16)); cc = dict_size; dict_size += 1; enlarge_in -= 1
        elif cc == 2:
            return "".join(result)
        if enlarge_in == 0:
            enlarge_in = 2 ** num_bits; num_bits += 1
        if cc in dictionary:
            entry = dictionary[cc]
        elif cc == dict_size:
            entry = w + w[0]
        else:
            return None
        result.append(entry)
        dictionary[dict_size] = w + entry[0]; dict_size += 1
        enlarge_in -= 1
        w = entry
        if enlarge_in == 0:
            enlarge_in = 2 ** num_bits; num_bits += 1

if __name__ == "__main__":
    t = "$ 1 0.000005 10.20027730826997 50 5 50\nv 80 80 80 240 0 0 40 5 0 0 0.5\nr 80 80 240 80 0 1000\nr 240 80 240 240 0 1000\nw 80 240 240 240 0\ng 80 240 80 272 0\n"
    ref = "CQAgjCAMB0l3BWcMBMcUHYMGZIA4UA2ATmIxAUgosgCgA3EPK5pqlAFiu5C+p5gJaAJzZjOLHmHgiQE8X3lVpcWgHcF7RXzoBzTeIwootIA"
    print(decompress_uri(ref) == t, repr(decompress_uri(ref))[:60])
    print(compress_uri(t) == ref)
    print(compress_uri(t.rstrip("\n")) == ref)
    s = "Resonancia serie: corriente máxima en f0 ñ € x"
    print(decompress_uri(compress_uri(s)) == s)
