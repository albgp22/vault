#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R5", "Distintivos de llamada", alcance: [Identificación de las estaciones radioeléctricas de aficionado · uso de los distintivos de llamada · composición de los distintivos (prefijo, distrito y sufijo) · prefijos nacionales.])

El distintivo se compone de _prefijo_ + _distrito_ + _sufijo_: en `EA5RCA`, `EA` es el prefijo, el `5` indica el distrito y `RCA` es el sufijo. Los prefijos atribuidos a España son `EA`–`EH` — a los que se añade la serie `AM`–`AO`, empleada en usos especiales —; los habituales para radioaficionados son `EA`, `EB` y `EC`, y las estaciones automáticas desatendidas usan `ED`.

#figure(
  {
    set text(size: 10pt)
    table(
      columns: (auto, auto),
      align: (center + horizon, left + horizon),
      fill: (x, y) => if y == 0 { col.gris-claro } else if x == 0 { col.acento-claro.lighten(55%) } else { none },
      inset: (x: 9pt, y: 4.5pt),
      [Distrito], [Zona geográfica],
      [0], [reservado a actos inaugurados o visitados por S. M. el Rey],
      [1], [Galicia, Asturias, Cantabria, Castilla y León y La Rioja],
      [2], [País Vasco, Navarra y Aragón],
      [3], [Cataluña],
      [4], [Madrid, Castilla-La Mancha (parte) y Extremadura],
      [5], [Comunidad Valenciana, Murcia y Albacete],
      [6], [Islas Baleares],
      [7], [Andalucía],
      [8], [Islas Canarias],
      [9], [Ceuta y Melilla],
    )
  },
  kind: table,
  supplement: [Cuadro],
  caption: [Distritos de los distintivos de llamada españoles.],
) <r5-cuadro-distritos>

#truco[Los insulares y las ciudades autónomas son los que más caen: *EA6* Baleares, *EA8* Canarias, *EA9* Ceuta y Melilla. Para los sufijos de las estaciones desatendidas: *Y* de analógica y *Z* de digital (`ED1YBD` repetidor analógico, `ED5ZAA` repetidor digital).]

#q("R5.1", "b",
  [El distintivo de llamada de una estación de radioaficionado está constituido, secuencialmente, por:],
  ([sufijo, distrito y prefijo], [prefijo, distrito y sufijo], [distrito, prefijo y sufijo], [prefijo, sufijo y distrito]),
  sol: [Prefijo + distrito + sufijo: `EA5RCA` = EA + 5 + RCA.],
)

#q("R5.2", "c",
  [Las series de prefijos internacionales atribuidas a España según el Reglamento de Radiocomunicaciones incluyen:],
  ([FM, FN y FA], [KN, KK y KL], [EA, EB y EC], [EPA, EQZ y EAA]),
  sol: [El Reglamento de Radiocomunicaciones atribuye a España las series EA–EH; las habituales son EA, EB y EC.],
)

#q("R5.3", "a",
  [El distrito de llamada «EA6» corresponde a:],
  ([las Islas Baleares], [las Islas Canarias], [Andalucía], [Cataluña]),
  sol: [EA6 = Baleares (tabla #ref(<r5-cuadro-distritos>, supplement: none)).],
)

#q("R5.4", "d",
  [El distrito de llamada «EA9» corresponde a:],
  ([las Islas Baleares], [las Islas Canarias], [Galicia], [Ceuta y Melilla]),
  sol: [EA9 = Ceuta y Melilla; Canarias es EA8.],
)

#q("R5.5", "b",
  [Si escuchamos una llamada con el distintivo `EA7RCA`, la estación emite desde:],
  ([Madrid], [Andalucía], [el País Vasco], [Canarias]),
  sol: [La cifra del distintivo es el distrito, y el 7 corresponde a Andalucía (véase la tabla #ref(<r5-cuadro-distritos>, supplement: none)). Madrid es el 4, el País Vasco el 2 y Canarias el 8.],
)

#q("R5.6", "a",
  [El distrito 0 de un distintivo de llamada se autoriza exclusivamente:],
  ([con motivo de actos inaugurados o visitados por S. M. el Rey], [para estaciones militares], [para concursos internacionales], [para estaciones marítimas]),
  sol: [El distrito 0 se reserva para actos inaugurados o visitados por S. M. el Rey.],
)

