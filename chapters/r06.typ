#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QSY, QRL…), como en el original.
#let _r6-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)

#tema("R6", "Planes de bandas de la IARU", alcance: [Planes de bandas de la IARU · objetivos que se persiguen en dichos planes.])

La IARU (Unión Internacional de Radioaficionados) agrupa a las asociaciones nacionales — la URE en España — y divide el mundo, como la UIT, en tres Regiones: la 1 (Europa, África, Oriente Medio y norte de Asia, la nuestra), la 2 (América) y la 3 (resto de Asia y Oceanía). Como las atribuciones de frecuencias difieren entre Regiones, cada una tiene su propio *plan de bandas*: un reparto _recomendado_ de cada banda de aficionados en segmentos por modos — telegrafía, banda estrecha, fonía, modos digitales, balizas, entradas y salidas de repetidores, satélites — con sus *frecuencias de llamada*. No es una norma con rango legal, sino el acuerdo de convivencia que evita que un modo pise a otro; la reglamentación española remite a él y todo radioaficionado que opere en España debe tenerlo en cuenta. Un ejemplo que cae en el examen: en la banda de 2 m, la entrada de los repetidores ocupa 145,000–145,1875 MHz y su salida va 600 kHz más arriba. (El plan vigente, de diciembre de 2020, amplía esos segmentos a 144,975–145,194 MHz para las entradas y 145,575–145,7935 MHz para las salidas, con el mismo desplazamiento de 600 kHz; las preguntas del banco usan los valores clásicos.)

#q("R6.1", "a",
  [Los planes de banda de la IARU para la Región 1 deben ser tenidos en cuenta:],
  ([por todo radioaficionado que opere en España], [solo por las estaciones colectivas], [solo por los titulares de licencia CEPT], [únicamente por los operadores de telegrafía]),
  sol: [Los planes de la Región 1 deben tenerlos en cuenta todos los radioaficionados que operen en España: la Orden IET/1311/2013 los incorpora «como norma general» (art. 2.2 y anexo I, apartado 3.1).],
)

#q("R6.2", "c",
  [Los planes de banda de la IARU proporcionan información sobre:],
  ([las tasas administrativas de cada país], [la potencia máxima autorizada en cada licencia], [el modo de utilización recomendado en cada banda de frecuencias], [el número de estaciones autorizadas por distrito]),
  sol: [Indican el uso recomendado de cada segmento (CW, fonía, digitales, balizas…) para que los modos convivan sin interferirse.],
)

#q("R6.3", "b",
  [Sobre los planes de banda de la IARU es correcto afirmar que:],
  ([sustituyen al Reglamento de Radiocomunicaciones], [tienen en cuenta la atribución de bandas del Reglamento de Radiocomunicaciones de la UIT], [son obligatorios solo en telegrafía], [los redacta cada comunidad autónoma]),
  sol: [Parten de la atribución de bandas del Reglamento de Radiocomunicaciones de la UIT y la detallan por modos.],
)

#q("R6.4", "d",
  [Los planes de banda de la IARU pueden:],
  ([modificarse por cada radio club local], [aplicarse solo los fines de semana], [ignorarse en los concursos internacionales], [ser distintos en cada Región de la UIT]),
  sol: [Cada Región de la UIT tiene su propio plan IARU, porque las atribuciones difieren entre Regiones.],
)

#q("R6.5", "b",
  [En los planes de banda de la IARU para la Región 1:],
  ([solo figuran las bandas de HF], [están previstas las frecuencias para el servicio de radioaficionados], [se asignan los distintivos de llamada], [se establecen las tasas de examen]),
  sol: [El plan de la Región 1 recoge las frecuencias previstas para el servicio de radioaficionados y su uso recomendado.],
)

#q("R6.6", "a",
  [Las frecuencias de llamada previstas en los planes de banda permiten:],
  ([contactar con otros operadores que utilizan el mismo modo], [emitir con más potencia de la autorizada], [reservar una frecuencia de uso exclusivo], [transmitir sin identificarse]),
  sol: [Las frecuencias de llamada son puntos de encuentro por modo, antes de desplazarse (#_r6-cod[QSY]) a otra frecuencia.],
)

#q("R6.7", "b",
  [Para utilizar un repetidor de VHF, la emisión (entrada del repetidor) se efectúa en el segmento de banda:],
  ([144,000 – 144,100 MHz], [145,000 – 145,1875 MHz], [145,800 – 146,000 MHz], [146,000 – 146,500 MHz]),
  sol: [La entrada de los repetidores de 2 m está en 145,000–145,1875 MHz; la salida, 600 kHz más arriba (145,600–145,7875 MHz). Son los valores clásicos de los bancos; el plan IARU vigente (diciembre de 2020) usa 144,975–145,194 y 145,575–145,7935 MHz.],
)

