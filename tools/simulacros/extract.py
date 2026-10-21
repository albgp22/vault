"""Extrae todas las preguntas #q(...) de los capítulos a build/simulacros/banco.json.
Cada pregunta guarda el código Typst tal cual (enunciado, opciones, solución) y su clave.
Uso: python3 -I tools/simulacros/extract.py"""
import glob
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OPEN = {'(': ')', '[': ']', '{': '}'}


def scan_call(s, i):
    """s[i] == '('. Devuelve (lista de argumentos de nivel superior, índice tras el ')')."""
    stack = [')']
    args, start, j = [], i + 1, i + 1
    in_str = False
    in_math = False
    while j < len(s):
        c = s[j]
        if c == '\\':
            j += 2
            continue
        top = stack[-1]
        if in_str:
            if c == '"':
                in_str = False
        elif top == ']' and c == '$':
            in_math = not in_math
        elif c == '"' and top != ']':
            in_str = True
        elif c == '"' and top == ']' and in_math:
            in_str = True
        elif c in OPEN and not (top == ']' and c in '({' and not in_math and s[j - 1] != '#' and not re.match(r'[\w\-.]', s[j - 1])):
            stack.append(OPEN[c])
        elif c in ')]}':
            if c != stack[-1]:
                # paréntesis de texto suelto dentro de contenido: ignorar
                if top == ']' and c == ')':
                    j += 1
                    continue
                raise ValueError(f'desequilibrio en {j}: {s[max(0, j - 80):j + 20]!r}')
            stack.pop()
            if not stack:
                args.append(s[start:j].strip())
                return args, j + 1
        elif c == ',' and len(stack) == 1:
            args.append(s[start:j].strip())
            start = j + 1
        j += 1
    raise ValueError('sin cierre')


def strip_content(a):
    a = a.strip()
    if a.startswith('[') and a.endswith(']'):
        return a[1:-1]
    return a


def main():
    out = []
    for f in sorted(glob.glob(os.path.join(ROOT, 'chapters', '*.typ'))):
        name = os.path.basename(f)[:-4]
        if name == 'ap-d':
            continue
        s = open(f, encoding='utf-8').read()
        for m in re.finditer(r'#q\(', s):
            i = m.end() - 1
            try:
                args, end = scan_call(s, i)
            except ValueError as e:
                print('ERROR', name, s.count('\n', 0, i) + 1, e)
                continue
            pos = [a for a in args if not re.match(r'^[a-z\-]+\s*:', a)]
            named = {a.split(':', 1)[0].strip(): a.split(':', 1)[1].strip() for a in args if re.match(r'^[a-z\-]+\s*:', a)}
            qid = pos[0].strip('"')
            ans = pos[1].strip('"')
            stem = strip_content(pos[2])
            optsrc = pos[3].strip()
            assert optsrc.startswith('(') and optsrc.endswith(')'), (qid, optsrc[:60])
            opts, _ = scan_call(optsrc, 0)
            opts = [strip_content(o) for o in opts if o]
            sol = strip_content(named['sol']) if 'sol' in named else None
            out.append({
                'id': qid, 'grupo': qid.rsplit('.', 1)[0], 'archivo': name,
                'linea': s.count('\n', 0, i) + 1, 'clave': ans,
                'enunciado': stem, 'opciones': opts, 'sol': sol,
                # forma original del argumento: [contenido] o expresión de código
                'raw': {'enunciado': pos[2].strip(), 'opciones': [o.strip() for o in scan_call(optsrc, 0)[0] if o.strip()],
                        'sol': named.get('sol')},
            })
    os.makedirs(os.path.join(ROOT, 'build', 'simulacros'), exist_ok=True)
    json.dump(out, open(os.path.join(ROOT, 'build', 'simulacros', 'banco.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    from collections import Counter
    print(len(out), 'preguntas')
    print(Counter(q['grupo'] for q in out))
    print('opciones != 4:', [q['id'] for q in out if len(q['opciones']) != 4][:20])
    print('claves raras:', [q['id'] for q in out if q['clave'] not in 'abcd' or len(q['clave']) != 1][:20])


if __name__ == '__main__':
    main()