#q("R5.7", "c",
  [El número total de distritos en que se dividen los indicativos de llamada españoles es:],
  ([siete], [ocho], [nueve], [diez]),
  sol: [Nueve distritos (1 a 9); el 0 es un caso especial reservado.],
)

#q("R5.8", "b",
  [Las estaciones automáticas desatendidas (por ejemplo, los repetidores) utilizan el prefijo:],
  ([EC], [ED], [EE], [EH]),
  sol: [Las desatendidas (repetidores, balizas, nodos) usan el prefijo ED.],
)

#q("R5.9", "d",
  [En los distintivos de las estaciones automáticas desatendidas, los sufijos de tres letras que comienzan por Y o por Z se reservan, respectivamente, para estaciones:],
  ([marítimas y aeronáuticas], [colectivas y personales], [experimentales y de concurso], [analógicas y digitales]),
  sol: [Inicial Y = analógica, Z = digital: `ED1YBD` repetidor analógico, `ED5ZAA` digital.],
)

#q("R5.10", "a",
  [Una estación de aficionado móvil marítima identificará su emisión añadiendo a su distintivo:],
  ([/MM], [/P], [/AM], [/`QRP`]),
  sol: [/MM = móvil marítima; /P portable, /M móvil. El sufijo aeronáutico reglamentario es /MA (art. 29): el «/AM» del enunciado ni siquiera existe en la Orden.],
)

#q("R5.11", "c",
  [Si un radioaficionado se identifica como `EA/M0BVM`, se trata de:],
  ([una estación española emitiendo desde el Reino Unido], [una estación repetidora del distrito 3], [un radioaficionado extranjero que emite desde España], [una estación colectiva de un radio club]),
  sol: [Prefijo del país visitado «EA/» seguido del distintivo propio: un radioaficionado con licencia CEPT operando temporalmente desde España (el prefijo del país anfitrión se antepone al indicativo).],
)

#q("R5.12", "b",
  [El distintivo de llamada estará constituido por un grupo alfanumérico de, como máximo:],
  ([cuatro caracteres], [seis caracteres], [ocho caracteres], [diez caracteres]),
  sol: [Grupo alfanumérico de seis caracteres como máximo.],
)

== Sufijos y usos temporales <r5-sec-sufijos>

El artículo 27 de la Orden IET/1311/2013 regula la composición del distintivo y sus variantes temporales. El _sufijo_ consta de una a tres letras, asignadas por riguroso turno de expedición. Los de tres letras son los ordinarios; los de una y dos letras son escasos y pueden adjudicarse a radioaficionados con al menos cinco años de autorización española que acrediten quince (una letra) o cinco (dos letras) años de práctica en la radioafición internacional y no hayan sido sometidos a expediente sancionador en los últimos cinco años. Los de una letra se reservan, además, para la participación en concursos internacionales de alta competitividad. Desde el 19 de septiembre de 2026 rige un procedimiento ordinario para asignar el sufijo de una letra (Resolución de 29 de julio de 2026 de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales, SETID, hoy la SETSI de la Orden; BOE-A-2026-17504, que deroga la de 12 de julio de 2019): solicitud por medios electrónicos, por distrito y por orden de presentación, con hasta diez distintivos preferentes; la práctica internacional se acredita con tarjetas `QSL` (dos por año durante quince de los últimos veinte) y el nuevo distintivo sustituye al anterior del titular. Dentro de los de tres letras hay reservas (art. 27.3): `UR` para las estaciones colectivas de asociaciones de radioaficionados y `RC` o `RK` para las de radioclubes, respectivamente; e `Y` o `Z` para las desatendidas analógicas y digitales, también respectivamente.

