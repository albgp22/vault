// Apéndice C (continuación): C.16 Tema R8 y C.17 Tema R9 del «Refuerzo del temario».
// Modo FIEL: transcripción exacta de las preguntas (PDF págs. 306–328) y de las
// soluciones razonadas de D.21 (PDF págs. 463–488). Clave: ap-c3.
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Ayudas locales (prefijo _apc3-): la nota «(Véase tema …)» y el párrafo «NO ESTÁ EN EL TEXTO».
#let _apc3-ver(cuerpo) = vease(cuerpo)
#let _apc3-net(cuerpo) = no-esta(cuerpo)

== Tema R8. Reglamentación nacional e internacional <apc3-r8>

#q("F-R8.1", "a",
  [Según el apartado 4.2 del anexo I de la Orden IET/1311/2013, deben limitarse a lo estrictamente necesario:],
  ([la potencia emitida y la duración de las emisiones], [únicamente la potencia emitida, sin restricción alguna para la duración], [únicamente la duración de las emisiones, pues la potencia puede ser siempre la máxima de la banda], [la potencia emitida y la duración de las emisiones, pero solo durante los ensayos de equipos]),
  sol: [El apartado 4.2 del anexo I impone dos límites a la vez: la potencia emitida, siempre dentro de los máximos del apartado 3, y la duración de las emisiones deben limitarse a lo estrictamente necesario. No basta con limitar solo una de las dos (b y c), ni la regla se reduce a los ensayos (d): rige siempre. Para los ensayos que no requieren radiación, el apartado 4.3 añade la carga artificial no radiante. El máximo de la banda es un techo, no el valor que hay que usar. #_apc3-ver[(Véase tema T9, sección «Medidas correctoras».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 4.2) establece que la potencia emitida, dentro de los máximos por banda del apartado 3, y la duración de las emisiones deben limitarse a lo estrictamente necesario. No se transmite con toda la potencia autorizada por sistema, ni se ocupa la frecuencia más tiempo del preciso. En los ensayos que no requieran radiar desde la antena, el apartado 4.3 exige una carga artificial no radiante.]],
)

#q("F-R8.2", "b",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), las antenas, sobre todo las horizontales, deben dejar en las peores condiciones ambientales previsibles una altura libre mínima sobre el plano de paso (la superficie accesible a las personas bajo la antena) de:],
  ([2 m], [3 m], [5 m], [10 m]),
  sol: [El artículo 13.2 exige que, en las peores condiciones ambientales previsibles, las antenas dejen en cualquier caso tres metros libres sobre el plano de paso, y lo subraya para las antenas horizontales, como un hilo largo o un dipolo sobre una azotea. La norma exige 3 m como mínimo: 2 m se queda corto, y 5 m o 10 m no son el mínimo que fija. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[El Reglamento de antenas de aficionado (RD 2623/1986) define el plano de paso como el plano o superficie situado bajo la antena y sus elementos anejos, accesible a las personas. Según su artículo 13.2, las antenas, sobre todo las horizontales, deben dejar en cualquier caso una altura libre de 3 m sobre ese plano, en las peores condiciones ambientales previsibles. Además, en azoteas y lugares transitables se señalizan anclajes y riostras (art. 12.2).]],
)

#q("F-R8.3", "d",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), la distancia mínima a la que deben situarse las líneas de transmisión y los cables de alimentación respecto de cualquier conducto o canalización de servicios del edificio es de:],
  ([5 cm], [50 cm], [1 m], [10 cm]),
  sol: [El artículo 18.1 fija una distancia mínima de 10 cm entre las líneas de transmisión o los cables de alimentación y cualquier conducto o canalización de servicios del edificio, para impedir su contacto con elementos mecánicos. Además, discurren preferentemente por patinillos de instalaciones o por patios interiores, y no se admite su tendido vertical libre: se fijan a intervalos apropiados (art. 18.2). Con 5 cm no se cumple el mínimo; 50 cm y 1 m son más de lo exigido. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Según el artículo 18 del RD 2623/1986, las líneas de transmisión y los cables de alimentación distan al menos 10 cm de cualquier conducto o canalización de servicios del edificio, y discurren preferentemente por patinillos de instalaciones o por patios interiores. No se admite el tendido vertical libre: se fijan a intervalos apropiados. Si van empotrados, se alojan en conductos o canalizaciones de uso exclusivo.]],
)

#q("F-R8.4", "c",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), los soportes de las antenas:],
  ([pueden fijarse a los anclajes del pararrayos del edificio, para aprovechar su toma de tierra], [pueden fijarse a los soportes de las conducciones aéreas de energía eléctrica, para reducir el número de anclajes], [se fijan a la obra civil, directamente en puntos aptos o mediante elementos repartidores de la carga debidamente dimensionados], [deben fijarse siempre mediante elementos repartidores de la carga, nunca directamente a la obra civil]),
  sol: [El artículo 17 prohíbe fijar los soportes de las antenas a soportes o anclajes de pararrayos y de conducciones aéreas de energía eléctrica, por tentador que parezca aprovecharlos (a y b). Los soportes se fijan directamente a la obra civil en puntos aptos para tolerar los esfuerzos, o bien mediante elementos repartidores de la carga debidamente dimensionados: son dos vías igual de válidas, por lo que no hay que usar siempre repartidores (d). #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[El artículo 17 del RD 2623/1986 prohíbe fijar los soportes de las antenas a soportes o anclajes de pararrayos y a los de conducciones aéreas de energía eléctrica. Se fijan directamente a la obra civil, en puntos aptos para tolerar los esfuerzos, o mediante elementos repartidores de la carga debidamente dimensionados. En todo caso, ni soportes ni anclajes pueden deteriorar la resistencia mecánica de los elementos constructivos ni originar vibraciones perturbadoras en los locales habitables.]],
)

#q("F-R8.5", "d",
  [Según el artículo 25 del Reglamento de Radiocomunicaciones, las administraciones deben verificar, de toda persona que desee utilizar una estación de aficionado:],
  ([su pertenencia a una asociación de radioaficionados], [que tiene cumplidos al menos 18 años], [su dominio del código Morse, que el Reglamento exige en todo caso], [sus cualificaciones operativas y técnicas]),
  sol: [El artículo 25 del Reglamento de Radiocomunicaciones obliga a cada administración a verificar la capacidad operativa y técnica de quien quiera operar una estación de aficionado; en España se hace con la prueba de capacitación (Orden IET/1311/2013, arts. 5.2 y 10). El Reglamento no pide pertenecer a una asociación ni una edad mínima. Tampoco impone el Morse: deja a cada administración decidir si lo exige, y el programa del anexo II de la Orden no lo incluye. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[El artículo 25 del Reglamento de Radiocomunicaciones es el que regula los servicios de aficionados. Permite las radiocomunicaciones entre aficionados de distintos países salvo oposición de una administración y las limita a los fines del servicio y a observaciones personales. Obliga a cada administración a verificar la capacidad operativa y técnica de quien quiera operar, y le deja decidir si exige el Morse. Las estaciones transmiten su distintivo a intervalos cortos.]],
)

#q("F-R8.6", "a",
  [Según el artículo 25 del Reglamento de Radiocomunicaciones, la potencia máxima de las estaciones de aficionado:],
  ([la fijan las administraciones interesadas], [es de 1 kW en todas las bandas y para todo el mundo], [la fija la IARU para cada Región en sus planes de banda], [es de 100 W en todas las bandas]),
  sol: [El artículo 25 deja la potencia máxima en manos de cada administración, por lo que varía de un país a otro. En España la fija el anexo I, apartado 3.1, de la Orden IET/1311/2013, con valores distintos según la banda: por ejemplo, 1000 W p.c.e. en HF y 300 W p.c.e. en 70 cm. Por eso no hay un valor único de 1 kW ni de 100 W (b y d). Y los planes de banda de la IARU reparten los segmentos por modos y anchuras de banda, pero no fijan la potencia máxima legal (c). #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Cada administración fija la potencia máxima de las estaciones de aficionado; el Reglamento de Radiocomunicaciones (art. 25) no da una cifra. En España lo hace el anexo I, apartado 3.1, de la Orden IET/1311/2013: 1000 W p.c.e. en las bandas de HF, 600 W p.c.e. en 50, 70 y 144 a 146 MHz, 300 W p.c.e. en 430 a 440 MHz y 1000 W p.i.r.e. de 23 cm en adelante. En bandas secundarias el límite baja al 50 % (apartado 3.2).]],
)

#q("F-R8.7", "b",
  [En los diplomas y concursos de radioaficionados se usan zonas numeradas. La España peninsular está en la zona ITU número:],
  ([14], [37], [33], [36]),
  sol: [Además de las tres Regiones de la UIT, los diplomas y concursos dividen el mundo en zonas ITU (numeradas hasta 90) y en 40 zonas CQ. La España peninsular y las Baleares están en la zona ITU 37 (y en la CQ 14). Canarias está en la ITU 36 (CQ 33), y Ceuta y Melilla en la ITU 37 (CQ 33). Así, 14 y 33 son zonas CQ, no ITU, y 36 solo corresponde a Canarias. #_apc3-ver[(Véase tema R6, sección «Las tres regiones de la UIT».)]

#_apc3-net[Además de las tres Regiones de la UIT, los diplomas y concursos de radioaficionados dividen el mundo en zonas: las zonas CQ (40) y las zonas ITU (numeradas hasta 90). España peninsular y Baleares están en la zona ITU 37 y en la CQ 14; Canarias, en la ITU 36 y la CQ 33; Ceuta y Melilla, en la ITU 37 y la CQ 33. En algunos concursos, como el CQ WW, el número de zona CQ forma parte del intercambio.]],
)

#q("F-R8.8", "c",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), el titular debe entregar una copia del contrato del seguro de responsabilidad civil de su antena, con la cláusula que cita el artículo 2 de la Ley 19/1983:],
  ([únicamente a la Jefatura Provincial de Inspección de Telecomunicaciones, sin dar copia a la propiedad], [a la asociación de radioaficionados a la que pertenece], [a la propiedad del inmueble o al presidente de la comunidad de propietarios], [al ayuntamiento del término municipal donde está la antena]),
  sol: [El artículo 20.3 exige que el contrato incluya una cláusula especial que exprese que cumple el artículo 2 de la Ley 19/1983, y que se entregue copia del contrato (y de sus actualizaciones) a la propiedad del inmueble o, en propiedad horizontal, al presidente de la comunidad de propietarios. Ni la asociación del titular ni el ayuntamiento intervienen. Recuerda además que el seguro se formaliza una vez autorizado el montaje y antes de expedirse la licencia (art. 20.2). #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Según el artículo 20 del RD 2623/1986, el seguro de responsabilidad civil cubre los daños materiales y corporales, a la propiedad y a terceros, derivados del uso, la instalación, la conservación y el desmontaje de la antena. Se formaliza una vez autorizado el montaje y antes de expedirse la licencia. Incluye una cláusula especial que expresa que cumple el artículo 2 de la Ley 19/1983, y se entrega copia del contrato y de sus actualizaciones a la propiedad del inmueble o al presidente de la comunidad.]],
)

#q("F-R8.9", "c",
  [Según el Real Decreto 2623/1986, que desarrolla la Ley de antenas, si la propiedad del inmueble causa daños a la antena o a sus elementos anejos, su reparación y la indemnización, en su caso, corren por cuenta de:],
  ([el titular de la licencia, con cargo a su seguro], [la Administración de telecomunicaciones], [la propiedad del inmueble], [el instalador que montó la antena]),
  sol: [El art. 22 del Real Decreto 2623/1986 lo dice sin rodeos: si la propiedad daña la antena o sus elementos anejos, la reparación y la indemnización, en su caso, son de cuenta de la propiedad. Es la regla inversa a la de los daños que _causa_ la antena (instalación, conservación y desmontaje): esos los asume el titular de la licencia y los cubre su seguro de responsabilidad civil (art. 2 de la Ley 19/1983). Aquí la antena no causa el daño, lo _sufre_, y por eso ni el seguro del titular, ni la Administración, ni el instalador responden de él. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Quién paga los daños depende del sentido en que se producen. Si los causa la antena (por su instalación, conservación o desmontaje), responde el titular de la licencia, con un seguro de responsabilidad civil que cubra los daños materiales y corporales a la propiedad y a terceros (art. 2 de la Ley 19/1983; art. 20 del Real Decreto 2623/1986). Si es la propiedad del inmueble quien daña la antena o sus elementos anejos, la reparación y la indemnización, en su caso, corren por cuenta de la propiedad (art. 22 del Real Decreto 2623/1986).]],
)

#q("F-R8.10", "b",
  [La Ley General de Telecomunicaciones vigente es:],
  ([la Ley 9/2014, de 9 de mayo], [la Ley 11/2022, de 28 de junio], [la Ley 32/2003, de 3 de noviembre], [la Ley 19/1983, de 16 de noviembre]),
  sol: [La Ley 11/2022, de 28 de junio, derogó la Ley 9/2014 (disposición derogatoria única, apartado a, salvo unas pocas disposiciones residuales), que a su vez había derogado la Ley 32/2003 (disposición derogatoria única, apartado b, de la Ley 9/2014). La Ley 19/1983 no es una ley general de telecomunicaciones: es la «Ley de antenas», que regula el derecho a instalar antenas en el exterior de los inmuebles. Ojo: la Orden IET/1311/2013 cita la Ley 32/2003, y muchos bancos antiguos la 9/2014; eran las vigentes en su época. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]],
)

#q("F-R8.11", "a",
  [El Real Decreto 123/2017, de 24 de febrero, aprueba el:],
  ([Reglamento sobre el uso del dominio público radioeléctrico], [Reglamento de instalación de antenas de aficionado en el exterior de los inmuebles], [Reglamento del procedimiento de evaluación de la conformidad de los aparatos de telecomunicaciones], [Reglamento de la actividad de instalación y mantenimiento de equipos y sistemas de telecomunicación]),
  sol: [El Real Decreto 123/2017 aprueba el Reglamento sobre el uso del dominio público radioeléctrico, que derogó el Real Decreto 863/2008 (disposición derogatoria única, a), todavía citado en la exposición de motivos y en el art. 1 de la Orden IET/1311/2013. Es el reglamento general de la Ley General de Telecomunicaciones en esta materia; en él se regulan el uso especial y su autorización individual para radioaficionados (arts. 22 y 25). Las demás opciones son reglamentos que la Orden también cita: el Real Decreto 2623/1986 (antenas, art. 18.2), el 1890/2000 (conformidad de aparatos, art. 5.5) y el 244/2010 (instaladores, art. 19.e). #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[El Reglamento sobre el uso del dominio público radioeléctrico, aprobado por el Real Decreto 123/2017, de 24 de febrero, desarrolla la Ley General de Telecomunicaciones en lo relativo al espectro y derogó el Real Decreto 863/2008, que es el que todavía cita la Orden IET/1311/2013 (exposición de motivos y art. 1). Distingue los usos común, especial y privativo: el de los radioaficionados es uso especial, con autorización individual (arts. 22 y 25). También prevé el Cuadro Nacional de Atribución de Frecuencias (art. 6).]],
)

#q("F-R8.12", "c",
  [El uso del dominio público radioeléctrico por los radioaficionados está clasificado como:],
  ([uso común, que no necesita título habilitante], [uso privativo, mediante concesión administrativa], [uso especial, mediante autorización individual], [uso reservado al Estado]),
  sol: [Es un uso especial: lo dicen la exposición de motivos de la Orden IET/1311/2013 y sus arts. 1.1 y 2.1. Según el art. 88.1 de la Ley 11/2022, el uso especial es el de las bandas habilitadas para su explotación compartida, sin limitación de número de usuarios, y para los radioaficionados se otorga mediante autorización individual (art. 88.5.a). No es uso común, que no necesita título habilitante (aquí hace falta la autorización de radioaficionado, art. 5.1 de la Orden). Tampoco es privativo, que es la explotación en exclusiva o por un número limitado de usuarios. El uso reservado al Estado es otra categoría del CNAF. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[El uso del dominio público radioeléctrico puede ser común, especial o privativo (art. 88.1 de la Ley 11/2022). El común no precisa título habilitante. El privativo es la explotación en exclusiva o por un número limitado de usuarios. El especial es el de las bandas habilitadas para su explotación compartida, sin limitación de número de usuarios. El de los radioaficionados es uso especial (art. 2.1 de la Orden IET/1311/2013) y se ejerce mediante autorización individual (art. 88.5.a de la Ley 11/2022): la autorización de radioaficionado.]],
)

#q("F-R8.13", "d",
  [La Orden IET/1311/2013 derogó expresamente:],
  ([la Ley 19/1983, de 16 de noviembre], [la Orden ITC/4096/2006, de 28 de diciembre (banda ciudadana CB-27)], [el Real Decreto 2623/1986, de 21 de noviembre], [la Orden ITC/1791/2006, de 5 de junio]),
  sol: [La disposición derogatoria única de la Orden IET/1311/2013 deroga expresamente la Orden ITC/1791/2006, de 5 de junio, que aprobaba el reglamento anterior de aficionados, y las normas de igual o inferior rango que se le opongan. La Ley 19/1983 (art. 2.2 del Código Civil: las leyes solo se derogan por otras posteriores) y el Real Decreto 2623/1986 tienen rango superior a una orden, y la propia Orden los cita como aplicables a las estaciones fijas (art. 18.2). La Orden ITC/4096/2006 (CB-27) no se deroga: la disposición final primera solo modifica el apartado 3 de su art. 4. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[La Orden IET/1311/2013 deroga expresamente la Orden ITC/1791/2006, de 5 de junio, que aprobaba el reglamento anterior de aficionados, y las disposiciones de igual o inferior rango que se le opongan. No deroga la Ley 19/1983 ni el Real Decreto 2623/1986, sobre antenas, que cita como aplicables a las estaciones fijas (art. 18.2), ni el reglamento de la banda ciudadana CB-27 (Orden ITC/4096/2006), del que solo modifica el apartado 3 del art. 4. Por eso los bancos antiguos que siguen la Orden de 2006 apoyan sus claves en una norma derogada.]],
)

#q("F-R8.14", "b",
  [La Orden IET/1311/2013 entró en vigor:],
  ([el mismo día de su publicación en el BOE], [el día siguiente al de su publicación en el BOE], [a los veinte días de su publicación en el BOE], [el 1 de enero de 2014]),
  sol: [La disposición final cuarta dice que la Orden «entrará en vigor el día siguiente al de su publicación» en el BOE. Se publicó el 12 de julio de 2013 (BOE núm. 166), de modo que rige desde el 13 de julio de 2013. Los veinte días son la regla general del art. 2.1 del Código Civil para las leyes, pero solo se aplica si la norma no dispone otra cosa, y aquí sí lo dispone. Entrar en vigor el mismo día de la publicación es más rápido de lo que establece, y el 1 de enero de 2014 no figura en el texto. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[La Orden IET/1311/2013, de 9 de julio, se publicó en el BOE núm. 166, de 12 de julio de 2013, y entró en vigor el día siguiente, el 13 de julio de 2013 (disposición final cuarta). Las autorizaciones de uso especial no extinguidas antes de esa fecha conservaron su vigencia y quedaron sometidas al nuevo reglamento (disposición transitoria única). Se dicta al amparo de la competencia exclusiva del Estado en telecomunicaciones, art. 149.1.21.ª de la Constitución (disposición final tercera).]],
)

#q("F-R8.15", "a",
  [Según la Orden IET/1311/2013, el uso del espectro por los radioaficionados se caracteriza por ser una explotación:],
  ([compartida, sin exclusión de terceros], [exclusiva, con reserva de la banda para cada titular], [reservada a las asociaciones de radioaficionados reconocidas], [limitada a un número de usuarios que fija la SETSI]),
  sol: [El art. 2.1 de la Orden define el uso especial del espectro por radioaficionados como una explotación compartida sin exclusión de terceros, con fines de instrucción individual, intercomunicación o realización de estudios técnicos. Coincide con el art. 88.1 de la Ley 11/2022: uso especial es el de las bandas habilitadas para su explotación compartida, sin limitación de número de usuarios. Por eso nadie tiene una banda o una frecuencia en exclusiva (b), no hay cupo de usuarios (d) y el uso no está reservado a las asociaciones (c): cualquier titular de autorización puede emitir en las bandas del servicio (art. 5.3). #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[El art. 2.1 de la Orden IET/1311/2013 define el uso especial del espectro por radioaficionados: una explotación compartida sin exclusión de terceros, con fines de instrucción individual, intercomunicación o realización de estudios técnicos. «Compartida sin exclusión de terceros» significa que ningún titular puede excluir a otro de una banda ni reclamar una frecuencia en exclusiva: el espectro es dominio público y todos los radioaficionados autorizados lo utilizan a la vez, sin cupo de usuarios.]],
)

#q("F-R8.16", "d",
  [Según el Reglamento de uso del dominio público radioeléctrico por radioaficionados, estos son personas debidamente autorizadas que se interesan por la radiotecnia con carácter:],
  ([profesional, con derecho a cobrar por los servicios que presten a terceros], [asociativo, por pertenecer a una asociación de radioaficionados reconocida], [institucional, por encargo de la Administración o de Protección Civil], [exclusivamente personal y sin fines de lucro ni contenido económico]),
  sol: [Lo dice el art. 2.1 de la Orden IET/1311/2013: los radioaficionados son personas debidamente autorizadas que se interesan por la radiotecnia con carácter exclusivamente personal y sin fines de lucro ni contenido económico. De ahí que emitir con fines comerciales, publicitarios o lucrativos pueda llevar a la revocación de la autorización (art. 8.1.b). No es una actividad profesional ni remunerada (a), ni asociativa (b), ni se ejerce por encargo de la Administración (c), aunque el titular deba colaborar con Protección Civil si se le requiere en catástrofes (art. 30.4). #_apc3-ver[(Véase tema R7, introducción del tema (definición del servicio de aficionados, «sin fines de lucro»).)]],
)

