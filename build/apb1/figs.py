# Manual figure snippets (Typst code) for the figure questions.
STEM = {}
OPTS = {}

# ---------------------------------------------------------------- T1.26 (options with formulas)
OPTS['C-T1.26'] = [
    r'$P ("dBm") = (log P ("W")) / 10$',
    r'$P ("dBm") = 10 − 3 · log P ("W")$',
    r'$P ("dBm") = 10 · log lr([ (P ("W")) / 10^(−3) ])$',
    r'$P ("dBm") = log lr([ (P ("W")) / 10 ])$',
]

# ---------------------------------------------------------------- T6.15 (options with formulas)
OPTS['C-T6.15'] = [
    r'Potencia del transmisor − atenuación del cable entre transmisor y antena',
    r'Potencia máxima / potencia mínima',
    r'$(|V_"máx"|) / (|V_"mín"|)$',
    r'$(|V_"máx"| + |V_"mín"|) / (|V_"máx"| − |V_"mín"|)$',
]

# ---------------------------------------------------------------- T2.21 symbols
_S = 0.5  # scale for small symbols


def _sym(body, escala=_S):
    return '#box(esquema(escala: %s, {\n      import zap: *\n      import cetz.draw: *\n%s\n    }))' % (escala, body)


_triac = r'''
      line((-1.2, 0), (0, 0), stroke: 0.8pt)
      line((0, 0.9), (0, -0.9), stroke: 0.8pt)
      line((0.8, -0.9), (0.8, 0.5), stroke: 0.8pt)
      line((0, 0.9), (0.8, 0.45), (0, 0), stroke: 0.8pt)
      line((0.8, 0), (0, -0.45), (0.8, -0.9), stroke: 0.8pt)
      line((0.8, 0), (1.9, 0), stroke: 0.8pt)
      line((0.8, 0.25), (1.4, 0.7), (1.4, 1.3), stroke: 0.8pt)
'''
_jfet_p = r'''
      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((0, 0.55), (-0.4, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
      line((-0.4, 0.55), (-1.1, 0.55), stroke: 0.8pt)
'''
_jfet_n = r'''
      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((-1.1, 0.55), (0, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
'''

STEM['C-T2.21'] = '¿Cuál de los siguientes símbolos es el de un transistor FET?'
OPTS['C-T2.21'] = [
    _sym(_triac),
    '#box(esquema(escala: 0.5, {\n      import zap: *\n      npn("q1", (0, 0))\n      wire("q1.b", (-1.2, 0))\n      pnp("q2", (3.2, 0))\n      wire("q2.b", (2.0, 0))\n    }))',
    '#box(esquema(escala: 0.5, {\n      import cetz.draw: *\n      group({\n        translate((0, 0))\n' + _jfet_p + '\n      })\n      group({\n        translate((3.2, 0))\n' + _jfet_n + '\n      })\n    }))',
    '#box(esquema(escala: 0.5, {\n      import zap: *\n      diode("d1", (-1.2, 0), (1.2, 0))\n    }))',
]

# ---------------------------------------------------------------- T2.21 (redefined with larger symbols)
def _simb(body, escala=0.75, zapimp=True):
    imp = '      import zap: *\n' if zapimp else ''
    return '#box(baseline: 45%, esquema(escala: ' + str(escala) + ', {\n' + imp + '      import cetz.draw: *\n' + body + '\n    }))'

OPTS['C-T2.21'] = [
    _simb(_triac),
    _simb('''      group({
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, 0.25), (0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
        line((0, -0.25), (0.55, -0.6), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
      })
      group({
        translate((3.4, 0))
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, -0.25), (0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
        line((0.55, 0.6), (0, 0.25), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
      })''', zapimp=False),
    _simb('''      group({
        translate((0, 0))
''' + _jfet_p + '''
      })
      group({
        translate((3.4, 0))
''' + _jfet_n + '''
      })''', zapimp=False),
    _simb('''      diode("d1", (-1.2, 0), (1.2, 0))'''),
]

# ---------------------------------------------------------------- T2.22
STEM['C-T2.22'] = '¿Cuál de los siguientes símbolos es el de la resistencia?'
OPTS['C-T2.22'] = [
    _simb('''      inductor("l1", (-1.1, 0), (1.1, 0))
      line((2.0, 0), (2.4, 0), stroke: 0.8pt)
      rect((2.4, -0.2), (3.6, 0.2), fill: black, stroke: none)
      line((3.6, 0), (4.0, 0), stroke: 0.8pt)'''),
    _simb('''      line((-1.1, 0), (-0.8, 0), (-0.6, 0.35), (-0.2, -0.35), (0.2, 0.35), (0.6, -0.35), (0.8, 0), (1.1, 0), stroke: 0.8pt)
      resistor("r1", (2.0, 0), (4.0, 0))'''),
    _simb('''      capacitor("c1", (-1.1, 0), (1.1, 0))
      pcapacitor("c2", (2.0, 0), (4.2, 0))
      content((3.45, 0.45), text(size: 7pt)[+])'''),
    _simb('''      diode("d1", (-1.2, 0), (1.2, 0))'''),
]