Para los usos temporales — concursos, experimentos, ensayos, conmemoraciones — el prefijo habitual se sustituye por otro que refleja el rango del evento, _previa autorización de la Jefatura Provincial_ (art. 27.1). Solo con `ED`, `EE` y `EF` se mantiene sin variación el resto del distintivo permanente (art. 27.1.a); con `EG`, `EH`, `AM`, `AN` y `AO` el distintivo lleva un sufijo propio de dos o tres letras:

#align(center, {
  set text(size: 9.5pt)
  table(
    columns: (auto, auto),
    align: left + horizon,
    fill: (x, y) => if y == 0 { col.gris-claro } else { none },
    inset: (x: 8pt, y: 4.5pt),
    [Prefijo temporal], [Rango del evento],
    [`ED`, `EE`, `EF`], [concursos, experimentos, ensayos, demostraciones y otros eventos de ámbito local, regional, autonómico o nacional],
    [`EG`, `EH`], [concursos, eventos internacionales y otros eventos relevantes de ámbito local, regional o autonómico],
    [`AM`, `AN`], [eventos relevantes de ámbito nacional],
    [`AO`], [eventos relevantes de ámbito internacional y, con carácter optativo, emisiones de radioaficionados españoles en zonas no adscritas a soberanías nacionales],
  )
})

Cada evento exige una solicitud independiente (período de utilización, distintivo pedido, motivo y tipo de estación), y los períodos autorizados para un mismo sufijo y peticionario no pueden superar, como norma general, los *30 días al año* (art. 28). La excepción son los distintivos de una sola letra empleados exclusivamente en concursos de alta competitividad, que pueden autorizarse al mismo titular por hasta *dos años* desde la fecha de autorización.

#ojo[`ED` tiene doble vida: es prefijo de uso temporal (con `EE` y `EF`) y, a la vez, el prefijo _permanente_ de las estaciones automáticas desatendidas.]

#q("R5.13", "b",
  [El sufijo del distintivo de llamada de una autorización de radioaficionado estará constituido por:],
  ([una combinación libre elegida por el titular], [hasta tres letras, asignadas ordenadas alfabéticamente por turno riguroso de expedición], [cifras y letras alternadas], [las iniciales del titular]),
  sol: [El sufijo son hasta tres letras, asignadas por orden alfabético según turno riguroso de expedición.],
)

#q("R5.14", "d",
  [El prefijo `EG` de un distintivo de llamada se relaciona con:],
  ([las estaciones colectivas de asociaciones], [las radiobalizas de HF], [las estaciones móviles marítimas], [usos temporales de especial relevancia para eventos de carácter regional, autonómico o local]),
  sol: [EG: usos temporales para concursos, eventos internacionales y otros eventos relevantes de ámbito local, regional o autonómico (art. 27.1.b).],
)

#q("R5.15", "a",
  [Los prefijos de uso temporal `ED`, `EE` y `EF`, a diferencia de `EG`, `EH`, `AM`, `AN` y `AO`:],
  ([mantienen sin variación el resto del distintivo asignado con carácter permanente al radioaficionado], [obligan a cambiar también el sufijo], [solo pueden usarse en telegrafía], [se asignan exclusivamente a extranjeros]),
  sol: [Con `ED`, `EE` y `EF` solo cambia el prefijo: cifra y sufijo siguen siendo los del distintivo permanente (art. 27.1.a de la Orden; p. ej. `EA4XYZ` emite como `EE4XYZ`). El art. 27.1 no dice lo mismo de `EG`, `EH`, `AM`, `AN` y `AO`, que se asignan con sufijo propio de dos o tres letras. `ED` tiene doble papel: prefijo permanente de las estaciones automáticas desatendidas y también temporal, junto con EE y EF. Ojo: el enunciado del banco público agrupa «EE, EF y EG» como si los tres mantuvieran el resto del distintivo; el art. 27.1.a solo menciona ED, EE y EF, pero si en el examen aparece así, la opción a es la que dan por buena.],
)

#q("R5.16", "c",
  [Si una estación tiene el indicativo `EF6RCA`, se trata de un distintivo:],
  ([permanente de una estación de Baleares], [de una estación repetidora digital], [concedido para uso temporal por un evento no especialmente significativo], [de una estación militar]),
  sol: [EF = uso temporal por evento no especialmente significativo; los especialmente relevantes usan otros prefijos o el prefijo AO.],
)