#q("F-R8.17", "c",
  [El Cuadro Nacional de Atribución de Frecuencias (CNAF) vigente en octubre de 2026 fue aprobado por la:],
  ([Orden IET/1311/2013, de 9 de julio], [Orden ETU/1033/2017, de 25 de octubre], [Orden TDF/732/2026, de 10 de julio], [Orden ETD/1449/2021, de 16 de diciembre]),
  sol: [El Ministerio aprueba el CNAF mediante orden, al amparo del art. 6 del Reglamento sobre el uso del dominio público radioeléctrico. La edición vigente es la de la Orden TDF/732/2026, de 10 de julio (BOE del 17 de julio, en vigor al día siguiente), que deroga y sustituye a la de la Orden ETD/1449/2021, de 16 de diciembre; la Orden ETU/1033/2017 es una edición anterior. La Orden IET/1311/2013 no es un CNAF: es el reglamento de los radioaficionados, y remite al CNAF para saber qué bandas se atribuyen al servicio (art. 2.1). #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[El CNAF es el plan que atribuye las bandas, subbandas y frecuencias a cada servicio de radiocomunicación y fija sus condiciones técnicas, de acuerdo con la Unión Europea, la CEPT y el Reglamento de Radiocomunicaciones de la UIT (art. 6 del Reglamento sobre el uso del dominio público radioeléctrico). Lo aprueba el Ministerio mediante orden. La edición vigente en octubre de 2026 es la de la Orden TDF/732/2026, de 10 de julio, que sustituyó a la de la Orden ETD/1449/2021, de 16 de diciembre.]],
)

#q("F-R8.18", "b",
  [En España, la banda de 5351,5–5366,5 kHz (60 m) está atribuida al servicio de aficionados:],
  ([con carácter primario y una potencia máxima de 1000 W p.c.e.], [con carácter secundario y una potencia radiada máxima de 15 W p.i.r.e.], [con carácter secundario y una potencia máxima de 500 W p.c.e., el 50 % de la de HF], [con carácter primario y una potencia radiada máxima de 15 W p.i.r.e.]),
  sol: [En el CNAF vigente la banda de 5351,5 a 5366,5 kHz figura con el servicio «Aficionados» en caracteres normales, es decir, con carácter secundario, y con la nota 5.133B del Reglamento de Radiocomunicaciones, que limita la potencia radiada a 15 W (p.i.r.e.). Como secundario, no puede causar interferencia a los servicios primarios ni reclamar protección frente a ellos. La banda no figura en la tabla de potencias del anexo I, 3.1, de la Orden IET/1311/2013: por eso no valen los 1000 W p.c.e. de las bandas de HF (a) ni su 50 % (c), y primario (a, d) es falso. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[Además de las bandas de la tabla, en HF el servicio de aficionados dispone de la banda de 60 m, 5351,5–5366,5 kHz, atribuida con carácter secundario: no debe causar interferencia perjudicial a los servicios primarios ni puede reclamar protección frente a ellos. La nota 5.133B del Reglamento de Radiocomunicaciones, recogida en el CNAF, limita la potencia radiada a 15 W (p.i.r.e.). Esta banda no figura en la tabla de potencias del anexo I, 3.1, de la Orden IET/1311/2013.]],
)

#q("F-R8.19", "a",
  [Según la Ley 19/1983, los derechos que el artículo 545 del Código Civil reconoce al dueño del predio sirviente se ejercen, en su caso, por la comunidad de propietarios, bastando que la decisión se adopte por:],
  ([mayoría simple], [unanimidad de los propietarios], [mayoría de tres quintos], [mayoría de dos tercios]),
  sol: [El art. 2 de la Ley 19/1983, en su último párrafo, dice que los derechos del art. 545, párrafo 2, del Código Civil se ejercen, en su caso, por la comunidad de propietarios, «bastando que la decisión se adopte por mayoría simple». Esos derechos son los del dueño del predio sirviente: variar, a su costa, el lugar o la forma de la servidumbre cuando le resulte muy incómoda, ofreciendo otro igualmente cómodo. La ley no exige unanimidad ni mayorías reforzadas (tres quintos, dos tercios). El Real Decreto 2623/1986 (art. 9) remite al mismo art. 545 para los cambios de emplazamiento que promueva la propiedad. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Según el art. 2 de la Ley 19/1983, los derechos que el art. 545, párrafo 2, del Código Civil reconoce al dueño del predio sirviente se ejercen, en su caso, por la comunidad de propietarios, bastando mayoría simple. Esos derechos son variar, a su costa, el lugar o la forma de la servidumbre cuando le resulte muy incómoda o le impida hacer obras, reparos o mejoras importantes, ofreciendo otro igualmente cómodo y sin perjuicio para el titular. El Real Decreto 2623/1986 (art. 9) remite al art. 545 para los cambios de emplazamiento que promueva la propiedad.]],
)

#q("F-R8.20", "d",
  [Según el artículo 4 de la Orden IET/1311/2013, el recurso potestativo de reposición contra las resoluciones de la SETSI sobre autorizaciones y licencias de radioaficionado debe interponerse en el plazo de:],
  ([quince días desde su notificación], [seis semanas desde la entrada de la solicitud], [dos meses desde el día siguiente a su notificación], [un mes desde el día siguiente a su notificación]),
  sol: [El art. 4 de la Orden dice que estas resoluciones agotan la vía administrativa y que contra ellas cabe recurso potestativo de reposición ante el mismo órgano que las dictó, en el plazo de un mes desde el día siguiente a su notificación. Las seis semanas (b) son el plazo para resolver y notificar, no para recurrir; transcurrido sin resolución expresa, la solicitud se entiende desestimada. Los dos meses (c) son el plazo para acudir directamente a la Audiencia Nacional, y ambos recursos no pueden ser simultáneos. Los quince días (a) no aparecen en el artículo. #_apc3-ver[(Véase tema R8, introducción del tema (tabla de cifras: seis semanas y silencio desestimatorio).)]

#_apc3-net[Según el art. 4 de la Orden IET/1311/2013, la SETSI debe resolver en seis semanas y el silencio es desestimatorio. Las resoluciones agotan la vía administrativa. Contra ellas cabe recurso potestativo de reposición ante el mismo órgano que las dictó, en el plazo de un mes desde el día siguiente a la notificación, o bien recurso directo ante la Sala de lo Contencioso-administrativo de la Audiencia Nacional, en el plazo de dos meses desde el día siguiente a la notificación. Ambos recursos no pueden ser simultáneos.]],
)

#q("F-R8.21", "c",
  [Las resoluciones de la SETSI a que se refiere el artículo 4 de la Orden IET/1311/2013 agotan la vía administrativa y pueden impugnarse directamente ante la Sala de lo Contencioso-administrativo de:],
  ([el Tribunal Supremo, en el plazo de dos meses], [la Audiencia Nacional, en el plazo de un mes], [la Audiencia Nacional, en el plazo de dos meses], [el Tribunal Superior de Justicia de la comunidad autónoma del interesado, en el plazo de dos meses]),
  sol: [El art. 4 permite impugnar estas resoluciones directamente ante la Sala de lo Contencioso-administrativo de la Audiencia Nacional, en el plazo de dos meses contados desde el día siguiente a la notificación. Es una alternativa al recurso potestativo de reposición (un mes ante el mismo órgano), y ambos no pueden ser simultáneos. El Tribunal Supremo y el Tribunal Superior de Justicia no aparecen en el artículo. El plazo de un mes ante la Audiencia Nacional mezcla el de la reposición con el órgano del recurso directo. #_apc3-ver[(Véase tema R8, introducción del tema (tabla de cifras: seis semanas y silencio desestimatorio).)]

#_apc3-net[Las resoluciones de la SETSI sobre autorización de radioaficionado, licencia de estación y demás procedimientos del art. 4 de la Orden IET/1311/2013 agotan la vía administrativa. Pueden impugnarse directamente ante la Sala de lo Contencioso-administrativo de la Audiencia Nacional, en el plazo de dos meses desde el día siguiente a la notificación, o recurrirse antes en reposición, ante el mismo órgano, en el plazo de un mes. Ambos recursos no pueden ser simultáneos.]],
)

#q("F-R8.22", "b",
  [Según el artículo 4 del Reglamento, el plazo de seis semanas para resolver y notificar, con silencio desestimatorio, se aplica a la autorización de radioaficionado y también a:],
  ([la realización de la prueba de capacitación y la expedición del certificado HAREC], [la expedición de la licencia de estación fija], [la notificación previa del uso de una estación portable], [la cancelación de la licencia de estación fija a petición de su titular]),
  sol: [El art. 4 fija seis semanas, desde la entrada de la solicitud en un registro de la SETSI, para resolver y notificar la autorización de radioaficionado (arts. 5 a 7), la autorización temporal para extranjeros sin licencia CEPT (art. 15), las autorizaciones especiales de los arts. 16 y 17 y la expedición de las licencias de estación fija (art. 20) y de estación automática desatendida (art. 26). Vencido el plazo sin resolución expresa, la solicitud se entiende desestimada. Quedan fuera de esa lista la prueba de capacitación (a), la notificación de uso portable (c) y la cancelación de la licencia (d). #_apc3-ver[(Véase tema R8, tabla de cifras al comienzo del capítulo (fila «Resolución de la solicitud de autorización»).)]

#_apc3-net[El cuaderno recoge las seis semanas y el silencio desestimatorio solo para la autorización de radioaficionado. El art. 4 de la Orden IET/1311/2013 aplica ese plazo a otros cinco procedimientos: la autorización temporal para extranjeros sin licencia CEPT (art. 15), la autorización especial para bandas con carácter secundario (art. 16), la experimental (art. 17) y la expedición de las licencias de estación fija (art. 20) y de estación automática desatendida (art. 26). El plazo cuenta desde la entrada de la solicitud en un registro de la SETSI; si vence sin resolución expresa, se entiende desestimada.]],
)

#q("F-R8.23", "c",
  [Los equipos radioeléctricos adquiridos en el mercado que se pretenda utilizar en una estación de radioaficionado deben cumplir la legislación (marcado CE, certificado de aceptación radioeléctrica, etc.) que les fuese de aplicación:],
  ([en el momento de su adquisición por el radioaficionado], [en la fecha en que se presente la solicitud de licencia de estación], [en el momento de su comercialización inicial], [en la fecha de entrada en vigor del Reglamento de radioaficionados]),
  sol: [El art. 5.5 exige a los equipos comprados en el mercado la legislación que les fuese de aplicación «en el momento de su comercialización inicial»: marcado CE, certificado de aceptación radioeléctrica, etc. Cuenta, pues, cuándo salió el equipo al mercado, no cuándo lo compra el aficionado (a), ni la fecha de la solicitud (b), ni la entrada en vigor del Reglamento (d). Los equipos de segunda mano anteriores al RD 1890/2000 y los ya legalizados en una licencia tienen reglas propias, en el mismo artículo. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.5 de la Orden IET/1311/2013: los equipos radioeléctricos comprados en el mercado y destinados a una estación de radioaficionado deben cumplir la legislación que les fuese de aplicación en el momento de su comercialización inicial (marcado CE, certificado de aceptación radioeléctrica, etc.). Se les exige, por tanto, lo que correspondía cuando el equipo salió al mercado, no lo vigente el día de la compra. Para los equipos de segunda mano anteriores al Real Decreto 1890/2000 y para los ya legalizados en una licencia rigen reglas propias, en el mismo artículo.]],
)

#q("F-R8.24", "a",
  [Un equipo de segunda mano comercializado antes de la entrada en vigor del Real Decreto 1890/2000 no dispone del certificado de aceptación radioeléctrica exigido en su día. Para utilizarlo en una estación de radioaficionado debe:],
  ([cumplir las características técnicas del anexo I, certificado por un laboratorio acreditado], [ir acompañado de una declaración de conformidad firmada por su titular], [sustituirse por un equipo con marcado CE, pues no existe otra vía], [presentarse en la Jefatura Provincial para su homologación individual]),
  sol: [El art. 5.5, segundo párrafo, exige a estos equipos de segunda mano el certificado de aceptación radioeléctrica de su época o, en su defecto, que cumplan las características técnicas del anexo I, certificado por un laboratorio acreditado. La vía del laboratorio existe precisamente para los que carecen de certificado, así que no hace falta cambiar el equipo (c). La mera declaración del titular (b) no basta, y la presentación en la Jefatura (d) es una posibilidad optativa de los equipos de construcción propia, no de los comerciales. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.5, segundo párrafo, de la Orden IET/1311/2013: los equipos de segunda mano comercializados antes de la entrada en vigor del Real Decreto 1890/2000 (evaluación de la conformidad de aparatos de telecomunicaciones) deben tener el certificado de aceptación radioeléctrica exigido en su día. Si carecen de él, deben cumplir las características técnicas del anexo I, certificado por un laboratorio acreditado. No basta la declaración del titular, y tampoco es preciso sustituir el equipo.]],
)

#q("F-R8.25", "d",
  [Respecto de los equipos anteriormente legalizados en una licencia de estación de radioaficionado, el Reglamento establece que les es de aplicación:],
  ([la normativa actual, con una nueva certificación del equipo], [la normativa vigente en el momento de su fabricación], [el marcado CE, sin excepción], [la normativa en vigor en el momento de su autorización inicial]),
  sol: [El último inciso del art. 5.5 dice que a los equipos anteriormente legalizados en una licencia de estación de radioaficionado les es de aplicación la normativa en vigor en el momento de su autorización inicial. No se les aplica la norma actual con una nueva certificación (a), y la fecha de fabricación (b) no es la que cuenta. Tampoco se exige el marcado CE «sin excepción» (c): solo lo que exigiese la norma de aquel momento. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.5, último inciso, de la Orden IET/1311/2013: a los equipos que ya estaban legalizados en una licencia de estación de radioaficionado se les aplica la normativa en vigor en el momento de su autorización inicial, no la actual. No hay que volver a certificarlos si la norma posterior ha cambiado. Es la regla de tránsito que completa las otras dos del artículo: equipos comprados (legislación de su comercialización inicial) y de segunda mano anteriores al RD 1890/2000 (certificado de aceptación radioeléctrica o laboratorio acreditado).]],
)

#q("F-R8.26", "b",
  [La presentación de un equipo de construcción propia en la Jefatura Provincial de Inspección de Telecomunicaciones, junto con su memoria descriptiva, es:],
  ([obligatoria antes de su primer uso: sin ella no puede utilizarse], [optativa: si supera las pruebas, el equipo recibe una autorización individual acreditativa de su correcto funcionamiento], [obligatoria únicamente para los transmisores de más de 100 W], [imposible: en la Jefatura solo se presentan equipos comerciales]),
  sol: [El art. 5.6 permite usar equipos de construcción propia sin autorización previa de la SETSI, bajo la responsabilidad del aficionado. Presentarlos en la Jefatura con una memoria es solo optativo: si superan las pruebas de comprobación de las características del anexo I, reciben una autorización individual acreditativa de su correcto funcionamiento. Por eso no es obligatoria antes del primer uso (a) ni según la potencia (c), y tampoco es imposible (d): la norma prevé expresamente esa presentación. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.6 de la Orden IET/1311/2013: los equipos total o parcialmente de construcción propia se usan sin autorización previa de la SETSI, bajo la responsabilidad del radioaficionado, y deben cumplir las características técnicas del anexo I. Optativamente pueden presentarse en la Jefatura Provincial de Inspección de Telecomunicaciones con una memoria descriptiva; los que superen las pruebas reciben una autorización individual acreditativa de su correcto funcionamiento. Ese trámite no es obligatorio.]],
)

#q("F-R8.27", "d",
  [La memoria descriptiva que acompaña a un equipo de construcción propia presentado en la Jefatura Provincial de Inspección de Telecomunicaciones debe incluir:],
  ([la factura de los componentes y el certificado de marcado CE de cada uno], [el plano de ubicación de la estación y el contrato de seguro de antenas], [un certificado de un laboratorio acreditado sobre el cumplimiento del anexo I], [el diagrama de bloques, los esquemas eléctricos y una descripción del funcionamiento básico del equipo]),
  sol: [Según el art. 5.6, la memoria incluye el diagrama de bloques, los esquemas eléctricos y una descripción del funcionamiento básico. Con ella y con el equipo montado para poder probarlo se comprueban las características del anexo I; un certificado de laboratorio (c) no forma parte de la memoria. La factura y el marcado CE (a) carecen de sentido en un equipo hecho por uno mismo, y el plano de ubicación y el seguro de antenas (b) pertenecen al trámite de la licencia de estación fija, no al de un equipo. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.6, segundo párrafo, de la Orden IET/1311/2013: la memoria descriptiva de un equipo de construcción propia presentado en la Jefatura Provincial incluye el diagrama de bloques, los esquemas eléctricos y una descripción del funcionamiento básico. El equipo debe permitir pruebas que comprueben las características técnicas del anexo I y poder alimentarse directamente de la red pública de corriente alterna. No hay que confundirla con la memoria técnica de la instalación de una estación fija, que es otro trámite.]],
)

#q("F-R8.28", "a",
  [Si un equipo de construcción propia produce interferencias perjudiciales a otros servicios autorizados por funcionamiento defectuoso, su titular:],
  ([queda sometido al régimen sancionador de la Ley General de Telecomunicaciones], [queda exento de responsabilidad, pues no necesita autorización previa], [solo responde si el equipo fue presentado antes en la Jefatura Provincial], [solo debe cesar las emisiones y reparar el equipo, sin más consecuencias]),
  sol: [El art. 5.6 permite usar equipos de construcción propia sin autorización previa, pero bajo la responsabilidad del propio aficionado: si por funcionamiento defectuoso producen interferencias perjudiciales a otros servicios autorizados, su titular queda sometido al régimen sancionador de la Ley General de Telecomunicaciones (título VIII, según el art. 34). No hay exención por ser un equipo casero (b), ni depende de que se hubiera presentado en la Jefatura (c), ni basta con repararlo sin más consecuencias (d). #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.6 de la Orden IET/1311/2013: el aficionado puede usar equipos total o parcialmente de construcción propia sin autorización previa, bajo su responsabilidad, y deben cumplir las características técnicas del anexo I. Si por funcionamiento defectuoso producen interferencias perjudiciales a otros servicios de telecomunicaciones autorizados, su titular queda sometido al régimen sancionador de la Ley General de Telecomunicaciones (título VIII; Ley 11/2022). Hay libertad para construir, pero responsabilidad por lo que se emite.]],
)

#q("F-R8.29", "c",
  [Los interesados en obtener la autorización de radioaficionado presentan su solicitud, preferentemente:],
  ([a través de la asociación de radioaficionados de la que sean socios], [en papel y exclusivamente en la Jefatura Provincial de Inspección de Telecomunicaciones], [por medios electrónicos, en la sede electrónica del Ministerio y según el modelo oficial], [mediante escrito libre, sin modelo oficial, enviado por correo electrónico a la SETSI]),
  sol: [El art. 6 admite presentar la solicitud en las Jefaturas Provinciales de Inspección de Telecomunicaciones o en los demás lugares que permite la ley de procedimiento administrativo, pero indica como vía preferente los medios electrónicos de la sede electrónica del Ministerio, según el modelo oficial. No se presenta a través de la asociación (a), el papel en la Jefatura no es la única vía (b) y el escrito libre no sirve: hay modelo oficial (d). La solicitud va acompañada del resguardo de la tasa de tramitación. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 6 de la Orden IET/1311/2013: la solicitud de autorización de radioaficionado se presenta en las Jefaturas Provinciales de Inspección de Telecomunicaciones, en los demás registros que admite la ley o, preferentemente, por medios electrónicos en la sede electrónica del Ministerio (en 2013, el de Industria, Energía y Turismo), según el modelo oficial publicado en ella. Va acompañada del resguardo de abono de la tasa de tramitación y de la demás documentación que proceda en cada caso. La resuelve la SETSI (art. 7).]],
)

#q("F-R8.30", "b",
  [Según el artículo 6 del Reglamento, a la solicitud de autorización de radioaficionado debe acompañarse:],
  ([la memoria técnica de la instalación y el contrato de seguro de antenas], [el resguardo de abono de la tasa de tramitación], [un certificado de pertenencia a una asociación de radioaficionados], [la autorización escrita de la comunidad de propietarios del domicilio]),
  sol: [El art. 6 dice que la solicitud va «acompañada del resguardo de abono de la tasa de tramitación» establecida en la Ley General de Telecomunicaciones, además de la documentación que en cada caso proceda. La memoria técnica y el seguro de antenas (a) se exigen para la licencia de estación fija, no para la autorización. Ser socio de una asociación (c) no es obligatorio para ejercer la actividad. Y la comunidad de propietarios (d) solo interviene en la instalación de antenas, no en esta solicitud. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 6 de la Orden IET/1311/2013: la solicitud de autorización de radioaficionado debe ir acompañada del resguardo de abono de la tasa de tramitación que establece la Ley General de Telecomunicaciones y de la demás documentación que proceda en cada caso. No se exige ser socio de ninguna asociación. La memoria técnica de la instalación y el justificante del seguro de antenas pertenecen a otro trámite posterior, el de la licencia de estación fija (arts. 19 y 20).]],
)

