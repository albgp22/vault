#!/usr/bin/env python3
# Stage 3: marker string -> Typst markup
import re, sys
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb1')
from s1 import I0, I1, B0, B1, U0, U1, D0, D1
V0, V1 = '', ''
MARKERS = ''.join(chr(c) for c in range(0xe000, 0xe00a))

# ---- Unicode math alphanumerics -> plain
def demath(ch):
    o = ord(ch)
    # Latin italic / bold / etc.
    ranges = [
        (0x1D400, 'A'), (0x1D41A, 'a'),  # bold
        (0x1D434, 'A'), (0x1D44E, 'a'),  # italic
        (0x1D468, 'A'), (0x1D482, 'a'),  # bold italic
        (0x1D5A0, 'A'), (0x1D5BA, 'a'),  # sans
        (0x1D670, 'A'), (0x1D68A, 'a'),  # mono
    ]
    for start, base in ranges:
        if start <= o < start + 26:
            return chr(ord(base) + o - start)
    if ch == '\U0001D455':  # italic h (reserved -> U+210E)
        return 'h'
    # Greek italic: U+1D6E2.. (Alpha..), lowercase U+1D6FC..
    for start, upper in ((0x1D6E2, True), (0x1D6FC, False), (0x1D71C, True), (0x1D736, False), (0x1D6A8, True), (0x1D6C2, False)):
        if start <= o < start + (26 if upper else 32):
            gr_up = 'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡϴΣΤΥΦΧΨΩ∇'
            gr_lo = 'αβγδεζηθικλμνξοπρςστυφχψω∂ϵϑϰϕϱϖ'
            idx = o - start
            return (gr_up if upper else gr_lo)[idx]
    if 0x1D7CE <= o <= 0x1D7FF:
        return str((o - 0x1D7CE) % 10)
    return ch


def is_math_char(ch):
    o = ord(ch)
    return 0x1D400 <= o <= 0x1D7FF or ch == 'ℎ'


def demath_str(s):
    return ''.join(demath(c) for c in s)

# ---- Typst escaping for text
ESC = {'\\': '\\\\', '#': '\\#', '$': '\\$', '@': '\\@', '*': '\\*', '_': '\\_', '~': '\\~', '<': '\\<', '`': '\\`', '[': '\\[', ']': '\\]'}


def esc(s):
    return ''.join(ESC.get(c, c) for c in s)

MATHWORDS = {'log', 'ln', 'sen', 'sin', 'cos', 'tan', 'exp'}
OPS = '=≈≠≥≤<>·×÷+−±∼/→⇒∝'
GREEK_ESC = {'ϵ': 'ϵ'}


def strip_markers(s):
    return ''.join(c for c in s if c not in MARKERS)


def tokenize(para):
    return [t for t in re.split(r'(?<![-]) +| +(?![-])|(?<=[]) +| +(?=[])', para) if t != ''] if False else [t for t in para.split(' ') if t != '']


def has_math(tok):
    return any(is_math_char(c) for c in tok)


def has_script(tok):
    return U0 in tok or D0 in tok


def script_groups(tok):
    """split tok into list of ('t', text) / ('U', text) / ('D', text)"""
    parts = []
    pos = 0
    for m in re.finditer(U0 + r'(.*?)' + U1 + '|' + D0 + r'(.*?)' + D1, tok):
        if m.start() > pos:
            parts.append(('t', tok[pos:m.start()]))
        if m.group(1) is not None:
            parts.append(('U', m.group(1)))
        else:
            parts.append(('D', m.group(2)))
        pos = m.end()
    if pos < len(tok):
        parts.append(('t', tok[pos:]))
    return parts


def ascii_letters(s):
    return len(re.findall(r'[A-Za-z]', s))


def base_text(tok):
    """token text with scripts removed and markers stripped"""
    return strip_markers(re.sub(U0 + '.*?' + U1 + '|' + D0 + '.*?' + D1, '', tok))


def classify(tok):
    """M (math), O (operator/number connector), W (math word), N (number), T (text)"""
    p = strip_markers(tok)
    b = base_text(tok)
    if (has_math(p) or has_script(tok)) and re.search(r'[\U0001D707μ]', p) and re.search(r'[A-Za-z]', p) and not has_script(tok):
        return 'T'
    if has_math(p) or has_script(tok):
        # texty if >=2 ASCII letters in the base outside math chars, unless a math word
        core = re.sub(r'[^A-Za-z]', '', ''.join(c for c in b if not is_math_char(c)))
        bw = re.sub(r'[^a-z]', '', b)
        if bw in MATHWORDS and has_script(tok):
            return 'M'
        if len(core) >= 2:
            return 'T'
        # degree sign only
        if has_script(tok) and re.fullmatch(r'\d+', re.sub(r'[^\d]', '', b)) and strip_markers(re.sub(U0 + '(.*?)' + U1, r'\1', tok)).endswith('◦') and not has_math(p):
            return 'T'
        if not has_math(p) and has_script(tok) and not re.search(r'\d', b) and len(re.sub(r'[^A-Za-z]', '', b)) >= 1 and len(core) >= 2:
            return 'T'
        return 'M'
    core = re.sub(r'^[(\[]+|[).,;:\]]+$', '', p)
    if core.lower() in MATHWORDS:
        return 'W'
    if core in ('dB',):
        return 'W'
    if re.fullmatch(r'[(]?dB[)]?[.,;:]?', p):
        return 'W'
    if re.fullmatch(r'[' + re.escape(OPS) + r'()\d.,%]+[,.;:]?', p) and re.search(r'[' + re.escape(OPS) + ']', p):
        return 'O'
    if re.fullmatch(r'[\d.,()]*\d[\d.,()]*[,.;:]?', p):
        return 'N'
    return 'T'