#q("R5.17", "b",
  [El prefijo `AO` se otorgará para eventos temporales:],
  ([de ámbito local], [especiales de relevancia internacional], [deportivos exclusivamente], [de duración inferior a un día]),
  sol: [El prefijo AO (serie AM/AN/AO) se reserva a eventos temporales especiales de relevancia internacional.],
)

#q("R5.18", "d",
  [Los distintivos de uso temporal con sufijo de una sola letra están reservados para:],
  ([las estaciones de radioclubs], [los radioaficionados veteranos], [las estaciones desatendidas], [la participación en concursos internacionales de alta competitividad]),
  sol: [Sufijo de una sola letra: concursos internacionales de alta competitividad (art. 27.3). Como distintivo temporal, el límite general es de 30 días al año por sufijo y peticionario; los de una letra usados solo en esos concursos pueden autorizarse hasta por dos años (art. 28).],
)

#q("R5.19", "c",
  [Sobre los distintivos de llamada con sufijo de dos letras, señale la opción _falsa_:],
  ([podrán asignarse a radioaficionados que cumplan determinadas condiciones], [se asignan en función de las disponibilidades existentes], [se reservan únicamente para estaciones colectivas], [una condición para su adjudicación es no haber sido sometido a expediente sancionador en los últimos cinco años]),
  sol: [Los sufijos de dos letras no son exclusivos de estaciones colectivas: puede obtenerlos cualquier radioaficionado que cumpla las condiciones (actividad acreditada y sin expediente sancionador).],
)

#q("R5.20", "a",
  [Los sufijos de tres letras que comienzan por `UR`, `RC` o `RK` están reservados para:],
  ([estaciones colectivas de asociaciones de radioaficionados y radio clubes], [estaciones automáticas desatendidas], [estaciones móviles marítimas], [concursos internacionales]),
  sol: [UR, RC y RK inician los sufijos de las estaciones colectivas: UR, los de asociaciones de radioaficionados, y RC y RK, los de radio clubes, «respectivamente» (art. 27.3). No confundir con las desatendidas, que usan Y/Z.],
)

== Asignación y uso del distintivo <r5-sec-asignacion>

El distintivo se otorga junto con la autorización, con la cifra del distrito de residencia del titular _en el momento del otorgamiento_ (art. 27.2). Es único y no puede modificarse (art. 28), salvo por cambio del número de letras del sufijo o por la asignación de distintivos adicionales: mudarse de distrito solo obliga a comunicar el nuevo domicilio a la SETSI (art. 7.3), no a cambiar de distintivo. Un distintivo ya utilizado solo se reasigna cuando se han agotado todas las combinaciones posibles, con dos excepciones: al anterior titular, si obtiene una nueva autorización tras una revocación, y a sus familiares en primer grado, si la baja se produjo por fallecimiento (salvo que el sufijo sea de una letra). Quedan excluidos de cualquier asignación los grupos de letras que expresan las señales de socorro, urgencia y seguridad — `DDD`, `PAN`, `SOS`, `TTT` y `XXX`, «y otras» — y toda la serie `QAA`–`QZZ`, para que ningún sufijo pueda confundirse con un código Q. En el uso diario, la estación transmite su distintivo al comienzo y al final de cada emisión y, si esta es larga, periódicamente a lo largo de ella.

#ojo[Las preguntas de los bancos antiguos sobre el cambio de domicilio («podrá solicitar mantener su sufijo», «no podrá mantener su distintivo si cambia de distrito») siguen la Orden ITC/1791/2006 y sus Instrucciones de 2006, derogadas: la Orden vigente no obliga a cambiar de distintivo al mudarse. Conviene conocer ambas versiones, porque el examen puede seguir usando la antigua.]