#q("F-R8.31", "a",
  [La autorización de radioaficionado se extingue automáticamente por:],
  ([el fallecimiento de su titular o la extinción de la asociación de radioaficionados titular de la misma], [el transcurso de cinco años sin comunicar a la SETSI la intención de seguir utilizando el espectro], [el traslado de su titular a un distrito distinto del de su distintivo], [la baja de su titular como socio de una asociación de radioaficionados]),
  sol: [El art. 8.2 fija la extinción automática: el fallecimiento del titular o la extinción de la asociación de radioaficionados titular de la autorización. La comunicación quinquenal de continuidad (b) quedó suprimida, con sus efectos de extinción, por la disposición adicional primera. Mudarse de distrito (c) solo obliga a comunicar el nuevo domicilio (art. 7.3). Y no hace falta ser socio de ninguna asociación (d). La renuncia del titular (art. 5.4) y la revocación (art. 8.1) son otras formas de perderla, pero no son extinción automática. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 8.2 de la Orden IET/1311/2013: la autorización de radioaficionado se extingue automáticamente por el fallecimiento de su titular o por la extinción de la asociación de radioaficionados titular de la misma. No es lo mismo que la revocación, que exige expediente y tiene causas específicas (art. 8.1), ni que la renuncia del titular (art. 5.4). Ya no existe la caducidad por no comunicar cada cinco años la intención de seguir usando el espectro: la disposición adicional primera la suprimió junto con sus efectos.]],
)

#q("F-R8.32", "d",
  [La licencia CEPT expedida por otro país que haya adoptado la Recomendación T/R 61-01 se equipara a la autorización española de radioaficionado y surte efectos:],
  ([para cualquier extranjero, residente o no, sin límite de tiempo], [solo para extranjeros procedentes de países de la Unión Europea], [para extranjeros residentes en España, siempre que además posean el certificado HAREC], [exclusivamente para extranjeros no residentes en España, durante sus estancias temporales]),
  sol: [El art. 13 equipara la licencia CEPT de otro país (T/R 61-01) a la autorización española, pero «exclusivamente» para extranjeros no residentes en territorio español y durante sus estancias temporales. Quien fija su residencia en España ya no puede amparar su actividad en la licencia CEPT: necesita la autorización española, que obtiene examinándose o, sin examen, con un HAREC o por convenio de reciprocidad (art. 5.2). No hay restricción por nacionalidad europea (b), ni vale sin límite de tiempo (a), y el HAREC del residente (c) es otra vía distinta. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 13 de la Orden IET/1311/2013: la licencia CEPT expedida por un país extranjero que haya adoptado la T/R 61-01 equivale a la autorización española de radioaficionado, pero surte efectos exclusivamente para extranjeros no residentes en territorio español y durante sus estancias temporales. Quien se instala en España como residente ya no puede basarse en ella: necesita la autorización española, que obtiene superando la prueba o, sin examen, con un certificado HAREC o por convenio de reciprocidad (art. 5.2).]],
)

#q("F-R8.33", "c",
  [La SETSI puede autorizar a operar temporalmente en España a un extranjero titular de una licencia en vigor de un país que no ha adoptado la Recomendación T/R 61-01. El período de validez de esa autorización temporal no será superior a:],
  ([15 días], [30 días], [90 días], [seis meses]),
  sol: [El art. 15 permite a la SETSI autorizar a operar mientras esté temporalmente en España al titular de una licencia en vigor de un país que no ha adoptado la T/R 61-01. El período de validez «no será superior a 90 días». Los otros plazos son de otros trámites del Reglamento: 15 días naturales para los usos portables no continuados que no precisan notificación (art. 17.1), 30 días para que la Jefatura verifique la instalación de una estación fija (art. 20) y seis meses para terminar la instalación de una estación desatendida (art. 26). #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Los países que han adoptado la T/R 61-01 se benefician de la licencia CEPT (art. 13). Para el titular de una licencia de un país que no la ha adoptado existe otra vía, el art. 15 de la Orden IET/1311/2013: la SETSI puede concederle una autorización temporal para operar mientras esté en España, previa solicitud con nombre y apellidos, nacionalidad, dirección y copia de la licencia de origen. Sus equipos deben cumplir la normativa española, y la autorización no puede durar más de 90 días.]],
)

#q("F-R8.34", "b",
  [La SETSI puede autorizar a un extranjero, titular de una licencia en vigor de un país que no ha adoptado la Recomendación T/R 61-01, a operar temporalmente en España (art. 15 de la Orden IET/1311/2013). En su solicitud se hace constar su nombre y apellidos, su nacionalidad, su dirección y:],
  ([el justificante del pago de la tasa de examen de radioaficionado], [el original o una fotocopia fehaciente de la licencia de su país de origen], [un certificado que acredite su residencia habitual en España], [la memoria técnica de la estación fija que pretende instalar]),
  sol: [El art. 15 permite a la SETSI autorizar a un extranjero con licencia en vigor de un país que no ha adoptado la T/R 61-01 a operar su estación mientras esté temporalmente en España. En la solicitud se hace constar su nombre y apellidos, su nacionalidad, su dirección y el original o una fotocopia fehaciente de la licencia de su país de origen (b). Lo demás no figura en el artículo: no hay examen, y por tanto tampoco tasa de examen (a); quien está de paso no acredita residencia (c); y no se trata de instalar una estación fija (d). Es la vía para quien no puede usar la licencia CEPT de los arts. 11 a 14. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[El art. 15 de la Orden IET/1311/2013 regula el caso de quien no puede acogerse a la licencia CEPT: el extranjero con licencia en vigor de un país que no ha adoptado la T/R 61-01. La SETSI puede autorizarle a operar su estación mientras esté temporalmente en España. La solicitud indica nombre y apellidos, nacionalidad y dirección, y acompaña el original o una fotocopia fehaciente de su licencia de origen. La autorización no puede durar más de 90 días.]],
)

#q("F-R8.35", "d",
  [Los equipos que utilice un extranjero con la autorización temporal del artículo 15 de la Orden IET/1311/2013 deben:],
  ([cumplir únicamente la normativa del país que expidió su licencia], [superar una inspección individual de la Jefatura Provincial antes de emitir], [estar homologados conforme a la Recomendación T/R 61-01], [cumplir la normativa española en materia de equipos y aparatos]),
  sol: [Según el art. 15, los equipos que utilice el extranjero con autorización temporal deben cumplir la normativa española en materia de equipos y aparatos (d): opera en territorio español, aunque su licencia sea de otro país y su estancia sea breve. No basta con la normativa de su país de origen (a). El artículo tampoco exige una inspección individual previa de la Jefatura (b) ni una homologación conforme a la T/R 61-01 (c): este extranjero procede, precisamente, de un país que no ha adoptado esa recomendación. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[La autorización temporal del art. 15 de la Orden IET/1311/2013 no exime de las normas españolas. La SETSI puede concederla al extranjero con licencia en vigor de un país que no ha adoptado la T/R 61-01, por un máximo de 90 días y previa solicitud con sus datos y su licencia de origen. Los equipos que use deben cumplir la normativa española en materia de equipos y aparatos.]],
)

#q("F-R8.36", "a",
  [Según el artículo 11 de la Orden IET/1311/2013, se entiende por licencia de radioaficionado CEPT la expedida por un país:],
  ([perteneciente o no a la CEPT, que haya adoptado la Recomendación T/R 61-01], [miembro de la CEPT, sin ningún otro requisito], [miembro de la Unión Europea, que haya adoptado la Recomendación T/R 61-01], [que haya adoptado la Recomendación T/R 61-02, la del certificado HAREC]),
  sol: [El art. 11 define la licencia CEPT como la expedida por un país, perteneciente o no a la CEPT, que haya adoptado la T/R 61-01. Lo decisivo es haber adoptado la recomendación, no ser miembro de la CEPT (b) ni de la Unión Europea (c). La T/R 61-02 (d) es la del certificado de examen HAREC, no la de la licencia. Esa licencia habilita a operar en los países que han adoptado la T/R 61-01, y las autorizaciones que otorga la SETSI tienen a todos los efectos la consideración de licencia CEPT. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Según el art. 11 de la Orden IET/1311/2013, licencia CEPT es la expedida por un país que haya adoptado la Recomendación T/R 61-01, pertenezca o no a la CEPT. Habilita a su titular a operar su estación en los países que la han adoptado, en los términos de los arts. 13 y siguientes. Las autorizaciones de radioaficionado otorgadas por la SETSI tienen, a todos los efectos, la consideración de licencias CEPT. El criterio es adoptar la recomendación, no pertenecer a la CEPT.]],
)

#q("F-R8.37", "c",
  [Según el artículo 10.2 de la Orden IET/1311/2013, el programa de la prueba de capacitación para operar estaciones de radioaficionado (anexo II) es acorde con:],
  ([el Reglamento de Radiocomunicaciones de la UIT], [la Recomendación T/R 61-01 de la CEPT, sobre la licencia CEPT], [el anexo 6 de la Recomendación T/R 61-02 de la CEPT], [los planes de bandas de la IARU Región 1]),
  sol: [El art. 10.2 dice que el programa de la prueba, que figura como anexo II de la Orden, es acorde al anexo 6 de la T/R 61-02. Por eso quien supera las dos partes recibe el certificado de examen armonizado HAREC, expedido conforme a la T/R 61-02 (art. 10.3), y un extranjero residente con HAREC de un país que la aplique puede obtener la autorización española sin examinarse (art. 5.2.a). La T/R 61-01 (b) es la de la licencia CEPT (arts. 11 a 14), no la de los exámenes. El Reglamento de Radiocomunicaciones (a) y los planes de la IARU (d) son materias del temario, no la referencia del programa. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[El art. 10 de la Orden IET/1311/2013 dice que la prueba de capacitación consta de dos partes independientes, una de electricidad y radioelectricidad y otra de normativa reglamentaria, y que su programa (anexo II) es acorde al anexo 6 de la Recomendación T/R 61-02 de la CEPT. Quien supera ambas partes recibe el certificado de examen armonizado (HAREC), expedido conforme a esa recomendación, y queda habilitado para solicitar la autorización de radioaficionado.]],
)

#q("F-R8.38", "d",
  [En las autorizaciones especiales del artículo 16 de la Orden IET/1311/2013 (bandas atribuidas con carácter secundario, con riesgo de interferir a servicios primarios), se establecen:],
  ([un plazo máximo inicial de dieciocho meses, ampliable si hace falta], [el uso exclusivo de la banda a favor del solicitante, sin compartirla con otros], [una tasa anual por cada banda cuyo uso se autoriza], [limitaciones geográficas o técnicas de uso que aseguren la compatibilidad con los servicios afectados]),
  sol: [El art. 16.2 dice que en estas autorizaciones especiales se establecen las limitaciones geográficas o técnicas de uso de la banda, para asegurar su compatibilidad con los servicios de radiocomunicaciones autorizados que puedan verse afectados (d). No hay uso exclusivo (b): la banda es secundaria y sus estaciones no deben causar interferencia perjudicial a las de un servicio primario. Los dieciocho meses (a) son los del art. 17.3 para las autorizaciones experimentales; el art. 16 no fija plazo. Y el artículo no menciona tasas por banda (c). #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[El art. 16 de la Orden IET/1311/2013 se refiere a las bandas atribuidas al servicio de aficionados con carácter secundario. Se usan según el Reglamento de Radiocomunicaciones, pero si hay riesgo de interferencia perjudicial a servicios primarios que comparten la banda, hace falta una autorización especial de la SETSI. En ella se fijan las limitaciones geográficas o técnicas de uso que garanticen la compatibilidad. La disposición adicional segunda enumera las bandas iniciales: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz, con algunas subbandas exceptuadas.]],
)

#q("F-R8.39", "b",
  [¿Cuál de los siguientes datos NO forma parte de la memoria técnica que debe acompañar a la solicitud de una autorización especial experimental (art. 17.2 de la Orden IET/1311/2013)?],
  ([el período de utilización de la banda], [la lista de socios de la asociación del solicitante], [la potencia de salida del transmisor], [el tipo y la ganancia de la antena]),
  sol: [El art. 17.2 enumera el contenido de la memoria técnica: el experimento, el diagrama de bloques (si el equipo es de construcción propia), el lugar con sus coordenadas, el período de utilización, la banda, la denominación de la emisión, la potencia de salida y el tipo y la ganancia de la antena. Por eso el período (a), la potencia (c) y la antena (d) sí figuran. La lista de socios de una asociación (b) no es un dato técnico del experimento y no se pide en la memoria. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Según el art. 17.2 de la Orden IET/1311/2013, la solicitud de autorización especial experimental va acompañada de una memoria técnica que describe: el experimento o prueba; el diagrama de bloques de los equipos, si son de construcción propia; el lugar, con las coordenadas geográficas de la instalación; el período de utilización; la banda; la denominación de la emisión; la potencia de salida del transmisor; y el tipo y la ganancia de la antena.]],
)

#q("F-R8.40", "c",
  [En la memoria técnica de una autorización especial experimental, la descripción del diagrama de bloques de los equipos se exige:],
  ([en todos los casos, sean los equipos comerciales o de construcción propia], [solo si la potencia de salida supera los 100 W], [en caso de equipos de construcción propia], [nunca, porque basta con indicar la banda y la potencia]),
  sol: [El art. 17.2.b pide la descripción del diagrama de bloques de los equipos «en caso de construcción propia» (c): un equipo comercial es conocido, mientras que el de construcción propia solo puede evaluarse por su descripción. No se exige en todos los casos (a) ni nunca (d), y el artículo no fija ningún umbral de potencia (b). El resto de la memoria (experimento, lugar con coordenadas, período, banda, emisión, potencia y antena) sí se presenta siempre. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 17.2 de la Orden IET/1311/2013: la solicitud de autorización especial experimental se acompaña de una memoria técnica. Entre sus datos figura la descripción del diagrama de bloques de los equipos cuando son de construcción propia (17.2.b). El resto de la memoria describe el experimento, el lugar con coordenadas, el período, la banda, la denominación de la emisión, la potencia de salida y el tipo y la ganancia de la antena.]],
)

#q("F-R8.41", "a",
  [En la memoria técnica de una autorización especial experimental, el lugar donde se efectuará la prueba se indica:],
  ([incluyendo las coordenadas geográficas de la ubicación de la instalación], [solo con el nombre del municipio], [con la cifra del distrito en el que reside el solicitante], [con el código postal del domicilio del solicitante]),
  sol: [El art. 17.2.c exige indicar el lugar de la prueba «incluyendo las coordenadas geográficas de la ubicación de la instalación» (a). Con ellas la Administración sitúa la emisión con precisión y puede fijar, en la autorización, las zonas geográficas donde no se pueden hacer emisiones por incompatibilidad con otros servicios (art. 17.3.3.º). El municipio (b), el distrito (c) o el código postal (d) no bastan para localizar una instalación experimental. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 17.2 de la Orden IET/1311/2013: la memoria técnica de la autorización especial experimental indica el lugar de la prueba con las coordenadas geográficas de la instalación (17.2.c). Además, la autorización especifica las zonas geográficas donde no podrán hacerse emisiones por incompatibilidad con otros servicios (17.3.3.º). La memoria incluye también el experimento, el período, la banda, la emisión, la potencia y la antena, y el diagrama de bloques si el equipo es de construcción propia.]],
)

#q("F-R8.42", "c",
  [Las emisiones realizadas al amparo de una autorización especial experimental (art. 17.3 de la Orden IET/1311/2013) se identifican con:],
  ([el número de la autorización especial, sin distintivo de llamada], [el distintivo de la Jefatura Provincial que tramita la solicitud], [el distintivo propio del radioaficionado o de la asociación solicitante], [un distintivo especial de una sola letra, reservado a los experimentos]),
  sol: [El art. 17.3.5.º lo dice sin rodeos: las emisiones se identifican con el distintivo propio del radioaficionado o de la asociación de radioaficionados solicitante (c). La autorización es nominativa, pero no sustituye al distintivo: no se emite con un número de autorización (a) ni con el distintivo de la Jefatura que tramita la solicitud (b). Y los sufijos de una letra (d) no se reservan a los experimentos: el art. 27 los liga a méritos y a la participación en concursos. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[El art. 17.3 de la Orden IET/1311/2013 fija las condiciones de las autorizaciones especiales experimentales: solicitud a la SETSI con al menos un mes de antelación; autorización nominativa, con plazo máximo inicial de 18 meses, ampliable; zonas geográficas excluidas; y suspensión inmediata de las emisiones si interfieren, en especial a la televisión. Las emisiones se identifican con el distintivo propio del radioaficionado o de la asociación de radioaficionados solicitante.]],
)

#q("F-R8.43", "b",
  [Según el artículo 18.3 de la Orden IET/1311/2013, la licencia de funcionamiento de una estación fija de radioaficionado queda condicionada, en cualquier caso, a:],
  ([la pertenencia del titular a una asociación de radioaficionados reconocida por la SETSI], [la ausencia de perturbaciones a otros servicios radioeléctricos autorizados y el cumplimiento de las normas sobre seguridad nacional, servidumbres, medio ambiente y ordenación del territorio], [el informe favorable de la comunidad de propietarios sobre las antenas de la estación], [una inspección anual de la Jefatura Provincial que confirme que la estación sigue en regla]),
  sol: [El art. 18.3 condiciona la licencia de una estación fija, en cualquier caso, a que no perturbe a otros servicios radioeléctricos autorizados y a que se cumplan las normas vigentes de seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente y ordenación del territorio. No se exige ser socio de ninguna asociación (a). La comunidad de propietarios puede alegar sobre la idoneidad del emplazamiento (RD 2623/1986, art. 3), pero no concede ni deniega la licencia (c). Y la Jefatura inspecciona «si lo estima conveniente» al expedirla (art. 20), no cada año (d). #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 18.3 de la Orden IET/1311/2013: la licencia de funcionamiento de una estación fija queda condicionada, en cualquier caso, a la ausencia de perturbaciones a otros servicios radioeléctricos autorizados y al cumplimiento de las disposiciones vigentes en materia de seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente, ordenación del territorio y cualquier otra que resulte de aplicación.]],
)

#q("F-R8.44", "d",
  [Los permisos o autorizaciones en materia de servidumbres aeronáuticas, medio ambiente u ordenación del territorio que exija la instalación de una estación fija de radioaficionado deben ser obtenidos, según el artículo 18.3 de la Orden IET/1311/2013, por:],
  ([la SETSI, de oficio, al tramitar la licencia], [la Jefatura Provincial de Inspección de Telecomunicaciones, al verificar la instalación], [la empresa instaladora, a su cargo, como parte del montaje], [los solicitantes de la licencia, por su cuenta y a su cargo]),
  sol: [El último inciso del art. 18.3 es claro: la obtención de los permisos o autorizaciones en materia de seguridad nacional, servidumbres, medio ambiente u ordenación del territorio es por cuenta y a cargo de los solicitantes de la licencia de la estación. No corresponde a la SETSI (a) ni a la Jefatura Provincial (b), y la empresa instaladora monta la estación, pero el coste no recae en ella (c). La razón es que la licencia depende de que se cumplan esas normas, y de ello responde quien la pide. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[La licencia de una estación fija depende de que se respeten las normas sobre seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente y ordenación del territorio (art. 18.3 de la Orden IET/1311/2013). La obtención de los permisos o autorizaciones que esas materias exijan es por cuenta y a cargo de quien solicita la licencia de la estación: no los asume la Administración de telecomunicaciones.]],
)

#q("F-R8.45", "a",
  [En el reglamento de instalación de antenas de aficionado en el exterior de los inmuebles, se denomina «plano de paso» a:],
  ([el plano o superficie situado bajo la antena y sus elementos anejos, accesible a las personas], [el plano de tierra, o conjunto de radiales, sobre el que se apoya una antena vertical], [el plano horizontal del diagrama de radiación de la antena], [el paso reservado en la azotea para tender las líneas de transmisión hasta la vivienda]),
  sol: [Es la definición del art. 1 del Real Decreto 2623/1986: el plano o superficie situado bajo la antena y sus elementos anejos al que pueden acceder las personas, por ejemplo una azotea transitable. Sirve de referencia para la altura libre de tres metros que deben dejar las antenas (art. 13.2). No es el plano de tierra de una antena vertical (b), que es un concepto radioeléctrico, ni el plano del diagrama de radiación (c). Un paso para cables (d) sería un «conducto o canalización», otro término distinto del mismo artículo. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Reglamento de antenas (Real Decreto 2623/1986, art. 1). _Elementos anejos_: todo lo que no forma parte de la antena (soporte, anclajes, riostras, rotores, etc.). _Plano de paso_: plano o superficie situado bajo la antena y sus elementos anejos, accesible a las personas (una azotea, una terraza). Se toma como referencia para dejar una altura libre de tres metros (art. 13.2), y en azoteas o lugares transitables se señalizan anclajes y riostras (art. 12.2).]],
)

#q("F-R8.46", "d",
  [En el reglamento de instalación de antenas de aficionado en el exterior de los inmuebles, se denomina «riostra» a:],
  ([el punto o elemento de fijación del mástil a la obra civil del inmueble], [el poste, metálico o de otro material, que sirve de antena o de soporte de ella], [el conducto que aloja la línea de transmisión, con su protección mecánica], [el cable, hilo u otra pieza, rígida o flexible, que asegura la estabilidad mecánica de la antena y su soporte]),
  sol: [Según el art. 1 del Real Decreto 2623/1986, la riostra es el cable, hilo u otra pieza, rígida o flexible, que sirve para asegurar la estabilidad mecánica de la antena y su soporte (los «vientos» de un mástil). No confundas los términos vecinos. El punto donde las riostras se fijan a la obra civil es el _anclaje_, no la pieza que tira de ellas (a). El mástil es el poste que sirve de antena o de soporte (b). El conducto o canalización aloja las líneas de transmisión (c). Regla: la riostra tira; el anclaje la sujeta al edificio. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Vocabulario del Reglamento de antenas (Real Decreto 2623/1986, art. 1). _Soporte_: elemento mecánico que sustenta la antena. _Mástil_: poste que sirve de antena o de soporte de ella. _Riostra_: cable, hilo u otra pieza, rígida o flexible, que asegura la estabilidad mecánica de la antena y su soporte. _Anclaje_: punto o elemento de fijación de las riostras a la obra civil del inmueble, repartiendo los esfuerzos. La riostra tira; el anclaje la agarra al edificio.]],
)

