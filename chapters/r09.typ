#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R9", "Inspección y régimen sancionador", alcance: [Órganos competentes en materia de inspección de equipos y estaciones del servicio de aficionados · infracciones y régimen sancionador en materia de radioaficionados.])

La potestad de inspección y sanción corresponde al Estado: el Ministerio competente en telecomunicaciones, a través de su inspección y de las Jefaturas Provinciales de Inspección de Telecomunicaciones. Las infracciones se tipifican en la Ley General de Telecomunicaciones vigente (Ley 11/2022) en tres grados, y del grado dependen la multa y los plazos de prescripción. El banco de preguntas se concentra en unas pocas conductas y en dos cifras:

#block(breakable: false, {
  set par(justify: false)
  table(
  columns: (auto, 1fr, auto),
  align: left + top,
  stroke: (x, y) => (
    top: if y == 0 { 0.8pt + col.tinta } else if y == 1 { 0.5pt + col.tinta } else { 0.3pt + col.gris.lighten(55%) },
    bottom: if y == 3 { 0.8pt + col.tinta },
  ),
  inset: (x: 6pt, y: 4.5pt),
  [Grado], [Conducta típica del examen], [Multa hasta],
  [Muy grave], [interceptar telecomunicaciones ajenas al público (art. 106.15); no atender el requerimiento de cese de emisiones por interferencias (art. 106.8)], [20 millones €],
  [Grave], [la mera producción de interferencias a servicios autorizados (art. 107.6); obstruir la inspección (art. 107.36)], [2 millones €],
  [Leve], [comunicarse utilizando estaciones no autorizadas (art. 108.2); no facilitar datos (art. 108.12)], [100.000 €],
)})

#nota[Un matiz sobre las «identificaciones falsas o engañosas». Los enunciados antiguos del banco la dan como infracción _grave_: así la tipificaba la Ley 9/2014 (art. 77.5) y antes la Ley 32/2003 (art. 54.d). La vigente Ley 11/2022 (arts. 106–108) ya no la recoge con esas palabras: hoy la conducta encajaría, como mucho, en la infracción leve de incumplir las condiciones de la autorización (art. 108.5), y sigue prohibida por el Reglamento de Radiocomunicaciones y por la Constitución de la UIT (art. 47). Por eso las preguntas de este cuaderno usan conductas graves que la ley vigente sí contempla (la mera producción de interferencias, art. 107.6, o la obstrucción a la inspección, art. 107.36). Si en el examen aparece la identificación falsa con la opción «grave», es la que dan por buena.]

Las infracciones prescriben a los tres años (muy graves), dos años (graves) y un año (leves) (art. 113).

#q("R9.1", "b",
  [La Ley General de Telecomunicaciones tipifica como infracción MUY GRAVE:],
  ([retrasar la aportación de datos requeridos por la Administración], [la interceptación, sin autorización, de telecomunicaciones no destinadas al público en general], [comunicarse con estaciones no autorizadas], [emitir sin decir «cambio»]),
  sol: [Interceptar sin autorización telecomunicaciones no destinadas al público: infracción muy grave (protege el secreto de las comunicaciones).],
)

#q("R9.2", "a",
  [La Ley General de Telecomunicaciones tipifica como infracción GRAVE:],
  ([la mera producción de interferencias a redes o servicios autorizados], [el uso del alfabeto fonético español antiguo], [no ser socio de una asociación de radioaficionados], [operar en fin de semana sin licencia de estación]),
  sol: [La mera producción de interferencias a redes o servicios autorizados es infracción grave (art. 107.6 de la Ley 11/2022); si la interferencia es deliberada, pasa a muy grave (art. 106.7). Ojo: los bancos de preguntas antiguos dan como grave la «emisión de señales de identificación falsas o engañosas» (art. 77.5 de la Ley 9/2014 y, antes, art. 54.d de la Ley 32/2003); la Ley 11/2022 no la tipifica con esas palabras. Si en el examen aparece con la opción «grave», es la que dan por buena. La identificación falsa sigue prohibida por el Reglamento de Radiocomunicaciones y por la Constitución de la UIT (art. 47).],
)