#q("R5.21", "b",
  [Los distintivos de llamada se podrán reasignar:],
  ([a cualquier solicitante, transcurrido un año], [en caso de fallecimiento del titular, a familiares en primer grado], [mediante subasta pública], [únicamente a estaciones colectivas]),
  sol: [En caso de fallecimiento del titular, el distintivo puede reasignarse a familiares en primer grado (salvo que tenga sufijo de una letra). Es una excepción: según el art. 28 (párr. 3.º), los distintivos ya utilizados solo se reasignan una vez agotadas todas las combinaciones posibles; la otra excepción es el anterior titular, si obtiene una nueva autorización tras una revocación. Reasignar a cualquier solicitante transcurrido un año (a), por subasta (c) o solo a las colectivas (d) no figura en la Orden.],
)

#q("R5.22", "c",
  [Un radioaficionado con distintivo del distrito 5 se traslada a vivir a una provincia del distrito 4. Conforme a la Orden IET/1311/2013:],
  ([debe sustituir la cifra de su distintivo por la 4], [pierde su distintivo y tiene que solicitar otro nuevo], [conserva su distintivo, que es único y no puede modificarse, y solo debe comunicar a la SETSI su nuevo domicilio], [debe renunciar a su autorización y pedir otra en el nuevo distrito]),
  sol: [Desde la Orden IET/1311/2013 el distintivo asociado a la autorización «será único y no podrá ser modificado» (art. 28); su cifra es la del distrito de residencia «en el momento del otorgamiento» (art. 27.2), y mudarse solo obliga a comunicar el nuevo domicilio a la SETSI (art. 7.3). Si se emite en móvil o portable desde otro distrito, puede añadirse opcionalmente el número de ese distrito (art. 29.2). Los bancos de preguntas antiguos dan como correcta la regla de la Orden ITC/1791/2006 y de sus Instrucciones de 2006 (derogadas): «no podrá mantener su distintivo si su nueva provincia de residencia pertenece a un distrito distinto». Si en el examen aparece con esa formulación, esa es la opción que dan por buena.],
)

#q("R5.23", "a",
  [El distintivo de llamada `AM8SOS`:],
  ([no se puede asignar], [corresponde a una estación de socorro de Canarias], [es un distintivo temporal de concurso], [corresponde a una radiobaliza]),
  sol: [`AM8SOS` no es asignable: «SOS» está reservado como señal de socorro y no puede formar parte de un sufijo.],
)

#q("R5.24", "c",
  [La cifra de distrito que compone el distintivo de llamada de un radioaficionado es:],
  ([un número elegido libremente por el titular], [la cifra que estuviera disponible al expedir la autorización], [la coincidente con el distrito de residencia del titular], [la del lugar donde se realizó el examen]),
  sol: [La cifra de distrito es la del distrito de residencia del titular _en el momento del otorgamiento_ de la autorización (art. 27.2), según la división geográfica reglamentaria.],
)

#q("R5.25", "b",
  [En relación con los distintivos de llamada, la localidad valenciana de Utiel se identifica con la cifra de distrito:],
  ([4], [5], [6], [7]),
  sol: [Utiel (Valencia) pertenece al distrito 5 (Comunidad Valenciana, Murcia y Albacete).],
)

#q("R5.26", "a",
  [De las siguientes, pertenecen al distrito 1:],
  ([Asturias, Ávila y León], [Soria, Sevilla y Santa Cruz de Tenerife], [Salamanca, Castellón y Cádiz], [Valencia, Valladolid y Vizcaya]),
  sol: [Asturias, Ávila y León están las tres en el distrito 1; las demás opciones mezclan distritos.],
)

#q("R5.27", "d",
  [Si un radioaficionado utiliza, con autorización del titular, una estación que no es suya, se identificará con:],
  ([el distintivo del titular únicamente], [su propio indicativo únicamente], [un distintivo temporal solicitado al efecto], [su propio indicativo precedido del distintivo del titular]),
  sol: [Al usar una estación ajena con permiso, la identificación es el propio indicativo precedido del distintivo del titular (clave del banco de examen). Ojo: esa regla procede de la Orden ITC/1791/2006 (arts. 36.4 y 37.5), derogada; la Orden IET/1311/2013 no regula que un radioaficionado opere la estación de otro, así que no hay precepto vigente que la sostenga (solo dice, en su art. 27, que el distintivo identifica a su titular). Se mantiene como clave porque es la que el banco da por buena; véanse R8.49 y R8.70, que avisan del mismo doble criterio.],
)

