"""Reparte los conceptos (build/simulacros/conceptos/*.json) en N simulacros de 30 + 30.
Uso: python3 -I tools/simulacros/planificar.py [N]   → build/simulacros/plan.json
Prioridad de entrada en los simulacros: primera pregunta de peso 3, de peso 2, segunda pregunta
de peso 3, primera de peso 1, segunda de peso 2, segunda de peso 1. Lo que no cabe va al apéndice
de repaso (pregunta → respuesta). Sin N, elige el menor N que mete todo el peso 3 y 2 técnico."""
import glob
import json
import math
import os
import random
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
EXCLUIR = set(json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'excluir.json'))))


def orden_tema(t):
    return (t[0] != 'T', int(t[1:]))


def cargar():
    conceptos = []
    for f in sorted(glob.glob(os.path.join(ROOT, 'build/simulacros/conceptos/*.json'))):
        for c in json.load(open(f, encoding='utf-8'))['conceptos']:
            qs = [q for q in c['preguntas'] if q not in EXCLUIR]
            if not qs:
                # concepto sin pregunta utilizable: probar con otra de su «cubre»
                qs = [q for q in c.get('cubre', []) if q not in EXCLUIR][:1]
            if not qs:
                print('AVISO concepto sin pregunta:', c['cid'])
                continue
            conceptos.append({**c, 'preguntas': qs})
    # fusión de conceptos duplicados entre temas (duplicados-*.json)
    por_cid = {c['cid']: c for c in conceptos}
    quitar = set()
    for f in sorted(glob.glob(os.path.join(ROOT, 'build/simulacros/duplicados-*.json'))):
        for g in json.load(open(f, encoding='utf-8')):
            k = por_cid.get(g['conservar'])
            if k is None:
                print('AVISO duplicado: no existe', g['conservar'])
                continue
            k['peso'] = max([k['peso'], g.get('peso') or 0] + [por_cid[q]['peso'] for q in g['quitar'] if q in por_cid])
            seg = g.get('segunda')
            if seg and seg not in EXCLUIR and seg not in k['preguntas']:
                k['preguntas'] = k['preguntas'][:1] + [seg]
            quitar.update(g['quitar'])
    return [c for c in conceptos if c['cid'] not in quitar]


def items_por_prioridad(conceptos, parte):
    cs = [c for c in conceptos if c['tema'][0] == parte]
    niveles = [
        [(c, 0) for c in cs if c['peso'] == 3],
        [(c, 0) for c in cs if c['peso'] == 2],
        [(c, 1) for c in cs if c['peso'] == 3 and len(c['preguntas']) > 1],
        [(c, 0) for c in cs if c['peso'] == 1],
        [(c, 1) for c in cs if c['peso'] == 2 and len(c['preguntas']) > 1],
        [(c, 1) for c in cs if c['peso'] == 1 and len(c['preguntas']) > 1],
    ]
    return niveles