#q("F-R8.47", "b",
  [En el reglamento de instalación de antenas de aficionado en el exterior de los inmuebles, un «elemento repartidor de carga» es:],
  ([la pieza que reparte la potencia del transmisor entre las distintas antenas de un sistema radiante], [el elemento que distribuye en la obra civil del inmueble los esfuerzos transmitidos por los soportes o anclajes, manteniéndolos por debajo de los límites de seguridad], [el dispositivo que reparte la corriente de un rayo entre varias tomas de tierra], [el cable, hilo u otra pieza que asegura la estabilidad mecánica de la antena y su soporte]),
  sol: [Según el art. 1 del Real Decreto 2623/1986, el elemento repartidor de carga distribuye en la obra civil del inmueble los esfuerzos que le transmiten los soportes o anclajes, para que queden por debajo de los límites de seguridad. El art. 17 permite fijar el soporte directamente a la obra civil, en puntos aptos para esos esfuerzos, o mediante elementos repartidores de la carga debidamente dimensionados. No reparte potencia radioeléctrica (a) ni corriente de rayo (c), y la pieza que da estabilidad mecánica es la riostra (d). #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Reglamento de antenas (Real Decreto 2623/1986). Art. 1: el _elemento repartidor de carga_ distribuye en la obra civil del inmueble los esfuerzos que le transmiten los soportes o anclajes, de modo que queden por debajo de los límites de seguridad. Art. 17: los soportes se fijan directamente a la obra civil, en puntos aptos para tolerar los esfuerzos, o mediante elementos repartidores de la carga debidamente dimensionados; nunca a soportes o anclajes de pararrayos ni de conducciones aéreas de energía eléctrica.]],
)

#q("F-R8.48", "c",
  [Según el artículo 18.7 de la Orden IET/1311/2013, la condición de asociación de radioaficionados reconocida se obtiene:],
  ([automáticamente, al inscribirse la asociación en el registro del Ministerio del Interior], [por designación de la IARU Región 1 a través de su sociedad miembro en España], [por resolución de la SETSI, una vez constituida legalmente e inscrita en el Ministerio del Interior, previa solicitud acompañada de los estatutos], [por resolución del Ministerio del Interior, previa solicitud acompañada de los estatutos]),
  sol: [El art. 18.7 fija el procedimiento. La asociación ha de estar legalmente constituida y registrada en el Ministerio del Interior, y solicita el reconocimiento con sus estatutos; la condición se obtiene por resolución de la SETSI. La inscripción en el Interior es un requisito previo: no concede el reconocimiento (a) ni lo resuelve ese Ministerio (d). El art. 18.7 no atribuye ningún papel a la IARU en la concesión (b). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.7 de la Orden IET/1311/2013: la condición de asociación de radioaficionados reconocida se obtiene por resolución de la SETSI, una vez que la asociación está legalmente constituida y registrada en el Ministerio del Interior, previa solicitud acompañada de sus estatutos. Solo las asociaciones reconocidas pueden ser autorizadas a instalar estaciones colectivas de radioaficionado (art. 18.6).]],
)

#q("F-R8.49", "a",
  [Según el artículo 18.6 de la Orden IET/1311/2013, de la utilización de una estación colectiva de radioaficionado es responsable:],
  ([la Junta Directiva de la asociación titular de la estación], [el operador que transmite en cada momento, de forma exclusiva], [la Jefatura Provincial de Inspección de Telecomunicaciones], [la empresa instaladora que montó la estación]),
  sol: [El art. 18.6 reserva las estaciones colectivas a las asociaciones de radioaficionados reconocidas y hace responsable de su utilización a la Junta Directiva de la asociación. La responsabilidad recae, pues, en el órgano de gobierno de la entidad titular, no exclusivamente en el operador de turno (b). La Jefatura Provincial inspecciona, pero no responde del uso de la estación (c), y la empresa instaladora solo interviene en el montaje (d). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.4 y 18.6 de la Orden IET/1311/2013: las estaciones fijas se clasifican en individuales y colectivas, y las fijas desatendidas se consideran colectivas. Solo las asociaciones de radioaficionados reconocidas pueden ser autorizadas a instalar estaciones colectivas, y de su utilización es responsable la Junta Directiva de la asociación.]],
)

#q("F-R8.50", "d",
  [Según el artículo 18.7 de la Orden IET/1311/2013, los estatutos de una asociación que solicita ser reconocida como asociación de radioaficionados deben contemplar:],
  ([la obligación de que todos los socios sean titulares de una autorización de radioaficionado], [un número mínimo de socios y una cuota anual mínima], [la gestión de al menos un repetidor en su provincia], [como finalidades específicas las propias de los radioaficionados y la obligación de cumplir lo dispuesto en el Reglamento]),
  sol: [El art. 18.7 exige dos cosas a los estatutos: que contemplen como finalidades específicas las propias de los radioaficionados y que recojan la obligación de cumplir lo dispuesto en el Reglamento (la Orden IET/1311/2013). No exige que todos los socios tengan autorización (a), ni un mínimo de socios o de cuota (b), ni gestionar repetidores (c). Instalar estaciones colectivas es una consecuencia del reconocimiento (art. 18.6), no un requisito para obtenerlo. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.7 de la Orden IET/1311/2013: para ser reconocida, la asociación debe estar legalmente constituida y registrada en el Ministerio del Interior y solicitar el reconocimiento a la SETSI con sus estatutos. Estos deben contemplar como finalidades específicas las propias de los radioaficionados y recoger la obligación de cumplir lo dispuesto en el Reglamento. El reconocimiento se concede por resolución de la SETSI.]],
)

#q("F-R8.51", "b",
  [Según el artículo 18.8 de la Orden IET/1311/2013, las estaciones colectivas de radioaficionado precisan para su funcionamiento:],
  ([únicamente la licencia de estación fija, sin ninguna autorización de radioaficionado], [la licencia de estación y una autorización de radioaficionado individualizada, a la que se asocia la licencia y que lleva su propio distintivo de llamada], [únicamente la autorización de radioaficionado personal del presidente de la asociación], [una autorización especial de la SETSI por cada banda de frecuencias que utilicen]),
  sol: [El art. 18.8 dice que las estaciones colectivas precisan, además de la licencia de estación, una autorización de radioaficionado individualizada a la que se considera asociada esa licencia, con un distintivo de llamada asignado según los arts. 27 y 28. No basta la licencia sola (a). Tampoco se trata de la autorización personal del presidente (c) ni de autorizaciones por banda (d): las autorizaciones especiales se reservan a casos concretos, como los de los arts. 16 y 17. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.8 de la Orden IET/1311/2013: una estación colectiva precisa, además de su licencia de estación, una autorización de radioaficionado individualizada, a la que se considera asociada la licencia y a la que se asigna un distintivo de llamada específico (arts. 27 y 28). Es una autorización propia de la estación, distinta de las de sus socios.]],
)

#q("F-R8.52", "a",
  [Según el artículo 18.8 de la Orden IET/1311/2013, varias estaciones automáticas desatendidas pueden estar amparadas por una única autorización de radioaficionado cuando tienen:],
  ([el mismo tipo de modulación, la misma titularidad y la misma ubicación], [el mismo tipo de modulación y la misma ubicación, aunque pertenezcan a asociaciones distintas], [la misma titularidad y la misma ubicación, aunque emitan con distinto tipo de modulación], [el mismo tipo de modulación y la misma titularidad, aunque estén en distinta ubicación]),
  sol: [El último inciso del art. 18.8 permite que las estaciones automáticas desatendidas compartan una única autorización de radioaficionado si tienen el mismo tipo de modulación y comparten titularidad y ubicación. Las tres condiciones a la vez. Cada distractor omite una: sin la misma titularidad (b), sin el mismo tipo de modulación (c) o sin la misma ubicación (d) no se cumple el supuesto, y rige la regla general de las colectivas, una autorización individualizada. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.8 de la Orden IET/1311/2013: cada estación colectiva precisa su licencia y una autorización de radioaficionado individualizada con su distintivo. Excepción: las estaciones automáticas desatendidas (repetidores, radiobalizas, etc.) que tengan el mismo tipo de modulación y compartan titularidad y ubicación pueden estar amparadas por una única autorización de radioaficionado.]],
)

#q("F-R8.53", "c",
  [Según el artículo 20 de la Orden IET/1311/2013, terminada la instalación de una estación fija en las condiciones autorizadas, el interesado debe comunicarlo a la Jefatura Provincial, justificando documentalmente que el seguro de responsabilidad civil está cubierto, en un plazo de:],
  ([15 días], [30 días], [6 semanas], [60 días]),
  sol: [Art. 20, primer párrafo: finalizada la instalación, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con justificante fehaciente del seguro de responsabilidad civil y, en su caso, el boletín de la empresa instaladora. No mezcles las cifras del artículo: los 30 días son el plazo máximo de la Jefatura para verificar y expedir la licencia, y los 60 días, el límite de las modificaciones experimentales. Los 15 días son la duración máxima de los usos portables no continuados que no precisan notificación (art. 17.1), otro asunto. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 20 de la Orden IET/1311/2013 (licencia de estación fija), tres cifras. 1) Terminada la instalación, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con justificante del seguro de responsabilidad civil y, en su caso, el boletín de la empresa instaladora. 2) La Jefatura dispone de 30 días como máximo para verificar, inspeccionar si lo estima conveniente y expedir la licencia. 3) Con la licencia, las modificaciones experimentales pueden durar hasta 60 días.]],
)

#q("F-R8.54", "b",
  [Según el artículo 20 de la Orden IET/1311/2013, recibida la documentación de fin de instalación de una estación fija, la Jefatura Provincial de Inspección de Telecomunicaciones dispone de un plazo máximo, para verificar su idoneidad, inspeccionar la instalación si lo estima conveniente y expedir la licencia si el resultado es positivo, de:],
  ([10 días], [30 días], [60 días], [tres meses]),
  sol: [Art. 20, segundo párrafo: recibida la documentación, la Jefatura dispone de un plazo máximo de 30 días para verificar su idoneidad, inspeccionar la instalación si lo estima conveniente y, si el resultado es positivo, expedir la licencia, que es lo que habilita a empezar a emitir. Los 60 días (c) son el período de las modificaciones experimentales posteriores a la licencia, y las 6 semanas, el plazo del interesado para comunicar el fin de la instalación. Ni 10 días (a) ni tres meses (d) figuran en este artículo. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 20 de la Orden IET/1311/2013: recibida la documentación de fin de instalación (justificante del seguro y, en su caso, boletín del instalador), la Jefatura Provincial dispone de 30 días como máximo para verificar su idoneidad, inspeccionar la instalación si lo estima conveniente y expedir la licencia. La licencia es lo que habilita al titular a comenzar las emisiones. El interesado, por su parte, tiene 6 semanas para comunicar el fin de la instalación.]],
)

#q("F-R8.55", "c",
  [Según el artículo 20 de la Orden IET/1311/2013, una vez obtenida la licencia de una estación fija, su titular puede realizar con carácter experimental cualquier modificación en las instalaciones y equipos de la estación, siempre que no afecte a la seguridad, por un período máximo de:],
  ([15 días], [30 días], [60 días], [seis meses]),
  sol: [Art. 20, tercer párrafo: con la licencia concedida, el titular puede modificar con carácter experimental las instalaciones y equipos durante un máximo de 60 días, siempre que no afecte a la seguridad. Si la modificación se hace permanente, remite a la SETSI la documentación complementaria con los cambios; si cambia la ubicación de la antena, se solicita como una primera instalación. Los 30 días son el plazo de la Jefatura para expedir la licencia, y los 15 días, el de los usos portables sin notificación. Los seis meses no figuran en este artículo. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 20 de la Orden IET/1311/2013: una vez obtenida la licencia, el titular puede hacer con carácter experimental cualquier modificación en las instalaciones y equipos de la estación durante un máximo de 60 días, siempre que no afecte a la seguridad. Si la modificación es permanente, remite a la SETSI la documentación complementaria, con los cambios incluidos. Si cambia la ubicación de la antena, se solicita a la SETSI como una primera instalación.]],
)

#q("F-R8.56", "b",
  [Según el art. 23 de la Orden IET/1311/2013, las estaciones de radioaficionado pueden interconectarse a través de otras instalaciones de telecomunicación autorizadas siempre que la interconexión se realice:],
  ([únicamente en situaciones de emergencia o desastre], [con fines relacionados con la actividad de la radioafición], [con fines comerciales, siempre que el operador de la red lo consienta], [sin que cada enlace supere los diez minutos de duración]),
  sol: [El art. 23 permite la interconexión con otras instalaciones de telecomunicación autorizadas con una condición: que tenga fines relacionados con la actividad de la radioafición. No se limita a las emergencias: el tráfico en nombre de terceros sí queda restringido a emergencias o desastres, pero es otra regla (art. 30.3). Tampoco fija una duración máxima por enlace. Y los fines comerciales quedan fuera de lo que define al Servicio de Aficionados: instrucción individual, intercomunicación y estudios técnicos (anexo I). #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 23 de la Orden IET/1311/2013: las estaciones de radioaficionado pueden interconectarse a través de otras instalaciones de telecomunicación autorizadas si la finalidad está relacionada con la radioafición. Los dispositivos que se usen para conectarse a redes públicas deben estar diseñados y construidos de forma que no puedan causar daños ni interferencias a las redes a las que se conecten. Si se emplea el dominio público radioeléctrico, rigen además el propio reglamento y el reglamento de uso del espectro radioeléctrico.]],
)

#q("F-R8.57", "a",
  [Según el art. 23 de la Orden IET/1311/2013, cuando el acceso a un repetidor analógico-digital se realiza a través de una red pública, el repetidor solo será accesible mediante:],
  ([un código personal e intransferible, distinto para cada usuario, y el distintivo de la estación del operador], [solo el distintivo de la estación del operador, sin necesidad de ningún código], [un código personal que cada usuario puede ceder a otros radioaficionados de confianza, junto con el distintivo de su estación], [una clave reservada a los socios de la asociación titular del repetidor]),
  sol: [Art. 23, tercer párrafo: si el acceso se hace a través de una red pública, el repetidor analógico-digital solo es accesible con un código y el distintivo de la estación del operador. El código es personal, intransferible y distinto para cada usuario. Falla la b porque omite el código; la c, porque el código no puede cederse a nadie; y la d, porque el responsable del repetidor está obligado a facilitar la clave a todo radioaficionado que la pida, no solo a los socios. Los enlaces entre repetidores exigen esos mismos códigos. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Un repetidor analógico-digital es una estación repetidora dotada de conversores analógico-digital/digital-analógico. Cuando el acceso a él se hace a través de una red pública, el art. 23 de la Orden IET/1311/2013 exige dos elementos: un código y el distintivo de la estación del operador. El código es personal, intransferible y distinto para cada usuario. La misma exigencia rige si se utilizan enlaces entre repetidores. No confundir con el art. 25.c: el acceso a los repetidores analógicos y digitales finales es libre y, si llevan código, este debe ser públicamente conocido.]],
)

#q("F-R8.58", "c",
  [Según el art. 23 de la Orden IET/1311/2013, en los repetidores analógico-digitales accesibles mediante código a través de una red pública, el responsable del repetidor está obligado a:],
  ([reservar las claves de acceso a los socios de su asociación], [entregar las claves de acceso solo a los radioaficionados que abonen una cuota], [facilitar las claves de acceso a todo radioaficionado que lo solicite], [comunicar las claves únicamente a la Jefatura Provincial de Inspección de Telecomunicaciones]),
  sol: [Art. 23, tercer párrafo: el responsable del repetidor está obligado a facilitar las claves de acceso a todo radioaficionado que lo solicite. La obligación alcanza a cualquiera que las pida; por eso no puede reservarlas a los socios (a), ni entregarlas solo a quien pague una cuota (b), ni limitarse a comunicarlas a la Jefatura Provincial (d). Es coherente con el art. 25.c, que declara necesariamente libre el acceso a los repetidores analógicos y digitales finales y exige que su código, si lo hay, sea públicamente conocido. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[El art. 23 de la Orden IET/1311/2013 impone al responsable de un repetidor analógico-digital, accesible mediante código a través de una red pública, la obligación de facilitar las claves de acceso a todo radioaficionado que lo solicite. Va en la misma línea el art. 25.c: el acceso a los repetidores analógicos y digitales finales será necesariamente libre y, si la estación tiene código de acceso, este deberá ser públicamente conocido.]],
)

#q("F-R8.59", "d",
  [Según el art. 24 de la Orden IET/1311/2013, se consideran estaciones automáticas desatendidas:],
  ([los repetidores analógicos y digitales, sin incluir las radiobalizas], [todas las estaciones colectivas de las asociaciones de radioaficionados], [los repetidores analógicos y digitales y las estaciones temporales de concursos y expediciones], [los repetidores analógicos, los repetidores digitales, los repetidores de portadora o nodo, los repetidores finales y las radiobalizas]),
  sol: [El art. 24 enumera las estaciones automáticas desatendidas: repetidores analógicos, digitales, de portadora o nodo y finales, y radiobalizas, más cualquier otra estación que encaje en la definición del anexo I (estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador). La a excluye las radiobalizas, que sí figuran. La c omite las radiobalizas y añade las estaciones temporales, que no están en el art. 24. La b confunde los términos: toda desatendida es colectiva, pero no toda colectiva es desatendida. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Clases del art. 24 de la Orden IET/1311/2013: repetidor analógico; repetidor digital; repetidor de portadora o nodo (repetidor digital que enlaza únicamente con otros repetidores digitales); repetidor final (repetidor digital que distribuye el tráfico de otros repetidores digitales a las estaciones de cada radioaficionado); y radiobaliza. Se añade cualquier otra estación que se ajuste a la definición del anexo I: estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador.]],
)

#q("F-R8.60", "b",
  [Según el art. 25.b de la Orden IET/1311/2013, toda interrupción de las emisiones de una estación automática desatendida por un período superior a un cierto plazo, salvo causas de fuerza mayor, puede dar lugar a la apertura de actuaciones para cancelar su licencia y otorgar la autorización a otra asociación interesada. Ese plazo es de:],
  ([un mes], [tres meses], [seis meses], [un año]),
  sol: [El art. 25.b fija en tres meses la interrupción de emisiones, salvo fuerza mayor, a partir de la cual puede abrirse el procedimiento para cancelar la licencia y, en su caso, otorgar la autorización a otra asociación interesada. Se hace para asegurar que estas estaciones funcionen el máximo tiempo posible, dado su interés técnico. No es una cancelación automática: la norma habla de apertura de actuaciones. No hay que confundirlo con los seis meses del art. 26, que son el plazo para terminar una instalación ya autorizada. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.b de la Orden IET/1311/2013: para asegurar que las estaciones automáticas desatendidas funcionen el máximo tiempo posible, toda interrupción de emisiones superior a tres meses, salvo causas de fuerza mayor, puede dar lugar a la apertura de actuaciones para cancelar la licencia y, en su caso, para otorgar la autorización a otra asociación interesada. Los seis meses del art. 26 son otro plazo: el que tiene la asociación para terminar una instalación ya autorizada.]],
)

#q("F-R8.61", "c",
  [Según el art. 25.e de la Orden IET/1311/2013, el intervalo máximo permitido entre dos transmisiones sucesivas del distintivo de una radiobaliza del Servicio de Aficionados es de:],
  ([un minuto], [dos minutos], [tres minutos], [diez minutos]),
  sol: [El art. 25.e dispone que las radiobalizas transmitan su distintivo a intervalos no superiores a tres minutos. El distractor más tentador es el de diez minutos: es el intervalo máximo de los repetidores analógicos (art. 25.d) y el que se exige a toda estación en emisiones de larga duración (art. 29.1). Para una radiobaliza, que funciona emitiendo automáticamente señales de identificación (anexo I), la norma es más estricta. Uno y dos minutos son cifras que la Orden no recoge. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.e de la Orden IET/1311/2013: las radiobalizas transmiten su distintivo a intervalos no superiores a tres minutos. Una radiobaliza es una estación automática desatendida destinada a estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación. Los repetidores analógicos, en cambio, emiten su distintivo a intervalos no superiores a diez minutos y, en Morse, a una velocidad no superior a diez palabras por minuto (art. 25.d).]],
)

#q("F-R8.62", "a",
  [Según el art. 25.f de la Orden IET/1311/2013, salvo casos excepcionales debidamente justificados, la información transmitida por una radiobaliza del Servicio de Aficionados se refiere únicamente a:],
  ([su posición y sus condiciones de funcionamiento], [la previsión meteorológica de su zona], [mensajes y boletines de la asociación titular], [el nombre y la dirección del radioaficionado que la mantiene]),
  sol: [Art. 25.f: salvo casos excepcionales debidamente justificados, la información que transmite una radiobaliza se refiere únicamente a su posición y a sus condiciones de funcionamiento. No lleva previsiones meteorológicas, boletines de la asociación ni datos personales de quien la mantiene. Es una estación automática desatendida cuyo funcionamiento se basa en emitir señales de identificación, y su utilidad para los aficionados es que se la pueda oír para estudiar la propagación (anexo I). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.f de la Orden IET/1311/2013: salvo casos excepcionales debidamente justificados, la información transmitida por una radiobaliza se refiere únicamente a su posición y a sus condiciones de funcionamiento, y su sistema radiante será, como norma general, omnidireccional. Junto con el distintivo a intervalos no superiores a tres minutos (art. 25.e), son las condiciones propias de las radiobalizas.]],
)

