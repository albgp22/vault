# Encargo: revisión independiente de preguntas de control

Contexto. `/home/user/vault` es un libro en Typst para el examen español de radioaficionado
(HAREC): `chapters/*.typ`, `cheatsheet.typ`. Otro agente ha escrito preguntas NUEVAS de control:
cada una pregunta un concepto ya trabajado en unos simulacros de estudio, pero de otra forma, para
medir si la persona domina el concepto o solo recuerda la pregunta. Tú eres el tribunal: una
pregunta mala aquí enseña algo falso o mide mal.

Entrada:
- `build/control/escritas/<LOTE>.json`: las preguntas nuevas (`kid`, `cid`, `enunciado`,
  `opciones`, `clave`, `sol`, `fuente`, `angulo`).
- `build/control/in/<LOTE>.json`: por concepto (`cid`), la pregunta de estudio
  (`preguntas_estudio`) y las del libro (`otras_del_libro`).

Para CADA pregunta comprueba:
1. **Clave correcta** según el libro (empieza por la `fuente`) y según la física o la norma
   vigente que da el libro. Rehaz todos los cálculos.
2. **Una sola opción correcta**; ningún distractor defendible; nada de «todas/ninguna de las
   anteriores».
3. **Es nueva de verdad**: no es copia ni paráfrasis de la de estudio ni de las del libro del
   mismo concepto (mismo enunciado con otras palabras y la misma respuesta = paráfrasis).
   Preguntar el mismo hecho en otro sentido, con otros datos o en un caso práctico sí vale.
4. **Prueba el concepto indicado** (`cid` y su pregunta de estudio), al nivel del examen real.
5. En normativa, **todo dato está en el libro**: si no lo encuentras en `chapters/r0*.typ`,
   `cheatsheet.typ` o en las soluciones de las preguntas del libro, la pregunta no vale.
6. `sol` correcta, 2–4 frases, sin nombrar letras de opciones.
7. Marcado Typst válido: `$…$` emparejados con sintaxis Typst (no LaTeX: nada de `\frac`,
   `\cdot`, `\Omega`), sin `#` salvo `#strong[…]`/`#emph[…]`, corchetes sueltos escapados `\[`.

Decisión por pregunta: `ok`; `corregida` (cambio mínimo que la deja impecable); o `reemplazada`
(si no tiene arreglo, escribe tú otra pregunta nueva para el mismo concepto que cumpla todo lo
anterior). No dejes ningún concepto sin pregunta.

Salida: `build/control/verificadas/<LOTE>.json`, lista JSON con una entrada por `kid` de la
entrada:
```json
{"kid": "K-T1-05-1", "veredicto": "ok" | "corregida" | "reemplazada", "motivo": "",
 "enunciado": "…", "opciones": ["…","…","…","…"], "clave": "b", "sol": "…"}
```
Incluye siempre los cuatro campos de contenido. Comprueba con un script (python3 -I): JSON
válido, una entrada por `kid`, 4 opciones distintas, clave a–d, `$` emparejados, sin `\frac`,
`\cdot`, `\Omega`. No modifiques ningún otro archivo. Termina con un resumen: cuántas ok,
corregidas y reemplazadas, y la lista de claves cambiadas con el motivo.