def balance_ok(toks):
    p = strip_markers(' '.join(toks))
    return p.count('(') <= p.count(')') and p.count('|') % 2 == 0


def find_runs(types, toks):
    runs = []
    i = 0
    n = len(toks)
    used = [False] * n
    while i < n:
        if types[i] != 'M' or used[i]:
            i += 1
            continue
        s = i
        # backtrack
        j = s - 1
        while j >= 0 and not used[j]:
            if types[j] == 'O':
                s = j
                j -= 1
                continue
            if types[j] == 'N' and ((types[s] == 'O') or re.match(r'(log|ln|sen|sin|cos|tan|exp)', strip_markers(toks[s]))):
                s = j
                j -= 1
                continue
            break
        e = i
        k = i + 1
        if re.search(r'[,;:.]$', strip_markers(toks[i])) and not strip_markers(toks[i]).endswith('.)'):
            k = n
        while k < n:
            if types[k] in ('M', 'O', 'N'):
                e = k
                if re.search(r'[,;:.]$', strip_markers(toks[k])):
                    break
                k += 1
                continue
            if types[k] == 'W':
                m = k
                while m < n and types[m] == 'W':
                    m += 1
                if m < n and types[m] in ('M', 'O', 'N'):
                    e = m
                    k = m + 1
                    continue
                break
            break
        # trim trailing tokens that are only dangling operators / numbers not after an operator
        while e > i:
            if types[e] == 'O':
                e -= 1
                continue
            if types[e] == 'N' and not (e - 1 >= s and types[e - 1] == 'O'):
                e -= 1
                continue
            break
        # absorb delimiter-only tokens needed to balance
        while e + 1 < n and not used[e + 1] and re.fullmatch(r'[|)]+[,.;:]?', strip_markers(toks[e + 1])) and not balance_ok(toks[s:e + 1]):
            e += 1
        runs.append((s, e))
        for x in range(s, e + 1):
            used[x] = True
        i = e + 1
    return runs


def math_atom(s):
    """convert a plain-math fragment (no markers) to typst math"""
    out = ''
    pos = 0
    s = s
    i = 0
    res = []
    prev_letter = False
    while i < len(s):
        c = s[i]
        o = ord(c)
        if is_math_char(c):
            ch = demath(c)
            if prev_letter:
                res.append(' ')
            res.append(ch if not ch == 'ϵ' else 'ϵ')
            prev_letter = True
        elif c == '/':
            res.append(' slash ')
            prev_letter = False
        elif c == 'ℓ':
            res.append(' ell ')
            prev_letter = False
        elif 'Α' <= c <= 'ω':
            if prev_letter:
                res.append(' ')
            res.append(c)
            prev_letter = True
        elif c.isalpha():
            # plain letters: group a word as text
            j = i
            while j < len(s) and s[j].isalpha() and not is_math_char(s[j]):
                j += 1
            word = s[i:j]
            if word in ('log', 'ln', 'sin', 'cos', 'tan', 'exp'):
                res.append(' ' + word + ' ')
            elif word == 'sen':
                res.append(' op("sen") ')
            else:
                res.append(' "' + word + '" ')
            i = j
            prev_letter = False
            continue
        elif c == '"':
            res.append('\\"')
        elif c == '\\':
            res.append('\\\\')
        elif c in '°':
            res.append('°')
            prev_letter = False
        elif c == '◦':
            res.append('°')
        else:
            res.append(c)
            prev_letter = False
        i += 1
    return ''.join(res)


def math_token(tok):
    """tok may have script groups; return typst math"""
    parts = script_groups(tok)
    res = ''
    for idx, (kind, txt) in enumerate(parts):
        txt = strip_markers(txt)
        if kind == 't':
            piece = math_atom(txt)
            if idx + 1 < len(parts):
                piece = piece.rstrip()
            res += piece
        else:
            if len(txt) >= 2 and all(is_math_char(c) and demath(c).isalpha() for c in txt):
                inner = '"' + demath_str(txt) + '"'
            else:
                inner = math_atom(txt).strip()
            # collapse spaces
            inner = re.sub(r'\s+', ' ', inner)
            sym = '^' if kind == 'U' else '_'
            if len(inner) == 1 or re.fullmatch(r'\d+', inner):
                res += sym + inner
            else:
                res += sym + '(' + inner + ')'
    return res