#q("R9.3", "c",
  [También constituye infracción GRAVE según la Ley General de Telecomunicaciones:],
  ([cambiar de frecuencia sin anunciarlo], [usar potencia inferior a la autorizada], [la negativa o la obstrucción a ser inspeccionado y la no colaboración con la inspección], [transmitir observaciones de carácter personal]),
  sol: [Negarse u obstruir la inspección, o no colaborar con ella: también grave.],
)

#q("R9.4", "d",
  [La Ley General de Telecomunicaciones tipifica como infracción LEVE:],
  ([la interceptación de comunicaciones de terceros], [la mera producción de interferencias a redes o servicios autorizados], [la obstrucción a la labor inspectora], [el establecimiento de comunicaciones utilizando estaciones no autorizadas]),
  sol: [Establecer comunicaciones utilizando estaciones no autorizadas es infracción leve (art. 108.2 de la Ley 11/2022), salvo que deba considerarse grave. La interceptación es muy grave (art. 106.15); la mera producción de interferencias (art. 107.6) y la obstrucción a la inspección (art. 107.36) son graves. Ojo: el banco antiguo decía «con estaciones no autorizadas» (redacción de la Ley 32/2003, donde era grave, art. 54.g) y la versión previa de esta pregunta ofrecía como distractor el «uso de identificaciones falsas», que entonces (Ley 9/2014, art. 77.5) era grave y que la Ley 11/2022 ya no tipifica con esas palabras. La clave del banco no cambia.],
)

#q("R9.5", "a",
  [Las multas previstas por la Ley General de Telecomunicaciones pueden llegar, para las infracciones muy graves y graves respectivamente, hasta:],
  ([20 millones y 2 millones de euros], [1 millón y 100 000 euros], [500 000 y 50 000 euros], [100 millones y 10 millones de euros]),
  sol: [Topes de multa: hasta 20 millones de euros las muy graves y hasta 2 millones las graves.],
)

#q("R9.6", "c",
  [La sanción impuesta por una infracción grave prescribe a los:],
  ([seis meses], [cinco años], [dos años], [diez años]),
  sol: [La sanción grave prescribe a los dos años (muy graves: tres años; leves: un año).],
)

#q("R9.7", "b",
  [La tipificación de las infracciones en que puede incurrir un radioaficionado se establece en:],
  ([el reglamento interno de la URE], [la Ley General de Telecomunicaciones vigente], [los planes de banda de la IARU], [la Recomendación T/R 61-01]),
  sol: [Las infracciones se tipifican en la Ley General de Telecomunicaciones vigente (hoy, Ley 11/2022).],
)

#q("R9.8", "d",
  [La inspección de los equipos y estaciones del servicio de aficionados corresponde a:],
  ([las asociaciones de radioaficionados legalmente reconocidas], [los ayuntamientos], [las comunidades de propietarios], [el Ministerio competente en telecomunicaciones, a través de la inspección de telecomunicaciones y sus Jefaturas Provinciales]),
  sol: [La inspección corresponde al Ministerio competente en telecomunicaciones, con las Jefaturas Provinciales como brazo territorial.],
)

#q("R9.9", "a",
  [No facilitar los datos requeridos por la Administración, o retrasar injustificadamente su aportación cuando resulte exigible, constituye una infracción:],
  ([leve], [grave], [muy grave], [no constituye infracción]),
  sol: [No facilitar los datos requeridos, o retrasar su aportación injustificadamente, es infracción leve (art. 108.12 de la Ley 11/2022). Pasa a grave si se exceden los plazos: una vez transcurrido un mes desde el fin del plazo del requerimiento o finalizado el del segundo requerimiento (art. 107.34).],
)

#q("R9.10", "c",
  [Las infracciones muy graves en materia de telecomunicaciones prescriben a los:],
  ([seis meses], [dos años], [tres años], [diez años]),
  sol: [Los tres plazos van escalonados con la gravedad: tres años las muy graves, dos las graves y uno las leves. Es una de las pocas cifras del tema que conviene memorizar en bloque.],
)

#q("R9.11", "a",
  [Las infracciones leves en materia de telecomunicaciones prescriben:],
  ([al año], [a los dos años], [a los tres años], [no prescriben nunca]),
  sol: [El plazo más corto de los tres, coherente con su menor gravedad. Ninguna infracción administrativa es imprescriptible.],
)

#q("R9.12", "d",
  [Las infracciones graves en materia de telecomunicaciones prescriben a los:],
  ([seis meses], [cinco años], [diez años], [dos años]),
  sol: [Dos años, el escalón intermedio entre el año de las leves y los tres de las muy graves.],
)

