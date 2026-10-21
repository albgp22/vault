# Encargo: inventario de conceptos de examen para un lote de temas

Contexto. El repositorio `/home/user/vault` contiene un libro en Typst para el examen español de
radioaficionado (HAREC): `chapters/*.typ`, hoja de repaso `cheatsheet.typ`. Vamos a hacer UN
documento de simulacros de examen (30 preguntas técnicas + 30 de normativa cada uno). El objetivo
del usuario: si conoce y entiende todas las preguntas de los simulacros, aprueba con alta
probabilidad. Por eso los simulacros deben cubrir TODOS los conceptos examinables y NO repetir el
mismo concepto salvo que la repetición aporte (una trampa distinta, otro ángulo que cae en examen).

Tu trabajo (solo para tu lote): leer TODAS las preguntas del banco de tu lote, agruparlas en
conceptos distintos, elegir la mejor pregunta para cada concepto y detectar huecos.

## Entrada
- `build/simulacros/in/<LOTE>.json`: `temas` (título y alcance oficial de cada tema) y `preguntas`
  (id, clave, enunciado, opciones, sol; `figura: true` si depende de una figura). El texto está en
  marcado Typst. Léelo entero (por partes si es grande).
- Para comprobar hechos y encontrar huecos: el capítulo del tema (`chapters/t01.typ`…`t10.typ`,
  `r01.typ`…`r09.typ`) y la sección del tema en `cheatsheet.typ`. Prefijos de grupo: `T5.x`/`R5.x`
  = preguntas propias del libro; `C-T5.x`/`C-R5.x` = preguntas de los bancos públicos
  (apéndice B); `F-T5.x`/`F-R5.x` = refuerzo del temario (apéndice C).

## Reglas
1. **Concepto** = un hecho o una destreza que el examen puede preguntar con una sola pregunta. Dos
   preguntas son del mismo concepto si saber responder una basta para responder la otra (por
   ejemplo, la misma fórmula con otros números). Ni demasiado fino ni demasiado grueso: «ley de
   Ohm» es un concepto; «Ohm con 12 V» y «Ohm con 24 V» no son dos.
2. **Cubre todas las preguntas**: cada id de la entrada debe aparecer en el `cubre` de algún
   concepto, o en `descartadas` con motivo (p. ej. clave dudosa reconocida en la propia solución).
3. **Elige** en `preguntas` la mejor pregunta del concepto (normalmente una). Criterios: redacción
   como la del examen, distractores que enseñan la trampa típica, sin depender de una figura si se
   puede evitar, clave segura. En normativa, si hay una equivalente de los bancos públicos
   (`C-R…`), prefiérela: el examen real de normativa se parece mucho a esos bancos.
   Pon una segunda pregunta SOLO si prueba un ángulo distinto que el examen usa de verdad (otra
   trampa, el dato contrario, el cálculo en el otro sentido). Explícalo en `nota`.
4. **Peso** 1–3: 3 = núcleo, cae con frecuencia; 2 = normal; 1 = marginal pero dentro del temario.
5. **Huecos**: si un punto del alcance oficial, del capítulo o de la hoja de repaso que el examen
   puede preguntar no tiene ninguna pregunta en el banco, escribe una pregunta nueva en `nuevas`.
   Solo hechos que estén en el libro o la hoja; cita `fuente` (archivo:línea). Cuatro opciones,
   una sola correcta, distractores plausibles. No inventes datos normativos.
6. **Marcado de las preguntas nuevas**: texto Typst sencillo, sin macros ni `#` (salvo `#strong[…]`
   si hace falta). Matemáticas entre `$…$` con sintaxis Typst (`$X_L = 2 pi f L$`,
   `$1 / (2 pi sqrt(L C))$`, `$10^(-6)$`, unidades entre comillas dentro de math: `$50 "Ω"$`).
   Coma decimal española fuera de math (2,5 V); dentro de math escribe `2,5` tal cual. Español de
   España, tuteo.
7. `sol` de cada pregunta nueva: 1–4 frases que expliquen por qué la clave es correcta y, si
   aporta, por qué falla el distractor tentador.
8. Si ves en el banco una clave que crees errónea, anótala en `problemas` (no la cambies).
9. No modifiques ningún archivo del repositorio. Escribe solo tu archivo de salida.

## Salida
Escribe `build/simulacros/conceptos/<LOTE>.json` (UTF-8, JSON válido) con esta forma:

```json
{
  "lote": "L1",
  "conceptos": [
    {"cid": "T1-01", "tema": "T1", "concepto": "Ley de Ohm: hallar I, V o R",
     "peso": 3, "preguntas": ["T1.3"], "cubre": ["T1.3", "T1.4", "C-T1.2", "F-T1.7"],
     "nota": ""}
  ],
  "nuevas": [
    {"nid": "N-T1-01", "cid": "T1-37", "tema": "T1",
     "enunciado": "…", "opciones": ["…", "…", "…", "…"], "clave": "b",
     "sol": "…", "fuente": "chapters/t01.typ:812"}
  ],
  "descartadas": [{"id": "C-T1.9", "motivo": "…"}],
  "problemas": [{"id": "…", "detalle": "…"}]
}
```
Un concepto cuyo único material es una pregunta nueva lleva `"preguntas": ["N-T1-01"]` y
`"cubre": []`. Numera los `cid` por tema en orden del temario.

Antes de terminar, comprueba con un script (python3 -I) que el JSON es válido, que todo id de
la entrada está en algún `cubre` o en `descartadas`, que todo id de `preguntas` existe (en la
entrada o en `nuevas`) y que cada pregunta nueva tiene 4 opciones y clave a–d.
Responde al final con un resumen breve: número de conceptos por tema y por peso, número de
preguntas nuevas y los problemas encontrados.
