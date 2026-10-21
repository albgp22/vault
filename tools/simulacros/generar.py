"""Genera simulacros.typ (un solo documento) a partir del plan de planificar.py.
Uso: python3 -I tools/simulacros/generar.py build/simulacros/plan.json simulacros.typ
Las preguntas salen del banco del libro (build/simulacros/banco.json) o de las nuevas
(build/simulacros/conceptos/*.json → "nuevas", en su versión revisada de verificadas-*.json).
Las opciones se barajan cuando es seguro (ninguna opción remite a otra, la solución no nombra
letras y no son números ya ordenados) y las claves quedan equilibradas en cada prueba."""
import glob
import json
import os
import random
import re
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from macros import definiciones  # noqa: E402

AQUI = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(AQUI))
LETRAS = 'abcd'
NO_BARAJAR = re.compile(r'anterior|todas las|ninguna de|ambas|las dos|los dos|a y b|b y c|a y c|c y d|'
                        r'\ba\)|\bb\)|\bc\)|\bd\)|ninguno de|cualquiera de|todos los|todo lo|ninguno', re.I)
LETRA_EN_SOL = re.compile(r'\(\s*[abcd]\s*\)|opci[oó]n\s+[abcd]\b|\b(?:la|las|respuesta)\s+[abcd]\b'
                          r'|#strong\[[abcd]\]|\b[abcd]\)', re.I)


def cargar_preguntas():
    banco = {q['id']: q for q in json.load(open(os.path.join(ROOT, 'build/simulacros/banco.json'), encoding='utf-8'))}
    revisadas = {}
    for f in glob.glob(os.path.join(ROOT, 'build/simulacros/verificadas-*.json')):
        for v in json.load(open(f, encoding='utf-8')):
            revisadas[v['nid']] = v
    for f in glob.glob(os.path.join(ROOT, 'build/simulacros/conceptos/*.json')):
        for n in json.load(open(f, encoding='utf-8')).get('nuevas', []):
            v = revisadas.get(n['nid'], n)
            if v.get('veredicto') == 'descartar':
                continue
            banco[n['nid']] = {'id': n['nid'], 'clave': v['clave'], 'enunciado': v['enunciado'],
                               'opciones': v['opciones'], 'sol': v['sol'], 'nueva': True,
                               'raw': {'enunciado': f"[{v['enunciado']}]", 'opciones': [f'[{o}]' for o in v['opciones']],
                                       'sol': f"[{v['sol']}]"}}
    return banco


def _numero(o):
    t = re.sub(r'[\[\]$\s"]', '', o).replace(',', '.')
    m = re.match(r'^[−-]?\d+(\.\d+)?', t.replace('−', '-'))
    return float(m.group(0).replace('−', '-')) if m else None


def barajable(q):
    ops = q['raw']['opciones']
    if any(NO_BARAJAR.search(o) for o in ops) or LETRA_EN_SOL.search(q['sol'] or '') or LETRA_EN_SOL.search(q['enunciado']):
        return False
    nums = [_numero(o) for o in ops]
    if all(x is not None for x in nums) and nums == sorted(nums):
        return False  # valores numéricos ordenados: se dejan en su orden natural
    return True


def ordenar_prueba(qs, rng):
    """qs: preguntas de una prueba. Devuelve [(opciones, clave)] con claves equilibradas."""
    res = [None] * len(qs)
    cuenta = Counter()
    for i, q in enumerate(qs):
        if not barajable(q):
            res[i] = (list(q['raw']['opciones']), q['clave'])
            cuenta[q['clave']] += 1
    for i, q in enumerate(qs):
        if res[i] is not None:
            continue
        minimo = min(cuenta[l] for l in LETRAS)
        objetivo = rng.choice([l for l in LETRAS if cuenta[l] == minimo])
        ops = list(q['raw']['opciones'])
        correcta = ops[LETRAS.index(q['clave'])]
        otras = [o for j, o in enumerate(ops) if j != LETRAS.index(q['clave'])]
        rng.shuffle(otras)
        otras.insert(LETRAS.index(objetivo), correcta)
        res[i] = (otras, objetivo)
        cuenta[objetivo] += 1
    return res


def limpiar_refs(t):
    """Referencias a figuras o tablas del libro: no existen en este documento."""
    t = re.sub(r'(tabla|figura|cuadro)\s+#ref\(<[^>]+>[^)]*\)', r'\1 del libro', t)
    t = re.sub(r'(?:la|el)\s+#ref\(<([^>]+)>[^)]*\)', lambda m: 'la tabla del libro' if ('cuadro' in m.group(1) or 'tab' in m.group(1)) else 'la figura del libro', t)
    t = re.sub(r'#ref\(<([^>]+)>[^)]*\)', lambda m: 'la tabla del libro' if ('cuadro' in m.group(1) or 'tab' in m.group(1)) else 'la figura del libro', t)
    t = re.sub(r'(?<![\w])@([a-z][\w-]*)(\[[^\]]*\])?', 'la figura del libro', t)
    return t