def repartir(items, n, rng):
    """items: lista de (concepto, índice de pregunta). Devuelve n listas de 30 (orden de tema),
    con cada tema repartido por igual y las segundas preguntas lejos de las primeras."""
    por_tema = {}
    for it in items:
        por_tema.setdefault(it[0]['tema'], []).append(it)
    cupos = [[] for _ in range(n)]
    # reparto por tema: cada simulacro recibe floor/ceil; los restos van a los simulacros con menos
    for tema in sorted(por_tema, key=orden_tema):
        lista = por_tema[tema]
        lista.sort(key=lambda it: (it[1], -it[0]['peso'], it[0]['cid']))
        primeras = [it for it in lista if it[1] == 0]
        segundas = [it for it in lista if it[1] == 1]
        rng.shuffle(primeras)
        primeras.sort(key=lambda it: -it[0]['peso'])  # estable: peso alto se reparte primero
        orden_sims = sorted(range(n), key=lambda i: (len(cupos[i]), rng.random()))
        dondeprim = {}
        for k, it in enumerate(primeras):
            s = min(range(n), key=lambda i: (len(cupos[i]) + (0 if i in orden_sims[:1] else 0), sum(1 for x in cupos[i] if x[0]['tema'] == tema), rng.random()))
            s = min(range(n), key=lambda i: (sum(1 for x in cupos[i] if x[0]['tema'] == tema), len(cupos[i]), rng.random()))
            cupos[s].append(it)
            dondeprim[it[0]['cid']] = s
        for it in segundas:
            p = dondeprim.get(it[0]['cid'])
            cand = [i for i in range(n) if p is None or abs(i - p) >= max(2, n // 3)] or [i for i in range(n) if i != p]
            s = min(cand, key=lambda i: (sum(1 for x in cupos[i] if x[0]['tema'] == tema), len(cupos[i]), rng.random()))
            cupos[s].append(it)
    return cupos


def equilibrar(cupos, objetivo=30):
    """Mueve preguntas de los simulacros con más de 30 a los que tienen menos (mismo tema si se puede)."""
    cambiado = True
    while cambiado:
        cambiado = False
        largos = [i for i, c in enumerate(cupos) if len(c) > objetivo]
        cortos = [i for i, c in enumerate(cupos) if len(c) < objetivo]
        if not largos or not cortos:
            break
        i, j = largos[0], cortos[0]
        # elegir una pregunta de i cuyo concepto no esté ya en j
        cids_j = {x[0]['cid'] for x in cupos[j]}
        for k, it in enumerate(cupos[i]):
            if it[0]['cid'] not in cids_j:
                cupos[j].append(cupos[i].pop(k))
                cambiado = True
                break
    return cupos


def main():
    rng = random.Random(20261021)
    conceptos = cargar()
    niv_t = items_por_prioridad(conceptos, 'T')
    niv_r = items_por_prioridad(conceptos, 'R')
    nucleo_t = len(niv_t[0]) + len(niv_t[1])
    n = int(sys.argv[1]) if len(sys.argv) > 1 else math.ceil(nucleo_t / 30)
    plazas = 30 * n
    elegidos, fuera = {}, {}
    for parte, niveles in (('T', niv_t), ('R', niv_r)):
        sel, resto = [], []
        for nivel in niveles:
            for it in nivel:
                (sel if len(sel) < plazas else resto).append(it)
        # si sobran plazas (no debería), se quedan cortas: avisar
        if len(sel) < plazas:
            print(f'AVISO parte {parte}: solo {len(sel)} preguntas para {plazas} plazas')
        elegidos[parte], fuera[parte] = sel, resto
    sims = []
    rep = {p: equilibrar(repartir(elegidos[p], n, rng)) for p in ('T', 'R')}
    for k in range(n):
        pruebas = []
        for p, parte in ((1, 'T'), (2, 'R')):
            its = sorted(rep[parte][k], key=lambda it: (orden_tema(it[0]['tema']), it[0]['cid'], it[1]))
            pruebas.append({'p': p, 'items': [{'qid': c['preguntas'][i], 'cid': c['cid'], 'tema': c['tema'],
                                               'concepto': c['concepto'], 'peso': c['peso']} for c, i in its]})
        sims.append({'n': k + 1, 'pruebas': pruebas})
    repaso = [{'qid': c['preguntas'][i], 'cid': c['cid'], 'tema': c['tema'], 'concepto': c['concepto'], 'peso': c['peso']}
              for parte in ('T', 'R') for c, i in fuera[parte] if i == 0]
    repaso.sort(key=lambda x: (orden_tema(x['tema']), x['cid']))
    plan = {'n': n, 'simulacros': sims, 'repaso': repaso}
    json.dump(plan, open(os.path.join(ROOT, 'build/simulacros/plan.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    # informe
    from collections import Counter
    print(f'N = {n} simulacros; conceptos: {len(conceptos)}')
    for parte in ('T', 'R'):
        en = Counter(it[0]['peso'] for it in elegidos[parte] if it[1] == 0)
        seg = sum(1 for it in elegidos[parte] if it[1] == 1)
        fu = Counter(it[0]['peso'] for it in fuera[parte] if it[1] == 0)
        print(f'  {parte}: en simulacros {len(elegidos[parte])} (primeras por peso {dict(en)}, segundas {seg}); '
              f'al repaso {sum(fu.values())} {dict(fu)}; segundas no usadas {sum(1 for it in fuera[parte] if it[1] == 1)}')
    tamanos = [(len(s['pruebas'][0]['items']), len(s['pruebas'][1]['items'])) for s in sims]
    print('  tamaños:', tamanos)


if __name__ == '__main__':
    main()