#q("R9.13", "b",
  [Los órganos que materialmente realizan la inspección de las estaciones de aficionado en cada provincia son:],
  ([las delegaciones provinciales de las asociaciones de radioaficionados], [las Jefaturas Provinciales de Inspección de Telecomunicaciones], [las jefaturas provinciales de tráfico], [los servicios técnicos municipales]),
  sol: [Son las mismas Jefaturas en las que se realiza el examen. Las asociaciones de radioaficionados no tienen ninguna potestad inspectora: son entidades privadas.],
)

#q("R9.14", "c",
  [Ante una actuación de la inspección de telecomunicaciones, el titular de una estación de aficionado está obligado a:],
  ([exigir una orden judicial en todos los casos], [negar el acceso si la estación está en un domicilio particular], [permitir el acceso del personal inspector y facilitar la comprobación de la estación], [desmontar previamente los equipos objeto de inspección]),
  sol: [La negativa o la obstrucción a la inspección constituye por sí misma infracción grave. La autorización de radioaficionado lleva aparejada la sujeción a esa comprobación.],
)

#q("R9.15", "a",
  [Emitir utilizando un distintivo de llamada que no corresponde al titular de la estación:],
  ([incumple el régimen de identificación (el distintivo identifica a su titular, art. 27 de la Orden) y es sancionable], [no constituye infracción si se identifica al final], [es una infracción muy grave, equiparable a la interceptación de comunicaciones], [es una falta administrativa sin sanción económica]),
  sol: [El distintivo identifica a su titular (art. 27 de la Orden) y cada emisión debe identificarse con el propio (art. 29.1): emitir con el de otro es falsear la identificación, lo que prohíben el Reglamento de Radiocomunicaciones y la Constitución de la UIT (art. 47), y es sancionable. Sobre el grado: los bancos de preguntas antiguos la dan como infracción grave («emisión de señales de identificación falsas o engañosas», art. 77.5 de la Ley 9/2014); la Ley 11/2022 no la tipifica con esas palabras y hoy encajaría como leve, por incumplir las condiciones de la autorización (art. 108.5). Si en el examen aparece con la opción «grave», es la que dan por buena.],
)

#q("R9.16", "d",
  [La potestad sancionadora en materia de radiocomunicaciones corresponde a:],
  ([la comunidad autónoma donde radique la estación], [el ayuntamiento del municipio], [la asociación de radioaficionados a la que pertenezca el titular], [la Administración General del Estado]),
  sol: [El dominio público radioeléctrico es competencia estatal, y con él la inspección y la sanción. Ni comunidades autónomas ni ayuntamientos tienen nada que decir sobre las emisiones.],
)

#q("R9.17", "b",
  [Con independencia de la multa que corresponda, la Administración puede acordar, como medida sobre los equipos:],
  ([su venta en subasta pública], [su precintado o incautación], [su cesión obligatoria a otro radioaficionado], [su traslado a un centro de investigación]),
  sol: [Es una sanción accesoria (art. 109.2.c de la Ley 11/2022), independiente de la multa, dirigida a que cese de inmediato la conducta infractora: se sella o se retira el equipo para que no pueda seguir emitiendo.],
)

#q("R9.18", "c",
  [La interceptación sin autorización de telecomunicaciones no destinadas al público en general, junto con la divulgación de su contenido, constituye una infracción:],
  ([leve], [grave], [muy grave], [exenta de responsabilidad si no hay ánimo de lucro]),
  sol: [Es la infracción muy grave por excelencia en este ámbito, porque afecta al secreto de las comunicaciones, que es un derecho fundamental. La ausencia de ánimo de lucro no la excusa.],
)

#q("R9.19", "a",
  [El expediente sancionador en materia de telecomunicaciones se tramita con arreglo a:],
  ([la Ley General de Telecomunicaciones y la legislación de procedimiento administrativo común], [las recomendaciones de la CEPT], [los planes de banda de la IARU], [los estatutos de la asociación de radioaficionados]),
  sol: [La Ley sectorial tipifica y gradúa; el procedimiento administrativo común aporta las garantías — audiencia, prueba, plazos— comunes a cualquier expediente. Recomendaciones de la CEPT y planes de la IARU no son normas sancionadoras.],
)

