# Circuitos propios de Falstad (CircuitJS)

Última verificación: 2026-10-20. Circuitos verificados: **1** de 13 encargados. Use en el libro solo los enlaces de la tabla «Verificados» (también en `lib/falstad-custom.typ`). Los demás son borradores **sin verificar**.

## Verificados

| id | Título | Qué muestra (qué debe mirar el lector) | Valores | URL completa | Verificado |
|---|---|---|---|---|---|
| `resonancia-serie` | Resonancia serie RLC | Un generador de barrido alimenta R, L y C en serie. En el osciloscopio, la corriente crece al acercarse a f0 ≈ 1 kHz, llega a un pico de 0,5 A (= 5 V / 10 Ω) y baja después; el generador muestra la frecuencia de cada momento. | R = 10 Ω, L = 10 mH, C = 2,533 µF (f0 = 1/(2π√(LC)) ≈ 1,00 kHz, Q ≈ 6,3). Barrido logarítmico de 250 Hz a 4 kHz y vuelta, 0,5 s en cada sentido, 5 V de pico. Paso de tiempo 10 µs. Frecuencias escaladas a audio para que se vea la animación; en radio, f0 estaría en MHz con L y C mucho menores. | https://www.falstad.com/circuit/circuitjs.html?ctz=CQAgjOCmC0AMCsIBMtYnmxH0zGAUAB4gAsAHKWgGxIml11hUgBKkAzgPYB2AhtwGMAlrwA67dpABOQyOJYAZAMIAucQBsx7AZykzI3AC5zJ7cQFsAh4SHmtB8QDNY40QEdxYAPQAKJIAHgQCwiH2UASlDxQAkiT3EAawAJAC8iUgoqOhoMikYkEABxA2leABNdcWKTACNePSFS8SQMcSTxQCTCcRI4lvYAT3EANwBXSHVDLR9+3nVdDnEOASmSzjN2LV5B4qFOUPwwAHY0MCQKJmpGKjQAZmRsElRMEFgAOnh8KXBj8AvkPdzTx-AsHw6h+f2+JCYXzQ0KesAgQIEpEh-whzGOFDQSBel0uMFgzCBAHMkWiyNlIZdYHQgcQmBQUJjLrkUAwPqxXB52GAXOxAJXAKUuR2QqBAlzIdBZpDZCg5nh55niApQyHIlHp8FyORASll7CQABp4JdxABWgBiKVVlxIGXgzGt2TZAFkhFITCNxMthNNtJwAA5bNTsTTiHS1AzGcTsQaVExTcS8ATSBZSSQJmLsBKJcR9djVABWWgq7D9gwAl+wnpaKJd0qQ7aKqI6hQBRdTiQmFKRLKQWYbsQzdjRaRxugTDQQicomBbFLTmTjmCOcKucUU3e2UACce3QjxeAIgSl0+iMJh8Vhsdjm3CcsB2QA&lang=es&euroResistors=true | 2026-10-20 |

## Sin verificar

The work stopped on request before these circuits were tested in the browser. Each one has a draft circuit text file. The draft URL for each id is in `build/falstad-custom/urls.json`. Do not use these URLs in the book until each one is opened and checked as described below.

| id | Estado | Borrador |
|---|---|---|
| `tanque-paralelo` | sin verificar | `build/falstad-custom/tanque-paralelo.txt` |
| `red-L` | sin verificar | `build/falstad-custom/red-L.txt` |
| `red-pi` | sin verificar | `build/falstad-custom/red-pi.txt` |
| `red-T` | sin verificar | `build/falstad-custom/red-T.txt` |
| `filtro-pi-fuente` | sin verificar | `build/falstad-custom/filtro-pi-fuente.txt` |
| `fuente-completa` | sin verificar | `build/falstad-custom/fuente-completa.txt` |
| `clase-c` | sin verificar | `build/falstad-custom/clase-c.txt` |
| `base-comun` | sin verificar | `build/falstad-custom/base-comun.txt` |
| `clases-ab` | sin verificar | `build/falstad-custom/clases-ab.txt` (comparación lado a lado de clase B y clase AB con una misma señal y FFT; no es igual a `pushpull.txt` ni a `pushpullxover.txt`, que muestran cada etapa por separado) |
| `modulacion-am` | sin verificar | `build/falstad-custom/modulacion-am.txt` |
| `modulacion-fm` | sin verificar | `build/falstad-custom/modulacion-fm.txt` |
| `mezclador` | sin verificar | `build/falstad-custom/mezclador.txt` |

The values in the drafts come from hand calculations in `build/falstad-custom/calc.py` (for example: red L 13,78 mH + 1,378 µF; red T 1,061 µF + 18,84 mH + 0,6497 µF; red pi 9,549 µF + 4,775 mH + 9,549 µF, 3rd harmonic −36 dB). These calculations are expected values, not simulator results.

## How the links were built

- Each circuit is written in the CircuitJS text format (`$` header line, one line per element, `o` scope lines) by `build/falstad-custom/circuits.py`, which uses the helpers in `build/falstad-custom/gen.py`. Element and scope line formats were read from the CircuitJS source (`pfalstad/circuitjs1`, branch `master`) and from the official example files.
- The text is compressed with lz-string `compressToEncodedURIComponent` and put in the `ctz` parameter. The compressor is a Python port in `build/falstad-custom/lz.py`. Check: it gives exactly the tested `ctz` string of `lib/falstad-catalog.md` for the same 5-element test circuit, and every generated URL decompresses back to its circuit text.
- Every URL ends with `&lang=es&euroResistors=true`.

## How the links were tested

For a row to be in «Verificados», all these checks passed on the live site (`www.falstad.com/circuit/circuitjs.html`, module `circuitjs110`), in the built-in browser, with the exact URL of the table:

1. The circuit loads with all its elements. `CircuitJS1.getElements()` returned the expected count (for `resonancia-serie`: 12 elements = sweep source, R, L, C, ground and 7 text labels), and the screenshot shows each element.
2. The simulation runs with no «Singular matrix» or convergence error. `CircuitJS1.isRunning()` stayed `true` and the simulation time increased (0,315 × real time in the hidden browser pane).
3. The scope shows the promised behaviour. A screenshot shows the current peaks of each sweep. A measurement script on the `ontimestep` hook recorded the current in R for 200 000 steps (2 s of simulated time, 4 sweeps). For `resonancia-serie`: peak current 0,499 A; the peaks occur when the sweep source reads 1,02 to 1,05 kHz (8 ms blocks), and the current is 0,02 A at 250 Hz and at 4 kHz.