# ---------------------------------------------------------------- T4.15
STEM['C-T4.15'] = 'El esquema de un receptor básico para banda lateral única se corresponde con la figura:'
OPTS['C-T4.15'] = [
    '#_apb1-rx([etapa\\ RF], [etapa\\ FI], [detector de\\ producto], [oscilador\\ variable], [oscilador de\\ batido])',
    '#_apb1-rx([etapa\\ FI], [etapa\\ RF], [detector de\\ producto], [oscilador\\ variable], [oscilador de\\ batido])',
    '#_apb1-rx([etapa\\ RF], [demodulador], [detector de\\ producto], [oscilador\\ fijo], [oscilador\\ variable])',
    '#_apb1-rx([etapa\\ RF], [etapa\\ FI], [diodo\\ detector], [oscilador\\ variable], none)',
]

# ---------------------------------------------------------------- T4.16
STEM['C-T4.16'] = '''En el siguiente diagrama de bloques, correspondiente a un receptor elemental de conversión directa, el bloque con interrogantes representa un:
    #circuito(caption: none)[
      #diagram(
        node-stroke: 0.6pt, spacing: (5mm, 8mm), edge-stroke: 0.6pt, mark-scale: 70%,
        node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
        edge((0, 0), (1, 0), "-|>"),
        _apb1-bq((1, 0), [mezclador]),
        edge((1, 0), (2, 0), "-|>"),
        _apb1-bq((2, 0), [filtro\\ de audio]),
        edge((2, 0), (3, 0), "-|>"),
        _apb1-bq((3, 0), [amplificador\\ de audio]),
        edge((3, 0), (4, 0), "-|>"),
        node((4, 0), stack(dir: ttb, spacing: 1pt, _apb1-alt, _apb1-etq[altavoz]), stroke: none),
        node((1, 1), text(size: 9pt, weight: "bold", fill: col.naranja)[?], shape: rect, stroke: (paint: col.naranja, dash: "dashed", thickness: 0.7pt), fill: col.naranja-claro, inset: 6pt),
        edge((1, 1), (1, 0), "-|>"),
      )
    ]'''

# ---------------------------------------------------------------- T5.31
STEM['C-T5.31'] = 'El esquema de un transmisor básico para banda lateral única se corresponde con la figura:'
OPTS['C-T5.31'] = [
    '#_apb1-tx([etapa\\ BF], [modulador\\ de fase], [filtro], [amplificador\\ RF])',
    '#_apb1-tx([etapa\\ BF], [modulador\\ balanceado], [filtro], [amplificador\\ RF])',
    '#_apb1-tx([etapa\\ BF], [modulador\\ balanceado], [modulador\\ de fase], [amplificador\\ RF])',
    '#_apb1-tx([etapa\\ RF], [modulador\\ balanceado], [filtro], [amplificador\\ BF])',
]

# ---------------------------------------------------------------- T6.19
STEM['C-T6.19'] = 'Señale el diagrama de radiación correspondiente a una antena Yagi:'
OPTS['C-T6.19'] = [
    '#box(baseline: 45%, _apb1-donut(1))',
    '#box(baseline: 45%, _apb1-rosa)',
    '#box(baseline: 45%, _apb1-donut(2))',
    '#box(baseline: 45%, _apb1-yagi)',
]

# ---------------------------------------------------------------- T6.21, T6.22
STEM['C-T6.21'] = 'Señale la conexión correcta entre equipos:'
OPTS['C-T6.21'] = [
    '#_apb1-cadena("acop", "roe", "amp")',
    '#_apb1-cadena("roe", "acop", "amp")',
    '#_apb1-cadena("amp", "roe", "acop")',
    '#_apb1-cadena("amp", "acop", "roe")',
]
STEM['C-T6.22'] = 'Señale la configuración de conexión de equipos correcta:'
OPTS['C-T6.22'] = [
    '#_apb1-cadena("acop", "amp")',
    '#_apb1-cadena("acop", "roe")',
    '#_apb1-cadena("roe", "acop")',
    '#_apb1-cadena("campo", "amp")',
]

# ---------------------------------------------------------------- T7.13
STEM['C-T7.13'] = '''En el siguiente gráfico, si la antena emite tres señales en distintas frecuencias, ¿cuál de ellas tiene una frecuencia superior a la frecuencia crítica?
    #circuito(caption: none)[
      #_apb1-iono
    ]'''

# ---------------------------------------------------------------- T8.12
STEM['C-T8.12'] = '''Para medir la potencia disipada en la resistencia del circuito de la figura, se deben seleccionar:
    #circuito(caption: none)[
      #_apb1-pot
    ]'''

# ---------------------------------------------------------------- T10.8
STEM['C-T10.8'] = 'Señale la conexión correcta entre los chasis metálicos de los equipos:'
OPTS['C-T10.8'] = [
    '#_apb1-chasis({\n      import cetz.draw: *\n      line((7.6, -0.75), (7.6, -1.3), stroke: 0.6pt)\n      circle((7.6, -0.75), radius: 0.03, fill: black, stroke: none)\n      line((7.2, -1.3), (8.0, -1.3), stroke: 1.2pt)\n      line((7.3, -1.45), (7.9, -1.45), stroke: 1.0pt)\n      line((7.4, -1.6), (7.8, -1.6), stroke: 0.8pt)\n      content((8.7, -1.45), text(size: 6.6pt, fill: col.gris)[tierra])\n    }, grueso: false)',
    '#_apb1-chasis({\n      import cetz.draw: *\n      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[230 V\\ (fase)]))\n    })',
    '#_apb1-chasis({\n      import cetz.draw: *\n      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[230 V\\ (neutro)]))\n    })',
    '#_apb1-chasis({\n      import cetz.draw: *\n      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[+12 V\\ CC]))\n    })',
]
