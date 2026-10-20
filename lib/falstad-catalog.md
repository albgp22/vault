# Catálogo verificado de circuitos de Falstad (CircuitJS)

Última verificación: 2026-10-20. Entradas verificadas: **122**. Use solo los enlaces de este archivo. No construya URLs a mano a partir de títulos.

## How links work

URL template (confirmed):

```
https://www.falstad.com/circuit/circuitjs.html?startCircuit=<file>
```

`<file>` is the file name in the "Archivo" column (for example `res-series.txt`), with no folder. Typst example:

```
#link("https://www.falstad.com/circuit/circuitjs.html?startCircuit=res-series.txt")[Abrir en Falstad]
```

How the template was confirmed:

1. Source code (GitHub `pfalstad/circuitjs1`, branch `master`): `CirSim.java` reads the query parameter `startCircuit` and calls `Menus.readSetupFile`. That method loads `GWT.getModuleBaseURL() + "circuits/" + file`.
2. The live page loads `circuitjs110/circuitjs1.nocache.js`, so the module base URL is `https://www.falstad.com/circuit/circuitjs110/`. The files are therefore served at `https://www.falstad.com/circuit/circuitjs110/circuits/<file>`. The example list is `https://www.falstad.com/circuit/circuitjs110/setuplist.txt` (482 lines, 366 unique files; identical to `src/com/lushprojects/circuitjs1/public/setuplist.txt` in the repo).
3. The common guess `https://www.falstad.com/circuit/circuits/<file>` returns HTTP 404. Do not use it.

Checks done for every row of every table (all 122 rows passed):

- HTTP 200 for `https://www.falstad.com/circuit/circuitjs110/circuits/<file>`, fetched twice (first full-list fetch and a final re-fetch of the 122 selected files).
- The file is a CircuitJS circuit: first character `$` (text format, 116 files) or `<cir` (newer XML format, 6 files: `conv-buck`, `crystalosc`, `crystalosc2`, `cs-multiplier`, `freqdouble`, `pll2`; marked "formato XML" in the table).
- The exact URL in the table was opened in the real app (built-in browser, one iframe per link). The page title became "`<Falstad title>` - Circuit Simulator" and the exported circuit had at least one element. 17 links timed out at 20 s in the first parallel run (6 pages loading at once) and loaded correctly when re-run with fewer pages in parallel.
- The column "Qué muestra realmente" comes from the component list parsed from the served file, not from the title. "(calculada/calculado)" marks a value computed here from the component values, not read from Falstad. "AC 40 Hz / 5 V" means frequency / peak amplitude.

Notes for authors:

- Falstad titles repeat in different menus ("Capacitor", "Switch", "Full-Wave Rectifier", "Common-Source Amplifier"). The title column shows the menu path in italics. Always use the file name.
- Most examples use audio or low frequencies (Hz to kHz) so that the animation is visible. RF values appear only in the transmission-line examples (MHz to GHz), `varactor.txt` (800 MHz) and the crystal oscillators (about 10 MHz).
- Optional URL parameters, added with `&` (tested on 2026-10-20 with `res-series.txt`; all worked together): `lang=es` (Spanish interface and Spanish example titles), `hideSidebar=true`, `whiteBackground=true`, `euroResistors=true` (IEC rectangular resistor symbol), `running=false` (start paused). Present in the source but not tested: `conventionalCurrent=true`, `editable=false`, `usResistors=true`, `hideMenu=true`, `hideInfoBox=true`.
  Example: `https://www.falstad.com/circuit/circuitjs.html?startCircuit=res-series.txt&lang=es&whiteBackground=true&euroResistors=true`
- The page needs Internet access. It also tries to load a Dropbox script; an ad blocker may block it. This is harmless.

## Custom circuits (`cct` and `ctz`)

Two more query parameters load a circuit that is not in the example list. Both were tested on 2026-10-20 in the app: each URL below loaded and the app exported the same 5 elements (source, 2 resistors, wire, ground).

- `?cct=<text>`: the circuit text, URL-encoded. Use `+` or `%20` for spaces and `%0A` for new lines. The `$` can stay literal (the app also turns `%24` back into `$`).
- `?ctz=<code>`: the same text compressed with lz-string `compressToEncodedURIComponent`. This is what the menu File > "Export As Link..." produces. It is the best choice for long circuits.

Test circuit (5 V source and a divider of two 1 kΩ resistors), text format:

```
$ 1 0.000005 10.20027730826997 50 5 50
v 80 80 80 240 0 0 40 5 0 0 0.5
r 80 80 240 80 0 1000
r 240 80 240 240 0 1000
w 80 240 240 240 0
g 80 240 80 272 0
```

- cct: https://www.falstad.com/circuit/circuitjs.html?cct=$+1+0.000005+10.20027730826997+50+5+50%0Av+80+80+80+240+0+0+40+5+0+0+0.5%0Ar+80+80+240+80+0+1000%0Ar+240+80+240+240+0+1000%0Aw+80+240+240+240+0%0Ag+80+240+80+272+0%0A
- ctz: https://www.falstad.com/circuit/circuitjs.html?ctz=CQAgjCAMB0l3BWcMBMcUHYMGZIA4UA2ATmIxAUgosgCgA3EPK5pqlAFiu5C+p5gJaAJzZjOLHmHgiQE8X3lVpcWgHcF7RXzoBzTeIwootIA