#q("R5.28", "c",
  [Los distintivos de llamada con sufijo de una sola letra se reservan para:],
  ([las estaciones de menor potencia], [los radioaficionados noveles], [la participación en concursos internacionales de alta competitividad], [las estaciones instaladas en Ceuta y Melilla]),
  sol: [Un sufijo de una sola letra es lo más corto —y por tanto lo más rápido de transmitir— que puede haber, y ahí está su valor: en concursos, cada carácter ahorrado cuenta. Por eso el art. 27.3 los reserva, asimismo, para la participación en concursos internacionales de alta competitividad. No quedan cerrados a ese uso: el mismo artículo permite asignarlos como distintivo permanente a titulares con cinco años de autorización española, quince de práctica internacional y sin expediente sancionador en los últimos cinco años, y desde el 19-09-2026 hay un procedimiento ordinario para pedirlos (Resolución de 29-07-2026 de la SETID, hoy la SETSI de la Orden; BOE-A-2026-17504, que deroga la de 2019). Ni la potencia, ni la condición de novel, ni la ubicación intervienen.],
)

#q("R5.29", "a",
  [Los distintivos de llamada con sufijo de dos letras:],
  ([podrán asignarse a cualquier radioaficionado que cumpla las condiciones establecidas], [están reservados a las asociaciones], [no se utilizan en España], [corresponden siempre a estaciones desatendidas]),
  sol: [No están reservados a ningún colectivo concreto: son asignables a cualquier titular que reúna las condiciones establecidas, con la lógica de que los sufijos cortos son un recurso escaso.],
)

#q("R5.30", "d",
  [Un sufijo de tres letras que comience por «Y» o por «Z» se reserva para:],
  ([las estaciones móviles], [las estaciones de concurso], [los distintivos temporales], [las estaciones automáticas desatendidas, analógicas y digitales respectivamente]),
  sol: [Es una convención cómoda: viendo el sufijo se sabe si la estación es desatendida y de qué tipo. Un distintivo como `ED1YBD` corresponde a una desatendida analógica, y uno que empiece por Z, a una digital.],
)

#q("R5.31", "a",
  [Los prefijos de los distintivos de llamada correspondientes a España son, entre otros:],
  ([EA, EB y EC], [AE, BE y CE], [EI, EJ y EK], [AA, BB y CC]),
  sol: [EA es el prefijo clásico, y EB y EC se han ido incorporando al agotarse las series. EI y EJ son de Irlanda y EK, de Armenia. Del resto de la serie española: ED, EE y EF sirven para usos temporales ordinarios (ED es además el prefijo permanente de las desatendidas) y EG y EH se reservan a eventos especialmente relevantes (art. 27).],
)

#q("R5.32", "b",
  [Los prefijos de uso temporal ED, EE y EF, al sustituir al habitual:],
  ([obligan a cambiar también el sufijo], [mantienen sin variación el resto del distintivo asignado con carácter permanente], [eliminan la cifra del distrito], [solo pueden usarse en telegrafía]),
  sol: [Lo único que cambia es el prefijo: la cifra del distrito y el sufijo siguen siendo los del distintivo permanente, de modo que se sigue reconociendo a la estación. Así `EA4XYZ` emite temporalmente como `ED4XYZ`.],
)

#q("R5.33", "c",
  [A efectos de distintivos de llamada, la provincia de La Rioja pertenece al distrito:],
  ([2], [9], [1], [0]),
  sol: [Distrito 1, junto con Galicia, Asturias, Cantabria y Castilla y León: el art. 27 la aparta de sus vecinos del distrito 2 (País Vasco, Navarra y Aragón). Conviene memorizarla precisamente por ir contra la intuición geográfica; el 0, además, no es un distrito geográfico.],
)

#q("R5.34", "d",
  [Las ciudades de Ceuta y Melilla están identificadas por la cifra de distrito:],
  ([6], [8], [0], [9]),
  sol: [Ambas comparten el distrito 9. Junto con el 6 (Baleares) y el 8 (Canarias), son los que más se preguntan, precisamente por no seguir la lógica peninsular.],
)

