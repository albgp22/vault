#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QRL, QSL…), como en el original.
#let _r7-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)

#tema("R7", "Responsabilidad social y procedimientos operativos", alcance: [Responsabilidad social del radioaficionado · procedimientos operativos.])

El Reglamento de Radiocomunicaciones define el servicio de aficionados como un servicio de _instrucción individual, intercomunicación y estudios técnicos_ efectuado por personas autorizadas que se interesan en la radiotecnia _sin fines de lucro_. De esa definición cuelga toda la deontología operativa que examina este tema: se escucha antes de transmitir («#_r7-cod[¿QRL?]»), se transmite en lenguaje claro y sin codificar el significado, el contenido se ciñe al servicio y a observaciones personales — nada de fines comerciales, publicitarios o lucrativos (causa de revocación, art. 8.1.b de la Orden) ni tráfico para terceros, salvo en emergencia o desastre (art. 30.3) —, jamás se interfiere deliberadamente, se deletrea con el alfabeto internacional y la estación se identifica con su distintivo al comienzo y al final de cada emisión — y, si es larga, a intervalos cortos: al menos cada diez minutos, fija el art. 29 de la Orden IET/1311/2013 —. El «cambio» al ceder la palabra y la tarjeta #_r7-cod[QSL] que confirma el contacto completan la liturgia del buen operador.

#q("R7.1", "b",
  [Comprobar si alguien está utilizando una frecuencia antes de iniciar una transmisión en ella es:],
  ([una pérdida de tiempo innecesaria], [una práctica de operación adecuada], [obligatorio solo en las bandas de VHF], [necesario únicamente en los concursos]),
  sol: [Escuchar antes de transmitir («#_r7-cod[¿QRL?]») es la primera norma de operación.],
)

#q("R7.2", "d",
  [Interferir deliberadamente las emisiones de otra estación de radioaficionado está permitido:],
  ([cuando la otra estación emite con más potencia], [en las frecuencias de llamada], [si la otra estación es extranjera], [nunca]),
  sol: [La interferencia deliberada está prohibida siempre; además es infracción sancionable.],
)

#q("R7.3", "a",
  [En relación con el contenido de las transmisiones entre estaciones de aficionado, es correcto afirmar que:],
  ([deben efectuarse en lenguaje claro, sin codificarse para ocultar su significado], [pueden cifrarse si ambos corresponsales lo acuerdan], [deben realizarse exclusivamente en inglés], [pueden codificarse en horario nocturno]),
  sol: [Lenguaje claro: no pueden codificarse las transmisiones para ocultar su significado (los códigos públicos Q, RST, etc. sí están permitidos).],
)

#q("R7.4", "c",
  [Las emisiones de radioaficionado se limitarán a:],
  ([boletines de noticias generales], [mensajes comerciales de terceros], [temas relacionados con el servicio de aficionados y observaciones de carácter personal], [cualquier contenido sin restricción]),
  sol: [El contenido se limita a temas del servicio de aficionados y observaciones personales.],
)

#q("R7.5", "a",
  [De las siguientes acciones, está permitida en el tráfico entre estaciones de aficionado:],
  ([transmitir mensajes de naturaleza técnica sobre ensayos], [transmitir propaganda electoral], [emitir anuncios de productos con fines lucrativos], [emitir con el distintivo de otro radioaficionado sin su permiso]),
  sol: [Mensajes técnicos sobre ensayos: sí, es el contenido propio del servicio (art. 2.1 de la Orden: instrucción individual, intercomunicación y estudios técnicos, sin fines de lucro). La propaganda electoral es ajena a ese fin (la Orden no la menciona por su nombre); la publicidad con fines lucrativos es causa de revocación (art. 8.1.b); y usar el distintivo de otro sin su permiso incumple el régimen de identificación (art. 27).],
)

#q("R7.6", "c",
  [Utilizar la palabra «cambio» al finalizar cada transmisión en fonía es:],
  ([obligatorio por el Reglamento de Radiocomunicaciones], [una falta de procedimiento], [recomendable], [exclusivo de las comunicaciones de emergencia]),
  sol: [Decir «cambio» al ceder la palabra es recomendable como buena práctica, no una obligación.],
)

#q("R7.7", "b",
  [Al deletrear las letras de su indicativo, el radioaficionado debe utilizar:],
  ([cualquier palabra que empiece por esa letra], [el alfabeto fonético internacional (OACI)], [nombres de ciudades españolas], [el alfabeto Morse hablado]),
  sol: [Para deletrear se usa el alfabeto fonético internacional (OACI); inventar palabras dificulta la comprensión.],
)

#q("R7.8", "d",
  [La transmisión del distintivo de llamada propio se efectuará:],
  ([solo al solicitar la autorización], [una vez al día como máximo], [solo cuando otro operador lo requiera], [al comienzo y al final de cada emisión y, en emisiones largas, a intervalos cortos]),
  sol: [El distintivo se transmite al comienzo y al final de cada emisión y a intervalos cortos si es larga (art. 25 del Reglamento de Radiocomunicaciones); la Orden concreta el intervalo: al menos cada diez minutos (art. 29).],
)

#q("R7.9", "c",
  [La transmisión de mensajes de cualquier naturaleza con destino a terceros ajenos al servicio de aficionados:],
  ([está siempre permitida], [está permitida previo pago de una tasa], [no está permitida con carácter general], [está permitida solo en fin de semana]),
  sol: [Con carácter general no se permite cursar tráfico con destino a terceros ajenos al servicio; la excepción son las emergencias y catástrofes.],
)

