# Circuitos propios de Falstad (CircuitJS)

Última verificación: 2026-10-20. Circuitos verificados: **13** de 13. Todos están en `lib/falstad-custom.typ`.

## Verificados

| id | Título | Qué muestra (qué debe mirar el lector) | Valores | URL completa | Verificado |
|---|---|---|---|---|---|
| `resonancia-serie` | Resonancia serie RLC | Un generador de barrido alimenta R, L y C en serie. En el osciloscopio, la corriente crece al acercarse a f0 ≈ 1 kHz, llega a un pico de 0,5 A (= 5 V / 10 Ω) y baja después; el generador muestra la frecuencia de cada momento. | R = 10 Ω, L = 10 mH, C = 2,533 µF (f0 = 1/(2π√(LC)) ≈ 1,00 kHz, Q ≈ 6,3). Barrido logarítmico de 250 Hz a 4 kHz y vuelta, 0,5 s en cada sentido, 5 V de pico. Paso de tiempo 10 µs. Frecuencias escaladas a audio para que se vea la animación; en radio, f0 estaría en MHz con L y C mucho menores. | https://www.falstad.com/circuit/circuitjs.html?ctz=CQAgjOCmC0AMCsIBMtYnmxH0zGAUAB4gAsAHKWgGxIml11hUgBKkAzgPYB2AhtwGMAlrwA67dpABOQyOJYAZAMIAucQBsx7AZykzI3AC5zJ7cQFsAh4SHmtB8QDNY40QEdxYAPQAKJIAHgQCwiH2UASlDxQAkiT3EAawAJAC8iUgoqOhoMikYkEABxA2leABNdcWKTACNePSFS8SQMcSTxQCTCcRI4lvYAT3EANwBXSHVDLR9+3nVdDnEOASmSzjN2LV5B4qFOUPwwAHY0MCQKJmpGKjQAZmRsElRMEFgAOnh8KXBj8AvkPdzTx-AsHw6h+f2+JCYXzQ0KesAgQIEpEh-whzGOFDQSBel0uMFgzCBAHMkWiyNlIZdYHQgcQmBQUJjLrkUAwPqxXB52GAXOxAJXAKUuR2QqBAlzIdBZpDZCg5nh55niApQyHIlHp8FyORASll7CQABp4JdxABWgBiKVVlxIGXgzGt2TZAFkhFITCNxMthNNtJwAA5bNTsTTiHS1AzGcTsQaVExTcS8ATSBZSSQJmLsBKJcR9djVABWWgq7D9gwAl+wnpaKJd0qQ7aKqI6hQBRdTiQmFKRLKQWYbsQzdjRaRxugTDQQicomBbFLTmTjmCOcKucUU3e2UACce3QjxeAIgSl0+iMJh8Vhsdjm3CcsB2QA&lang=es&euroResistors=true | 2026-10-20 |

## Verificación de los otros 12 (2026-10-20)

`www.falstad.com` no era accesible desde la sesión, así que CircuitJS se compiló desde su código
oficial (`github.com/pfalstad/circuitjs1`, rama `master`, `gradle makeSite`) y se sirvió en local.
El mismo circuito `resonancia-serie` dio en esa copia exactamente las medidas de la verificación en
el sitio real (pico 0,499 A a 1,022 kHz), lo que confirma que la copia local se comporta igual.

Cada URL de `build/falstad-custom/urls.json` se abrió tal cual (solo cambia el servidor) en Chromium
sin interfaz. Script: `tools/falstad-test/` (`run.js` abre la URL y graba en cada paso de tiempo;
`check.py` mide). Se comprobó en todos: carga con el número de elementos esperado, simulación en marcha
sin «Singular matrix» ni errores de página, y el comportamiento prometido:

