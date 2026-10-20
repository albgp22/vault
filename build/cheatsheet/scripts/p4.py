PAIRS = [
(r'''#table(
  columns: (auto, 1fr, auto, 1fr),
  th[Aparato][Uso][Aparato][Uso],
  [amperímetro], [en *serie*; $R_i$ nula], [voltímetro], [en *paralelo*; $R_i$ infinita],
  [óhmetro], [sin tensión y con los condensadores descargados], [shunt], [en paralelo con el amperímetro: amplía la escala y protege],
  [frecuencímetro], [la frecuencia, con precisión], [osciloscopio], [dominio del *tiempo*: amplitud, $T$, $f = 1 slash T$],
  [analizador], [dominio de la *frecuencia* (espectro): portadora, bandas, armónicos], [generador de RF], [señal calibrada para probar etapas],
  [medidor de campo], [V/m (dBμV/m)], [dipmeter], [resonancia de un circuito *sin alimentarlo*],
  [carga artificial], [50 Ω no inductiva: ajustar sin radiar], [medidor de ROE], [el más imprescindible],
)''', r'''#table(
  columns: (auto, 1fr),
  th[Aparato][Cómo se usa · qué mide],
  [amperímetro], [en *serie*; $R_i$ nula],
  [voltímetro], [en *paralelo*; $R_i$ infinita],
  [óhmetro], [sin tensión y con los condensadores descargados],
  [shunt], [en paralelo con el amperímetro: amplía la escala y lo protege],
  [medidor de ROE], [el más imprescindible de la estación],
  [frecuencímetro], [la frecuencia, con precisión],
  [osciloscopio], [dominio del *tiempo*: amplitud, $T$ y $f = 1 slash T$],
  [analizador], [dominio de la *frecuencia* (espectro): portadora, bandas, armónicos],
  [generador de RF], [señal calibrada para probar etapas],
  [medidor de campo], [V/m (dBμV/m)],
  [dipmeter], [resonancia de un circuito *sin alimentarlo*],
  [carga artificial], [50 Ω no inductiva: ajustar sin radiar],
)'''),
(r'''#table(
  columns: (auto, 1fr, auto, 1fr),
  th[Dónde][Remedio][Dónde][Remedio],
  [salida TX], [filtro paso bajo], [red], [filtro de línea],
  [cables], [ferritas y condensadores; cable blindado al altavoz], [televisor], [filtro de rechazo a su entrada],
  [equipo], [caja metálica estanca y a tierra (jaula de Faraday, en los dos sentidos)], [estación], [buena tierra, ROE baja, potencia mínima, marcado CE (EMC); fibra óptica: inmune],
)''', r'''#table(
  columns: (auto, 1fr),
  th[Dónde][Remedio: filtrar, desacoplar, apantallar],
  [salida del TX · red], [filtro paso bajo · filtro de línea en la red],
  [cables · televisor], [ferritas y condensadores; cable blindado al altavoz · filtro de rechazo en el televisor],
  [equipo], [caja metálica estanca y a tierra (jaula de Faraday: protege en los dos sentidos)],
  [estación], [buena tierra, ROE baja, potencia mínima, marcado CE (EMC); la fibra óptica es inmune],
)'''),
# color table: no hyphenation
(r'''    table.cell(fill: c, text(fill: if i in (3, 4, 9) { black } else { white }, font: _sans, size: 6.2pt, weight: "bold")[#i \ #n])''', r'''    table.cell(fill: c, inset: (x: 0.5pt, y: 1.8pt), text(fill: if i in (3, 4, 9) { black } else { white }, font: _sans, size: 5.7pt, weight: "bold", hyphenate: false)[#i \ #n])'''),
# Prueba 2 band shorter
(r'''#prueba[Prueba 2 · Normativa reglamentaria][temas R1 a R9 · Orden IET/1311/2013 · Ley 11/2022 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 2 · Normativa reglamentaria][temas R1 a R9 · 30 preguntas · 45 min · aprobado con 15]'''),
(r'''- Nomenclatura UIT (tabla de T7): VHF 30–300 MHz = ondas métricas, B.m, banda nº 8; UHF 0,3–3 GHz = nº 9. Clases de emisión (T1): A1A CW · A3E AM · J3E BLU · F3E FM.''', r'''- Nomenclatura UIT (tabla en T7): VHF 30–300 MHz = métricas, B.m, banda nº 8; UHF = nº 9. Clases (T1): A1A CW · A3E AM · J3E BLU · F3E FM.'''),
(r'''  [portable], [la fija, usada temporalmente en otro sitio (sin distintivo temporal)],''', r'''  [portable], [la fija usada temporalmente en otro sitio (sin distintivo temporal)],'''),
# ionosphere smaller: scale via canvas length
(r'''#let fig-ionosfera = cetz.canvas(length: 1cm, {''', r'''#let fig-ionosfera = cetz.canvas(length: 0.9cm, {'''),
(r'''  let W = 8.6
  let capa(y1, y2, c, txt) = {''', r'''  let W = 9.5
  let capa(y1, y2, c, txt) = {'''),
(r'''  let tx = (3.65, 0)
  line(tx, (6.0, 2.45), (8.35, 0), stroke: 1pt + col.senal1)
  line(tx, (4.75, 3.15), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((4.8, 3.12), anchor: "west", t6(text(fill: col.senal2)[$f$ > MUF: atraviesa y se pierde]))
  line(tx, (4.6, 0.0), stroke: 1.4pt + col.verde, mark: (end: ">", fill: col.verde, scale: 0.4))
  content((3.65, 0), anchor: "north", padding: 1pt, t6[TX])
  content((8.35, 0), anchor: "north-east", padding: 1pt, t6[1.#super[er] salto])
  line((4.65, -0.3), (8.3, -0.3), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
  content((6.45, -0.3), anchor: "north", padding: 1pt, t6[zona de silencio])
  content((3.4, -0.08), anchor: "north-east", t6(text(fill: col.verde)[onda de superficie →]))''', r'''  let tx = (4.0, 0)
  line(tx, (6.65, 2.45), (9.3, 0), stroke: 1pt + col.senal1)
  line(tx, (5.15, 3.15), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((5.2, 3.12), anchor: "west", t6(text(fill: col.senal2)[$f$ > MUF: atraviesa y se pierde]))
  line(tx, (5.0, 0.0), stroke: 1.4pt + col.verde, mark: (end: ">", fill: col.verde, scale: 0.4))
  content((4.0, 0), anchor: "north", padding: 1pt, t6[TX])
  content((9.3, 0), anchor: "north-east", padding: 1pt, t6[1.#super[er] salto])
  line((5.05, -0.3), (9.25, -0.3), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
  content((7.15, -0.3), anchor: "north", padding: 1pt, t6[zona de silencio])
  content((3.75, -0.08), anchor: "north-east", t6(text(fill: col.verde)[onda de superficie →]))'''),
# dipole smaller
(r'''#let fig-dipolo = cetz.canvas(length: 1cm, {''', r'''#let fig-dipolo = cetz.canvas(length: 0.92cm, {'''),
(r'''  let L = 3.6''', r'''  let L = 3.9'''),
]