def typst_str(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def titulos_temas():
    t = {}
    for f in glob.glob(os.path.join(ROOT, 'build/simulacros/in/*.json')):
        for k, v in json.load(open(f, encoding='utf-8'))['temas'].items():
            t[k] = v['titulo']
    return t


def orden_tema(t):
    return (t[0] != 'T', int(t[1:]))


def generar(plan, salida):
    banco = cargar_preguntas()
    rng = random.Random(20261021)
    usadas, cuerpo = [], []
    donde = {}  # cid → [«3·P1·7», …]
    conceptos = {}  # cid → (tema, concepto)
    for sim in plan['simulacros']:
        n = sim['n']
        cuerpo.append(f'\n// {"=" * 70}\n#simulacro({n})\n')
        for prueba in sim['pruebas']:
            p = prueba['p']
            cuerpo.append(f'#prueba({n}, {p})\n')
            qs = [banco[it['qid']] for it in prueba['items']]
            orden = ordenar_prueba(qs, rng)
            for k, (it, q, (ops, clave)) in enumerate(zip(prueba['items'], qs, orden), 1):
                usadas.append((n, p, k, q['id'], it['cid'], clave))
                donde.setdefault(it['cid'], []).append(f'{n}·{p}·{k}')
                conceptos[it['cid']] = (it['tema'], it['concepto'])
                origen = '' if q.get('nueva') else q['id']
                ops_t = ', '.join(limpiar_refs(o) for o in ops)
                cuerpo.append(
                    f'#pq({n}, {p}, {k}, "{clave}", {typst_str(origen)}, {typst_str(it["concepto"])},\n'
                    f'  {limpiar_refs(q["raw"]["enunciado"])},\n'
                    f'  ({ops_t},),\n'
                    f'  sol: {limpiar_refs(q["raw"]["sol"] or "[]")})\n')
            cuerpo.append('#fin-prueba()\n')
        cuerpo.append(f'#soluciones-simulacro({n})\n')
    # ---- apéndice de repaso: pregunta → respuesta
    cuerpo.append('\n#repaso-inicio()\n')
    tema_actual = None
    titulos = titulos_temas()
    for i, it in enumerate(plan['repaso'], 1):
        q = banco[it['qid']]
        if it['tema'] != tema_actual:
            tema_actual = it['tema']
            cuerpo.append(f'#repaso-tema({typst_str(tema_actual)}, {typst_str(titulos.get(tema_actual, ""))})\n')
        resp = q['raw']['opciones'][LETRAS.index(q['clave'])]
        origen = '' if q.get('nueva') else q['id']
        donde.setdefault(it['cid'], []).append(f'R{i}')
        conceptos[it['cid']] = (it['tema'], it['concepto'])
        cuerpo.append(f'#rq({i}, {typst_str(origen)}, {limpiar_refs(q["raw"]["enunciado"])}, {limpiar_refs(resp)})\n')
    # ---- mapa de conceptos
    cuerpo.append('\n#mapa-inicio()\n#mapa-cuerpo[\n')
    por_tema = {}
    for cid, (tema, con) in conceptos.items():
        por_tema.setdefault(tema, []).append((cid, con))
    for tema in sorted(por_tema, key=orden_tema):
        cuerpo.append(f'#mapa-tema({typst_str(tema)}, {typst_str(titulos.get(tema, ""))})\n')
        for cid, con in sorted(por_tema[tema], key=lambda x: int(re.sub(r'\D', '', x[0].split('-')[-1]) or 0)):
            cuerpo.append(f'#mapa-item({typst_str(con)}, {typst_str(", ".join(donde[cid]))})\n')
    cuerpo.append(']\n')
    texto = ''.join(cuerpo)
    macros, faltan = definiciones(texto)
    faltan = [f for f in faltan if f not in ('_self-policing', '_ex-young')]
    if faltan:
        print('AVISO macros no encontradas:', faltan)
    n_t = sum(1 for u in usadas if u[1] == 1)
    datos = (f'#let datos = (n: {plan["n"]}, preguntas: {len(usadas)}, conceptos: {len(conceptos)}, '
             f'repaso: {len(plan["repaso"])}, nuevas: {sum(1 for u in usadas if u[3].startswith("N-"))}, '
             f'tecnicas: {n_t})\n')
    cab = open(os.path.join(AQUI, 'cabecera.typ'), encoding='utf-8').read()
    intro = open(os.path.join(AQUI, 'intro.typ'), encoding='utf-8').read()
    with open(salida, 'w', encoding='utf-8') as f:
        f.write(cab)
        f.write('\n// ---- macros locales copiadas de los capítulos del libro (generado) ----\n')
        f.write(macros + '\n')
        f.write(datos)
        f.write(intro)
        f.write(texto)
    json.dump(usadas, open(os.path.join(ROOT, 'build/simulacros/usadas.json'), 'w'), ensure_ascii=False)
    return usadas


if __name__ == '__main__':
    plan = json.load(open(sys.argv[1], encoding='utf-8'))
    u = generar(plan, sys.argv[2])
    print(len(u), 'preguntas; claves:', dict(Counter(x[5] for x in u)))
    peor = max((abs(c - 7.5) for s in range(1, plan['n'] + 1) for p in (1, 2)
                for c in Counter(x[5] for x in u if x[0] == s and x[1] == p).values()), default=0)
    print('máxima desviación de letras por prueba:', peor)