#q("F-R8.63", "d",
  [Según el art. 25.f de la Orden IET/1311/2013, el sistema radiante de una radiobaliza del Servicio de Aficionados será, como norma general:],
  ([directivo, con una antena Yagi de alta ganancia para aumentar el alcance], [de polarización circular, obligatoriamente], [un dipolo horizontal orientado de este a oeste], [omnidireccional]),
  sol: [Art. 25.f: el sistema radiante de una radiobaliza será, como norma general, omnidireccional. La lógica es clara: una baliza sirve para que cualquier estación la oiga, esté en la dirección que esté, y pueda valorar así la propagación. Una Yagi (a) concentra la señal en una dirección y deja sin ella las demás; un dipolo horizontal (c) tiene nulos marcados en la dirección de su eje. La polarización circular (b) no se exige en la norma. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.f de la Orden IET/1311/2013: el sistema radiante de una radiobaliza será, como norma general, omnidireccional, es decir, radiará por igual en todas las direcciones del plano horizontal, de modo que cualquier estación pueda oírla sea cual sea su posición. Una antena directiva, como una Yagi, concentra la señal en una dirección y deja sin cobertura las demás, por eso no es lo habitual en una baliza.]],
)

#q("F-R8.64", "b",
  [Según el art. 25.g de la Orden IET/1311/2013, las estaciones repetidoras y las radiobalizas deberán disponer de:],
  ([un dispositivo de encendido y apagado por telemando y un sistema de alimentación ininterrumpida de al menos veinticuatro horas], [un dispositivo de encendido y apagado por telemando y un sistema de alimentación ininterrumpida de al menos seis horas], [un operador que las vigile de forma permanente y un sistema de alimentación ininterrumpida de al menos seis horas], [un grupo electrógeno propio y un duplicado completo de sus equipos emisores]),
  sol: [Art. 25.g: repetidores y radiobalizas deben tener un dispositivo de encendido y apagado por telemando (a distancia) y un sistema de alimentación ininterrumpida que las mantenga funcionando como mínimo seis horas si falla la alimentación externa. La a da una cifra errónea (veinticuatro horas). La c exige un operador de guardia, contrario a la idea misma de estación desatendida (anexo I). La d pide un grupo electrógeno y duplicar los equipos, cosas que la norma no contempla. #_apc3-ver[(Véase tema R8, introducción (tabla de cifras: alimentación ininterrumpida de 6 horas).)]

#_apc3-net[Art. 25.g de la Orden IET/1311/2013: las estaciones repetidoras y las radiobalizas deben disponer de un dispositivo de encendido y apagado por telemando, es decir, por mando a distancia, de modo que se puedan conectar o desconectar sin acudir al emplazamiento. Deben tener además un sistema de alimentación ininterrumpida que les permita funcionar, como mínimo, seis horas si falla la alimentación externa.]],
)

#q("F-R8.65", "c",
  [Autorizada la instalación de una estación automática desatendida, la asociación de radioaficionados solicitante dispone de un plazo para finalizarla; su incumplimiento supone la caducidad de la autorización de instalación. Según el art. 26 de la Orden IET/1311/2013, ese plazo es de:],
  ([seis semanas], [tres meses], [seis meses], [dieciocho meses]),
  sol: [Art. 26, primer párrafo: autorizada la instalación, la asociación solicitante dispone de seis meses para finalizarla, y el incumplimiento supone la caducidad de la autorización de instalación. Conviene no mezclar cifras de la Orden: seis semanas es el plazo que tiene la Administración para resolver las solicitudes (art. 4); tres meses, la interrupción de emisiones de una desatendida en funcionamiento que puede abrir actuaciones de cancelación (art. 25.b); dieciocho meses, el plazo máximo inicial de una autorización experimental (art. 17.3). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 26 de la Orden IET/1311/2013: autorizada la instalación de una estación automática desatendida, la asociación solicitante tiene seis meses para finalizarla. Si no lo hace, caduca la autorización de instalación. Terminada la instalación se aplica el procedimiento del art. 20 (comunicación a la Jefatura Provincial y expedición de la licencia de estación). Si hay interferencia perjudicial a otros servicios legalmente autorizados, se aplica el art. 32.]],
)

#q("F-R8.66", "a",
  [Según el art. 26 de la Orden IET/1311/2013, finalizada la instalación de una estación automática desatendida será de aplicación el procedimiento establecido para:],
  ([la expedición de la licencia de estación fija (art. 20)], [el otorgamiento de la autorización de radioaficionado (arts. 5 a 7)], [la autorización especial de uso experimental (art. 17)], [el reconocimiento de la condición de asociación de radioaficionados (art. 18.7)]),
  sol: [Art. 26, segundo párrafo: terminada la instalación se aplica el procedimiento del art. 20, el de expedición de la licencia de estación fija. El interesado comunica a la Jefatura Provincial, en seis semanas, que ha terminado, justificando que la responsabilidad está cubierta con el seguro; la Jefatura dispone de un máximo de 30 días para verificar la idoneidad y expedir la licencia, que habilita a emitir. Las otras opciones son trámites distintos: la autorización personal, la experimental y el reconocimiento de la asociación, que ya debe tenerse para pedir la instalación. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 26, segundo párrafo, de la Orden IET/1311/2013: terminada la instalación de una estación automática desatendida se sigue el procedimiento del art. 20, el de la licencia de estación fija. El interesado comunica a la Jefatura Provincial, en seis semanas, que ha finalizado, justificando que la responsabilidad está cubierta con el seguro y aportando, en su caso, el boletín de instalación. La Jefatura dispone de 30 días para verificar la idoneidad y expedir la licencia, que habilita a empezar las emisiones.]],
)

#q("F-R8.67", "d",
  [Si una estación automática desatendida causa interferencia perjudicial a otros servicios legalmente autorizados, el art. 26 de la Orden IET/1311/2013 remite al art. 32. Según este, si tras adoptar las medidas técnicas exigidas la interferencia persiste, la SETSI podrá imponer, excepcionalmente, restricciones en cuanto a:],
  ([la ubicación de la estación y el tipo de antena utilizada], [el tipo de modulación y el número de operadores autorizados], [el distintivo de llamada y la titularidad de la estación], [las bandas de frecuencias, la potencia o el horario de las emisiones]),
  sol: [El art. 26 remite al art. 32, que actúa en tres pasos. Si la SETSI comprueba la interferencia, el titular cesa sus emisiones y adopta a su costa medidas técnicas razonables. Tras comunicar esas medidas a la SETSI puede reiniciar sin más trámite. Si la interferencia persiste, la SETSI puede imponer, con carácter excepcional, restricciones en cuanto a las bandas de frecuencias, la potencia o el horario de las emisiones. Ubicación, antena, modulación, distintivo y titularidad no figuran entre ellas. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 32 de la Orden IET/1311/2013 (interferencia perjudicial a otros servicios autorizados o a la recepción de radiodifusión sonora o de televisión). 1.º Comprobada por la SETSI, el titular cesa las emisiones y, siguiendo sus instrucciones, adopta a su costa medidas técnicas razonables. 2.º Comunica esas medidas a la SETSI de forma fehaciente y puede reiniciar sin más trámite. 3.º Si la interferencia persiste, la SETSI puede imponer, excepcionalmente, restricciones de bandas, potencia u horario.]],
)

#q("F-R8.68", "b",
  [Según el art. 30.2 de la Orden IET/1311/2013, las transmisiones entre estaciones y equipos de aficionado no deberán codificarse para ocultar su significado, excepto:],
  ([las comunicaciones de emergencia o desastre realizadas en nombre de terceros], [las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite], [las transmisiones de concursos entre estaciones de países distintos], [las comunicaciones entre estaciones de una misma asociación de radioaficionados]),
  sol: [Art. 30.2: las transmisiones entre estaciones y equipos de aficionado no deben codificarse para ocultar su significado; la única excepción son las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite. Es una excepción estrecha, limitada al mando de esas estaciones espaciales. Ni las emergencias (a), ni los concursos (c), ni las comunicaciones internas de una asociación (d) autorizan a cifrar el contenido. El tráfico en nombre de terceros en casos de emergencia o desastre es otra regla distinta (art. 30.3). #_apc3-ver[(Véase tema R7, introducción (se transmite en lenguaje claro y sin codificar el significado).)]

#_apc3-net[Art. 30.2 de la Orden IET/1311/2013: las transmisiones entre estaciones y equipos de aficionado no deberán codificarse para ocultar su significado. La única excepción son las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite, que utiliza estaciones espaciales situadas en satélites de la Tierra para los mismos fines que el Servicio de Aficionados.]],
)

#q("F-R8.69", "c",
  [Según el artículo 30.6 de la Orden IET/1311/2013, las estaciones colectivas pueden ser utilizadas esporádicamente por personas noveles, con fines de divulgación, bajo la responsabilidad y supervisión directa y presencial de un radioaficionado autorizado con una antigüedad mínima en el ejercicio de la radioafición de:],
  ([un año], [dos años], [tres años], [cinco años]),
  sol: [El artículo 30.6.b exige que el uso por noveles se haga bajo la responsabilidad y la supervisión directa y presencial de un radioaficionado autorizado con al menos tres años de antigüedad en el ejercicio de la radioafición. Uno o dos años se quedan cortos. Cinco años es la antigüedad de autorización española que el artículo 27 pide para un sufijo de dos letras: es otro supuesto, sin relación con la divulgación. Recuerda además que el uso debe ser esporádico, en demostraciones, cursos o eventos sin ánimo de lucro y de corta duración (30.6.a). #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]],
)

#q("F-R8.70", "d",
  [Según el artículo 30.6 de la Orden IET/1311/2013, cuando personas noveles utilizan esporádicamente una estación colectiva con fines de divulgación, las emisiones se identifican mediante:],
  ([el distintivo personal del radioaficionado que supervisa, sin añadido alguno], [el distintivo de la estación colectiva, sin añadido alguno], [el distintivo de la estación colectiva seguido, tras el sufijo, de una cifra de libre elección], [el distintivo de la estación colectiva seguido, tras el sufijo, de dos o tres letras de libre elección]),
  sol: [El artículo 30.6.c dispone que las emisiones se identifiquen con el distintivo de la estación colectiva seguido, tras el sufijo, de dos o tres letras de libre elección. No basta el distintivo de la colectiva solo (b), ni se emite con el del supervisor (a), ni lo que se añade es una cifra (c): son letras, dos o tres, y van después del sufijo. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]],
)

#q("F-R8.71", "b",
  [Un novel utiliza esporádicamente, con fines de divulgación y bajo supervisión, la estación colectiva de una asociación en la banda de 20 m, cuyo máximo general en la Orden IET/1311/2013 es de 1000 W p.c.e. Según el artículo 30.6.d, la potencia de sus emisiones no superará:],
  ([40 W], [100 W], [400 W], [1000 W]),
  sol: [El artículo 30.6.d impone dos topes a los noveles en estaciones colectivas: el 40 % del máximo de la banda y, en cualquier caso, 100 W (p.i.r.e.). En 20 m el máximo es 1000 W p.c.e. (Anexo I, 3.1) y el 40 % sería $0,40 times 1000 = 400$ W, pero el tope absoluto de 100 W prevalece. Los 400 W olvidan el tope; los 1000 W ignoran los dos límites; los 40 W salen de aplicar el 40 % al tope, y la norma no dice eso. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]],
)

#q("F-R8.72", "a",
  [Según el artículo 31 de la Orden IET/1311/2013, cuando una instalación de radioaficionado incumple las normas de seguridad aplicables, la SETSI:],
  ([no es responsable en ningún caso del incumplimiento de tales normas], [responde subsidiariamente de los daños causados a terceros], [comparte la responsabilidad con el titular si concedió la licencia de la estación], [responde solo si la Jefatura Provincial había inspeccionado antes la instalación]),
  sol: [El artículo 31 pone la obligación en el titular de la autorización: cumplir la normativa de seguridad de las Administraciones competentes para evitar accidentes derivados del uso de sus estaciones. Y cierra con una frase tajante: la SETSI no es responsable, en ningún caso, del incumplimiento de tales normas. De ahí que no haya responsabilidad subsidiaria (b), ni compartida por haber concedido la licencia (c), ni condicionada a una inspección previa (d): conceder la autorización no traslada la responsabilidad a la Administración. #_apc3-ver[(Véase tema T10, sección «Fusibles y protecciones» (última pregunta del capítulo: obligación del titular de cumplir la normativa de seguridad).)]

#_apc3-net[Art. 31 de la Orden IET/1311/2013: el titular de la autorización debe cumplir la normativa de seguridad que establezcan las distintas Administraciones Públicas, según sus competencias, para evitar cualquier accidente derivado del uso de sus estaciones. Equipos, antenas y elementos anejos deben mantenerse adecuadamente, y cualquier anomalía que afecte a su seguridad mecánica o eléctrica se subsana de forma inmediata. La SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. Los titulares de licencias de estaciones fijas garantizan además el uso conforme a la legislación, también a través de su interconexión con otras redes o servicios.]],
)

#q("F-R8.73", "d",
  [Según el artículo 31 de la Orden IET/1311/2013, si el titular observa una anomalía que afecta a la seguridad mecánica o eléctrica de los equipos, las antenas o los elementos anejos de su estación, debe:],
  ([esperar a la siguiente inspección de la Jefatura Provincial], [subsanarla en un plazo máximo de un mes], [comunicarla a la SETSI y esperar su autorización antes de repararla], [subsanarla de forma inmediata]),
  sol: [El artículo 31 obliga a mantener adecuadamente equipos, antenas y elementos anejos y a subsanar de forma inmediata cualquier anomalía que afecte a su seguridad, tanto mecánica como eléctrica. No hay plazo de gracia (b), ni se espera a una inspección (a), ni se pide permiso a la SETSI (c): la obligación nace en cuanto el titular observa la anomalía. Piensa en una riostra floja o un cable pelado: se arregla ese día, no el mes que viene. #_apc3-ver[(Véase tema T10, sección «Fusibles y protecciones» (última pregunta del capítulo: obligación del titular de cumplir la normativa de seguridad).)]

#_apc3-net[Art. 31 de la Orden IET/1311/2013: el titular de la autorización debe cumplir la normativa de seguridad que establezcan las distintas Administraciones Públicas, según sus competencias, para evitar cualquier accidente derivado del uso de sus estaciones. Equipos, antenas y elementos anejos deben mantenerse adecuadamente, y cualquier anomalía que afecte a su seguridad mecánica o eléctrica se subsana de forma inmediata. La SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. Los titulares de licencias de estaciones fijas garantizan además el uso conforme a la legislación, también a través de su interconexión con otras redes o servicios.]],
)

#q("F-R8.74", "c",
  [Según la disposición final segunda de la Orden IET/1311/2013, la SETSI está facultada para:],
  ([modificar por resolución el articulado del Reglamento cuando lo aconsejen las necesidades del Servicio de Aficionados], [fijar la cuantía de las tasas por el uso del dominio público radioeléctrico], [dictar las instrucciones necesarias para aplicar el Reglamento y revisar el contenido técnico de sus anexos, para actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional], [ampliar por resolución la vigencia de las autorizaciones de uso especial del dominio público radioeléctrico]),
  sol: [La disposición final segunda faculta a la SETSI, en su apartado 1, para dictar las instrucciones necesarias para aplicar el Reglamento y para revisar el contenido técnico de sus anexos, con el fin de actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional; y, en el apartado 2, para establecer los modelos de solicitud, que serán públicos y accesibles en la sede electrónica del Ministerio. Nada dice de reescribir los artículos (a), de fijar tasas (b) ni de prorrogar autorizaciones (d): la disposición transitoria única ya conserva la vigencia de las existentes. #_apc3-ver[(Véase tema R8, introducción del capítulo (marco normativo: la Orden IET/1311/2013 como norma de detalle).)]

#_apc3-net[Disposiciones de la Orden IET/1311/2013: la final segunda faculta a la SETSI para dictar las instrucciones necesarias para aplicar el Reglamento, para revisar el contenido técnico de sus anexos y actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional, y para establecer los modelos de solicitud, que deben ser públicos y accesibles en la sede electrónica del Ministerio. La transitoria única mantiene la vigencia de las autorizaciones existentes y la derogatoria única deroga la Orden ITC/1791/2006.]],
)

#q("F-R8.75", "a",
  [Según el Real Decreto 2623/1986, cuando las obras necesarias en el inmueble tienen carácter de indudable urgencia, la propiedad puede desmontar las antenas de la estación de aficionado y sus elementos anejos:],
  ([sin los trámites ni los plazos de las obras ordinarias, pero comunicándolo inmediatamente al titular de la licencia], [sin comunicárselo a nadie, porque la urgencia exime de cualquier aviso], [solo tras avisar al titular de la licencia con un mes de antelación, como en cualquier otra obra], [previa autorización de la Jefatura Provincial de Inspección de Telecomunicaciones]),
  sol: [Art. 6 del Real Decreto 2623/1986: en las obras ordinarias la propiedad avisa de forma fehaciente al titular con un mes de antelación, para que desmonte él mismo la instalación o lo presencie. Art. 7: si las obras son de indudable urgencia, puede desmontar las antenas sin esos trámites y plazos, pero debe poner inmediatamente en conocimiento del titular la realización de las obras. La urgencia exime del plazo, no del aviso: por eso b es falsa. La c aplica la regla ordinaria y la d inventa una autorización que el Real Decreto no pide. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Real Decreto 2623/1986 (arts. 6 y 7): si la propiedad debe hacer obras necesarias que obliguen a desmontar y volver a montar la antena, lo comunica de forma fehaciente al titular de la licencia con un mes de antelación, para que desmonte él mismo o lo presencie. Si las obras son de indudable urgencia, puede desmontar sin esos trámites ni plazos, pero debe avisar inmediatamente al titular. Terminadas las obras, la instalación queda en condiciones similares a las anteriores y el titular no puede exigir indemnización (art. 6.2).]],
)

#q("F-R8.76", "b",
  [Según el Real Decreto 2623/1986, mientras las antenas permanecen desmontadas por razón de obras en el inmueble y siempre que sea posible, puede autorizarse una instalación provisional compatible con las obras. ¿Quién la autoriza y quién corre con sus gastos?],
  ([La comunidad de propietarios la autoriza y el titular de la licencia paga los gastos.], [La Administración de telecomunicaciones la autoriza y los gastos corren por cuenta del titular de la licencia.], [La Administración de telecomunicaciones la autoriza y asume ella los gastos.], [La comunidad de propietarios la autoriza y corre con los gastos, por ser quien causa el desmontaje.]),
  sol: [El art. 8 del Real Decreto 2623/1986 prevé que, mientras las antenas y elementos anejos estén desmontados por las obras y siempre que sea posible, la Administración (entonces, la Dirección General de Telecomunicaciones) pueda autorizar una instalación provisional compatible con ellas, y que sus gastos son de cuenta del titular de la licencia. La autoriza la Administración, no la comunidad, y la paga el radioaficionado: es coherente con la Ley 19/1983 (art. 2), que pone a su cargo los daños y perjuicios de la instalación, la conservación y el desmontaje. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Real Decreto 2623/1986, art. 8: mientras las antenas y elementos anejos deban permanecer desmontados por las obras del inmueble, y siempre que ello sea posible, la Administración puede autorizar una instalación provisional compatible con las obras. Los gastos de esa instalación provisional corren por cuenta del titular de la licencia de estación, que tampoco puede exigir indemnización por el desmontaje (art. 6.2).]],
)

#q("F-R8.77", "d",
  [Según el Anexo I de la Orden IET/1311/2013, una «estación repetidora de portadora o nodo» es una estación repetidora digital destinada a:],
  ([distribuir el tráfico a las estaciones de cada radioaficionado], [convertir señales analógicas en digitales y viceversa], [emitir señales de identificación para estudios de propagación], [enlazar únicamente con otras estaciones repetidoras digitales]),
  sol: [El Anexo I define la estación repetidora de portadora o nodo como una estación repetidora digital destinada a enlazar únicamente con otras estaciones repetidoras digitales: es un eslabón entre repetidoras. Distribuir el tráfico a las estaciones de cada radioaficionado es la función de la repetidora final (a); convertir señales analógicas en digitales y viceversa es lo propio del repetidor analógico-digital (b), y emitir señales automáticas de identificación para estudios de propagación define a la radiobaliza (c). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Anexo I de la Orden IET/1311/2013: la estación repetidora digital es una repetidora de radioaficionado que retransmite emisiones digitales para ampliar el alcance de las comunicaciones. La estación repetidora de portadora o nodo es la destinada a enlazar únicamente con otras repetidoras digitales; la estación repetidora final procesa o distribuye el tráfico procedente de otras repetidoras digitales a las estaciones de cada radioaficionado y viceversa. El repetidor analógico-digital es el que dispone de conversores analógico-digital y digital-analógico.]],
)