Line format (text format): `r x1 y1 x2 y2 flags ohms`, `c ... flags farads`, `l ... flags henries`, `v x1 y1 x2 y2 flags waveform frequency maxVoltage bias phase duty` (waveform 0 = DC, 1 = AC, 2 = square, 3 = triangle), `w` wire, `g` ground. The simplest way to author a variant: open a catalog circuit, edit it in the app, then use "Export As Link...". The tested `cct` and `ctz` examples use the text format; the app's own JavaScript export returns the XML format.

## Índice rápido por tema

- Ley de Ohm, divisores, serie/paralelo de R: sección 1. Serie/paralelo de C y L: sección 2.
- Carga/descarga RC y RL: sección 2 (`cap`, `induct`). Resonancia LC/LRC serie y paralelo: sección 3.
- Filtros RC/RL/LC (paso bajo, alto, banda, notch): sección 4. Filtros activos y pasa-todo: sección 16.
- Transformadores: sección 5. Adaptación de impedancias, ondas estacionarias, líneas: sección 6.
- Diodos, rectificadores, filtro con condensador, dobladores, Zener: sección 7. Reguladores: secciones 7 y 8.
- Varactor: sección 9 (y `varactorvco.txt`). BJT: secciones 10, 11, 12. FET/MOSFET/triodo: secciones 11 y 18.
- Osciladores: sección 13. Mezcladores y detector de AM: sección 14. PLL: sección 15.
- Amplificador operacional: sección 16. 555: sección 17.

