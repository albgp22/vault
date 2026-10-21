# Encargo: encontrar conceptos duplicados entre temas

Contexto. Para unos simulacros del examen español de radioaficionado se ha hecho un inventario de
conceptos tema a tema (cada tema lo hizo un agente distinto). Un concepto es un hecho o destreza
que el examen pregunta con una sola pregunta. Como los temas se solapan (componentes y circuitos,
receptores e interferencias, medidas y antenas, distintivos y reglamentación…), hay conceptos que
aparecen en dos o tres temas. En los simulacros cada concepto debe salir una sola vez, salvo que la
segunda pregunta pruebe un ángulo realmente distinto que el examen usa.

Entrada: un archivo de texto con un bloque por concepto:
`cid | tema | peso | nombre del concepto` y debajo, sangradas, sus preguntas elegidas
(`id: enunciado → respuesta correcta`).

Tu trabajo: leer la lista ENTERA (por partes) y encontrar todos los grupos de conceptos de
TEMAS DISTINTOS que son el mismo concepto: saber responder la pregunta de uno basta para
responder la del otro. No marques como duplicados conceptos solo relacionados (p. ej. «qué es la
ROE» y «cómo se mide la ROE» son distintos; «armónicos son múltiplos enteros de la fundamental» en
T3, T5 y T9 es el mismo).

Para cada grupo decide:
- `conservar`: el cid cuya pregunta es mejor (más parecida al examen, mejores distractores; en
  normativa, preferir las de los bancos públicos `C-R…`). Si los pesos difieren, el grupo hereda el
  peso mayor (indícalo en `peso`).
- `quitar`: los otros cids.
- `segunda`: opcional, id de UNA pregunta de un concepto quitado que merezca quedarse como segunda
  pregunta del conservado porque prueba otro ángulo de verdad (otro dato, la trampa inversa).
  Úsalo poco.

Salida: el archivo JSON indicado:
```json
[{"conservar": "T3-28", "quitar": ["T5-42", "T9-06"], "peso": 2, "segunda": null,
  "motivo": "las tres preguntan que los armónicos son múltiplos enteros de f"}]
```
Valida con python3 -I que el JSON es correcto y que todo cid existe en la entrada y no aparece en
dos grupos. No modifiques ningún otro archivo. Termina con un resumen: número de grupos y de
conceptos quitados por tema.