#q("F-R8.78", "a",
  [Según el Anexo I de la Orden IET/1311/2013, una «estación repetidora final» es una estación repetidora digital que tiene por objeto:],
  ([procesar o distribuir el tráfico procedente de otras repetidoras digitales a las estaciones de cada radioaficionado y viceversa], [enlazar únicamente con otras estaciones repetidoras digitales], [convertir señales analógicas en digitales y viceversa], [emitir señales de identificación para estudios de propagación]),
  sol: [Según el Anexo I, la estación repetidora final es una repetidora digital cuyo objeto es procesar o distribuir el tráfico procedente de otras repetidoras digitales a las estaciones de cada radioaficionado y viceversa: es el extremo de la red, el que reparte hacia los usuarios. Enlazar únicamente con otras repetidoras digitales es la definición de la repetidora de portadora o nodo (b); convertir señales analógicas en digitales es el repetidor analógico-digital (c); y emitir señales de identificación para estudios de propagación, la radiobaliza (d). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Anexo I de la Orden IET/1311/2013: la estación repetidora digital es una repetidora de radioaficionado que retransmite emisiones digitales para ampliar el alcance de las comunicaciones. La estación repetidora de portadora o nodo es la destinada a enlazar únicamente con otras repetidoras digitales; la estación repetidora final procesa o distribuye el tráfico procedente de otras repetidoras digitales a las estaciones de cada radioaficionado y viceversa. El repetidor analógico-digital es el que dispone de conversores analógico-digital y digital-analógico.]],
)

#q("F-R8.79", "c",
  [Según el Anexo I de la Orden IET/1311/2013, una «estación temporal de radioaficionado» es la utilizada con carácter temporal para actividades relacionadas con:],
  ([la retransmisión automática de las emisiones recibidas para ampliar el alcance de las comunicaciones], [la emisión automática de señales de identificación para estudios de propagación], [concursos y diplomas, expediciones, demostraciones en colegios, ferias y otros eventos de similar naturaleza], [la estancia temporal en España de un radioaficionado extranjero con licencia CEPT]),
  sol: [El Anexo I define la estación temporal como la utilizada con carácter temporal para actividades relacionadas con concursos y diplomas, expediciones, demostraciones en colegios, ferias y otros eventos de similar naturaleza. No es la estación portable (una fija usada temporalmente en una ubicación distinta de la habitual). Retransmitir automáticamente las emisiones es lo propio del repetidor (a) y emitir señales automáticas de identificación para estudios de propagación, de la radiobaliza (b). La estancia de un extranjero con licencia CEPT (d) no figura en la definición. #_apc3-ver[(Véase tema R8, sección «Tipos de estación» (definiciones del Anexo I, recogidas en la solución de la pregunta complementaria sobre la estación móvil).)]],
)

#q("F-R8.80", "b",
  [Según el Anexo I de la Orden IET/1311/2013, las estaciones de un servicio con categoría secundaria:],
  ([tienen derecho a protección frente a las interferencias de las estaciones de un servicio primario, pero no deben causarles interferencia], [no deben causar interferencia perjudicial a las estaciones de un servicio primario ni pueden reclamar protección frente a las interferencias perjudiciales que estas les causen], [no deben causar interferencia perjudicial a las estaciones de un servicio primario que ya tengan frecuencias asignadas, pero pueden causarla a las que las reciban después], [pueden causar interferencia a las estaciones de un servicio primario siempre que limiten su potencia al 50 % del valor de la tabla]),
  sol: [La categoría de servicio secundario, definida en el Anexo I, tiene tres reglas: no causar interferencia perjudicial a las estaciones de un servicio primario (tengan ya frecuencias asignadas o puedan recibirlas en el futuro), no poder reclamar protección frente a las interferencias de esas estaciones y sí estar protegida frente a otras secundarias posteriores. La a invierte la segunda regla; la c limita la obligación a las primarias ya asignadas, cuando alcanza también a las futuras; la d confunde con el 50 % de potencia que el Anexo I, 3.2, impone en bandas secundarias: es un límite de potencia, no un permiso para interferir. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]],
)

#q("F-R8.81", "d",
  [Según el Anexo I de la Orden IET/1311/2013, una estación de un servicio secundario tiene derecho a protección contra las interferencias perjudiciales causadas por:],
  ([las estaciones de un servicio primario a las que se asignen frecuencias con posterioridad], [cualquier estación de otro servicio, sea primario o secundario], [ninguna estación, pues un servicio secundario carece de protección por definición], [las estaciones del mismo servicio o de otros servicios secundarios a las que se asignen frecuencias ulteriormente]),
  sol: [El apartado c) de la categoría de servicio secundario del Anexo I reconoce a estas estaciones el derecho a protección contra las interferencias perjudiciales causadas por estaciones del mismo servicio o de otros servicios secundarios a las que se asignen frecuencias ulteriormente. Frente a las estaciones primarias no hay protección, ni de las ya asignadas ni de las futuras: por eso fallan la a y la b. La c falla porque sí existe protección, pero solo frente a secundarias posteriores. Regla práctica: el secundario gana únicamente frente a otro secundario que llega más tarde. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[Categoría de servicio secundario (Anexo I de la Orden IET/1311/2013): sus estaciones a) no deben causar interferencia perjudicial a las de un servicio primario, tengan ya frecuencias asignadas o puedan recibirlas en el futuro; b) no pueden reclamar protección frente a las interferencias de esas estaciones primarias; c) sí tienen derecho a protección frente a las interferencias de estaciones del mismo servicio o de otros servicios secundarios a las que se asignen frecuencias después.]],
)

#q("F-R8.82", "a",
  [Según el Anexo I de la Orden IET/1311/2013, la tolerancia de frecuencia es la desviación máxima admisible entre la frecuencia asignada y:],
  ([la frecuencia situada en el centro de la banda ocupada por la emisión], [la frecuencia del límite inferior de la banda ocupada por la emisión], [la frecuencia del armónico más intenso de la emisión], [la frecuencia de resonancia del último circuito sintonizado del transmisor]),
  sol: [El Anexo I define la tolerancia de frecuencia como la desviación máxima admisible entre la frecuencia asignada (el valor nominal de la portadora sin modular o de la frecuencia de emisión) y la situada en el centro de la banda ocupada por la emisión. Se expresa en partes por millón o en hertzios. Ejemplo: ±10 ppm sobre 14 MHz son $14 times 10^6 times 10 times 10^(-6) = 140$ Hz. El límite inferior de la banda, el armónico más intenso y la resonancia del último circuito no son la referencia. #_apc3-ver[(Véase tema T5, sección «Etapas y definiciones» (junto a la pregunta sobre la anchura de banda necesaria).)]

#_apc3-net[Anexo I de la Orden IET/1311/2013: la frecuencia asignada es el valor nominal de la frecuencia portadora (sin modular) o de la frecuencia de emisión. La tolerancia de frecuencia es la desviación máxima admisible entre la frecuencia asignada y la situada en el centro de la banda de frecuencias ocupada por la emisión; se expresa en partes por millón (ppm) o en hertzios. Por ejemplo, ±10 ppm en 14 MHz equivalen a ±140 Hz.]],
)

#q("F-R8.83", "a",
  [En la designación de la clase de emisión J3E, los tres símbolos significan, por este orden:],
  ([banda lateral única con portadora suprimida, un solo canal con información analógica, telefonía], [doble banda lateral, un solo canal con información analógica, telefonía], [modulación de frecuencia, un solo canal con información analógica, telefonía], [banda lateral única con portadora suprimida, un solo canal con información analógica, telegrafía para recepción acústica]),
  sol: [Los símbolos de la clase se leen por orden: tipo de modulación de la portadora principal (J: banda lateral única con portadora suprimida), naturaleza de la señal moduladora (3: un solo canal con información analógica) y tipo de información (E: telefonía). Es la fonía en SSB. La opción b describe A3E (doble banda lateral), la c F3E (modulación de frecuencia) y la d sería J3A, con telegrafía de recepción acústica en lugar de telefonía. Anexo I (definición de «clase de emisión») y Apéndice 1 del Reglamento de Radiocomunicaciones (§§ 5 y 6). #_apc3-ver[(Véase tema T5, sección «Arquitecturas y características generales».)]

#_apc3-net[La clase de emisión se escribe con tres símbolos normalizados por la UIT (Apéndice 1 del Reglamento de Radiocomunicaciones). El primero indica la modulación de la portadora: A, doble banda lateral; J, banda lateral única con portadora suprimida; F, frecuencia; G, fase. El segundo, la señal moduladora: 1, un canal digital sin subportadora; 3, un canal analógico. El tercero, la información: A, telegrafía para recepción acústica; B, telegrafía para recepción automática; E, telefonía; D, datos.]],
)

#q("F-R8.84", "c",
  [La clase de emisión F1B corresponde a:],
  ([telefonía con modulación de frecuencia, con un solo canal analógico], [telegrafía de recepción acústica por manipulación de la portadora todo o nada (CW)], [telegrafía por manipulación de frecuencia para recepción automática (por ejemplo, RTTY con FSK)], [televisión con modulación de frecuencia]),
  sol: [F1B se lee símbolo a símbolo: F, modulación de frecuencia de la portadora principal; 1, un solo canal con información digital, sin subportadora moduladora; B, telegrafía para recepción automática (la lee una máquina, no el oído). Es la clase del RTTY por desplazamiento de frecuencia (FSK): dos frecuencias, marca y espacio. La telefonía de FM es F3E, la telegrafía por manipulación todo o nada de la portadora es A1A (CW) y la televisión lleva una F en tercera posición. Apéndice 1 del Reglamento de Radiocomunicaciones (§ 6). #_apc3-ver[(Véase tema T5, sección «Arquitecturas y características generales».)]

#_apc3-net[En la clase F1B, la F indica modulación de frecuencia; el 1, un solo canal con información digital y sin subportadora moduladora; y la B, telegrafía para recepción automática, es decir, que la decodifica una máquina y no el oído. Corresponde al RTTY por desplazamiento de frecuencia (FSK): el transmisor salta entre dos frecuencias, marca y espacio. Si ese desplazamiento se logra aplicando tonos de audio a un transmisor de banda lateral, la clase es J2B (con subportadora).]],
)

#q("F-R8.85", "b",
  [En la designación de una clase de emisión como A3E, F3E o J3E, el primer símbolo (la letra inicial) indica:],
  ([la naturaleza de la señal que modula la portadora], [el tipo de modulación de la portadora principal], [el tipo de información que se va a transmitir], [la anchura de banda necesaria de la emisión]),
  sol: [El anexo I define la clase de emisión con tres características, que los símbolos recogen por este orden: tipo de modulación de la portadora principal (primer símbolo, una letra: A, F, J o G), naturaleza de la señal moduladora (segundo, una cifra) y tipo de información (tercero, otra letra). En F3E: F, frecuencia; 3, un canal analógico; E, telefonía. La anchura de banda necesaria no es un símbolo de la clase: se añade inmediatamente antes de ella (por ejemplo, 2K70 delante de J3E; Apéndice 1 del Reglamento de Radiocomunicaciones, § 2). #_apc3-ver[(Véase tema T5, sección «Arquitecturas y características generales».)]],
)

#q("F-R8.86", "d",
  [Según el anexo I de la Orden IET/1311/2013, la «interferencia perjudicial» es la interferencia que:],
  ([produce cualquier degradación de la calidad de la recepción, por ligera que sea, en cualquier servicio], [procede de una estación que supera la potencia máxima autorizada, sea cual sea su efecto], [afecta únicamente a otras estaciones del Servicio de Aficionados o del Servicio de Aficionados por Satélite], [compromete el funcionamiento de un servicio de radionavegación o de otros servicios de seguridad, o degrada gravemente, interrumpe repetidamente o impide el funcionamiento de un servicio de radiocomunicación explotado de acuerdo con el Reglamento de Radiocomunicaciones]),
  sol: [La definición del anexo I atiende al efecto, no al origen ni a la potencia: es perjudicial la interferencia que compromete un servicio de radionavegación u otros de seguridad, o que degrada gravemente, interrumpe repetidamente o impide un servicio de radiocomunicación explotado conforme al Reglamento de Radiocomunicaciones. Una degradación ligera es interferencia, pero no perjudicial (a). La potencia emitida no entra en la definición (b), y se protege a cualquier servicio legítimo, no solo al de aficionados (c). Si la SETSI comprueba que una estación de aficionado la causa, su titular debe cesar las emisiones (artículo 32). #_apc3-ver[(Véase tema T10, introducción del capítulo (dejar de emitir ante una interferencia que afecte a la seguridad).)]

#_apc3-net[Según el anexo I, la interferencia perjudicial es la que compromete el funcionamiento de un servicio de radionavegación o de otros servicios de seguridad, o degrada gravemente, interrumpe repetidamente o impide el funcionamiento de un servicio de radiocomunicación explotado de acuerdo con el Reglamento de Radiocomunicaciones. Si la SETSI comprueba que una estación de radioaficionado la causa a otro servicio autorizado, su titular debe cesar las emisiones y adoptar medidas técnicas razonables (artículo 32 de la Orden).]],
)

#q("F-R8.87", "b",
  [Según el anexo I, la «interferencia» es el efecto de una energía no deseada sobre la recepción en un sistema de radiocomunicación, que se manifiesta como:],
  ([únicamente la interrupción total del servicio de radiocomunicación afectado], [degradación de la calidad, falseamiento o pérdida de la información que se podría obtener en ausencia de esa energía no deseada], [emisiones situadas inmediatamente fuera de la anchura de banda necesaria, resultado del proceso de modulación], [una desviación de la frecuencia de la emisión respecto de la frecuencia asignada]),
  sol: [El anexo I define la interferencia por su efecto sobre la recepción: energía no deseada que se manifiesta como degradación de la calidad, falseamiento o pérdida de la información que se obtendría sin ella. Basta una degradación; no hace falta que el servicio se interrumpa (a). Las emisiones fuera de banda (c) y la tolerancia de frecuencia (d) son otras definiciones del anexo, sin relación con el efecto sobre la recepción. Cuando la degradación es grave o repetida, o afecta a servicios de seguridad, se habla de interferencia perjudicial.

#_apc3-net[Según el anexo I, la interferencia es el efecto de una energía no deseada, debida a una o varias emisiones, radiaciones, inducciones o sus combinaciones, sobre la recepción en un sistema de radiocomunicación, que se manifiesta como degradación de la calidad, falseamiento o pérdida de la información que se obtendría sin esa energía. Es un concepto más amplio que el de interferencia perjudicial, que exige además que la degradación sea grave o repetida, o que afecte a servicios de seguridad.]],
)

#q("F-R8.88", "a",
  [La potencia isótropa radiada equivalente (p.i.r.e.) es el producto de la potencia suministrada a la antena por:],
  ([su ganancia con relación a una antena isótropa, en una dirección dada], [su ganancia con relación a un dipolo de media onda, en una dirección dada], [su ganancia con relación a una antena vertical corta, en una dirección dada], [su rendimiento, es decir, la relación entre la potencia radiada y la suministrada a la antena]),
  sol: [Anexo I: la p.i.r.e. es el producto de la potencia suministrada a la antena por su ganancia con relación a una antena isótropa (ganancia isótropa o absoluta) en una dirección dada. Con 10 W y una ganancia de 10 dBi (factor 10), la p.i.r.e. es de 100 W. Con el dipolo como referencia se obtiene la p.r.a. (b) y con la vertical corta, la p.r.a.v. (c). El rendimiento no entra en la definición: la ganancia ya descuenta las pérdidas de la antena. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-R8.89", "d",
  [La potencia radiada aparente (p.r.a.) es el producto de la potencia suministrada a la antena por su ganancia, en una dirección dada, con relación a:],
  ([una antena isótropa aislada en el espacio], [una antena vertical corta sobre un plano perfectamente conductor], [una antena vertical de cuarto de onda con radiales], [un dipolo de media onda]),
  sol: [Anexo I: la p.r.a. es el producto de la potencia suministrada a la antena por su ganancia con relación a un dipolo de media onda en una dirección dada (ganancia en dBd). Con la isótropa como referencia sería la p.i.r.e. (a) y con la vertical corta, la p.r.a.v. (b); el anexo no toma como referencia la vertical de cuarto de onda (c). Ejemplo: 10 W con una ganancia de 3 dBd (factor de potencia $approx 2$) dan una p.r.a. de unos 20 W. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas».)]

#_apc3-net[El anexo I define tres potencias según la antena de referencia con la que se multiplica la potencia suministrada a la antena, siempre en una dirección dada: la p.i.r.e. (potencia isótropa radiada equivalente), con la antena isótropa; la p.r.a. (potencia radiada aparente), con un dipolo de media onda; y la p.r.a.v. (potencia radiada aparente referida a una antena vertical corta), con la antena vertical corta.]],
)

#q("F-R8.90", "c",
  [La potencia de cresta de la envolvente (p.c.e.) es la media de la potencia suministrada a la línea de alimentación de la antena por un transmisor, en condiciones normales de funcionamiento y durante un ciclo de radiofrecuencia, tomada:],
  ([en ausencia de modulación], [promediada a lo largo de toda la modulación], [en la cresta más elevada de la envolvente de modulación], [en el instante de máxima tensión de un ciclo de radiofrecuencia]),
  sol: [Según el anexo I, la p.c.e. es la media de la potencia entregada a la línea de la antena durante un ciclo de radiofrecuencia, pero tomada en la cresta más elevada de la envolvente de modulación: la potencia en el pico de la modulación. En ausencia de modulación se mide la potencia de la portadora (a); la potencia media se calcula a lo largo de la modulación y, con voz en SSB, queda muy por debajo de la p.c.e. (b). Tampoco es la potencia instantánea máxima de un ciclo (d): se promedia el ciclo. Es la unidad de los límites de HF del anexo I. #_apc3-ver[(Véase tema T8, sección «Técnica de medida».)]],
)

#q("F-R8.91", "b",
  [Con la notación del anexo I, una antena tiene una ganancia Gd de 6 dB en su dirección de máxima radiación. Su ganancia isótropa o absoluta Gi en esa dirección es:],
  ([3,85 dBi], [8,15 dBi], [6 dBi], [9 dBi]),
  sol: [Gd es la ganancia con relación a un dipolo de media onda (dBd) y Gi, con relación a la antena isótropa (dBi). El dipolo tiene ya 2,15 dB sobre la isótropa, luego $G_i = G_d + 2,15$: $6 + 2,15 = 8,15$ dBi (un factor de potencia de $10^(0,815) approx 6,5$). Restar 2,15 da 3,85 dBi; confundir las dos referencias, 6 dBi; y 9 dBi supone, sin base, que el dipolo gana 3 dB sobre la isótropa. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas».)]

#_apc3-net[El anexo I llama Gi a la ganancia con relación a una antena isótropa aislada en el espacio (en dBi), Gd a la ganancia con relación a un dipolo de media onda aislado en el espacio (en dBd) y Gv a la ganancia con relación a una antena vertical corta sobre un plano perfectamente conductor. Como el dipolo tiene 2,15 dB de ganancia sobre la isótropa, $G_i = G_d + 2,15$ dB.]],
)

#q("F-R8.92", "a",
  [Según el anexo I, la ganancia isótropa o absoluta (Gi) de una antena se mide tomando como antena de referencia:],
  ([una antena isótropa aislada en el espacio], [un dipolo de media onda aislado en el espacio], [un conductor rectilíneo mucho más corto que un cuarto de longitud de onda, perpendicular a un plano perfectamente conductor], [una antena vertical de cuarto de onda con radiales sobre el suelo]),
  sol: [La ganancia de una antena compara la potencia que necesitaría una antena de referencia sin pérdidas con la que recibe la antena real para dar el mismo campo en una dirección dada. Según la referencia, el anexo I distingue Gi (antena isótropa aislada en el espacio), Gd (dipolo de media onda aislado en el espacio) y Gv (conductor rectilíneo mucho más corto que un cuarto de onda sobre un plano perfectamente conductor). La opción b es la referencia de Gd, la c la de Gv, y la d no es referencia alguna del anexo. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas».)]

#_apc3-net[La ganancia de una antena es la relación entre la potencia que necesitaría una antena de referencia sin pérdidas y la suministrada a la antena real para producir, en una dirección dada, el mismo campo. El anexo I distingue según la referencia: Gi, antena isótropa aislada en el espacio; Gd, dipolo de media onda aislado en el espacio; Gv, conductor rectilíneo mucho más corto que un cuarto de onda, perpendicular a un plano perfectamente conductor.]],
)

#q("F-R8.93", "c",
  [Según el apartado 3.1 del anexo I, los radioaficionados pueden emplear la modulación de amplitud (con doble banda lateral o banda lateral única), la de frecuencia, la de fase y otras modulaciones digitales, siempre que la emisión resultante:],
  ([no ocupe más de 3 kHz de anchura de banda en ninguna banda], [haya sido autorizada expresamente por la SETSI para ese modo de emisión], [se ajuste a las bandas de frecuencias autorizadas y, como norma general, tenga un ancho de banda acorde con el plan de bandas de la IARU para la Región 1], [se ajuste a las bandas autorizadas y tenga un ancho de banda acorde con los planes de bandas de la IARU para la Región 2]),
  sol: [El apartado 3.1 autoriza la modulación de amplitud (doble banda lateral o banda lateral única, con distintos niveles de portadora), la de frecuencia o de fase y otras modulaciones digitales, con una condición: que la emisión quede dentro de las bandas autorizadas al servicio y con anchos de banda acordes, como norma general, al plan de bandas de la IARU para la Región 1 (u otros que se establezcan). No fija un máximo de 3 kHz (a) ni exige autorización para cada modo (b), y España está en la Región 1 (d). El artículo 2.2 de la Orden remite igualmente a ese plan. #_apc3-ver[(Véase tema R6, introducción del capítulo (el plan de bandas de la IARU para la Región 1).)]

#_apc3-net[El apartado 3.1 del anexo I autoriza la modulación de amplitud (doble banda lateral o banda lateral única, con distintos niveles de portadora), la de frecuencia o de fase y otras modulaciones digitales, con una sola condición: que la emisión resultante se ajuste a las bandas de frecuencias autorizadas al servicio de radioaficionados y tenga anchos de banda acordes, como norma general, con el plan de bandas de la IARU para la Región 1 (u otros que se establezcan).]],
)

