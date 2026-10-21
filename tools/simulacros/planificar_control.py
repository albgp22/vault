"""Plan de los simulacros de CONTROL: los mismos conceptos que los simulacros de estudio (con el
mismo número de preguntas por concepto), con las preguntas nuevas K-<cid>-<n>, repartidos de nuevo
en 13 exámenes con otra semilla. Uso: python3 -I tools/simulacros/planificar_control.py
→ build/control/plan.json"""
import json
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import generar  # noqa: E402
from planificar import repartir, equilibrar, orden_tema  # noqa: E402

ROOT = generar.ROOT


def main():
    estudio = json.load(open(os.path.join(ROOT, 'build/simulacros/plan.json'), encoding='utf-8'))
    banco = generar.cargar_control(generar.cargar_preguntas())
    conceptos = {}
    for s in estudio['simulacros']:
        for pr in s['pruebas']:
            for k, it in enumerate(pr['items'], 1):
                c = conceptos.setdefault(it['cid'], {'cid': it['cid'], 'tema': it['tema'], 'peso': it['peso'],
                                                     'concepto': it['concepto'], 'estudio': [], 'libro': [], 'preguntas': []})
                c['estudio'].append(f"{s['n']}·{pr['p']}·{k}")
                if not it['qid'].startswith('N-'):
                    c['libro'].append(it['qid'])
                c['preguntas'].append(f"K-{it['cid']}-{len(c['preguntas']) + 1}")
    faltan = [q for c in conceptos.values() for q in c['preguntas'] if q not in banco]
    if faltan:
        print('AVISO preguntas de control que faltan:', len(faltan), faltan[:10])
    n = estudio['n']
    rng = random.Random(20261022)
    sims = [{'n': k + 1, 'pruebas': []} for k in range(n)]
    for p, parte in ((1, 'T'), (2, 'R')):
        items = [(c, i) for c in conceptos.values() if c['tema'][0] == parte
                 for i, q in enumerate(c['preguntas']) if q in banco]
        rep = equilibrar(repartir(items, n, rng))
        for k in range(n):
            its = sorted(rep[k], key=lambda it: (orden_tema(it[0]['tema']), it[0]['cid'], it[1]))
            sims[k]['pruebas'].append({'p': p, 'items': [
                {'qid': c['preguntas'][i], 'cid': c['cid'], 'tema': c['tema'], 'concepto': c['concepto'],
                 'peso': c['peso'], 'estudio': c['estudio'], 'libro': c['libro'], 'variante': i} for c, i in its]})
    plan = {'n': n, 'simulacros': sims}
    os.makedirs(os.path.join(ROOT, 'build/control'), exist_ok=True)
    json.dump(plan, open(os.path.join(ROOT, 'build/control/plan.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('N =', n, 'tamaños:', [(len(s['pruebas'][0]['items']), len(s['pruebas'][1]['items'])) for s in sims])
    # mismo concepto en el mismo número de examen que en estudio: solo informativo
    igual = sum(1 for s in sims for pr in s['pruebas'] for it in pr['items']
                if any(e.split('·')[0] == str(s['n']) for e in it['estudio']))
    print('preguntas cuyo concepto cae en el mismo número de simulacro que en estudio:', igual)


if __name__ == '__main__':
    main()
