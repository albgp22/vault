"""Genera simulacros.typ (un solo documento) a partir de un plan.
Uso: python3 -I tools/simulacros/generar.py build/simulacros/plan.json simulacros.typ
El plan: {"simulacros": [{"n": 1, "pruebas": [{"p": 1, "items": [{"qid", "cid", "concepto",
"tema"}, …]}, …]}, …], "cobertura": [...], "intro": {...}}. Las preguntas salen del banco
(build/simulacros/banco.json) o de las nuevas (build/simulacros/conceptos/*.json → "nuevas").
Las opciones se barajan con una semilla fija cuando es seguro (ninguna opción remite a otra y la
solución no nombra letras); la clave se recalcula."""
import glob
import json
import os
import random
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from macros import definiciones  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LETRAS = 'abcd'
NO_BARAJAR = re.compile(r'anterior|todas las|ninguna de|ambas|las dos|los dos|a y b|b y c|a y c|c y d|'
                        r'\ba\)|\bb\)|\bc\)|\bd\)|ninguno de|cualquiera de', re.I)
LETRA_EN_SOL = re.compile(r'\(\s*[abcd]\s*\)|opci[oó]n\s+[abcd]\b|\b(?:la|las|respuesta)\s+[abcd]\b'
                          r'|#strong\[[abcd]\]|\b[abcd]\)', re.I)


def cargar_preguntas():
    banco = {q['id']: q for q in json.load(open(os.path.join(ROOT, 'build/simulacros/banco.json'), encoding='utf-8'))}
    for f in glob.glob(os.path.join(ROOT, 'build/simulacros/conceptos/*.json')):
        for n in json.load(open(f, encoding='utf-8')).get('nuevas', []):
            banco[n['nid']] = {'id': n['nid'], 'clave': n['clave'], 'enunciado': n['enunciado'],
                               'opciones': n['opciones'], 'sol': n['sol'], 'nueva': True,
                               'raw': {'enunciado': f"[{n['enunciado']}]", 'opciones': [f'[{o}]' for o in n['opciones']],
                                       'sol': f"[{n['sol']}]"}}
    return banco


def barajar(q, semilla):
    """Devuelve (opciones en forma original, clave, barajada) quizá barajadas."""
    ops, clave = list(q['raw']['opciones']), q['clave']
    if any(NO_BARAJAR.search(o) for o in ops) or LETRA_EN_SOL.search(q['sol'] or '') or LETRA_EN_SOL.search(q['enunciado']):
        return ops, clave, False
    rng = random.Random(semilla)
    idx = list(range(4))
    rng.shuffle(idx)
    nuevas = [ops[i] for i in idx]
    return nuevas, LETRAS[idx.index(LETRAS.index(clave))], True


def limpiar_refs(t):
    """Referencias a figuras o tablas del libro: no existen en este documento."""
    t = re.sub(r'(tabla|figura|cuadro)\s+#ref\(<[^>]+>[^)]*\)', r'\1 del libro', t)
    t = re.sub(r'(?:la|el)\s+#ref\(<([^>]+)>[^)]*\)', lambda m: 'la tabla del libro' if ('cuadro' in m.group(1) or 'tab' in m.group(1)) else 'la figura del libro', t)
    t = re.sub(r'#ref\(<([^>]+)>[^)]*\)', lambda m: 'la tabla del libro' if ('cuadro' in m.group(1) or 'tab' in m.group(1)) else 'la figura del libro', t)
    t = re.sub(r'(?<![\w])@([a-z][\w-]*)(\[[^\]]*\])?', 'la figura del libro', t)
    return t


def typst_str(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def generar(plan, salida):
    banco = cargar_preguntas()
    usadas = []
    cuerpo = []
    for sim in plan['simulacros']:
        n = sim['n']
        cuerpo.append(f'\n// {"=" * 70}\n#simulacro({n})\n')
        for prueba in sim['pruebas']:
            p = prueba['p']
            cuerpo.append(f'#prueba({n}, {p})\n')
            for k, it in enumerate(prueba['items'], 1):
                q = banco[it['qid']]
                ops, clave, _ = barajar(q, f"{n}-{p}-{k}-{q['id']}")
                usadas.append((n, p, k, q['id'], it.get('cid', ''), clave))
                origen = '' if q.get('nueva') else q['id']
                ops_t = ', '.join(limpiar_refs(o) for o in ops)
                cuerpo.append(
                    f'#pq({n}, {p}, {k}, "{clave}", {typst_str(origen)}, {typst_str(it.get("concepto", ""))},\n'
                    f'  {limpiar_refs(q["raw"]["enunciado"])},\n'
                    f'  ({ops_t},),\n'
                    f'  sol: {limpiar_refs(q["raw"]["sol"] or "[]")})\n')
            cuerpo.append(f'#fin-prueba()\n')
        cuerpo.append(f'#soluciones-simulacro({n})\n')
    texto = ''.join(cuerpo)
    macros, faltan = definiciones(texto)
    if faltan:
        print('AVISO macros no encontradas:', faltan)
    cab = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cabecera.typ'), encoding='utf-8').read()
    extra = plan.get('typst_previo', '')
    with open(salida, 'w', encoding='utf-8') as f:
        f.write(cab)
        f.write('\n// ---- macros locales copiadas de los capítulos (generado) ----\n')
        f.write(macros + '\n')
        f.write(extra)
        f.write(texto)
        f.write(plan.get('typst_final', ''))
    json.dump(usadas, open(os.path.join(ROOT, 'build/simulacros/usadas.json'), 'w'), ensure_ascii=False)
    return usadas


if __name__ == '__main__':
    plan = json.load(open(sys.argv[1], encoding='utf-8'))
    u = generar(plan, sys.argv[2])
    from collections import Counter
    print(len(u), 'preguntas; claves:', Counter(x[5] for x in u))