#q("F-R8.94", "d",
  [Los «otros tipos de modulaciones digitales» que autoriza el apartado 3.1 del anexo I, siempre que la emisión respete las bandas y los anchos de banda aplicables, pueden transportar señales de:],
  ([solo datos, como el RTTY o los paquetes], [audio y datos, pero no vídeo], [datos y vídeo, pero no audio], [audio, datos o vídeo]),
  sol: [El apartado 3.1 autoriza «otros tipos de modulaciones digitales con señales de audio, datos o vídeo», sin distinguir por el contenido: lo que importa es que la emisión quede dentro de las bandas autorizadas al servicio y con anchos de banda acordes, como norma general, al plan de bandas de la IARU para la Región 1. Valen, pues, la voz digital (audio), los modos de texto y de paquetes (datos) y la televisión digital (vídeo). Las otras tres opciones excluyen, sin apoyo en el texto, alguno de los tres tipos de señal.

#_apc3-net[Las modulaciones digitales que autoriza el apartado 3.1 del anexo I pueden llevar señales de audio, datos o vídeo: el anexo no limita el tipo de contenido, sino que exige que la emisión se ajuste a las bandas de frecuencias autorizadas y, como norma general, a anchos de banda acordes con el plan de bandas de la IARU para la Región 1.]],
)

#q("F-R8.95", "a",
  [Según la tabla del apartado 3.1 del anexo I, la potencia máxima de emisión en la banda de 14 MHz (20 m) es de:],
  ([1000 W p.c.e.], [600 W p.c.e.], [300 W p.c.e.], [100 W p.c.e.]),
  sol: [La tabla del apartado 3.1 del anexo I fija 1000 W p.c.e. para todas las bandas de 1,8 a 28 MHz, y 14 MHz está en ese grupo. Las otras cifras son de otras filas: 600 W p.c.e. en 50, 70 y 144–146 MHz, y 300 W p.c.e. en 430–440 MHz. Los 100 W p.c.e. no son el valor de ninguna fila de la tabla. La rebaja al 50 % del apartado 3.2 solo afecta a las bandas atribuidas con carácter secundario. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[La tabla del apartado 3.1 del anexo I fija la potencia máxima de emisión por bandas: 1000 W p.c.e. en todas las de 1,8 a 28 MHz; 600 W p.c.e. en 50, 70 y 144 a 146 MHz; 300 W p.c.e. en 430 a 440 MHz; 1000 W p.i.r.e. desde 23 cm hacia arriba; y 1 W p.i.r.e. en 137 y 475 kHz. En las bandas atribuidas con carácter secundario, el máximo es el 50 % de esos valores (apartado 3.2).]],
)

#q("F-R8.96", "c",
  [En la tabla del apartado 3.1 del anexo I, la potencia máxima de las bandas de HF (de 1,8 a 28 MHz) se expresa como:],
  ([potencia isótropa radiada equivalente (p.i.r.e.)], [potencia de la portadora], [potencia de cresta de la envolvente (p.c.e.)], [potencia radiada aparente (p.r.a.)]),
  sol: [En HF, de 1,8 a 28 MHz, la tabla da el límite, 1000 W, en potencia de cresta de la envolvente (p.c.e.): es la magnitud natural de la SSB, donde no hay portadora y la potencia sube y baja con la voz. La p.i.r.e. es la unidad de la fila de 23 cm y superiores (1000 W) y de las de 137 y 475 kHz (1 W). La potencia de la portadora se mide sin modulación, y la p.r.a. es la potencia radiada referida a un dipolo: ninguna de las dos es la unidad de la tabla. #_apc3-ver[(Véase tema T8, sección «Técnica de medida».)]],
)

#q("F-R8.97", "c",
  [Según la tabla de potencias máximas del anexo I, la potencia máxima autorizada en cada una de las bandas de 50, 70 y 144–146 MHz es de:],
  ([300 W p.c.e.], [1000 W p.c.e.], [600 W p.c.e.], [1000 W p.i.r.e.]),
  sol: [La tabla del apartado 3.1 del anexo I agrupa las bandas por potencia máxima: 1000 W p.c.e. en HF (1,8 a 28 MHz), *600 W p.c.e.* en 50, 70 y 144–146 MHz, 300 W p.c.e. en 430–440 MHz y 1000 W p.i.r.e. de 23 cm en adelante. Las tres bandas del enunciado comparten, pues, la misma celda de 600 W p.c.e. Los 1000 W p.c.e. son el valor de HF, los 300 W p.c.e. el de 70 cm y los 1000 W p.i.r.e. el de las bandas de 23 cm y superiores, donde la magnitud cambia y sí cuenta la ganancia de la antena. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 3.1) fija en una tabla la potencia máxima por banda. En HF (1,8 a 28 MHz): 1000 W p.c.e. En 50, 70 y 144–146 MHz: 600 W p.c.e. En 430–440 MHz: 300 W p.c.e. La p.c.e. es la potencia media, durante un ciclo de RF, suministrada a la línea de la antena en la cresta de la envolvente de modulación. De 23 cm en adelante el límite es de 1000 W p.i.r.e.; en 137 y 475 kHz, de 1 W p.i.r.e.]],
)

#q("F-R8.98", "a",
  [Según la tabla de potencias máximas del anexo I, en la banda de 430–440 MHz (70 cm) se puede emplear como máximo:],
  ([300 W p.c.e.], [600 W p.c.e.], [1000 W p.c.e.], [1000 W p.i.r.e.]),
  sol: [Para 430–440 MHz (70 cm) la tabla del apartado 3.1 del anexo I fija *300 W p.c.e.*, justo la mitad que en 2 m. Es fácil equivocarse porque las cifras vecinas se parecen: 600 W p.c.e. vale para 50, 70 y 144–146 MHz, 1000 W p.c.e. para HF (1,8 a 28 MHz) y 1000 W p.i.r.e. para 23 cm y superiores. Regla mnemotécnica: 1000, 600 y 300 W p.c.e. al pasar de HF a VHF y a 70 cm, y 1000 W p.i.r.e. desde 23 cm. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 3.1) da en una tabla la potencia máxima por banda. En HF (1,8 a 28 MHz) es de 1000 W p.c.e.; en 50, 70 y 144–146 MHz, de 600 W p.c.e.; en 430–440 MHz (70 cm), de 300 W p.c.e. Desde 23 cm (1240 MHz) el límite se expresa en otra magnitud, 1000 W p.i.r.e., y en 137 y 475 kHz es de 1 W p.i.r.e.]],
)

#q("F-R8.99", "d",
  [En el anexo I, la potencia máxima de 1000 W fijada para las bandas de 23 cm y superiores se expresa como:],
  ([potencia de cresta de la envolvente (p.c.e.)], [potencia radiada aparente (p.r.a.)], [potencia de la portadora], [potencia isótropa radiada equivalente (p.i.r.e.)]),
  sol: [En microondas el límite se da en la magnitud que incluye la antena: 1000 W *p.i.r.e.*, es decir, la potencia suministrada a la antena multiplicada por su ganancia respecto a la isótropa, $"p.i.r.e." = P dot G_i$. Con una antena de 20 dBi ($G_i = 100$), la potencia suministrada a ella no podría pasar de 10 W. La p.c.e. (HF, VHF y 70 cm) es la potencia en la línea de la antena y no cuenta su ganancia. La p.r.a. se refiere al dipolo de media onda, y la potencia de la portadora es la que hay sin modular: ninguna es la magnitud de esta fila de la tabla. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas» (definición de p.i.r.e.), y tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[En el anexo I de la Orden IET/1311/2013 (apartado 3.1), desde 23 cm (1240 MHz) hasta 250 GHz — bandas de 23, 13, 6, 3 y 1,5 cm, 6 mm y 75 a 250 GHz — la potencia máxima es de 1000 W p.i.r.e.: la potencia suministrada a la antena multiplicada por su ganancia respecto a la antena isótropa. En HF y de 50 a 440 MHz el límite se da en p.c.e. (1000, 600 y 300 W); en 137 y 475 kHz, en p.i.r.e. (1 W).]],
)

#q("F-R8.100", "b",
  [Con carácter general, la potencia máxima de emisión en las bandas de 137 kHz (2200 m) y 475 kHz (630 m) es, según el anexo I, de:],
  ([1000 W p.c.e.], [1 W p.i.r.e.], [1 W p.c.e.], [10 W p.i.r.e.]),
  sol: [Para las dos bandas más bajas, la tabla del apartado 3.1 del anexo I da solo *1 W p.i.r.e.*, muy por debajo de los 1000 W p.c.e. de HF. En 475 kHz existe una excepción: hasta 5 W p.i.r.e. en zonas distantes más de 800 km de la frontera de países africanos. La opción de 1 W p.c.e. acierta la cifra pero cambia la magnitud: la p.c.e. se mide en la línea de la antena y la p.i.r.e. incluye su ganancia. Los 1000 W p.c.e. son los de HF, y los 10 W p.i.r.e. no figuran en la tabla. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 3.1) autoriza las bandas de 137 kHz (2200 m, LF) y 475 kHz (630 m, MF) con una potencia máxima de 1 W p.i.r.e. En 475 kHz se puede llegar a 5 W p.i.r.e. en las zonas geográficas distantes más de 800 km de la frontera de países africanos. La p.i.r.e. es la potencia suministrada a la antena multiplicada por su ganancia respecto a la isótropa.]],
)

#q("F-R8.101", "c",
  [En la banda de 475 kHz (630 m), la potencia máxima de 1 W p.i.r.e. puede elevarse hasta 5 W p.i.r.e. en las zonas geográficas distantes más de:],
  ([200 km de cualquier costa], [400 km de la frontera de países africanos], [800 km de la frontera de países africanos], [100 km de las fronteras de la Unión Europea]),
  sol: [El apartado 3.1 del anexo I permite en 475 kHz 1 W p.i.r.e. con carácter general y hasta 5 W p.i.r.e. _solo_ en las zonas geográficas distantes *más de 800 km de la frontera de países africanos*. Hay, pues, dos datos que retener: la distancia (800 km, no 200 ni 400) y la referencia (fronteras de países africanos, no las costas ni las fronteras de la Unión Europea). La cláusula no existe en 137 kHz, cuyo límite es siempre 1 W p.i.r.e. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[En la banda de 475 kHz (630 m), el anexo I de la Orden IET/1311/2013 (apartado 3.1) fija 1 W p.i.r.e. y permite llegar a 5 W p.i.r.e. en las zonas geográficas distantes más de 800 km de la frontera de países africanos. En 137 kHz (2200 m) el límite es de 1 W p.i.r.e., sin esa excepción.]],
)

#q("F-R8.102", "a",
  [En las bandas atribuidas al servicio de radioaficionados con carácter secundario, la potencia máxima de las emisiones no superará, según el anexo I:],
  ([el 50 % de los valores de la tabla], [el 25 % de los valores de la tabla], [el 75 % de los valores de la tabla], [el 10 % de los valores de la tabla]),
  sol: [El apartado 3.2 del anexo I dice que en las bandas atribuidas con carácter secundario la potencia máxima _no superará el 50 %_ de los valores de la tabla del apartado 3.1. La categoría de servicio secundario ya limita a esas estaciones (no deben causar interferencia perjudicial al servicio primario ni pueden reclamar protección frente a él), y el apartado 3.2 añade la rebaja de potencia. Un límite de 1000 W p.c.e. quedaría en 500 W p.c.e., y uno de 1000 W p.i.r.e., en 500 W p.i.r.e. Ni el 10, ni el 25, ni el 75 % figuran en la Orden. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[Las bandas del Servicio de Aficionados se atribuyen con carácter primario o secundario. En las secundarias, el apartado 3.2 del anexo I de la Orden IET/1311/2013 limita la potencia máxima al 50 % de los valores de la tabla del apartado 3.1: una banda de HF con 1000 W p.c.e. quedaría en 500 W p.c.e., y una de microondas con 1000 W p.i.r.e., en 500 W p.i.r.e.]],
)

#q("F-R8.103", "d",
  [Si una banda de HF de la tabla del anexo I (1000 W p.c.e.) estuviera atribuida al servicio de radioaficionados con carácter secundario, su potencia máxima sería de:],
  ([1000 W p.c.e.], [250 W p.c.e.], [500 W p.i.r.e.], [500 W p.c.e.]),
  sol: [Se aplica el apartado 3.2 del anexo I: en una banda secundaria la potencia máxima no supera el 50 % de la tabla. Para HF la tabla da 1000 W p.c.e., luego el límite sería $1000 dot 0,5 = 500$ W p.c.e. Los 1000 W p.c.e. olvidan la rebaja; los 250 W la aplican dos veces; y 500 W p.i.r.e. acierta la cifra pero no la magnitud, porque en HF la tabla se expresa en p.c.e. Lo mismo vale para una banda de microondas de 1000 W p.i.r.e.: quedaría en 500 W p.i.r.e. Qué banda es secundaria lo fija el CNAF (art. 16). #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[En las bandas atribuidas con carácter secundario, el apartado 3.2 del anexo I de la Orden IET/1311/2013 limita la potencia máxima al 50 % de la tabla del apartado 3.1. El porcentaje se aplica a la magnitud de la tabla: una banda de HF (1000 W p.c.e.) quedaría en 500 W p.c.e., y una de microondas (1000 W p.i.r.e.) en 500 W p.i.r.e. Qué bandas son secundarias lo determina el CNAF (art. 16).]],
)

#q("F-R8.104", "b",
  [Una estación emite en 144 MHz para un enlace por rebote lunar (EME), en una subbanda recomendada por la IARU y fuera de un casco urbano. La potencia de cresta de la envolvente máxima que le permite el anexo I es de:],
  ([600 W], [1000 W], [1500 W], [300 W]),
  sol: [Para el rebote lunar (EME) y la dispersión meteórica (MS), el apartado 3.3 del anexo I sube el tope a *1000 W p.c.e.* siempre que se trabaje dentro de las subbandas recomendadas por la IARU y, en cualquier caso, fuera de los cascos urbanos. Ambas condiciones se cumplen en el enunciado, así que no rige el límite ordinario de 600 W p.c.e. de la banda de 2 m. Los 300 W son el valor de 70 cm, y los 1500 W no figuran en la Orden: el máximo es 1000 W. #_apc3-ver[(Véase tema T7, sección «Fenómenos de propagación».)]

#_apc3-net[Para enlaces por rebote lunar (EME) o por dispersión meteórica (MS), el apartado 3.3 del anexo I de la Orden IET/1311/2013 permite hasta 1000 W de potencia de cresta de la envolvente (p.c.e.), por encima del límite habitual de la banda (por ejemplo, 600 W en 144 MHz o 300 W en 430–440 MHz). Las condiciones son dos: operar dentro de las subbandas recomendadas por la IARU y, en cualquier caso, fuera de los cascos urbanos.]],
)

#q("F-R8.105", "a",
  [El anexo I permite subir a 1000 W p.c.e. la potencia en los enlaces EME y de dispersión meteórica (MS) cuando la estación funciona:],
  ([dentro de las subbandas recomendadas por la IARU y, en cualquier caso, fuera de los cascos urbanos], [en cualquier frecuencia de la banda, siempre que sea fuera de los cascos urbanos], [dentro de las subbandas recomendadas por la IARU, incluso en un casco urbano], [como estación colectiva de una asociación reconocida]),
  sol: [El apartado 3.3 del anexo I exige para EME y MS dos condiciones a la vez: las emisiones deben quedar _dentro de las subbandas recomendadas por la IARU_ y, en cualquier caso, _fuera de los cascos urbanos_. La segunda opción omite la primera (vale cualquier frecuencia), y la tercera invierte la segunda (en casco urbano no se aplica la excepción). La estación colectiva no interviene: la excepción depende del tipo de enlace y de dónde está la estación, no de quién sea su titular. Si no se cumplen, sigue rigiendo el límite de la tabla. #_apc3-ver[(Véase tema T7, sección «Fenómenos de propagación».)]

#_apc3-net[El apartado 3.3 del anexo I de la Orden IET/1311/2013 permite utilizar hasta 1000 W de potencia de cresta de la envolvente (p.c.e.) en enlaces por rebote lunar (EME) o por dispersión meteórica (MS), pero solo si se cumplen dos condiciones a la vez: que las emisiones se hagan dentro de las subbandas recomendadas por la IARU y que la estación esté, en cualquier caso, fuera de los cascos urbanos.]],
)

#q("F-R8.106", "d",
  [Las estaciones de radioaficionado que funcionan en las bandas destinadas a aplicaciones industriales, científicas y médicas (ICM), según el anexo I:],
  ([tienen derecho a ser protegidas frente a la interferencia de esas aplicaciones], [no pueden utilizar esas bandas], [pueden reclamar el cese de las aplicaciones ICM que les interfieran], [deben aceptar la interferencia perjudicial resultante de esas aplicaciones]),
  sol: [El apartado 3.4 del anexo I destina cuatro bandas a aplicaciones ICM y dispone que las estaciones de radioaficionado que funcionen en ellas _deberán aceptar la interferencia perjudicial_ resultante de dichas aplicaciones. El aficionado puede, pues, usar esas bandas, pero no puede exigir protección ni pedir que cesen las aplicaciones ICM. Por eso fallan las opciones que le dan protección o derecho de reclamación, y también la que le prohíbe el uso: la Orden no excluye esas bandas del servicio de aficionados. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El apartado 3.4 del anexo I de la Orden IET/1311/2013 destina cuatro bandas a aplicaciones industriales, científicas y médicas (ICM): 433,050–434,790 MHz, 2400–2450 MHz, 5725–5800 MHz y 24,00–24,25 GHz. Las estaciones de radioaficionado que funcionen en ellas deben aceptar la interferencia perjudicial resultante de dichas aplicaciones: no pueden exigir protección, pero tampoco se les excluye de esas bandas.]],
)

#q("F-R8.107", "b",
  [Son bandas ICM del apartado 3.4 del anexo I: 433,050–434,790 MHz, 2400–2450 MHz, 5725–5800 MHz y:],
  ([10,00–10,50 GHz], [24,00–24,25 GHz], [47,0–47,2 GHz], [1240–1300 MHz]),
  sol: [El apartado 3.4 del anexo I enumera cuatro bandas ICM: 433,050–434,790 MHz, 2400–2450 MHz, 5725–5800 MHz y *24,00–24,25 GHz*. Las otras opciones (10 GHz, 47 GHz y 23 cm) son bandas de aficionado de la tabla del apartado 3.1 que no figuran en esa lista. Las cuatro ICM se solapan con bandas de aficionado de la tabla (70 cm, 13 cm, 6 cm y 1,5 cm), y en ellas el aficionado debe aceptar la interferencia perjudicial de las aplicaciones ICM. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[Las bandas destinadas a aplicaciones industriales, científicas y médicas (ICM) según el apartado 3.4 del anexo I de la Orden IET/1311/2013 son cuatro: 433,050–434,790 MHz, 2400–2450 MHz, 5725–5800 MHz y 24,00– 24,25 GHz. Las cuatro se solapan con bandas de aficionado (70 cm, 13 cm, 6 cm y 1,5 cm), y en ellas el aficionado debe aceptar la interferencia perjudicial de esas aplicaciones.]],
)

#q("F-R8.108", "c",
  [¿Cuál de las siguientes bandas es una de las destinadas a aplicaciones ICM en el anexo I?],
  ([144–146 MHz], [50–52 MHz], [2400–2450 MHz], [1240–1300 MHz]),
  sol: [El apartado 3.4 del anexo I destina a aplicaciones ICM cuatro bandas: 433,050–434,790 MHz, 2400– 2450 MHz, 5725–5800 MHz y 24,00–24,25 GHz; la correcta es, pues, la de 2400–2450 MHz. Las de 144–146 MHz (2 m), 50 MHz (6 m) y 1240–1300 MHz (23 cm) son bandas de aficionado de la tabla del apartado 3.1 sin relación con las ICM. La de 2400–2450 MHz forma parte de la de 13 cm (2300–2450 MHz), y en ella el aficionado debe aceptar la interferencia perjudicial de esas aplicaciones. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El apartado 3.4 del anexo I de la Orden IET/1311/2013 destina a aplicaciones industriales, científicas y médicas (ICM) cuatro bandas: 433,050–434,790 MHz, 2400–2450 MHz, 5725–5800 MHz y 24,00–24,25 GHz. La de 2400–2450 MHz está dentro de la banda de aficionado de 13 cm (2300–2450 MHz): en ella el aficionado debe aceptar la interferencia perjudicial de esas aplicaciones.]],
)

