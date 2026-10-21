"""Copia de los capítulos las definiciones #let de las macros locales (_xxx-…) que usan las
preguntas elegidas, con sus dependencias. Uso: from macros import definiciones"""
import glob
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
NOMBRE = r'(?<![\w-])(_[a-z][a-z0-9]*-[a-z0-9-]+)'


def _fin_sentencia(s, i):
    """Desde i (tras '#let …'), avanza hasta el salto de línea con profundidad 0."""
    depth, j, in_str = 0, i, False
    while j < len(s):
        c = s[j]
        if c == '\\':
            j += 2
            continue
        if in_str:
            if c == '"':
                in_str = False
        elif c == '"':
            in_str = True
        elif c in '([{':
            depth += 1
        elif c in ')]}':
            depth -= 1
        elif c == '\n' and depth == 0:
            return j
        j += 1
    return j


def _todas():
    defs = {}
    for f in sorted(glob.glob(os.path.join(ROOT, 'chapters', '*.typ'))):
        s = open(f, encoding='utf-8').read()
        for m in re.finditer(r'^#let (_[a-z][a-z0-9]*-[a-z0-9-]+)\b', s, re.M):
            fin = _fin_sentencia(s, m.end())
            # comentario /// inmediatamente encima, si existe
            defs.setdefault(m.group(1), (os.path.basename(f), s[m.start():fin]))
    return defs


def definiciones(texto):
    """Devuelve el código Typst con las definiciones necesarias para `texto`, en orden."""
    todas = _todas()
    pendientes = [n for n in dict.fromkeys(re.findall(NOMBRE, texto)) if n in todas]
    orden, vistos = [], set()

    def visitar(n):
        if n in vistos:
            return
        vistos.add(n)
        for dep in dict.fromkeys(re.findall(NOMBRE, todas[n][1])):
            if dep in todas and dep != n:
                visitar(dep)
        orden.append(n)

    for n in pendientes:
        visitar(n)
    faltan = [n for n in dict.fromkeys(re.findall(NOMBRE, texto)) if n not in todas]
    partes = [f'// de chapters/{todas[n][0]}\n{todas[n][1]}' for n in orden]
    return '\n'.join(partes), faltan


if __name__ == '__main__':
    import json
    b = json.load(open(os.path.join(ROOT, 'build', 'simulacros', 'banco.json')))
    todo = '\n'.join(q['enunciado'] + ' '.join(q['opciones']) + (q['sol'] or '') for q in b if q['grupo'] != 'C-H')
    codigo, faltan = definiciones(todo)
    print(codigo.count('#let'), 'definiciones; no encontradas:', faltan)
