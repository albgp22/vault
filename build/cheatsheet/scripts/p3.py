PAIRS = [
(r'''  margin: (x: 1.05cm, top: 1.15cm, bottom: 1.25cm),''', r'''  margin: (x: 0.95cm, top: 1.0cm, bottom: 1.15cm),'''),
(r'''#set columns(gutter: 0.5cm)''', r'''#set columns(gutter: 0.45cm)'''),
(r'''#set text(font: fuente-texto, size: 8.6pt,''', r'''#set text(font: fuente-texto, size: 8.5pt,'''),
# units: 2 pairs per row
(r'''#table(
  columns: (auto, 1fr, auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.4pt),
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  [*Ω* ohmio], [resistencia], [*A* amperio], [intensidad], [*V* voltio], [tensión y fem],
  [*W* vatio], [potencia], [*J* julio], [energía], [*C* culombio], [carga (A·s)],
  [*F* faradio], [capacidad], [*H* henrio], [autoinducción], [*Hz* hercio], [frecuencia],
)
#k[Campo eléctrico:] V/m. ''', r'''#table(
  columns: (auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.4pt),
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  [*Ω* ohmio], [resistencia $R$], [*C* culombio], [carga $Q$ (1 C = 1 A·s)],
  [*A* amperio], [intensidad $I$], [*F* faradio], [capacidad $C$],
  [*V* voltio], [tensión y fem $V$, $E$], [*H* henrio], [autoinducción $L$],
  [*W* vatio], [potencia $P$], [*Hz* hercio], [frecuencia $f$],
  [*J* julio], [energía], [*V/m*], [campo eléctrico $E$],
)
'''),
# fig-imagen labels: taller marks, labels on top
(r'''  content((f2x(fs) + 0.55, 1.18), anchor: "west", t6(text(fill: col.senal3)[preselector (RF): deja pasar la señal \ y atenúa la imagen antes del mezclador]))''', r'''  content((0.05, 1.28), anchor: "west", t6(text(fill: col.senal3)[preselector]))'''),
(r'''  marca(14.2, 0.55, col.senal1, [señal \ 14,2])
  marca(14.655, 0.4, col.ambar, [OL \ 14,655])
  marca(15.11, 0.4, col.senal2, [imagen \ 15,11])''', r'''  marca(14.2, 1.3, col.senal1, [señal 14,2])
  marca(14.655, 1.3, col.ambar, [OL 14,655])
  marca(15.11, 1.3, col.senal2, [imagen 15,11])'''),
(r'''#fig(fig-imagen, cap: [Señal, OL e imagen quedan separadas por la FI; el OL, en medio. La imagen también da FI = 455 kHz: hay que quitarla *antes* del mezclador.])''', r'''#fig(fig-imagen, cap: [Señal, OL e imagen quedan separadas por la FI; el OL, en medio. La imagen también da FI = 455 kHz: el preselector (verde) la atenúa *antes* del mezclador.])'''),
# superhet caption: add antena
(r'''#fig(fig-superhet, cap: [Cadena: antena → amp. RF''', r'''#fig(fig-superhet, cap: [Cadena: antena → amp. RF'''),
(r'''#fig(fig-fuente, cap: [Fuente lineal: la forma de onda a la salida de cada bloque.], sim: ("fullrectf.txt", "zenerref.txt"))''', r'''#fig(fig-fuente, cap: [Fuente lineal: forma de onda a la salida de cada bloque.], sim: ("fullrectf.txt", "zenerref.txt"))'''),
]