def convert_math_run(toks):
    # strip enclosing/trailing punctuation outside
    first = strip_markers(toks[0])
    last = strip_markers(toks[-1])
    lead = ''
    trail = ''
    toks = list(toks)
    # trailing punctuation
    m = re.search(r'([,.;:?!]+)$', toks[-1])
    if m and not toks[-1].endswith(U1) and not toks[-1].endswith(D1):
        trail = m.group(1)
        toks[-1] = toks[-1][:m.start()]
    elif m is None:
        pass
    # closing paren handling
    joined = ' '.join(toks)
    pj = strip_markers(joined)
    open_ = pj.count('(')
    close = pj.count(')')
    # leading unmatched '(' / trailing unmatched ')'
    while close > open_ and toks[-1].rstrip().endswith(')') and not toks[-1].endswith(D1) and not toks[-1].endswith(U1):
        toks[-1] = toks[-1].rstrip()[:-1]
        trail = ')' + trail
        close -= 1
    if open_ > close and strip_markers(toks[0]).startswith('('):
        toks[0] = toks[0][1:] if toks[0].startswith('(') else toks[0]
        lead = '('
        open_ -= 1
    # fully wrapped by one pair -> move out
    pj = strip_markers(' '.join(toks))
    if pj.startswith('(') and pj.endswith(')') and open_ == close == 1:
        toks[0] = toks[0][1:]
        toks[-1] = toks[-1][:-1]
        lead = lead + '('
        trail = ')' + trail
    body = ' '.join(math_token(t) for t in toks if t != '')
    body = re.sub(r'\s+', ' ', body).strip()
    # tidy "( x" -> "(x"
    body = body.replace('( ', '(').replace(' )', ')')
    return esc(lead) + '$' + body + '$' + esc(trail)


def convert_text_token(tok):
    """convert a text-mode token with possible markers and scripts"""
    tok = re.sub(r'^([×·≈=])(?=[A-Za-z0-9])', r'\1 ', tok)
    out = ''
    pos = 0
    # handle script groups
    parts = script_groups(tok)
    for kind, txt in parts:
        if kind == 't':
            out += convert_text_markers(txt)
        else:
            t2 = strip_markers(txt)
            if t2 == '◦':
                out += '°'
            else:
                t2 = demath_str(t2)
                fn = '#super[' if kind == 'U' else '#sub['
                out += fn + esc(t2) + ']'
    return out


def convert_text_markers(txt):
    out = ''
    for c in txt:
        if c == I0: out += '#emph['
        elif c == I1: out += ']'
        elif c == B0: out += '#strong['
        elif c == B1: out += ']'
        elif c == V0: out += '#vease['
        elif c == V1: out += ']'
        elif c in MARKERS: out += ''
        else:
            out += esc(demath(c))
    return out


def merge_scripts(s):
    # merge adjacent script groups of the same kind: "^{a}^{b}" -> "^{ab}"
    s = re.sub(U1 + U0, '', s)
    s = re.sub(D1 + D0, '', s)
    # merge when only italic markers are between
    return s


def mark_vease(s):
    """wrap '(Véase ... )' parenthetical with V0/V1; strip italic markers within"""
    out = ''
    i = 0
    n = len(s)
    pat = re.compile(r'\(' + '[' + MARKERS + ']*' + r'Véase\b')
    while i < n:
        m = pat.search(s, i)
        if not m:
            out += s[i:]
            break
        st = m.start()
        while st > i and s[st - 1] in (I0, I1):
            st -= 1
        out += s[i:st]
        depth = 0
        j = m.start()
        while j < n:
            c = s[j]
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
                if depth == 0:
                    break
            j += 1
        en = j + 1
        while en < n and s[en] in (I0, I1):
            en += 1
        seg = s[st:en]
        seg = ''.join(ch for ch in seg if ch not in (I0, I1))
        out += V0 + seg + V1
        i = en
    return out


def drop_math_italics(s):
    # remove italic markers around segments containing math chars or no letters
    def f(m):
        inner = m.group(1)
        if any(is_math_char(c) for c in inner) or not re.search(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]', strip_markers(inner)):
            return inner
        return m.group(0)
    return re.sub(I0 + '(.*?)' + I1, f, s)


def convert_para(para):
    para = drop_math_italics(para)
    para = merge_scripts(para)
    para = re.sub(r' +(?=[,.;:)])', '', para)
    para = re.sub(r'\( +', '(', para)
    para = mark_vease(para)
    # italics spanning math: handled; tokens:
    toks = tokenize(para)
    types = [classify(t) for t in toks]
    runs = find_runs(types, toks)
    out = []
    i = 0
    starts = {s: e for s, e in runs}
    while i < len(toks):
        if i in starts:
            e = starts[i]
            out.append(convert_math_run(toks[i:e + 1]))
            i = e + 1
        else:
            out.append(convert_text_token(toks[i]))
            i += 1
    res = ' '.join(out)
    return res
