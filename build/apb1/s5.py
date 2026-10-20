#!/usr/bin/env python3
# Stage 5: build chapters/ap-b1.typ
import re, sys, os
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb1')
import s2, s3, s4

OUT = '/Users/albertogarciaplanes/tmpradio/chapters/ap-b1.typ'

OVR = [
    ('C-T1.20', 'sol', '$E =^1_2 L I^2$', '$E = 1/2 L I^2$'),
    ('C-T1.22', 'sol', '$I$ = dq/dt', '$I = "d"q slash "d"t$'),
    ('C-T1.23', 'sol', 'El valor máximo√ (de pico) es mayor: 220 2 ≈ 311 V.', 'El valor máximo (de pico) es mayor: $220 sqrt(2) ≈ 311$ V.'),
    ('C-T1.23', 'noesta', 'se especifica√ √ en valor eficaz', 'se especifica en valor eficaz'),
    ('C-T1.23', 'noesta', '$V_("ef") = V_0 slash$ 2, el pico es $V_0 = V_("ef")$ 2: unos', '$V_("ef") = V_0 slash sqrt(2)$, el pico es $V_0 = V_("ef") sqrt(2)$: unos'),
    ('C-T1.26', 'sol', '$P$ (dBm) $= 10 log_(10−)^P_(3 "W")$', '$P ("dBm") = 10 log P / (10^(−3) "W")$'),
    ('C-T1.26', 'sol', '$10 log_10^1_(−3) = 10 log 1000 = 30$', '$10 log 1 / 10^(−3) = 10 log 1000 = 30$'),
    ('C-T1.30', 'sol', 'reactancias√ del circuito', 'reactancias del circuito'),
    ('C-T1.30', 'sol', '$Z = R^2 + X^2$', '$Z = sqrt(R^2 + X^2)$'),
    ('C-T2.7', 'sol', '($e = −N$ dφ/dt = 0)', '($e = −N "d"φ slash "d"t = 0$)'),
    ('C-T2.14', 'sol', '$W =^1_2C V^2$', '$W = 1/2 C V^2$'),
    ('C-T2.15', 'sol', '$L = μ N^2A slash ell —$ y no', '$L = μ N^2 A slash ell$— y no'),
    ('C-T5.21', 'sol', '$m =^A_A^("m" ´ "ax" −)_(+A)^(A "m" ´𝚤 "n")$', '$m = (A_"máx" − A_"mín") / (A_"máx" + A_"mín")$'),
    ('C-T5.21', 'sol', 'No#super[m´axm´𝚤n] es', 'No es'),
    ('C-T6.15', 'sol', '$= V_("m" ´ "ax") slash V_("m" ´𝚤 "n") = (1 + |ρ$ |)/(1 $− |ρ|$)', '$= V_"máx" slash V_"mín" = (1 + |ρ|) slash (1 − |ρ|)$'),
    ('C-T6.15', 'sol', '$2V_d slash 2V_r = 1 slash |ρ |$', '$2V_d slash 2V_r = 1 slash |ρ|$'),
    ('C-T7.8', 'sol', '$λ$ (m) = 300 $000 slash f$ (kHz)', '$λ ("m") = 300 thin 000 slash f$ (kHz)'),
    ('C-T8.3', 'sol', '$P$ (dBm) $= 10 log 101$ mW#super[P]', '$P ("dBm") = 10 log_10 P / (1 "mW")$'),
]


def wrap(s, width=100):
    """wrap a markup string at spaces outside $..$ and outside #cmd[..] heads"""
    out = []
    line = ''
    in_math = False
    toks = []
    cur = ''
    for ch in s:
        if ch == '$' and not (cur.endswith('\\')):
            in_math = not in_math
        if ch == ' ' and not in_math:
            toks.append(cur)
            cur = ''
        else:
            cur += ch
    toks.append(cur)
    for t in toks:
        if line == '':
            line = t
            continue
        if len(line) + 1 + len(t) > width and not re.match(r'^(?:[-+/=]|\d+[.)]|//|\*)', t):
            out.append(line)
            line = t
        else:
            line += ' ' + t
    out.append(line)
    return out


def sol_content(e, conv, indent='    '):
    parts = []
    for (kind, text) in conv:
        if kind == 'sol':
            parts.append(('', text))
        elif kind == 'noesta':
            parts.append(('#no-esta[', text))
        else:
            parts.append(('#_apb1-clave[', text))
    lines = []
    for i, (head, text) in enumerate(parts):
        body = wrap(text, 96)
        if head == '':
            for j, l in enumerate(body):
                lines.append(l)
        else:
            body[0] = head + body[0]
            body[-1] = body[-1] + ']'
            lines.extend(body)
    return lines


def main(figs):
    entries, _ = s2.solutions()
    conv = {}
    used = set()
    for e in entries:
        cs = []
        for kind, t in e['paras']:
            c = s3.convert_para(t)
            for k, (i, kd, old, new) in enumerate(OVR):
                if i == e['id'] and kd == kind and old in c:
                    c = c.replace(old, new)
                    used.add(k)
            cs.append((kind, c))
        conv[e['id']] = cs
    missing = [OVR[k] for k in range(len(OVR)) if k not in used]
    assert not missing, missing
    qs = s4.questions()
    ans = {e['id']: e['ans'] for e in entries}
    assert [q['id'] for q in qs] == [e['id'] for e in entries], 'order mismatch'
    return qs, conv, ans


if __name__ == '__main__':
    pass