== Las tres regiones de la UIT <r6-sec-regiones>

El espectro no se reparte igual en todo el planeta. Para poder atribuir bandas a cada servicio sin que un país estorbe a su vecino, la UIT divide el mundo en tres *Regiones* (figura #ref(<r6-fig-regiones>, supplement: none)), y el Cuadro de atribuciones asigna las bandas región por región. Por eso una banda de aficionado puede tener límites distintos según dónde se esté — el caso más citado es el de 40 metros — y por eso los planes de banda de la IARU también se redactan por regiones.

*España está en la Región 1*, que abarca Europa, África, Oriente Medio y el norte de Asia. La *Región 2* es América entera, y la *Región 3*, Asia meridional y oriental junto con Oceanía. La IARU se organiza en tres divisiones que calcan esas regiones, de modo que el plan de banda que hay que conocer para el examen es el de la Región 1.

// Cada Región es una celda del cuadro: título, descripción y, si procede, una marca.
#let _r6-reg(titulo, detalle, pie: none) = align(center + top, {
  text(font: fuente-sans, size: 10pt, weight: "bold", fill: col.tinta, titulo)
  parbreak()
  text(font: fuente-sans, size: 7.5pt, fill: col.gris, detalle)
  if pie != none {
    parbreak()
    v(0.5em)
    text(font: fuente-sans, size: 8pt, weight: "bold", fill: col.naranja, pie)
  }
})

#circuito(caption: [Las tres Regiones en que la UIT divide el mundo para atribuir el espectro. España pertenece a la Región 1, y es su plan de banda de la IARU el que rige aquí.])[
  #block(width: 80%, grid(
    columns: (1fr, 1fr, 1fr),
    rows: 3.2cm,
    inset: (x: 6pt, y: 9pt),
    fill: (x, y) => (col.naranja-claro, col.acento-claro, col.verde-claro).at(x),
    stroke: (x, y) => (
      top: 0.6pt + col.gris,
      bottom: 0.6pt + col.gris,
      left: if x == 0 { 0.6pt + col.gris } else { (paint: col.gris, thickness: 0.6pt, dash: "dashed") },
      right: if x == 2 { 0.6pt + col.gris },
    ),
    _r6-reg([Región 2], [América \ (norte, centro y sur)]),
    _r6-reg([Región 1], [Europa, África, \ Oriente Medio \ y norte de Asia], pie: [España]),
    _r6-reg([Región 3], [Asia meridional \ y oriental, Oceanía]),
  ))
] <r6-fig-regiones>

#q("R6.8", "d",
  [A efectos de atribución de frecuencias, España pertenece a la:],
  ([Región 3 de la UIT], [Región 2 de la UIT], [Zona CEPT independiente de las regiones], [Región 1 de la UIT]),
  sol: [La Región 1 abarca Europa, África, Oriente Medio y el norte de Asia. Es la que determina qué bandas tenemos aquí y cuál de los tres planes de banda de la IARU hay que conocer.],
)

#q("R6.9", "b",
  [La UIT divide el mundo en tres regiones con el fin de:],
  ([repartir por igual el número de radioaficionados], [atribuir las bandas de frecuencia a los servicios según zonas geográficas], [establecer tres husos horarios de referencia], [asignar los prefijos de los distintivos de llamada]),
  sol: [Las necesidades de cada zona del planeta son distintas y la propagación no entiende de fronteras. Repartir el espectro por regiones permite que las atribuciones se coordinen entre países próximos.],
)

#q("R6.10", "a",
  [La Región 2 de la UIT comprende:],
  ([el continente americano], [Europa y África], [Asia y Oceanía], [únicamente los países de la CEPT]),
  sol: [América entera, de Alaska a Tierra del Fuego. Europa y África son Región 1; Asia meridional y oriental con Oceanía, Región 3.],
)

#q("R6.11", "c",
  [La Región 3 de la UIT está formada principalmente por:],
  ([África y Oriente Medio], [América del Sur], [Asia meridional y oriental junto con Oceanía], [Europa oriental]),
  sol: [Incluye Japón, China, la India, el sureste asiático, Australia y Nueva Zelanda. África y Oriente Medio quedan en la Región 1.],
)

#q("R6.12", "d",
  [Que una banda de aficionado tenga límites distintos en España y en Estados Unidos se debe a que:],
  ([cada país fija libremente sus bandas sin coordinación], [las bandas dependen de la potencia autorizada en cada país], [los planes de banda de la IARU son obligatorios en unos países y no en otros], [pertenecen a regiones distintas de la UIT, con atribuciones diferentes]),
  sol: [España está en la Región 1 y Estados Unidos en la 2, y el Cuadro de atribuciones de la UIT asigna las bandas región por región. El caso más citado es el de 40 metros, con extensión distinta a uno y otro lado del Atlántico.],
)