## 1. Ley de Ohm, divisores de tensión y redes de resistencias

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Ohm's Law *(Basics)* | `ohms.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=ohms.txt | 2 resistencias (100 Ω y 1 kΩ) conectadas a una misma fuente de tensión ajustable con deslizador; se ve I = V/R. |
| Resistors *(Basics)* | `resistors.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=resistors.txt | Fuente DC 5 V, 5 resistencias (100, 200, 400, 600 y 800 Ω) y 6 interruptores: al conmutar se forman combinaciones serie y paralelo. |
| Voltage Divider *(Basics)* | `voltdivide.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=voltdivide.txt | Fuente DC 10 V; un divisor de 2 resistencias de 10 kΩ y otro de 4 resistencias de 10 kΩ en serie, con puntos de medida en los nodos. |
| Potentiometer Divider *(Basics)* | `potdivide.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=potdivide.txt | Potenciómetro con cursor ajustable y una fuente DC 5 V: divisor de tensión variable. |
| Thevenin's Theorem *(Basics)* | `thevenin.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=thevenin.txt | Red de 14 resistencias (100 Ω a 1 kΩ) con fuentes DC y, abajo, su equivalente Thévenin (fuente 2,81 V + 117,78 Ω). |
| Wheatstone Bridge *(Other Passive Circuits)* | `wheatstone.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=wheatstone.txt | Puente de Wheatstone: 4 resistencias (100, 200 y 400 Ω), fuente DC 5 V y amperímetro en la diagonal. |

## 2. Condensador e inductor: carga/descarga, reactancia, serie y paralelo

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Capacitor *(Basics)* | `cap.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=cap.txt | Fuente DC 5 V, R = 100 Ω, C = 200 µF e interruptor inversor: carga y descarga RC. |
| Inductor *(Basics)* | `induct.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=induct.txt | Fuente DC 5 V, 2 resistencias de 140 Ω, L = 3 H e interruptor inversor: subida y caída de corriente RL. |
| Differentiator *(Other Passive Circuits)* | `diff.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=diff.txt | Fuente cuadrada 40 Hz / 5 V con C = 9 µF y R = 120 Ω: derivador pasivo RC (picos en los flancos). |
| Capacitor *(A/C Circuits)* | `capac.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=capac.txt | AC 40 Hz / 5 V con R = 180 Ω y C = 33 µF: la corriente adelanta a la tensión (reactancia capacitiva). |
| Inductor *(A/C Circuits)* | `inductac.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=inductac.txt | AC 40 Hz / 5 V con R = 180 Ω y L = 1 H: la corriente retrasa respecto a la tensión (reactancia inductiva). |
| Caps w/ Various Frequencies *(A/C Circuits)* | `capmultfreq.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=capmultfreq.txt | 3 ramas RC iguales (R = 200 Ω, C = 30 µF) con AC a 15, 40 y 80 Hz: la reactancia baja al subir la frecuencia. |
| Inductors w/ Various Frequencies *(A/C Circuits)* | `indmultfreq.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=indmultfreq.txt | 3 ramas RL iguales (R = 200 Ω, L = 400 mH) con AC a 30, 80 y 200 Hz: la reactancia sube con la frecuencia. |
| Impedances of Same Magnitude *(A/C Circuits)* | `impedance.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=impedance.txt | 3 fuentes AC 80 Hz / 5 V con 3 ramas de igual módulo de impedancia (200 Ω): R = 200 Ω, R = 100 Ω + L = 344,58 mH y R = 100 Ω + C = 11,486 µF (calculado). |
| Caps in Series *(Other Passive Circuits › Series/Parallel)* | `capseries.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=capseries.txt | 2 circuitos RC con fuente DC 5 V e interruptor inversor: C de 1 mF en serie con 100 µF frente al equivalente de 90,91 µF. |
| Caps in Parallel *(Other Passive Circuits › Series/Parallel)* | `cappar.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=cappar.txt | 2 circuitos RC con fuente DC 5 V e interruptor inversor: C de 100 µF en paralelo con 200 µF frente al equivalente de 300 µF. |

## 3. Resonancia LC y LRC (serie y paralelo)

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| LRC Circuit *(Basics)* | `lrc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=lrc.txt | Fuente DC 5 V, interruptor, R = 10 Ω, L = 1 H, C = 15 µF y R = 100 Ω, con deslizadores para C, L y R: descarga LRC amortiguada, f0 ≈ 41,1 Hz (calculada). |
| Critically Damped LRC *(Other Passive Circuits)* | `lrc-critical.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=lrc-critical.txt | Mismo LRC (L = 1 H, C = 15 µF) con R = 516,4 Ω = 2·√(L/C): amortiguamiento crítico. |
| Series Resonance *(A/C Circuits)* | `res-series.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=res-series.txt | 3 circuitos RLC serie (R = 10 Ω, L = 1 H, C = 15 µF) con AC a 35, 41,09 y 45 Hz: corriente máxima a 41,09 Hz (resonancia). |
| Parallel Resonance *(A/C Circuits)* | `res-par.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=res-par.txt | 3 circuitos RLC paralelo (L = 1 H, C = 15 µF, R = 100 Ω y 2 kΩ) con AC a 41,09, 30 y 50 Hz. |
| Weak Coupling *(Other Passive Circuits › Coupled LC's)* | `coupled2.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=coupled2.txt | Dos lazos LC (L = 1 H, C = 1 µF, R = 1 Ω) acoplados por un condensador común de 20 µF (acoplamiento débil): la energía pasa de un lazo al otro. |
| LC Ladder *(Other Passive Circuits › Coupled LC's)* | `ladder.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=ladder.txt | Escalera LC de 21 secciones (L = 10 mH, C = 100 µF, R = 10 Ω) excitada con un pulso de 40 Hz / 5 V: propagación y retardo, análoga a una línea. |
| Band-pass with Ringing *(Passive Filters)* | `ringing.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=ringing.txt | Fuente cuadrada 100 Hz / 5 V sobre L = 2 mH, C = 12,64 µF, R = 100 Ω: oscilación amortiguada (ringing) a f0 ≈ 3,17 kHz (calculada). |

## 4. Filtros pasivos (paso bajo, paso alto, paso banda, rechazo/notch, LC de varios polos)

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Low-Pass Filter (RC) *(Passive Filters)* | `filt-lopass.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-lopass.txt | Paso bajo RC: R = 187 Ω, C = 10 µF (fc ≈ 85 Hz, calculada), fuente de barrido 20 Hz a 1 kHz. |
| High-Pass Filter (RC) *(Passive Filters)* | `filt-hipass.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-hipass.txt | Paso alto RC: C = 10 µF, R = 35 Ω (fc ≈ 455 Hz, calculada), fuente de barrido 20 Hz a 1 kHz. |
| Low-Pass Filter (RL) *(Passive Filters)* | `filt-lopass-l.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-lopass-l.txt | Paso bajo RL: R = 35 Ω, L = 65,45 mH (fc ≈ 85 Hz, calculada), fuente de barrido 20 Hz a 1 kHz. |
| High-Pass Filter (RL) *(Passive Filters)* | `filt-hipass-l.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-hipass-l.txt | Paso alto RL: R = 187 Ω, L = 65,45 mH (fc ≈ 455 Hz, calculada), fuente de barrido 20 Hz a 1 kHz. |
| Band-pass Filter *(Passive Filters)* | `bandpass.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=bandpass.txt | Paso banda: R serie de 250 Ω y tanque LC en paralelo a masa (L = 500 mH, C = 31,7 µF, f0 ≈ 40 Hz, calculada), barrido 10 a 150 Hz. |
| Notch Filter *(Passive Filters)* | `notch.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=notch.txt | Filtro de rechazo (notch): R serie de 100 Ω y rama LC serie a masa (L = 500 mH, C = 31,7 µF, f0 ≈ 40 Hz, calculada), barrido 20 a 60 Hz. |
| Twin-T Filter *(Passive Filters)* | `twint.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=twint.txt | Filtro Twin-T pasivo: 3 R (50 y 100 Ω) y 3 C (26,5 y 53 µF), notch en torno a 60 Hz, barrido 40 a 80 Hz. |
| Band-pass w/ Noise *(Passive Filters)* | `bandnoise.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=bandnoise.txt | Paso banda LC (L = 599,6 µH, C = 169 µF, R = 200 Ω, f0 ≈ 500 Hz calculada) alimentado con ruido y salida de audio: se oye el filtrado. |
| Butterworth Low-Pass (10 pole) *(Passive Filters)* | `butter10lo.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=butter10lo.txt | Paso bajo Butterworth de 10 polos: escalera LC de 5 L (3,7 a 14,4 mH) y 5 C, impedancia 50 Ω, barrido 100 Hz a 2 kHz. |
| Butterworth High-Pass (10 pole) *(Passive Filters)* | `butter10hi.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=butter10hi.txt | Paso alto Butterworth de 10 polos: escalera LC de 5 L y 5 C, impedancia 50 Ω, barrido 500 Hz a 8 kHz. |
| Butterworth Band-Stop *(Passive Filters)* | `butterbandstop.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=butterbandstop.txt | Rechazo de banda Butterworth: escalera de 8 L y 8 C, impedancia 50 Ω, barrido 20 Hz a 4 kHz. |

## 5. Transformadores

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Transformer *(Other Passive Circuits › Transformers)* | `transformer.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=transformer.txt | Transformador 1:1 (L primaria 100 H), AC 60 Hz / 10 V, carga de 1 kΩ y R serie de 0,1 Ω. |
| Step-Up Transformer *(Other Passive Circuits › Transformers)* | `transformerup.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=transformerup.txt | Transformador elevador 1:10 (L primaria 1 H), AC 60 Hz / 10 V, carga de 2 kΩ. |
| Step-Down Transformer *(Other Passive Circuits › Transformers)* | `transformerdown.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=transformerdown.txt | Transformador reductor 10:1 (L primaria 1000 H), AC 60 Hz / 169,7 V (120 V eficaces), carga de 300 Ω. |
| Transformer w/ DC *(Other Passive Circuits › Transformers)* | `transformerdc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=transformerdc.txt | Transformador con fuente DC 10 V, R = 100 Ω y 300 Ω: no transmite corriente continua. |

## 6. Líneas de transmisión, ondas estacionarias y adaptación de impedancias

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Simple TL *(Transmission Lines)* | `tl.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tl.txt | Línea de transmisión (Z0 = 75 Ω, retardo 30 ns) con fuente AC 40 MHz / 5 V y carga adaptada de 75 Ω. |
| Standing Wave *(Transmission Lines)* | `tlstand.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlstand.txt | Línea Z0 = 300 Ω (retardo 2 ns) con fuente AC 1,5 GHz / 5 V, resistencia de fuente de 300 Ω y extremo en cortocircuito: onda estacionaria. |
| Termination *(Transmission Lines)* | `tlterm.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlterm.txt | 4 líneas Z0 = 75 Ω (10 ns) con pulsos de 10 MHz: fuente de 75 Ω con cargas de 75 Ω, 10 kΩ (casi abierta) y 10 Ω (casi cortocircuito), y fuente de 10 Ω con carga de 10 kΩ: efecto de la terminación. |
| Mismatched lines (Pulse) *(Transmission Lines)* | `tlmismatch.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlmismatch.txt | Tramos de 75 Ω, 500 Ω y 75 Ω en cascada (10 ns cada uno) con pulso de 10 MHz y carga de 75 Ω: reflexiones por desadaptación. |
| Mismatched lines (Standing Wave) *(Transmission Lines)* | `tlmis1.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlmis1.txt | Línea de 75 Ω seguida de otra de 500 Ω cargada con 500 Ω, AC 187 MHz / 5 V: onda estacionaria por desadaptación. |
| Impedance Matching (L-Section) *(Transmission Lines)* | `tlmatch1.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlmatch1.txt | Adaptación 75 Ω a 300 Ω con sección L (L = 250 nH serie, C = 10,6 pF en derivación) a 90 MHz; incluye copia sin adaptar para comparar. |
| Impedance Matching (Shunt Stub) *(Transmission Lines)* | `tlmatch2.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=tlmatch2.txt | Adaptación 75 Ω a 300 Ω con 2 stubs de línea en derivación a 100 MHz; incluye copia sin stubs para comparar. |

## 7. Diodos, rectificadores, filtro con condensador y multiplicadores de tensión

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Diode *(Diodes)* | `diodevar.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=diodevar.txt | Un diodo con fuente de tensión ajustable (deslizador): la corriente crece de forma exponencial a partir de ≈ 0,6 a 0,7 V. |
| Diode I/V Curve *(Diodes)* | `diodecurve.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=diodecurve.txt | Diodo con fuente triangular 50 Hz (offset 0,25 V, 650 mV): traza la curva I/V. |
| Half-Wave Rectifier *(Diodes)* | `rectify.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=rectify.txt | Rectificador de media onda: AC 40 Hz / 5 V, diodo y carga de 640 Ω. |
| Full-Wave Rectifier *(Diodes)* | `fullrect.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=fullrect.txt | Rectificador de onda completa en puente de 4 diodos: AC 40 Hz / 5 V, carga de 100 Ω. |
| Full-Wave Rectifier w/ Filter *(Diodes)* | `fullrectf.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=fullrectf.txt | Puente de 4 diodos con condensador de filtro de 102 µF y carga de 430 Ω: se ve el rizado. |
| Diode Limiter *(Diodes)* | `diodelimit.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=diodelimit.txt | Limitador con 2 diodos en antiparalelo, R = 110 Ω y AC 40 Hz / 5 V. |
| Waveform Clipper *(Diodes)* | `diodeclip.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=diodeclip.txt | Recortador con diodo, 2 resistencias, referencia DC de 5 V y señal triangular 40 Hz / 10 V. |
| DC Restoration *(Diodes)* | `dcrestoration.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=dcrestoration.txt | Fijador de nivel (clamp): C = 5 µF, diodo y R = 5 kΩ con AC 500 Hz / 5 V. |
| Blocking Inductive Kickback *(Diodes)* | `inductkick-block.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=inductkick-block.txt | Fuente 5 V, interruptor, L = 1 H, R = 100 Ω, C = 500 pF y diodo de libre circulación contra la sobretensión inductiva. |
| I/V Curve *(Diodes › Zener Diodes)* | `zeneriv.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=zeneriv.txt | Diodo Zener con rampa triangular de 50 Hz: curva I/V con codo de ruptura inversa. |
| Voltage Doubler *(Diodes › Voltage Multipliers)* | `voltdouble.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=voltdouble.txt | Doblador de tensión: 2 diodos, 2 C de 100 µF, R = 10 kΩ, AC 40 Hz / 15 V. |
| Voltage Tripler *(Diodes › Voltage Multipliers)* | `volttriple.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=volttriple.txt | Triplicador: 3 diodos, 3 C de 100 µF, R = 40 kΩ, AC 120 Hz / 15 V. |
| Joule Thief *(Transistors)* | `joule-thief.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=joule-thief.txt | Joule thief: transistor NPN, transformador, diodo y LED con una pila de 1,5 V (único ejemplo con LED, como carga). |

## 8. Reguladores y fuentes de alimentación

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Voltage Reference *(Diodes › Zener Diodes)* | `zenerref.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=zenerref.txt | Referencia Zener: resistencia de 500 Ω, Zener y carga de 10 kΩ sobre una fuente de 6,7 V con 1 V de rizado. |
| Voltage Reference w/ Follower *(Diodes › Zener Diodes)* | `zenerreffollow.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=zenerreffollow.txt | Referencia Zener con seguidor de emisor NPN (R = 100 Ω, 500 Ω y 10 kΩ) sobre una fuente de 8,8 V con 2 V de rizado. |
| Voltage Regulator *(Op-Amps)* | `opamp-regulator.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=opamp-regulator.txt | Regulador lineal: op-amp, transistor NPN de paso, Zener de referencia y carga variable (potenciómetro y pulso), con entrada triangular 16 V ± 2 V para ver la regulación. |
| Buck Converter *(Power Converters)* | `conv-buck.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=conv-buck.txt | Convertidor reductor (buck): MOSFET conmutado a 1 kHz, diodo, L = 1 H y R = 1 kΩ, con fuente de 5 V (formato XML). |

## 9. Varactor (diodo de capacidad variable)

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Varactor *(Misc Devices › Varactor)* | `varactor.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=varactor.txt | 3 varactores con AC 800 MHz / 1 V y polarización de -1,5, -5 y -10 V, cada uno con 100 Ω: la capacidad cambia con la tensión inversa. |
| VCO *(Misc Devices › Varactor)* | `varactorvco.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=varactorvco.txt | VCO con varactores: NPN, L = 30 nH, 2 varactores, C de 1,5 a 100 pF y 9 resistencias; la tensión de control sintoniza la frecuencia. |

## 10. Transistor bipolar (BJT): curvas características y conmutador

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| NPN Transistor *(Transistors)* | `npn.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=npn.txt | Transistor NPN (β = 100) con dos fuentes ajustables (tensión de base y de colector): se ve Ic frente a Vbe y Vce. |
| PNP Transistor *(Transistors)* | `pnp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=pnp.txt | Transistor PNP con dos fuentes ajustables (tensiones de base y de colector) y una fuente DC de 2 V. |
| Switch *(Transistors)* | `transswitch.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=transswitch.txt | NPN como interruptor: fuente 5 V, R de base de 10 kΩ con interruptor y carga de 300 Ω en el colector. |

## 11. Amplificadores de pequeña señal (emisor común, seguidor de emisor, diferencial, FET, triodo)

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Common-Emitter Amplifier *(Transistors)* | `ceamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=ceamp.txt | Emisor común con polarización por divisor (110 kΩ / 10 kΩ), Rc = 10 kΩ, Re = 1 kΩ, 2 C de 5 µF y carga de 1 MΩ; entrada AC 80 Hz / 0,5 V, alimentación 20 V. |
| Emitter Follower *(Transistors)* | `follower.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=follower.txt | Seguidor de emisor (colector común): divisor 800/800 Ω, Re = 40 Ω, C de entrada 3 µF, alimentación 5 V y entrada AC 40 Hz / 5 V. |
| Differential Input *(Transistors › Differential Amplifiers)* | `trans-diffamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=trans-diffamp.txt | Amplificador diferencial con 2 NPN: alimentación ±15 V, R = 75 kΩ y 1 kΩ, entrada diferencial AC 100 mV. |
| Common-Mode w/Current Source *(Transistors › Differential Amplifiers)* | `trans-diffamp-cursrc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=trans-diffamp-cursrc.txt | Amplificador diferencial con 3 NPN (fuente de corriente en la cola) y señal en modo común de 4 V: rechazo de modo común. |
| Common-Source Amplifier *(MOSFETs)* | `mosfetamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=mosfetamp.txt | MOSFET canal N en fuente común: R de 4 kΩ y 50 kΩ, C de 1 µF y 100 µF, alimentación ±10 V, entrada AC 40 Hz / 50 mV. |
| Common-Source Amplifier *(Misc Devices › JFETs)* | `jfetamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=jfetamp.txt | JFET en fuente común: R de 1,675 kΩ y 50 kΩ, C de 1 µF y 100 µF, alimentación 10 V, entrada AC 40 Hz / 100 mV. |
| Amplifier *(Misc Devices › Triodes)* | `triodeamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=triodeamp.txt | Amplificador con válvula triodo: R de 3, 10 y 100 kΩ, 3 C de 5 µF, alimentación 160 V, entrada AC 80 Hz / 500 mV. |
| Volume Control *(Misc Devices › JFETs)* | `volume.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=volume.txt | JFET como resistencia controlada por tensión (control de volumen): R de 6 kΩ y 100 kΩ, señal AC 200 Hz / 5 V y control triangular lento. |

## 12. Etapas de potencia: push-pull, clase B / AB, distorsión de cruce, clase D

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Simple, with distortion *(Transistors › Push-Pull Follower)* | `pushpullxover.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=pushpullxover.txt | Seguidor push-pull NPN + PNP sin polarización, ±10 V, carga de 10 Ω, entrada AC 40 Hz / 5 V: distorsión de cruce (clase B). |
| Improved *(Transistors › Push-Pull Follower)* | `pushpull.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=pushpull.txt | Mismo push-pull con 2 diodos y 2 resistencias de 220 Ω que polarizan las bases: la distorsión de cruce desaparece (clase AB). |
| Class-D Amplifier *(Op-Amps › Amplifiers)* | `classd.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=classd.txt | Amplificador clase D: comparador con op-amp, triangular de 1 kHz y señal de 30 Hz, MOSFET P y N, filtro L = 80 mH / C = 10 µF, alimentación 15 V. |

## 13. Osciladores (LC, Colpitts, Hartley, cristal, desfase, Wien, relajación, multivibrador)

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Colpitts Oscillator *(Transistors › Oscillators)* | `colpitts.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=colpitts.txt | Oscilador Colpitts: NPN, L = 10 mH y dos condensadores de 100 µF (C1, C2), R de 100 Ω y 1 kΩ, alimentación 5 V. |
| Hartley Oscillator *(Transistors › Oscillators)* | `hartley.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=hartley.txt | Oscilador Hartley: NPN, dos inductores (L1 = 500 mH, L2 = 1,5 H), C = 633 nF, R de 100 Ω y 1 kΩ, alimentación 5 V. |
| Emitter-Coupled LC Oscillator *(Transistors › Oscillators)* | `eclosc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=eclosc.txt | Oscilador LC de emisores acoplados: 2 NPN, L = 100 mH, C = 50 µF (f0 ≈ 71 Hz, calculada), alimentación -5,2 V; con anotación de Q. |
| Crystal Oscillator *(Transistors › Oscillators)* | `crystalosc2.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=crystalosc2.txt | Oscilador a cristal con 1 NPN: cristal con fs ≈ 10,07 MHz (calculada; Cs = 0,1 pF, Lm = 2,5 mH, r = 6,4 Ω, C0 = 28,7 pF), 3 C de 100 pF, 5 R y alimentación 5 V (formato XML). |
| CMOS Crystal Oscillator *(MOSFETs)* | `crystalosc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=crystalosc.txt | Oscilador a cristal tipo Pierce con inversor CMOS (2 MOSFET): mismo tipo de cristal (fs ≈ 10,07 MHz, calculada), 2 C de 22 pF, R = 1 MΩ (realimentación) y 1 kΩ (formato XML). |
| Phase-Shift Oscillator *(Op-Amps › Oscillators)* | `phaseshiftosc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=phaseshiftosc.txt | Oscilador de desfase RC: op-amp, 3 C de 500 nF, 3 R de 1 kΩ y realimentación de 29 kΩ; salida de audio. |
| Wien Bridge Oscillator *(Misc Devices › Light Bulb)* | `wienbridge.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=wienbridge.txt | Oscilador de puente de Wien: op-amp, 2 C de 1 µF, R de 1 kΩ y lámpara de incandescencia que estabiliza la amplitud. |
| Relaxation Oscillator *(Op-Amps › Oscillators)* | `relaxosc.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=relaxosc.txt | Oscilador de relajación con op-amp: R de 10 kΩ y 100 kΩ, C = 400 nF; salida de audio. |
| Astable Multivib *(Transistors › Multivibrators)* | `multivib-a.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=multivib-a.txt | Multivibrador astable con 2 NPN, 2 C de 18 µF y R de 320 Ω, 330 Ω y 1,02 kΩ; alimentación 5 V. |
| Sine Wave Generator *(Op-Amps › Oscillators)* | `sine.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=sine.txt | Generador senoidal con 2 op-amps, 3 C de 1 µF y 3 R (≈ 1 kΩ); salida de audio. |
| Voltage-Controlled Oscillator *(Op-Amps › Oscillators)* | `vco.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=vco.txt | Oscilador controlado por tensión con 2 op-amps, MOSFET de control, R de 49,9 kΩ y 100 kΩ, C = 10 nF; salida de audio. |

## 14. Mezcladores, moduladores y detector de AM

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| AM Detector *(Diodes)* | `amdetect.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amdetect.txt | Receptor de AM: antena con 3 emisoras AM (3000, 2710 y 2433 Hz, moduladas a 12 a 14 Hz) y una FM; circuito sintonizado L = 1 mH / C = 2,81 µF (3000 Hz, calculado), diodo y filtro RC (C = 300 nF, R = 47 kΩ). |
| Ring Modulator *(Diodes)* | `ringmod.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=ringmod.txt | Modulador en anillo: 4 diodos, 2 transformadores con toma central, fuentes AC de 300 Hz / 2,4 V y 200 Hz / 2 V: mezclador (suma y diferencia de frecuencias). |
| Gilbert Cell Multiplier *(Transistors)* | `gilbertcell.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=gilbertcell.txt | Celda de Gilbert: 14 transistores NPN, op-amp y Zener, con entradas AC 80 Hz / 2 V y triangular 10 Hz / 2 V: multiplicador/mezclador de 4 cuadrantes. |
| VCVS Multiplier *(Controlled Sources)* | `cs-multiplier.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=cs-multiplier.txt | Multiplicador ideal con fuente controlada (VCVS) de 2 señales AC (40 y 88 Hz / 5 V): producto de tensiones, base de un mezclador (formato XML). |
| Peak Detector *(Op-Amps)* | `peak-detect.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=peak-detect.txt | Detector de picos: 2 op-amps, diodo, C = 10 µF, R = 10 Ω e interruptor de reinicio, con AC 40 Hz / 5 V y 110 Hz / 3 V; similar a un detector de envolvente. |

## 15. Lazo de enganche de fase (PLL) y detectores de fase

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| XOR Phase Detector *(Phase-Locked Loops)* | `xorphasedet.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=xorphasedet.txt | Detector de fase con puerta XOR y 2 ondas cuadradas de 100 y 105 Hz. |
| Type I PLL *(Phase-Locked Loops)* | `pll.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=pll.txt | PLL tipo I: VCO, detector de fase XOR, filtro RC (R = 5 kΩ, C = 9 µF), op-amp y entrada cuadrada de 60 Hz. |
| Phase Comparator (Type II) *(Phase-Locked Loops)* | `phasecomp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=phasecomp.txt | Comparador de fase/frecuencia (tipo II) con entradas cuadradas de 100 y 105 Hz. |
| Type II PLL *(Phase-Locked Loops)* | `pll2.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=pll2.txt | PLL tipo II: VCO, comparador de fase/frecuencia, op-amp, R y C del filtro de lazo, entrada cuadrada de 120 Hz (formato XML). |
| Frequency Doubler *(Phase-Locked Loops)* | `freqdouble.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=freqdouble.txt | Doblador de frecuencia con PLL: VCO, comparador de fase, biestable D y entrada cuadrada de 320 Hz (formato XML). |

## 16. Amplificador operacional: circuitos básicos y filtros activos

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Op-Amp *(Op-Amps)* | `opamp.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=opamp.txt | Amplificador operacional aislado con 2 fuentes ajustables en las entradas: se ve la ganancia diferencial y la saturación. |
| Inverting Amplifier *(Op-Amps › Amplifiers)* | `amp-invert.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-invert.txt | Amplificador inversor: R de 1 kΩ y 3 kΩ (ganancia -3), entrada AC 40 Hz / 5 V. |
| Noninverting Amplifier *(Op-Amps › Amplifiers)* | `amp-noninvert.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-noninvert.txt | Amplificador no inversor: R de 1 kΩ y 2 kΩ (ganancia 3), entrada AC 40 Hz / 5 V. |
| Follower *(Op-Amps › Amplifiers)* | `amp-follower.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-follower.txt | Seguidor de tensión con op-amp (ganancia 1), R = 1 kΩ, entrada AC 40 Hz / 5 V. |
| Differential Amplifier *(Op-Amps › Amplifiers)* | `amp-diff.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-diff.txt | Amplificador diferencial con op-amp y 4 resistencias de 1 kΩ: señal de 60 Hz en modo común y cuadrada de 120 Hz diferencial. |
| Summing Amplifier *(Op-Amps › Amplifiers)* | `amp-sum.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-sum.txt | Amplificador sumador: 3 R de 1 kΩ, entradas AC 200 Hz / 5 V y cuadrada 20 Hz / 2 V. |
| Integrator *(Op-Amps)* | `amp-integ.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-integ.txt | Integrador con op-amp: R = 1 kΩ, C = 5,8 µF y entradas cuadradas de 40 y 80 Hz. |
| Differentiator (inverting) *(Op-Amps)* | `amp-dfdx.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-dfdx.txt | Derivador con op-amp: C = 2 µF, R = 5 kΩ y entrada triangular 40 Hz / 5 V. |
| Schmitt Trigger *(Op-Amps)* | `amp-schmitt.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-schmitt.txt | Disparador de Schmitt con op-amp: R de 10 kΩ y 100 kΩ, fuente AC 40 Hz / 5 V y otra AC 1 kHz / 1 V con offset de 5 V. |
| Half-Wave Rectifier (inverting) *(Op-Amps)* | `amp-rect.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-rect.txt | Rectificador de media onda de precisión (inversor): op-amp, 2 diodos, 2 R de 10 kΩ, AC 40 Hz / 500 mV. |
| Full-Wave Rectifier *(Op-Amps)* | `amp-fullrect.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=amp-fullrect.txt | Rectificador de onda completa de precisión: 2 op-amps, 2 diodos y 5 resistencias, AC 40 Hz / 1 V. |
| Gyrator *(Op-Amps)* | `gyrator.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=gyrator.txt | Girador con op-amp (R de 1 kΩ y 20 kΩ, C = 250 nF) que simula un inductor, junto a un inductor real de 5 H para comparar, con cuadradas de 20 Hz. |
| VCVS Low-Pass Filter *(Active Filters)* | `filt-vcvs-lopass.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-vcvs-lopass.txt | Paso bajo activo (Sallen-Key/VCVS): op-amp, 4 R (5,86 kΩ y 10 kΩ), 2 C de 159 nF, barrido 20 a 800 Hz. |
| VCVS High-Pass Filter *(Active Filters)* | `filt-vcvs-hipass.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=filt-vcvs-hipass.txt | Paso alto activo (Sallen-Key/VCVS): op-amp, 4 R, 2 C de 53 nF, barrido 20 a 800 Hz. |
| Butterworth Low-Pass *(Active Filters)* | `actbutterlo.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=actbutterlo.txt | Paso bajo activo Butterworth: 3 op-amps, 6 R, 6 C, fuente de ruido y salida de audio. |
| Butterworth Band-Pass *(Active Filters)* | `actbutterband.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=actbutterband.txt | Paso banda activo Butterworth: 4 op-amps, 12 R, 8 C, fuente de ruido y salida de audio. |
| Allpass *(Active Filters)* | `allpass1.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=allpass1.txt | Filtro pasa-todo: op-amp, 3 R de 1 kΩ y C = 1 µF, barrido 10 Hz a 2 kHz (cambia la fase, no la amplitud). |

## 17. Temporizador 555

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| Square Wave Generator *(555 Timer Chip)* | `555square.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=555square.txt | 555 como oscilador astable: R de 10 kΩ y 1 MΩ, C = 300 nF, alimentación 10 V. |
| Monostable Multivibrator *(555 Timer Chip)* | `555monostable.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=555monostable.txt | 555 monoestable: 2 R (100 Ω y 1 kΩ), 2 C de 10 µF y entrada lógica de disparo, alimentación 5 V. |
| Pulse Width Modulator *(555 Timer Chip)* | `555pulsemod.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=555pulsemod.txt | 555 como modulador de ancho de pulso: R = 300 Ω, C = 3 µF, modulado con una triangular de 20 Hz. |

## 18. Dispositivos básicos (MOSFET, triodo) y figuras de Lissajous

| Título (como en Falstad) | Archivo | URL completa | Qué muestra realmente |
|---|---|---|---|
| n-MOSFET *(MOSFETs)* | `nmosfet.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=nmosfet.txt | MOSFET canal N con 2 fuentes ajustables (puerta y drenador): curva Id frente a Vgs y Vds. |
| Triode *(Misc Devices › Triodes)* | `triode.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=triode.txt | Triodo de vacío con 2 fuentes ajustables (rejilla y ánodo): curvas características. |
| Lissajous Figures *(2-D Scope)* | `lissa.txt` | https://www.falstad.com/circuit/circuitjs.html?startCircuit=lissa.txt | 6 fuentes AC de 5 V en 3 pares X/Y (100/104, 40/101 y 91/30 Hz) para figuras de Lissajous en el osciloscopio XY (fase y relación de frecuencias). |

## Not available in Falstad examples

Temas del encargo sin ejemplo propio en la lista oficial (comprobado en `setuplist.txt` y buscando en los 366 archivos servidos):

- **Filtros en pi (CLC) y redes L/pi/T de adaptación con elementos concentrados.** Solo hay adaptación con líneas de transmisión (`tlmatch1.txt`, `tlmatch2.txt`). Lo más cercano a un filtro en pi: la escalera LC de `butter10lo.txt`.
- **Antenas** (dipolo, radiación, ROE). El único "antenna" es la fuente `Ant` dentro de `amdetect.txt` (3 portadoras AM de 3000, 2710 y 2433 Hz y una portadora FM de unos 2200 Hz, generadas por el programa).
- **Modulación AM (generación) y modulación/demodulación FM.** Ningún archivo usa los elementos "AM Source" ni "FM Source" (búsqueda en los 366 archivos: ningún elemento de tipo 200 o 201). Esos elementos existen en el programa y se pueden usar en un circuito propio con `cct` o `ctz`. Hay detector de AM (`amdetect.txt`), pero no demodulador de FM.
- **LED como tema propio.** Los LED solo aparecen como indicadores (`joule-thief.txt`, `ledflasher.txt`, `traffic.txt`, `relayctr.txt`). Solo `joule-thief.txt` está en el catálogo.
- **Amplificador en base común, cascodo, clase C (con carga sintonizada), clase A de potencia y amplificadores sintonizados de RF/FI.**
- **Redes de polarización del BJT como ejemplos separados** (polarización fija, realimentación de colector, polarización de emisor). `ceamp.txt` incluye el divisor de base con resistencia de emisor, pero no hay una comparación entre polarizaciones. Tampoco hay curvas de ganancia de corriente más allá de `npn.txt` (deslizadores).
- **Receptor superheterodino completo, etapa de FI, CAG/AGC, silenciador, S-metro, detector de producto/BFO y SSB.**
- **Filtro de cristal y oscilador Clapp.** Sí hay osciladores de cristal (`crystalosc.txt`, `crystalosc2.txt`).
- **Carta de Smith, medidor de ROE, balun, atenuadores en T/pi y acoplador direccional.**
- **Fuente de alimentación completa** (transformador, puente, filtro y regulador en un solo circuito) y **reguladores integrados de 3 terminales** (78xx, LM317). Las piezas existen por separado en las secciones 5, 7 y 8.