#q("R7.10", "b",
  [De acuerdo con el Reglamento de Radiocomunicaciones, el servicio de aficionados se define como un servicio de:],
  ([radiodifusión de programas de contenido cultural], [instrucción individual, intercomunicación y estudios técnicos], [comunicaciones comerciales de ámbito local], [enlace entre servicios de emergencia]),
  sol: [Es la definición del Reglamento de Radiocomunicaciones de la UIT (número 1.56): un servicio de _instrucción individual, intercomunicación y estudios técnicos_ efectuado por aficionados debidamente autorizados, sin fines de lucro. Todo lo demás del temario se deduce de ahí.],
)

#q("R7.11", "c",
  [Las transmisiones entre estaciones de aficionado deben limitarse a:],
  ([cualquier asunto, siempre que no se emplee lenguaje ofensivo], [mensajes de terceros de carácter comercial], [comunicaciones relacionadas con el servicio de aficionados y observaciones de carácter personal], [retransmisiones de emisoras de radiodifusión]),
  sol: [El servicio no es un medio de comunicación general: las transmisiones se ciñen a asuntos propios de la radioafición, con las observaciones de carácter personal que la cortesía admite. Lo que queda fuera es el tráfico comercial y el de terceros con contenido ajeno al servicio.],
)

#q("R7.12", "a",
  [Las comunicaciones entre estaciones de aficionado deben efectuarse:],
  ([en lenguaje claro, sin códigos que oculten su contenido], [en cualquier clave acordada entre las estaciones], [exclusivamente en castellano], [mediante códigos cifrados si se trata de concursos]),
  sol: [El lenguaje claro es una exigencia reglamentaria: no se pueden emplear códigos que oculten el sentido de la comunicación. El código Q y las abreviaturas no lo contradicen, porque son públicos y su significado está normalizado — abrevian, no cifran.],
)

#q("R7.13", "c",
  [Al deletrear un mensaje, el radioaficionado debe tener en cuenta que:],
  ([conviene inventar palabras propias, más fáciles de recordar], [puede emplear indistintamente cualquier alfabeto nacional], [no es aconsejable inventar palabras: debe emplearse el alfabeto internacional], [basta con repetir la letra dos veces]),
  sol: [El alfabeto internacional existe justamente porque sus palabras se eligieron para no confundirse entre sí en malas condiciones. Inventar palabras propias rompe ese trabajo y obliga al corresponsal a adivinar, sobre todo si no comparte idioma.],
)

#q("R7.14", "b",
  [La prueba de capacitación de radioaficionado tiene por objeto:],
  ([acreditar la propiedad de los equipos de la estación], [evaluar la capacidad del aspirante para operar estaciones del servicio de aficionados], [comprobar la aptitud física del aspirante], [validar la instalación de antenas del domicilio]),
  sol: [La prueba acredita conocimientos técnicos y reglamentarios suficientes para operar sin causar perjuicio a otros servicios. No tiene nada que ver con la propiedad de los equipos ni con la instalación concreta, que son trámites distintos.],
)

#q("R7.15", "b",
  [El antiguo diploma de operador de estaciones de aficionado se corresponde actualmente con:],
  ([la licencia de estación], [el certificado de examen armonizado de radioaficionado (HAREC)], [el distintivo de llamada], [el seguro de responsabilidad civil de las antenas]),
  sol: [Aquel diploma, de la etapa anterior a la Orden IET/1311/2013, fue sustituido por el actual certificado HAREC, armonizado con la Recomendación T/R 61-02 de la CEPT. Acredita lo mismo: la capacidad del titular para operar estaciones del servicio de aficionados. Conviene reconocer la denominación antigua porque aún aparece en material de estudio.],
)

#q("R7.16", "b",
  [La licencia CEPT permite a su titular:],
  ([emitir sin límite de potencia en cualquier país], [operar en los países que la reconocen, con arreglo a la normativa de cada uno], [obtener automáticamente un distintivo especial], [quedar exento de la normativa del país visitado]),
  sol: [La licencia CEPT evita tener que pedir autorización país por país, pero no es una patente de corso: en cada país se opera con arreglo a su normativa —bandas, potencias y forma de identificarse—, no con la del país de origen.],
)

#q("R7.17", "b",
  [Al instalar una antena de estación de aficionado debe tenerse en cuenta que:],
  ([la responsabilidad por daños a terceros corresponde al fabricante], [debe garantizarse el derecho de terceros a no sufrir daños en su propiedad], [basta con avisar verbalmente a los vecinos], [no existe obligación alguna si la instalación está autorizada]),
  sol: [La instalación no puede crear un riesgo para los demás. De ahí la exigencia de seguro de responsabilidad civil para las antenas exteriores y el cuidado en anclajes, soportes y distancias, que es también materia del tema T10.],
)

#q("R7.18", "c",
  [Si el titular de una autorización especial de emisión comprueba que está produciendo interferencias a otros sistemas, debe:],
  ([continuar hasta agotar el plazo de la autorización], [reducir la potencia a la mitad y seguir emitiendo], [suspender de inmediato las transmisiones], [comunicarlo al finalizar el periodo autorizado]),
  sol: [Las autorizaciones especiales no dan prioridad sobre otros servicios: si se comprueba que se interfiere, se suspende de inmediato y no se reanuda hasta corregir la causa. Es el mismo principio que rige toda la reglamentación de interferencias.],
)