#q("F-R8.109", "a",
  [Las potencias máximas del anexo I no eximen al radioaficionado de adoptar las medidas técnicas necesarias, incluida la reducción de la potencia, para que la energía de radiofrecuencia emitida sea inferior a:],
  ([3,5 mW/cm#super[2]], [0,35 mW/cm#super[2]], [35 mW/cm#super[2]], [10 mW/cm#super[2]]),
  sol: [El apartado 3.5 del anexo I recuerda que las potencias máximas de la tabla no son un derecho a emitir todo lo permitido: si hace falta, hay que reducir la potencia para que la energía de RF emitida sea *inferior a 3,5 mW/cm#super[2]* en los emplazamientos accesibles a las personas. Equivale a 35 W/m#super[2] (1 mW/cm#super[2] son 10 W/m#super[2]). Los 0,35 y los 35 mW/cm#super[2] son errores de un factor 10, y los 10 mW/cm#super[2] no figuran en la Orden.

#_apc3-net[El apartado 3.5 del anexo I de la Orden IET/1311/2013 establece que las potencias máximas de la tabla no eximen al radioaficionado de adoptar las medidas técnicas necesarias, incluida la reducción de la potencia emitida, para que la energía de radiofrecuencia emitida sea inferior a 3,5 mW/cm#super[2] (35 W/m#super[2]) en los emplazamientos a los que tengan acceso, o en cuya proximidad puedan transitar, las personas.]],
)

#q("F-R8.110", "b",
  [El límite de 3,5 mW/cm#super[2] de energía de radiofrecuencia del anexo I debe respetarse:],
  ([solo en el interior de la vivienda o local donde está instalada la estación], [en los emplazamientos a los que tengan acceso las personas o en cuya proximidad puedan transitar], [solo en las estaciones cuya potencia supera los 100 W en cualquier banda], [solo en las bandas de frecuencias superiores a 1 GHz, con cualquier potencia]),
  sol: [El apartado 3.5 del anexo I aplica el límite de 3,5 mW/cm#super[2] a _aquellos emplazamientos a los que tengan acceso o en cuya proximidad puedan transitar las personas_. Lo que cuenta es dónde puede haber gente, no la banda ni la potencia: el apartado se refiere a las potencias máximas de toda la tabla, así que vale para cualquier banda, y la forma de cumplirlo es adoptar las medidas técnicas necesarias, incluida la reducción de la potencia. Limitarlo al interior de la vivienda, a más de 100 W o a más de 1 GHz no figura en la Orden.

#_apc3-net[El apartado 3.5 del anexo I de la Orden IET/1311/2013 fija el límite de 3,5 mW/cm#super[2] de energía de radiofrecuencia emitida para aquellos emplazamientos a los que tengan acceso las personas o en cuya proximidad puedan transitar. Se refiere a las potencias máximas de la tabla del apartado 3.1, es decir, a cualquier banda, y se cumple adoptando las medidas técnicas necesarias, incluida la reducción de la potencia emitida.]],
)

#q("F-R8.111", "b",
  [Un transmisor de 100 W de potencia media trabaja en la banda de 144 MHz. Según el Anexo I de la Orden IET/1311/2013, la potencia media de cada componente de emisión no esencial que suministra a la línea de la antena no debe rebasar:],
  ([40 dB por debajo de la potencia media, sin exceder de 50 mW], [60 dB por debajo de la potencia media, sin exceder de 1 mW], [60 dB por debajo de la potencia media, sin exceder de 20 mW], [40 dB por debajo de la potencia media, sin exceder de 25 μW]),
  sol: [Entre 30 y 235 MHz, si la potencia media supera 25 W, el Anexo I, 4.1.2, exige 60 dB por debajo de la potencia media, sin exceder de 1 mW. Con 100 W: $100 "W" dot 10^(-6) = 100 thin mu"W"$, menos que el tope de 1 mW; manda el más restrictivo, aquí los 60 dB. Los 40 dB y 50 mW son el límite por debajo de 30 MHz. Los 60 dB con 20 mW valen de 235 a 960 MHz con más de 25 W, y los 40 dB con 25 μW, para potencias de 25 W o menos. #_apc3-ver[(Véase tema T5, sección «Emisiones no deseadas».)]

#_apc3-net[Límites del Anexo I, 4.1, para las emisiones no esenciales (dB por debajo de la potencia media, sin exceder del tope): por debajo de 30 MHz, 40 dB y 50 mW; de 30 a 235 MHz, 60 dB y 1 mW con más de 25 W, o 40 dB y 25 μW con 25 W o menos; de 235 a 960 MHz, 60 dB y 20 mW con más de 25 W, o 40 dB y 25 μW con 25 W o menos; de 960 MHz a 17,7 GHz, 50 dB y 100 mW con más de 10 W, o 50 dB y 100 μW con 10 W o menos.]],
)

#q("F-R8.112", "d",
  [Un transmisor de 10 W de potencia media trabaja en la banda de 70 cm (430 a 440 MHz). Según el Anexo I de la Orden IET/1311/2013, la potencia media de cada componente de emisión no esencial que suministra a la línea de la antena no debe rebasar:],
  ([60 dB por debajo de la potencia media, sin exceder de 20 mW], [50 dB por debajo de la potencia media, sin exceder de 100 μW], [60 dB por debajo de la potencia media, sin exceder de 1 mW], [40 dB por debajo de la potencia media, sin exceder de 25 μW]),
  sol: [De 235 a 960 MHz, con una potencia media de 25 W o menos, el Anexo I, 4.1.3, pide 40 dB por debajo de la potencia media, sin exceder de 25 μW. Con 10 W, los 40 dB dan $10 "W" dot 10^(-4) = 1 "mW"$, pero el tope de 25 μW es mucho más estricto y es el que manda. Los 60 dB con 20 mW son para más de 25 W en esa misma banda; 60 dB con 1 mW, para más de 25 W entre 30 y 235 MHz; y 50 dB con 100 μW, para las microondas (960 MHz a 17,7 GHz) con 10 W o menos. #_apc3-ver[(Véase tema T5, sección «Emisiones no deseadas».)]

#_apc3-net[De 235 a 960 MHz (Anexo I, 4.1.3) la regla es 60 dB por debajo de la potencia media, sin exceder de 20 mW, si la potencia supera 25 W; y 40 dB, sin exceder de 25 μW, si es de 25 W o menos. Entre 30 y 235 MHz (4.1.2) el umbral de potencia es el mismo, pero el tope de los 60 dB es de 1 mW. «Sin exceder de» obliga a cumplir a la vez los dos criterios, el de los decibelios y el tope absoluto; manda el más restrictivo.]],
)

#q("F-R8.113", "a",
  [Un transmisor de 5 W de potencia media trabaja en la banda de 23 cm (1240 a 1300 MHz). Según el Anexo I de la Orden IET/1311/2013, la potencia media de cada componente de emisión no esencial que suministra a la línea de la antena no debe rebasar:],
  ([50 dB por debajo de la potencia media, sin exceder de 100 μW], [50 dB por debajo de la potencia media, sin exceder de 100 mW], [40 dB por debajo de la potencia media, sin exceder de 25 μW], [60 dB por debajo de la potencia media, sin exceder de 1 mW]),
  sol: [Entre 960 MHz y 17,7 GHz, con una potencia media de 10 W o menos, el Anexo I, 4.1.4, fija 50 dB por debajo de la potencia media, sin exceder de 100 μW. Con 5 W: $5 "W" dot 10^(-5) = 50 thin mu"W"$, más estricto que el tope de 100 μW, y es el que manda. Los 100 mW (también con 50 dB) son el tope para más de 10 W. Los 40 dB con 25 μW son de 25 W o menos entre 30 y 960 MHz, y los 60 dB con 1 mW, de 30 a 235 MHz con más de 25 W. #_apc3-ver[(Véase tema T5, sección «Emisiones no deseadas».)]

#_apc3-net[De 960 MHz a 17,7 GHz (Anexo I, 4.1.4) se exigen siempre 50 dB por debajo de la potencia media y solo cambia el tope: 100 mW si la potencia supera 10 W y 100 μW si es de 10 W o menos. Por debajo de 960 MHz el umbral de potencia es de 25 W, y por debajo de 30 MHz hay un único límite: 40 dB sin exceder de 50 mW.]],
)

== Tema R9. Inspección y régimen sancionador <apc3-r9>

#q("F-R9.1", "c",
  [La multa máxima que prevé la Ley 11/2022, General de Telecomunicaciones, por una infracción leve es de:],
  ([50 000 euros], [500 000 euros], [100 000 euros], [2 millones de euros]),
  sol: [El art. 109.1.d fija para las infracciones leves una multa de hasta 100 000 euros. La escala completa es: hasta 20 millones de euros para las muy graves (letra a), hasta 2 millones para las graves (letra c) y hasta 100 000 euros para las leves. Los 50 000 euros eran el tope de las leves en la ley anterior (Ley 9/2014, art. 79.1.d), cifra que todavía figura en preguntas antiguas. Los 2 millones son el tope de las graves, y 500 000 euros no corresponde a ningún grado del art. 109.1. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados y multas).)]],
)

#q("F-R9.2", "b",
  [De las siguientes medidas, ¿cuál _no_ figura entre las sanciones accesorias que el art. 109.2 de la Ley 11/2022 permite añadir a las infracciones de los arts. 106 a 108?],
  ([el precintado o la incautación de los equipos de telecomunicación], [la inhabilitación del titular durante cinco años para operar como radioaficionado], [la clausura de las instalaciones], [el cese inmediato de las emisiones radioeléctricas no autorizadas]),
  sol: [El art. 109.2 enumera cuatro sanciones accesorias: el cese inmediato de las emisiones no autorizadas, el ajuste de las emisiones a los parámetros autorizados, el precintado o la incautación de los equipos y la clausura de las instalaciones. Se aplican mientras no se disponga del título habilitante, o mientras se emita con parámetros distintos de los autorizados. La inhabilitación hasta cinco años es otra cosa: la prevé el art. 109.1.b para infracciones muy graves y solo habla del operador de comunicaciones electrónicas y del instalador, no del radioaficionado. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[Las sanciones por infracciones de los arts. 106 a 108 de la Ley 11/2022 pueden llevar aparejadas estas sanciones accesorias (art. 109.2): cese inmediato de las emisiones no autorizadas, ajuste de las emisiones a los parámetros autorizados, precintado o incautación de los equipos de telecomunicación y clausura de las instalaciones. Rigen mientras no se tenga el título habilitante necesario o se emita con parámetros distintos de los autorizados.]],
)

#q("F-R9.3", "d",
  [Según el art. 114.1 de la Ley 11/2022, la competencia para imponer las sanciones por infracciones como emitir sin autorización o producir interferencias corresponde a:],
  ([la Comisión Nacional de los Mercados y la Competencia], [los juzgados de lo contencioso-administrativo], [el Ministerio del Interior, a través de las Fuerzas y Cuerpos de Seguridad], [la persona titular de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales]),
  sol: [El art. 114.1.c atribuye la competencia sancionadora a la persona titular de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales en todos los casos no reservados a otros órganos. La CNMC solo sanciona las infracciones que enumera el art. 114.1.a, y entre ellas no están la emisión sin autorización ni las interferencias. Los juzgados de lo contencioso-administrativo aparecen en el art. 103.2 para autorizar la entrada en un domicilio, no como órgano sancionador. Las Fuerzas y Cuerpos de Seguridad pueden apoyar a la inspección (art. 103.1), pero no sancionan. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (introducción).)]

#_apc3-net[En la Ley 11/2022 la inspección (arts. 102 y 103) y la sanción (art. 114) se atribuyen por separado. Sanciona la persona titular de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales, salvo en los casos que el art. 114.1 reserva a la CNMC (letra a) y a la Agencia Española de Protección de Datos (letra b). Las infracciones típicas de los radioaficionados caen en el resto de los casos, es decir, en la Secretaría de Estado.]],
)

#q("F-R9.4", "a",
  [Según el art. 114.2 de la Ley 11/2022, el plazo para resolver el procedimiento sancionador en materia de telecomunicaciones es de:],
  ([un año], [seis meses], [tres meses], [dos años]),
  sol: [El art. 114.2 remite al procedimiento administrativo común de la Ley 39/2015, pero con dos plazos propios: el de resolución es de un año, y el de alegaciones, de al menos quince días hábiles. Ni seis meses ni tres meses ni dos años figuran en ese artículo. No hay que confundirlo con la prescripción (art. 113), que es otra cosa: las infracciones prescriben a los tres años las muy graves, a los dos las graves y al año las leves. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[El procedimiento sancionador en materia de telecomunicaciones se tramita por el procedimiento administrativo común (Ley 39/2015), con dos plazos propios que fija el art. 114.2 de la Ley 11/2022: un año para resolver y, como mínimo, quince días hábiles para presentar alegaciones.]],
)

#q("F-R9.5", "c",
  [Según el art. 114.2 de la Ley 11/2022, en el procedimiento sancionador en materia de telecomunicaciones el plazo de alegaciones es, como mínimo, de:],
  ([diez días hábiles], [quince días naturales], [quince días hábiles], [diez días naturales]),
  sol: [El art. 114.2 dice que el plazo de alegaciones será como mínimo de quince días hábiles, y que el procedimiento debe resolverse en un año. «Como mínimo» significa que la Administración puede conceder más tiempo, pero no menos. Las dos opciones de diez días quedan por debajo del mínimo legal, y quince días naturales dan menos tiempo que quince hábiles, de modo que tampoco lo cumplen. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[En el procedimiento sancionador de telecomunicaciones se aplica el procedimiento administrativo común (Ley 39/2015), con dos plazos propios que fija el art. 114.2 de la Ley 11/2022: las alegaciones disponen como mínimo de quince días hábiles, y el procedimiento debe resolverse en un año.]],
)

#q("F-R9.6", "d",
  [Según el art. 109.6 de la Ley 11/2022, hay incumplimiento reiterado cuando se impone sanción firme en vía administrativa por dos o más infracciones del mismo tipo en un período de:],
  ([un año], [dos años], [cinco años], [tres años]),
  sol: [El art. 109.6 lo define así: sanción firme en vía administrativa por dos o más infracciones del mismo tipo en un período de tres años. La reiteración agrava la calificación: las leves reiteradas pasan a ser graves (art. 107.44) y las graves reiteradas, muy graves (art. 106.16). Un año y dos años son plazos de prescripción de las infracciones leves y graves (art. 113), y cinco años es el máximo de la inhabilitación (art. 109.1.b): ninguno mide la reiteración. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[Incumplimiento reiterado (art. 109.6 de la Ley 11/2022): sanción firme en vía administrativa por dos o más infracciones del mismo tipo en un período de tres años. Sus efectos: las infracciones leves reiteradas se consideran graves (art. 107.44) y las graves reiteradas, muy graves (art. 106.16).]],
)

#q("F-R9.7", "b",
  [Según el art. 103.2 de la Ley 11/2022, el acceso de la inspección de telecomunicaciones a una finca o inmueble donde hay equipos o estaciones requiere el consentimiento de su titular o autorización judicial:],
  ([en todos los casos, aunque la finca no sea un domicilio], [solo cuando sea necesario entrar en un domicilio constitucionalmente protegido o efectuar registros en él], [siempre que el titular no esté presente durante la inspección], [nunca, porque los titulares están obligados a permitir el acceso en cualquier circunstancia]),
  sol: [El art. 103.2 obliga a los titulares de fincas o inmuebles con equipos de telecomunicación a permitir el acceso de la inspección. El consentimiento del titular o la autorización judicial solo hacen falta cuando sea necesario entrar en un domicilio constitucionalmente protegido o efectuar registros en él, y el órgano contencioso-administrativo resuelve en un máximo de setenta y dos horas. Fuera de ese caso, negar u obstruir el acceso es infracción grave (art. 107.36). Por eso fallan «en todos los casos» y «nunca»; la ausencia del titular no figura en la ley. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[Los titulares de fincas o inmuebles donde haya equipos, estaciones o instalaciones de telecomunicaciones deben permitir el acceso de la inspección (art. 103.2 de la Ley 11/2022). Hace falta el consentimiento del titular o autorización judicial solo si se ha de entrar en un domicilio constitucionalmente protegido o efectuar registros en él; el juzgado contencioso-administrativo resuelve en un máximo de 72 horas. La negativa o la obstrucción a ser inspeccionado es infracción grave (art. 107.36).]],
)

#q("F-R9.8", "c",
  [La producción deliberada de interferencias a redes o servicios autorizados constituye, según la Ley 11/2022:],
  ([una infracción grave], [una infracción leve], [una infracción muy grave], [una infracción solo cuando la Administración ya ha requerido el cese]),
  sol: [El art. 106.7 tipifica como infracción muy grave la producción deliberada de interferencias a redes o servicios autorizados. La mera producción de interferencias, sin deliberación, es grave (art. 107.6): la diferencia está en la intención. No hace falta requerimiento previo para que haya infracción; no atender después el requerimiento de cese es otra infracción muy grave distinta (art. 106.8). «Leve» infravalora ambas conductas, y «solo tras el requerimiento» contradice el texto de la ley. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 106.7 de la Ley 11/2022: es infracción muy grave la producción deliberada, en España o en los países vecinos, de interferencias a redes o servicios autorizados. La mera producción de interferencias, sin deliberación, es infracción grave (art. 107.6), y no atender el requerimiento de cese de la Secretaría de Estado es de nuevo muy grave (art. 106.8).]],
)

#q("F-R9.9", "a",
  [La utilización del dominio público radioeléctrico, de frecuencias o de canales no adecuada al Cuadro Nacional de Atribución de Frecuencias (CNAF) es, según la Ley 11/2022:],
  ([una infracción muy grave], [una infracción grave], [una infracción leve], [una infracción solo si llega a causar interferencias]),
  sol: [El art. 106.5 incluye entre las infracciones muy graves la utilización del dominio público radioeléctrico, frecuencias o canales no adecuada al plan de utilización del espectro o al CNAF. La ley no exige que cause interferencias: basta con que el uso no se ajuste a la atribución. Otras infracciones próximas tienen menor grado: usar el espectro sin la autorización necesaria es grave (art. 107.5) e incumplir las condiciones de la autorización es leve (art. 108.5). Por eso «grave», «leve» y «solo si interfiere» fallan. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 106.5 de la Ley 11/2022: es infracción muy grave utilizar el dominio público radioeléctrico, frecuencias o canales radioeléctricos de modo no adecuado al plan de utilización del espectro o al Cuadro Nacional de Atribución de Frecuencias (CNAF). Basta la falta de adecuación; no se exige que haya interferencias. Usar el espectro sin la autorización necesaria es, en cambio, infracción grave (art. 107.5), e incumplir las condiciones de la autorización, leve (art. 108.5).]],
)

#q("F-R9.10", "d",
  [Efectuar emisiones que incumplan los límites de exposición a las emisiones radioeléctricas, o incumplir las medidas de señalización o vallado de las instalaciones radioeléctricas, constituye, según la Ley 11/2022:],
  ([una infracción muy grave], [una infracción leve], [una recomendación de seguridad, sin consecuencias sancionadoras], [una infracción grave]),
  sol: [El art. 107.7 tipifica como infracción grave efectuar emisiones que incumplan los límites de exposición, o incumplir las demás medidas de seguridad, incluidas las obligaciones de señalización o vallado de las instalaciones. También lo es contribuir, con emisiones no autorizadas, a que esos límites se superen. Conecta con el Anexo I, 3.5, de la Orden IET/1311/2013: las potencias máximas no eximen de reducir la potencia emitida, si hace falta, para que la energía radiada quede por debajo del valor que allí se fija en los emplazamientos accesibles o de paso. Sobrepasar los límites ni es una simple recomendación ni una falta leve. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 107.7 de la Ley 11/2022: es infracción grave efectuar emisiones radioeléctricas que incumplan los límites de exposición fijados en la normativa de desarrollo (niveles de emisión radioeléctrica tolerable) o incumplir las demás medidas de seguridad, incluidas las obligaciones de señalización o vallado de las instalaciones radioeléctricas. También lo es contribuir, mediante emisiones no autorizadas, a que esos límites se incumplan.]],
)

#q("F-R9.11", "b",
  [La instalación de una estación de radioaficionado careciendo de autorización constituye, según la Ley 11/2022:],
  ([una infracción grave], [una infracción leve], [una infracción muy grave], [una infracción solo si la estación llega a emitir]),
  sol: [El art. 108.4 tipifica como infracción leve la instalación de estaciones radioeléctricas de radioaficionado careciendo de autorización: es el tipo propio de nuestro servicio. El art. 107.1, más general, castiga como grave la instalación sin autorización de estaciones radioeléctricas; para las de radioaficionado la ley tiene su tipo leve. La ley castiga la propia instalación, sin exigir que la estación llegue a emitir. La multa máxima de una infracción leve es de 100 000 euros (art. 109.1.d). #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[Infracciones leves que afectan al radioaficionado (art. 108 de la Ley 11/2022): comunicarse utilizando estaciones no autorizadas (108.2), instalar una estación de radioaficionado careciendo de autorización (108.4) e incumplir las condiciones de la autorización (108.5). Multa máxima: 100 000 euros (art. 109.1.d). Instalar sin la autorización necesaria otras estaciones radioeléctricas es, en general, infracción grave (art. 107.1).]],
)

#q("F-R9.12", "c",
  [La producción de cualquier tipo de emisión radioeléctrica no autorizada es, según la Ley General de Telecomunicaciones, una infracción:],
  ([muy grave en todo caso], [grave en todo caso], [leve, salvo que deba considerarse grave o muy grave], [que solo se sanciona si llega a causar interferencias]),
  sol: [Lo dice el art. 108.1 de la Ley 11/2022: emitir sin autorización es, como regla, infracción leve (multa de hasta 100.000 euros, art. 109.1.d). La salvedad final importa: si la emisión vulnera los planes de utilización del espectro o el Cuadro Nacional de Atribución de Frecuencias es muy grave (art. 106.6), y si produce interferencias puede pasar a grave (art. 107.6) o muy grave (art. 106.7, si son deliberadas). Por eso «grave en todo caso» y «muy grave en todo caso» son falsas. Tampoco hace falta causar interferencias: la emisión no autorizada ya es infracción por sí misma. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Infracciones leves del art. 108 de la Ley 11/2022 que afectan al radioaficionado: producir cualquier tipo de emisión radioeléctrica no autorizada (108.1), salvo que deba considerarse grave o muy grave; comunicarse con estaciones no autorizadas (108.2); instalar una estación de radioaficionado careciendo de autorización (108.4); incumplir las condiciones autorizadas (108.5); no facilitar datos a la Administración (108.12). Multa de hasta 100.000 euros (art. 109.1.d). Instalar estaciones radioeléctricas sin la autorización necesaria es, en general, infracción grave (art. 107.1).]],
)