#q("R9.20", "d",
  [Si la inspección comprueba que una estación de aficionado causa interferencias perjudiciales a otros servicios, puede:],
  ([obligar al titular a cambiar de domicilio], [retirar el distintivo de llamada con carácter definitivo y automático], [imponer únicamente una advertencia verbal sin más consecuencias], [ordenar el cese de las emisiones hasta que se corrija la causa]),
  sol: [La prioridad es que la interferencia se acabe, y para eso basta con detener las emisiones mientras se corrige el problema. La retirada definitiva del distintivo sería una consecuencia del expediente sancionador, no una medida automática.],
)

#q("R9.21", "b",
  [Si el titular de una estación de aficionado tiene constancia de que está causando interferencias, deberá:],
  ([esperar a que la Administración le requiera formalmente], [adoptar a su costa todas las medidas técnicas razonables para evitarlas], [trasladar el problema a su asociación], [continuar emitiendo mientras no haya denuncia]),
  sol: [La obligación nace en cuanto se tiene constancia, sin esperar requerimiento, y el coste corre por cuenta del titular: es él quien explota la estación. El art. 32 de la Orden fija el protocolo: si la SETSI comprueba la interferencia perjudicial, el titular debe cesar las emisiones y adoptar a su costa medidas técnicas razonables, siguiendo sus instrucciones; después lo comunica y puede reiniciar las emisiones sin más trámite, y si la interferencia persiste la SETSI puede imponer restricciones de bandas, potencia u horario.],
)

#q("R9.22", "d",
  [No atender el requerimiento de la autoridad competente para el cese de las emisiones constituye una infracción:],
  ([leve], [grave], [exenta de sanción si se subsana después], [muy grave]),
  sol: [Muy grave: así la tipifica el art. 106.8 de la Ley 11/2022. Desatender un requerimiento formal de cese agrava mucho el asunto: ya no se trata solo de la interferencia, sino de desobedecer a la autoridad que vela por el dominio público radioeléctrico. En bancos antiguos (con la ley de 2003) la respuesta era «grave» (art. 54.f de la Ley 32/2003); ya era muy grave en la Ley 9/2014 (art. 76.7) y la Ley 11/2022 lo mantiene.],
)

#q("R9.23", "a",
  [Interferir deliberadamente las emisiones de otra estación de aficionado:],
  ([no está permitido en ningún caso], [se admite en los concursos], [se admite si la otra estación ocupaba la frecuencia], [se admite si se avisa previamente]),
  sol: [La interferencia deliberada es de las conductas peor consideradas, en lo reglamentario y en lo ético. Ni la competición ni el hecho de que otro «ocupara» la frecuencia la justifican: la respuesta correcta siempre es cambiar de frecuencia.],
)

#q("R9.24", "c",
  [De las siguientes, _no_ es causa de revocación de una autorización de radioaficionado:],
  ([realizar emisiones con fines comerciales, publicitarios o lucrativos], [causar interferencias y no corregirlas], [no disponer de una estación radioeléctrica], [obstruir reiteradamente la labor inspectora]),
  sol: [Ser titular de la autorización no obliga a tener equipos: puede haberse aprobado el examen y no haber montado aún la estación, u operar en estaciones ajenas con permiso de sus titulares. Las otras tres sí comprometen la autorización. Las emisiones con fines comerciales, publicitarios o lucrativos son causa expresa de revocación (art. 8.1.b de la Orden IET/1311/2013), que remite además a las causas del reglamento de dominio público radioeléctrico: hoy el incumplimiento de las condiciones y requisitos técnicos o administrativos de uso y el empleo de las frecuencias para fines distintos de los autorizados (RD 123/2017, art. 95.1; Ley 11/2022, art. 95.3).],
)

#q("R9.25", "b",
  [La emisión de una portadora sin modular por una estación de aficionado:],
  ([está prohibida en cualquier circunstancia], [se admite a efectos de ensayo y durante un tiempo breve], [puede mantenerse indefinidamente si se identifica], [solo se admite en las bandas de VHF]),
  sol: [Una portadora sin modular no transmite información y ocupa frecuencia, así que solo se admite lo justo para ajustar la antena o el acoplador — y siempre identificándose. Hoy no hay una prohibición expresa (era de la Orden de 1986, derogada): se deduce del anexo I, 4.2 y 4.3, de la Orden, que limita la potencia y la duración de las emisiones a lo estrictamente necesario y exige carga artificial en los ensayos sin radiación. Mantenerla es, de hecho, interferir.],
)