| id | Resultado medido en el simulador |
|---|---|
| `tanque-paralelo` | tensión del tanque máxima 5,00 V a 1,017 kHz; ≤ 0,38 V entre 250 y 350 Hz |
| `red-L` | carga: 10,00 V de pico, 0,250 W con red; 8,00 V, 0,160 W sin red |
| `red-T` | carga: 10,00 V de pico, 0,250 W con red; 8,00 V, 0,160 W sin red |
| `red-pi` | 3.er armónico: −9,5 dB en la salida del PA, −45,8 dB en la carga (5.º: −63,9 dB) |
| `filtro-pi-fuente` | 12,6 V de continua; rizado 2,07 V p-p con un condensador, 0,009 V con el filtro en pi |
| `fuente-completa` | secundario 15,3 V ef.; condensador 19,8 V con 1,95 V de rizado; salida 13,87 V, 13 mV de rizado, 0,50 A |
| `clase-c` | el colector conduce el 38 % del ciclo (impulsos de 17,7 mA); en el tanque 2.º armónico −31 dB, 3.º −44 dB |
| `base-comun` | entrada 20 mV, salida 0,80 V: ganancia 40, en fase (correlación +0,99); I_E 0,96 mA |
| `clases-ab` | clase B: salida 0 V mientras \|v_ent\| < 0,4 V, 3.er armónico −23 dB; clase AB: −46 dB |
| `modulacion-am` | rayas de 2,50 V en 2 kHz y 1,25 V en 1,8 y 2,2 kHz; nada en 1,6 ni 2,4 kHz |
| `modulacion-fm` | β = 0,5: portadora 4,69 V, 1.ª banda 1,21 V, 2.ª 0,15 V; β = 3: 1,30 / 1,69 / 2,43 / 1,54 / 0,66 V (Bessel) |
| `mezclador` | producto: 2,5 V en 0,5 kHz y en 2,5 kHz; tras el filtro: 2,33 V en 0,5 kHz y 0,25 V en 2,5 kHz |

Corrección encontrada en la prueba: el borrador de `mezclador` usaba el código de elemento `213`, que
es la fuente de *corriente* controlada (VCCS); la salida llegaba a kilovoltios. `gen.py` usa ahora
`212` (fuente de tensión controlada, VCVS). Además se movieron dos rótulos que tapaban un componente
(`red-pi`, `base-comun`).

Todos los enlaces están en `lib/falstad-custom.typ` y se usan en el libro y en la hoja de repaso. Dos
marcas no se enlazaron porque el circuito no representa la figura: intro-2c, «Modulación de AM de
colector» (el circuito `modulacion-am` es un generador, no un modulador de colector) y t05,
«Doblador de frecuencia» (`clase-c` está sintonizado a f, no a 2f).

## How the links were built

- Each circuit is written in the CircuitJS text format (`$` header line, one line per element, `o` scope lines) by `build/falstad-custom/circuits.py`, which uses the helpers in `build/falstad-custom/gen.py`. Element and scope line formats were read from the CircuitJS source (`pfalstad/circuitjs1`, branch `master`) and from the official example files.
- The text is compressed with lz-string `compressToEncodedURIComponent` and put in the `ctz` parameter. The compressor is a Python port in `build/falstad-custom/lz.py`. Check: it gives exactly the tested `ctz` string of `lib/falstad-catalog.md` for the same 5-element test circuit, and every generated URL decompresses back to its circuit text.
- Every URL ends with `&lang=es&euroResistors=true`.

## How the links were tested

For a row to be in «Verificados», all these checks passed on the live site (`www.falstad.com/circuit/circuitjs.html`, module `circuitjs110`), in the built-in browser, with the exact URL of the table:

1. The circuit loads with all its elements. `CircuitJS1.getElements()` returned the expected count (for `resonancia-serie`: 12 elements = sweep source, R, L, C, ground and 7 text labels), and the screenshot shows each element.
2. The simulation runs with no «Singular matrix» or convergence error. `CircuitJS1.isRunning()` stayed `true` and the simulation time increased (0,315 × real time in the hidden browser pane).
3. The scope shows the promised behaviour. A screenshot shows the current peaks of each sweep. A measurement script on the `ontimestep` hook recorded the current in R for 200 000 steps (2 s of simulated time, 4 sweeps). For `resonancia-serie`: peak current 0,499 A; the peaks occur when the sweep source reads 1,02 to 1,05 kHz (8 ms blocks), and the current is 0,02 A at 250 Hz and at 4 kHz.