#q("R5.35", "b",
  [Las Islas Baleares y las Islas Canarias corresponden, respectivamente, a las cifras de distrito:],
  ([8 y 6], [6 y 8], [5 y 9], [9 y 6]),
  sol: [Baleares es el 6 y Canarias el 8. La confusión habitual es invertirlos; conviene fijar el 6 con «Baleares, más cerca» y el 8 con «Canarias, más lejos».],
)

#q("R5.36", "c",
  [En un distintivo de llamada, la cifra 0 podrá autorizarse exclusivamente:],
  ([a las estaciones de las asociaciones], [a las estaciones desatendidas], [con motivo de actos inaugurados o visitados por Su Majestad el Rey], [a los titulares con más de veinticinco años de antigüedad]),
  sol: [Es la única excepción a la numeración geográfica: la cifra 0 no identifica zona alguna, sino la relevancia del acto. De ahí que sea un distintivo excepcional y siempre temporal.],
)

#q("R5.37", "a",
  [El sufijo `XXX` en un distintivo de llamada español:],
  ([no puede asignarse], [identifica a una estación sanitaria], [corresponde a las estaciones experimentales], [se reserva para los concursos internacionales]),
  sol: [XXX es la señal radiotelegráfica de urgencia y, como SOS (socorro) y TTT (seguridad), no puede aparecer como sufijo de ningún distintivo: una identificación rutinaria no debe poder confundirse con una señal de socorro, urgencia o seguridad.],
)

#q("R5.38", "d",
  [El prefijo AO se otorga para eventos temporales:],
  ([de ámbito estrictamente local], [de carácter deportivo], [organizados por las asociaciones], [especiales de relevancia internacional]),
  sol: [Los prefijos especiales se escalonan según la importancia del evento (`ED`/`EE`/`EF`, `EG`/`EH`, `AM`/`AN`) y `AO` queda para los de relevancia internacional (art. 27.1.d). Es un distintivo temporal: termina cuando termina el acontecimiento que lo motivó.],
)

#q("R5.39", "b",
  [Si escuchamos a una estación identificarse como `EA3/OK2HM`, se trata de:],
  ([una estación española que opera en la República Checa], [un radioaficionado con autorización expedida en otro país que opera ocasionalmente en España], [una estación automática desatendida catalana], [un distintivo temporal de concurso]),
  sol: [La barra separa el prefijo del país donde se está —EA3, Cataluña— del distintivo propio del operador, `OK2HM`, checo. Es la forma de identificarse al amparo de la licencia CEPT: primero dónde estoy, después quién soy.],
)

#q("R5.40", "d",
  [El distintivo `EA7/EA4KLM/M` corresponde a:],
  ([una estación fija de Andalucía], [una estación desatendida del distrito 7], [un distintivo especial de concurso], [una estación móvil del distrito 4 que opera en el distrito 7]),
  sol: [Se lee de fuera hacia dentro: EA7 dice desde dónde se emite (Andalucía), `EA4KLM` es el titular, del distrito 4, y el sufijo final /M indica que opera en móvil. La misma lógica con /P para portable.],
)

#q("R5.41", "a",
  [Durante sus emisiones, las estaciones de aficionado deben transmitir su distintivo de llamada:],
  ([al menos al comienzo y al final de cada emisión], [únicamente al comienzo], [solo si otra estación lo solicita], [una sola vez al día]),
  sol: [La identificación al principio y al final de cada emisión es la regla básica: permite saber en todo momento quién ocupa la frecuencia y es lo que hace posible el control del servicio.],
)

#q("R5.42", "c",
  [En una comunicación de larga duración, además de al principio y al final, el distintivo debe transmitirse:],
  ([solo si cambia el operador], [solo si se cambia de banda], [periódicamente a lo largo de la emisión], [nunca, para no ocupar la frecuencia]),
  sol: [Si la emisión se alarga, quien sintonice a mitad de comunicación no tendría forma de saber quién está transmitiendo. Por eso hay que reidentificarse a intervalos, sin esperar al final. La Orden lo concreta: en emisiones de larga duración, al menos cada diez minutos (art. 29).],
)

