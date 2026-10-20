PAIRS = [
(r'''  margin: (x: 0.85cm, top: 0.95cm, bottom: 1.1cm),''', r'''  margin: (x: 0.85cm, top: 0.85cm, bottom: 1.0cm),'''),
(r'''  footer-descent: 0.4cm,''', r'''  footer-descent: 0.35cm,'''),
(r'''  `QRK`, [inteligibilidad], [`QSA` \ `QRI`], [fuerza de las señales \ tono],''', r'''  `QRK`, [inteligibilidad], `QSA`, [fuerza de las señales],'''),
(r'''Otros: `QTC` tengo mensajes''', r'''Otros: `QRI` tono · `QTC` tengo mensajes'''),
(r'''  grid(columns: (1fr,) * 5, row-gutter: 3.2pt, column-gutter: 2pt,
    ..letras.map(p => [#text(font: _sans, weight: "bold", fill: col.acento, p.first())#h(2pt)#p]))''', r'''  set text(size: 8pt)
  grid(columns: (1fr,) * 6, row-gutter: 3.2pt, column-gutter: 1pt,
    ..letras.map(p => [#text(font: _sans, weight: "bold", fill: col.acento, p.first())#h(1.5pt)#p]))'''),
]