#q("R6.13", "b",
  [Los planes de banda de la IARU, en cuanto a su naturaleza jurídica:],
  ([tienen rango de ley en los países de la CEPT], [son acuerdos voluntarios entre las asociaciones nacionales, no normas legales], [son obligatorios solo para los titulares de la clase A], [sustituyen al Cuadro Nacional de Atribución de Frecuencias]),
  sol: [La IARU es una federación de asociaciones, no un legislador: sus planes nacen de un acuerdo voluntario y no tienen rango de ley. Pero la Orden IET/1311/2013 (art. 2.2 y anexo I, apartado 3.1) remite a ellos y obliga a usarlos «como norma general», de modo que todo radioaficionado que opere en España debe tenerlos en cuenta (como dice R6.1). Por encima siguen estando el CNAF y la normativa nacional.],
)

#q("R6.14", "c",
  [Dentro de cada banda, los planes de banda de la IARU reparten los segmentos atendiendo principalmente a:],
  ([la antigüedad del distintivo de llamada de cada estación], [el país de procedencia de cada estación], [el modo de emisión y la anchura de banda ocupada], [la potencia de salida de los equipos]),
  sol: [Se agrupan los modos estrechos por un lado y los anchos por otro, de manera que una emisión de fonía no caiga encima de un segmento de telegrafía o de modos digitales. Es la única forma de que quepan todos.],
)

#q("R6.15", "b",
  [El objetivo que se persigue al instalar un repetidor de radioaficionado es:],
  ([reducir la potencia necesaria en las estaciones fijas], [ampliar el alcance de las comunicaciones], [liberar espectro en las bandas de HF], [sustituir a las estaciones de aficionado individuales]),
  sol: [Un repetidor recibe en un punto elevado y retransmite al instante en otra frecuencia, de modo que dos estaciones que no se oyen directamente —por la distancia o por el terreno— sí se oyen a través de él. Con equipos portátiles de pocos vatios la diferencia es enorme.],
)

#q("R6.16", "b",
  [La instalación de una estación repetidora de aficionado puede autorizarse a:],
  ([cualquier radioaficionado con autorización en vigor], [las asociaciones de radioaficionados legalmente reconocidas], [cualquier persona física o jurídica], [los ayuntamientos exclusivamente]),
  sol: [Las estaciones repetidoras y demás automáticas desatendidas se autorizan a asociaciones de radioaficionados legalmente reconocidas, no a título individual: son infraestructura de uso común y alguien tiene que responder de ellas de forma estable.],
)

#q("R6.17", "c",
  [Históricamente, el uso de la banda de 50 MHz en España estuvo sujeto a restricciones geográficas. Una de las provincias desde las que _no_ se podía emitir era:],
  ([Almería], [Lugo], [Segovia], [Girona]),
  sol: [Pregunta histórica. Las Instrucciones de 2006 (Resolución de 20-09-2006, apartado 2) solo prohibían emitir en 50,0–51,0 MHz desde Ávila, Guadalajara, Madrid, Segovia, Soria, Toledo y Valladolid (con límites parciales en Palencia, Burgos, Zamora, Salamanca, Cuenca y Cáceres): de las cuatro opciones solo Segovia estaba restringida; Almería, Lugo y Girona sí podían emitir. La limitación protegía la recepción de la televisión analógica; con el apagón analógico (abril de 2010) la restricción por provincias desapareció y en la Orden vigente la banda de 50 MHz ya no tiene condición geográfica (el CNAF, nota UN-100, mantiene que es un uso especial que no puede causar interferencia perjudicial a la televisión de países vecinos). Ojo: en el banco original la pregunta era «señale la provincia desde la que se podrán efectuar emisiones», con Almería como respuesta; aquí se ha invertido el enunciado para que solo haya una opción correcta. Si en el examen aparece la versión original, la que dan por buena es Almería.],
)

#nota[La restricción (Instrucciones de 2006, apartado 2) prohibía emitir en 6 metros desde Ávila, Guadalajara, Madrid, Segovia, Soria, Toledo y Valladolid, con límites parciales en otras provincias del centro, para proteger la recepción de la televisión analógica. Con el apagón analógico (2010) desapareció — en la Orden vigente la banda de 50 MHz ya no tiene condición geográfica, aunque el CNAF (nota UN-100) mantiene que es un uso especial que no puede causar interferencia perjudicial a la televisión de países vecinos —, pero la pregunta sigue apareciendo en los bancos con su redacción histórica (en el banco original: «señale la provincia desde la que se podrán efectuar emisiones», con Almería como respuesta).]