#q("R5.43", "b",
  [El distintivo de llamada se define como:],
  ([el número de expediente de la autorización], [el grupo de caracteres que constituye la señal de identificación de la estación], [la referencia catastral del emplazamiento], [el código del equipo homologado]),
  sol: [El distintivo identifica a la _estación_ y a su titular ante todo el mundo, y su formato está normalizado internacionalmente por la UIT. No tiene nada que ver con expedientes administrativos ni con los equipos.],
)

#q("R5.44", "d",
  [Respecto de la autorización de radioaficionado y el distintivo de llamada:],
  ([el distintivo se solicita aparte, un año después], [el distintivo lo asigna la asociación a la que se pertenezca], [el distintivo se elige libremente por el titular], [al concederse la autorización se otorga a la vez el distintivo]),
  sol: [Van juntos: la autorización no serviría de nada sin un distintivo con el que identificarse, así que se otorgan en el mismo acto. Tampoco se elige libremente — lo asigna la Administración conforme a las series disponibles.],
)

#q("R5.45", "a",
  [Una emisión de una estación de aficionado debe identificarse con su distintivo:],
  ([siempre], [solo en las bandas de HF], [solo cuando se establezca contacto con el extranjero], [solo si se supera una determinada potencia]),
  sol: [Sin excepción de banda, de potencia ni de destino (art. 29.1 de la Orden: distintivo al comienzo y al final de cada emisión y, en las largas, al menos cada diez minutos). No identificarse incumple la Orden y puede ser sancionable conforme al régimen de la Ley General de Telecomunicaciones (art. 34 de la Orden).],
)

#q("R5.46", "c",
  [En el servicio de aficionados, una radiobaliza:],
  ([retransmite las señales que recibe], [enlaza dos repetidores entre sí], [basa su funcionamiento en la emisión automática de señales de identificación], [solo funciona durante los concursos]),
  sol: [Es una estación desatendida que transmite de forma automática y continua su identificación desde un emplazamiento conocido, para que los demás puedan evaluar las condiciones de propagación hacia esa zona.],
)

#q("R5.47", "c",
  [Si un radioaficionado cambia de domicilio y ello implica cambio de distrito:],
  ([pierde necesariamente su sufijo], [debe solicitar un distintivo nuevo con la cifra de su nuevo distrito], [conserva íntegro su distintivo anterior], [debe examinarse de nuevo]),
  sol: [El distintivo asociado a la autorización «será único y no podrá ser modificado» (art. 28) y su cifra es la del distrito de residencia en el momento del otorgamiento (art. 27.2); cambiar de domicilio solo obliga a comunicarlo a la SETSI (art. 7.3). Ni se pierde el distintivo ni hay que examinarse de nuevo. Los bancos de preguntas antiguos dan como correcta «podrá solicitar mantener su sufijo, si estuviera disponible» (regla de las Instrucciones de 2006 que acompañaban a la Orden ITC/1791/2006, derogada); si en el examen aparece esa opción, es la que dan por buena.],
)

#q("R5.48", "d",
  [Puede solicitarse un distintivo de llamada temporal cuando se desee:],
  ([operar con mayor potencia de la autorizada], [ceder la estación a un tercero], [evitar ser identificado], [participar en concursos, experimentos, ensayos o conmemoraciones]),
  sol: [Los distintivos temporales existen para dar visibilidad a actividades concretas y acotadas en el tiempo. Nunca para operar fuera de lo autorizado ni, mucho menos, para ocultar la identidad.],
)

#q("R5.49", "a",
  [El acceso a los repetidores de aficionado, analógicos y digitales:],
  ([será necesariamente libre para todos los radioaficionados], [queda reservado a los socios de la asociación titular], [requiere una autorización individual previa], [se limita a las estaciones del mismo distrito]),
  sol: [Un repetidor se autoriza como infraestructura de uso común del servicio: aunque lo gestione una asociación, no puede reservarse a sus socios ni condicionar el acceso. Cosa distinta es respetar sus normas de uso.],
)
