# Encargo: verificación independiente de preguntas nuevas de examen

Contexto. `/home/user/vault` es un libro en Typst para el examen español de radioaficionado
(HAREC). Otros agentes han redactado preguntas tipo test nuevas para unos simulacros de examen.
Tu trabajo es revisarlas con ojo crítico, como un tribunal de examen, antes de que las estudie una
persona que va a examinarse. Un error aquí le enseñaría algo falso.

Entrada: un archivo JSON con una lista de preguntas: `nid`, `tema`, `enunciado`, `opciones`
(4), `clave` (a–d), `sol` (solución razonada), `fuente` (archivo:línea del libro de donde sale el
dato). El texto está en marcado Typst (matemáticas entre `$…$`).

Para CADA pregunta comprueba:
1. **La clave es correcta** según el libro (`chapters/*.typ`, `cheatsheet.typ`; empieza por la
   `fuente`) y según la física o la norma. Rehaz todo cálculo.
2. **Solo una opción es correcta**: ningún distractor es también defendible.
3. Los distractores son plausibles y no son absurdos ni triviales.
4. El enunciado no es ambiguo y no da la respuesta.
5. La `sol` explica bien por qué y no contiene errores.
6. El marcado Typst es válido: math entre `$…$` con sintaxis Typst (no LaTeX: nada de `\frac`,
   `\cdot`, `\Omega`; sí `dot`, `times`, `"Ω"`, `a / b`, `sqrt(x)`, `10^(-6)`). No hay `#` salvo
   `#strong[…]`/`#emph[…]`. Corchetes `[` `]` sueltos en texto deben ir escapados `\[`.

Si una pregunta tiene un defecto, CORRÍGELA tú (mínimo cambio que la deje impecable). Si no tiene
arreglo razonable, recomiéndala para descartar.

Salida: escribe el archivo JSON indicado con una lista de objetos:
```json
{"nid": "N-T1-01", "veredicto": "ok" | "corregida" | "descartar",
 "motivo": "qué fallaba (vacío si ok)",
 "enunciado": "…", "opciones": ["…","…","…","…"], "clave": "b", "sol": "…"}
```
Incluye SIEMPRE los cuatro campos de contenido (iguales al original si `ok`). Comprueba con un
script (python3 -I) que el JSON es válido, que hay una entrada por cada `nid` de la entrada y que
cada pregunta tiene 4 opciones distintas y clave a–d. No modifiques ningún otro archivo.
Termina con un resumen breve: cuántas ok, corregidas y descartadas, y la lista de correcciones de
clave (si las hay).
