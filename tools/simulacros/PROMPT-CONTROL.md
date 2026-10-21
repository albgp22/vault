# Encargo: escribir preguntas NUEVAS de control para el examen de radioaficionado

Contexto. `/home/user/vault` es un libro en Typst para el examen español de radioaficionado
(HAREC): capítulos en `chapters/*.typ`, hoja de repaso en `cheatsheet.typ`. Ya existe un documento
de **simulacros de estudio**: 13 exámenes de 30 + 30 preguntas, una por concepto del temario. La
persona va a estudiar con ese documento y con el libro. Ahora hace falta un segundo documento, de
**control**: los mismos conceptos, pero con preguntas que no ha visto nunca, para medir si de verdad
domina cada concepto o solo recuerda la pregunta.

Tu trabajo: escribir, para cada concepto de tu lote, el número indicado (`escribir`) de preguntas
tipo test NUEVAS.

## Entrada
`build/control/in/<LOTE>.json`: lista de conceptos con `cid`, `tema`, `concepto`, `peso`,
`escribir` (1 o 2), `preguntas_estudio` (la pregunta o preguntas que ya salen en los simulacros de
estudio: enunciado, opciones, clave, solución) y `otras_del_libro` (otras preguntas del libro sobre
el mismo concepto: enunciado y respuesta). Léelo entero (por partes).

## Reglas
1. **Nueva de verdad.** La pregunta no puede ser una copia ni una paráfrasis de
   `preguntas_estudio` ni de `otras_del_libro`. Cambia la superficie y conserva el concepto:
   - en cálculos: otros datos y, si se puede, el cálculo en el otro sentido (dado el resultado,
     hallar el dato), u otra magnitud de la misma fórmula;
   - en hechos: pregunta el dato al revés (del significado al código, de la banda a la
     frecuencia), ponlo en un caso práctico, o pregunta otra consecuencia del mismo hecho;
   - usa distractores distintos, sacados de errores típicos de ESTE concepto.
   Quien entiende el concepto debe acertarla; quien solo memorizó la pregunta de estudio, no
   necesariamente.
2. **Mismo nivel que el examen real.** Ni más fácil ni rebuscada. Una sola opción correcta;
   ningún distractor defendible. Nada de «todas las anteriores», «ninguna de las anteriores» ni
   «a y b». Solo texto: sin figuras.
3. **Solo hechos del libro.** Cada dato (sobre todo en normativa: plazos, potencias, bandas,
   artículos, distintivos) debe estar en `chapters/*.typ` o `cheatsheet.typ`. Cita la `fuente`
   (archivo:línea). Si el libro no permite una pregunta nueva fiable para un concepto, escribe la
   mejor variante posible del mismo dato (por ejemplo, el dato al revés) y explica en `angulo`.
   No inventes normas ni cifras. Rehaz todos los cálculos.
4. Si `escribir` es 2, las dos preguntas deben ser distintas entre sí y de las de estudio.
5. **Marcado Typst**: texto sencillo, sin `#` salvo `#strong[…]`/`#emph[…]`. Matemáticas entre
   `$…$` con sintaxis Typst (`$X_L = 2 pi f L$`, `$1 / (2 pi sqrt(L C))$`, `$10^(-6)$`,
   `$50 "Ω"$`); nada de LaTeX (`\frac`, `\cdot`, `\Omega`). Coma decimal (2,5 V). Corchetes
   sueltos escapados `\[`. Español de España, tuteo, tono del examen.
6. `sol`: 2–4 frases. Por qué la clave es correcta y por qué falla el distractor más tentador. No
   nombres letras de opciones (las opciones se reordenan después).
7. Reparte las claves entre a, b, c y d.
8. No modifiques ningún archivo del repositorio salvo tu salida.

## Salida
`build/control/escritas/<LOTE>.json`: lista JSON, una entrada por pregunta:
```json
{"kid": "K-T1-05-1", "cid": "T1-05", "enunciado": "…", "opciones": ["…","…","…","…"],
 "clave": "c", "sol": "…", "fuente": "chapters/t01.typ:212",
 "angulo": "cálculo inverso: dada la potencia, hallar la corriente"}
```
`kid` = `K-<cid>-<1|2>`. Antes de terminar, comprueba con un script (python3 -I): JSON válido;
para cada concepto de la entrada hay exactamente `escribir` preguntas; 4 opciones distintas;
clave a–d; ningún enunciado coincide (ni casi) con los de `preguntas_estudio` u
`otras_del_libro` (compara, por ejemplo, con difflib y revisa las que pasen de 0,6 de
parecido); `$` emparejados; sin `\frac`, `\cdot`, `\Omega`. Termina con un resumen breve:
número de preguntas, reparto de claves y conceptos donde no fue posible un ángulo nuevo.
