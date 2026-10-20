PAIRS = [
# modulation table widths and text
(r'''#table(
  columns: (auto, auto, 1fr),
  th[Clase][Varía][Lo que cae en el examen],
  [`A1A` CW], [portadora on/off], [flancos bruscos ⇒ chasquidos (clics)],
  [`A3E` AM], [amplitud], [portadora + 2 bandas; $B = 2 f_m$ (6 kHz con voz de 3 kHz); $m > 100$ %: sobremodulación (distorsión, _splatter_)],
  [`J3E` BLU/SSB], [—], [1 banda, sin portadora: 2,7 kHz],
  [`F3E` FM], [frecuencia (amplitud constante)], [índice $m = Delta f slash f_m$; Carson $B approx 2(Delta f + f_m)$; FM comercial en VHF],
  [PM], [fase], [—],
)''', r'''#table(
  columns: (1.75cm, 1.6cm, 1fr),
  th[Clase][Varía][Lo que cae en el examen],
  [`A1A` CW], [on/off], [flancos bruscos ⇒ chasquidos (clics)],
  [`A3E` AM], [amplitud], [portadora + 2 bandas: $B = 2 f_m$ (6 kHz con voz de 3 kHz); $m > 100$ % = sobremodulación (distorsión, _splatter_)],
  [`J3E` BLU/SSB], [amplitud], [1 banda, sin portadora: 2,7 kHz],
  [`F3E` FM], [frecuencia], [amplitud constante; índice $m = Delta f slash f_m$; Carson $B approx 2(Delta f + f_m)$; FM comercial en VHF],
  [PM], [fase], [—],
)'''),
# sinusoid table compact
(r'''#table(
  columns: (auto, auto, 1fr),
  th[Valor][Fórmula][Ej. con $V_"max" = 100$ V],''', r'''#table(
  columns: (auto, auto, 1fr),
  th[Valor][Fórmula][Ej. con $V_"max" = 100$ V],'''),
(r'''  [media de media onda], [$2 V_"max" slash pi = 0,637 V_"max"$], [63,7 V (de la senoide entera: 0)],''', r'''  [media de ½ ciclo], [$2 V_"max" slash pi = 0,637 V_"max"$], [63,7 V (senoide entera: 0)],'''),
# series/parallel table compact
(r'''  [total], [$R = R_1 + R_2 + …$], [$1 slash R = 1 slash R_1 + 1 slash R_2 + …$],
  [atajos], [—], [dos: producto/suma; $n$ iguales: $R slash n$],
  [resultado], [mayor que la mayor], [siempre *menor que la menor*],''', r'''  [total], [$R = R_1 + R_2 + …$ \ mayor que la mayor], [$1 slash R = 1 slash R_1 + 1 slash R_2 + …$; dos: producto/suma; $n$ iguales: $R slash n$. Siempre *menor que la menor*],'''),
# fuente badges
(r'''sim: ("fullrect.txt", "fullrectf.txt", "zenerref.txt"))''', r'''sim: ("fullrectf.txt", "zenerref.txt"))'''),
# CE: smaller figure
(r'''#let fig-ec = esquema(escala: 0.78, {''', r'''#let fig-ec = esquema(escala: 0.6, {'''),
# measures table -> two pairs per row
(r'''#table(
  columns: (auto, 1fr),
  th[Instrumento][Cómo se usa · qué mide],
  [amperímetro], [en *serie*; $R_i$ nula],
  [voltímetro], [en *paralelo*; $R_i$ infinita],
  [óhmetro], [sin tensión en el circuito y con los condensadores descargados],
  [shunt], [resistencia en paralelo con el amperímetro: amplía la escala y lo protege],
  [polímetro], [$V$, $I$, $R$; sin _true RMS_ falla con ondas no senoidales; no mide la impedancia de una antena],
  [vatímetro direccional], [potencia directa $P_d$ y reflejada $P_r$: $rho = sqrt(P_r slash P_d)$; reflejada apreciable = no adaptado],
  [medidor de ROE], [el más imprescindible de la estación],
  [frecuencímetro], [la frecuencia, con precisión],
  [osciloscopio], [dominio del *tiempo*: amplitud, $T$ y $f = 1 slash T$],
  [analizador de espectro], [dominio de la *frecuencia*: portadora, bandas laterales, armónicos],
  [generador de RF], [señal calibrada para probar etapas],
  [medidor de campo], [V/m (dBμV/m)],
  [dipmeter], [la resonancia de un circuito *sin alimentarlo*],
  [carga artificial], [50 Ω no inductiva: ajustar sin radiar],
)
#ej[100 W directa y 25 W reflejada → $rho = sqrt(25 slash 100) = 0,5$ → ROE 3; radia 75 W.]''', r'''#table(
  columns: (auto, 1fr, auto, 1fr),
  th[Aparato][Uso][Aparato][Uso],
  [amperímetro], [en *serie*; $R_i$ nula], [voltímetro], [en *paralelo*; $R_i$ infinita],
  [óhmetro], [sin tensión y con los condensadores descargados], [shunt], [en paralelo con el amperímetro: amplía la escala y protege],
  [frecuencímetro], [la frecuencia, con precisión], [osciloscopio], [dominio del *tiempo*: amplitud, $T$, $f = 1 slash T$],
  [analizador], [dominio de la *frecuencia* (espectro): portadora, bandas, armónicos], [generador de RF], [señal calibrada para probar etapas],
  [medidor de campo], [V/m (dBμV/m)], [dipmeter], [resonancia de un circuito *sin alimentarlo*],
  [carga artificial], [50 Ω no inductiva: ajustar sin radiar], [medidor de ROE], [el más imprescindible],
)
- #k[Polímetro]: $V$, $I$, $R$; sin _true RMS_ falla con ondas no senoidales; no mide la impedancia de una antena.
- #k[Vatímetro direccional]: potencia directa $P_d$ y reflejada $P_r$; $rho = sqrt(P_r slash P_d)$. #ej[100 W y 25 W → $rho = 0,5$ → ROE 3; radia 75 W.] Reflejada apreciable = no adaptado.'''),
# remedies -> compact
(r'''#table(
  columns: (auto, 1fr),
  th[Dónde][Remedio (filtrar, desacoplar, apantallar)],
  [salida del TX], [filtro paso bajo],
  [red eléctrica], [filtro de línea],
  [cables], [ferritas y condensadores de desacoplo; cable blindado al altavoz],
  [televisor], [filtro de rechazo a su entrada],
  [equipo], [caja metálica estanca y a tierra (jaula de Faraday: protege en los dos sentidos)],
  [estación], [buena tierra, ROE baja, potencia mínima, equipos con marcado CE (EMC); la fibra óptica es inmune],
)''', r'''#table(
  columns: (auto, 1fr, auto, 1fr),
  th[Dónde][Remedio][Dónde][Remedio],
  [salida TX], [filtro paso bajo], [red], [filtro de línea],
  [cables], [ferritas y condensadores; cable blindado al altavoz], [televisor], [filtro de rechazo a su entrada],
  [equipo], [caja metálica estanca y a tierra (jaula de Faraday, en los dos sentidos)], [estación], [buena tierra, ROE baja, potencia mínima, marcado CE (EMC); fibra óptica: inmune],
)'''),
# band names table compact
(r'''#table(
  columns: (auto, auto, auto, auto, auto, auto),
  th[Banda][Frecuencia][Ondas][Banda][Frecuencia][Ondas],
  [VLF], [3–30 kHz], [miriamétricas], [LF], [30–300 kHz], [kilométricas],
  [MF], [0,3–3 MHz], [hectométricas], [HF], [3–30 MHz], [*decamétricas*],
  [VHF], [30–300 MHz], [métricas], [UHF], [0,3–3 GHz], [decimétricas],
  [SHF], [3–30 GHz], [centimétricas], [EHF], [30–300 GHz], [milimétricas],
)''', r'''#table(
  columns: (auto, auto, 1fr, auto, auto, 1fr),
  th[Banda][Frecuencia][Ondas][Banda][Frecuencia][Ondas],
  [VLF], [3–30 kHz], [miriamétr.], [LF], [30–300 kHz], [kilométr.],
  [MF], [0,3–3 MHz], [hectométr.], [HF], [3–30 MHz], [*decamétricas*],
  [VHF], [30–300 MHz], [métricas], [UHF], [0,3–3 GHz], [decimétr.],
  [SHF], [3–30 GHz], [centimétr.], [EHF], [30–300 GHz], [milimétr.],
)'''),
# antenna table: shorter
(r'''  [vertical λ/4], [plano de tierra o radiales; ≈ 36 Ω (radiales inclinados: hacia 50 Ω); polarización vertical; máximo en el plano horizontal],''', r'''  [vertical λ/4], [plano de tierra o radiales; ≈ 36 Ω (radiales inclinados: hacia 50 Ω); polarización vertical; máximo en el plano horizontal],'''),
(r'''  [con trampas], [$L C$ paralelo en los brazos: multibanda],
  [bobinas en los brazos], [alargan la longitud eléctrica: resuena más bajo que por su longitud física],
  [helicoidal], [polarización circular (satélites); ganancia según el nº de espiras],
  [de apertura], [bocina, parabólica],''', r'''  [con trampas], [$L C$ paralelo en los brazos: multibanda],
  [bobinas en brazos], [alargan la longitud eléctrica: resuena más bajo que por su longitud física],
  [helicoidal], [polarización circular (satélites); ganancia según el nº de espiras],
  [de apertura], [bocina, parabólica],'''),
# socorro: remove meaning row
(r'''  [Morse ×3], [`SOS`], [`XXX`], [`TTT`],
  [significa], [peligro grave e inminente], [mensaje urgente, sin peligro inmediato], [aviso de navegación o meteorológico],
)''', r'''  [Morse ×3], [`SOS`], [`XXX`], [`TTT`],
)'''),
# fix bold bug
(r'''#recuerda[T/R 61-0*1*: *visito* un país ⇒ licencia CEPT. T/R 61-0*2*: *me instalo* ⇒ HAREC.]''', r'''#recuerda[T/R 61-0#strong[1]: #strong[visito] un país ⇒ licencia CEPT. T/R 61-0#strong[2]: #strong[me instalo] ⇒ HAREC.]'''),
# qtab alignment
(r'''  columns: (auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.5pt),
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  ..pares.pos().map(c => c),''', r'''  columns: (auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.5pt), align: left + horizon,
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  ..pares.pos().map(c => c),'''),
]