#q("R9.26", "d",
  [Transmitir música a través de una estación de aficionado:],
  ([se admite si es de dominio público], [se admite fuera de las horas punta], [se admite si dura menos de un minuto], [está prohibido, porque el de aficionados no es un servicio de radiodifusión]),
  sol: [El servicio de aficionados es de instrucción individual, intercomunicación y estudios técnicos (art. 2.1 de la Orden), no de difusión de contenidos a una audiencia. Emitir música lo convertiría en radiodifusión, que es otro servicio con otras autorizaciones.],
)

#q("R9.27", "a",
  [Emplear bandas de frecuencia distintas de las autorizadas al servicio de aficionados constituye:],
  ([una infracción], [una práctica admitida si la banda está libre], [una conducta permitida con baja potencia], [una falta solo si se causa interferencia]),
  sol: [Las bandas atribuidas al servicio son el límite de la autorización: fuera de ellas hay otros servicios, muchos de seguridad, y emitir ahí es infracción con independencia de la potencia o de que la banda «parezca» libre.],
)

#q("R9.28", "d",
  [Carecer de un libro diario o registro de las comunicaciones efectuadas constituye:],
  ([una infracción muy grave], [una infracción grave], [una infracción leve], [no constituye infracción, al no existir tal obligación]),
  sol: [Es una pregunta trampa clásica: la reglamentación española no impone al radioaficionado llevar libro de guardia ni registro de contactos. Anotarlos es costumbre útil —y necesaria para diplomas y concursos—, pero voluntaria.],
)

#q("R9.29", "b",
  [La reiteración en la comisión de infracciones leves:],
  ([carece de consecuencias], [puede dar lugar a que se califiquen como graves], [obliga a repetir el examen], [extingue la responsabilidad anterior]),
  sol: [La reiteración es una circunstancia que agrava: repetir conductas leves deja de ser un descuido y pasa a revelar un incumplimiento sostenido. La Ley 11/2022 la trata como infracción grave (art. 107.44): hay reiteración cuando se han impuesto sanciones firmes por dos o más infracciones del mismo tipo en un período de tres años (art. 109.6).],
)

#q("R9.30", "d",
  [Las modificaciones introducidas en una instalación de estación de aficionado deben comunicarse a la Jefatura Provincial de Inspección de Telecomunicaciones:],
  ([en todos los casos, incluidas las provisionales], [únicamente si aumentan la potencia], [nunca, por tratarse de una instalación privada], [siempre que dichas modificaciones sean permanentes]),
  sol: [Lo que interesa a la Administración es que el expediente refleje la instalación real y estable. Art. 20 de la Orden: las modificaciones con carácter experimental pueden hacerse hasta 60 días sin trámite; las permanentes se remiten a la SETSI (las solicitudes pueden presentarse a través de la Jefatura Provincial, art. 19.a), y un cambio de ubicación de la antena se solicita como una primera instalación. La salida de fin de semana es otro caso: las estaciones portables se notifican a la Jefatura con cinco días de antelación, salvo usos no continuados de hasta 15 días (art. 17.1).],
)

#q("R9.31", "a",
  [El personal de la inspección de telecomunicaciones, en el ejercicio de sus funciones, tiene la consideración de:],
  ([autoridad pública], [perito designado por las partes], [representante de la asociación de radioaficionados], [técnico contratado por el titular]),
  sol: [La Ley 11/2022 les da la consideración de autoridad pública: es lo que da fuerza a sus actas y lo que convierte en infracción la negativa u obstrucción a su labor. No actúa como perito de parte ni en representación de nadie: ejerce una potestad pública.],
)

#q("R9.32", "c",
  [La autorización de radioaficionado se cancelará:],
  ([transcurridos diez años desde su concesión, sin excepción], [solo mediante resolución sancionadora], [en cualquier momento, a petición de su titular], [únicamente por fallecimiento del titular]),
  sol: [La autorización se mantiene mientras su titular quiera y cumpla; y como es un derecho y no una carga, puede renunciar a ella cuando lo desee. La revocación por incumplimiento es un supuesto distinto.],
)
