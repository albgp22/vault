#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T10
// ---------------------------------------------------------------------
#let _t10-chico(c) = text(size: 7.5pt, c)

/// Caja con texto centrado para diagramas de bloques dibujados con CeTZ.
#let _t10-caja(a, b, cuerpo, relleno: col.acento-claro, borde: col.acento) = {
  import cetz.draw: *
  rect(a, b, radius: 0.1, fill: relleno, stroke: 0.7pt + borde)
  content((a, 50%, b), align(center, text(size: 7.5pt, cuerpo)))
}

#tema("T10", "Seguridad", alcance: [Precauciones frente a accidentes eléctricos en la estación · protecciones generales y de los equipos · protección contra contactos de las personas · puesta a tierra · disposición de antenas y líneas de alimentación · protección contra descargas atmosféricas.])

En la estación conviven tres riesgos. El *eléctrico* clásico: la red de 230 V, las fuentes internas y — donde aún hay válvulas — tensiones de miles de voltios que sobreviven en los condensadores incluso con el equipo apagado; contra él, un *interruptor general* que corte toda la estación de un solo gesto, protecciones diferencial y magnetotérmica, y la regla de no trabajar nunca en un equipo en tensión. El de *radiofrecuencia*: los extremos de una antena en transmisión llevan tensiones de RF elevadas y tocarlos produce quemaduras profundas — una antena que transmite no se toca, y se instala donde nadie pueda hacerlo. Y el *atmosférico*: el mástil es un pararrayos involuntario, así que antenas y soportes se conectan a tierra, las bajadas se desconectan o derivan en tormenta, y la instalación se protege contra descargas.

Los umbrales fisiológicos justifican las protecciones: la corriente se percibe hacia 1 mA, los músculos dejan de obedecer en torno a 10–20 mA («no poder soltar») y la fibrilación acecha desde unos 30 mA — justamente la sensibilidad del interruptor diferencial doméstico. La quemadura de RF es otra cosa: no hay calambre, porque a esas frecuencias el sistema nervioso no responde, pero la energía se deposita en el tejido y quema en profundidad. Por eso la antena se respeta aunque «solo» haya unos vatios.

=== Por qué mata la corriente (y no la tensión)

#motivacion[Un pájaro se posa tranquilamente sobre un cable de alta tensión de miles de voltios. Tú tocas un enchufe de 230 V con una mano mientras pisas el suelo descalzo, y puedes morir. ¿Qué tiene el pájaro que no tengas tú?]

El pájaro tiene las dos patas sobre el *mismo* cable: entre ellas no hay diferencia de potencial, no pasa corriente por su cuerpo y no le ocurre nada. Tú, en cambio, tocas la fase con la mano y la tierra con los pies: tu cuerpo *cierra un circuito*, y por él pasa una corriente. Lo que daña los tejidos, contrae los músculos y desordena el ritmo del corazón es esa *corriente*; la tensión solo importa porque es la que la empuja a través de tu resistencia, según la ley de Ohm: $I = V slash R_"cuerpo"$.

#circuito(caption: [Cómo se cierra el circuito en un contacto directo. El neutro de la red está unido a tierra en el transformador de distribución. Quien toca la fase estando en contacto con el suelo ofrece a la corriente un camino de vuelta a través de su cuerpo y del terreno.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    trafo("t", (0, 1.5))
    content((-1.3, 1.5), anchor: "east", _t10-chico[media\ tensión])
    wire("t.s1", (5.6, 2.3))
    wire("t.s2", (3.6, 0.7))
    node("nn", (3.6, 0.7), fill: false)
    content((3.75, 0.7), anchor: "west", _t10-chico[neutro])
    content((3.0, 2.6), anchor: "south", _t10-chico[fase (230 V respecto a tierra)])
    node("k", (1.7, 0.7))
    wire((1.7, 0.7), (1.7, -0.4))
    earth("e1", (1.7, -0.4))
    node("kp", (5.6, 2.3))
    resistor("rp", (5.6, 2.3), (5.6, -0.4), label: [$R_"cuerpo"$])
    earth("e2", (5.6, -0.4))
    content((7.5, 1.0), anchor: "west", _t10-chico[persona: la mano en la fase,\ los pies en el suelo])
    line((5.3, -1.25), (2.0, -1.25), mark: (end: ">", fill: col.senal2), stroke: (paint: col.senal2, thickness: 0.8pt, dash: "dashed"))
    content((3.65, -1.4), anchor: "north", text(size: 7.5pt, fill: col.senal2)[la corriente vuelve por el terreno])
  })
] <t10-fig-cuerpo>

#porque[
  - El transformador que alimenta el barrio tiene su neutro unido a tierra. Por eso la fase está a 230 V *respecto al suelo*: cualquier cosa que toque a la vez la fase y el suelo cierra el circuito.
  - El cuerpo es una resistencia. Por dentro (sangre, músculos) es buen conductor, del orden de 500 a 1000 Ω; la piel seca añade miles de ohmios, la piel mojada casi nada. El calzado y el suelo también suman.
  - La corriente sigue el camino entre el punto de entrada y el de salida. Si ese camino cruza el pecho — mano a mano o mano a pies —, atraviesa el corazón, y eso es lo que convierte unas decenas de miliamperios en un accidente mortal (T10.20).
]

#circuito(caption: [Efectos de la corriente alterna de 50 Hz que atraviesa el cuerpo (valores orientativos, escala logarítmica). El interruptor diferencial doméstico corta a 30 mA, justo donde empieza la zona de fibrilación.])[
  #cetz.canvas({
    import cetz.draw: *
    let x(i) = 3.6 * calc.log(i / 0.1)
    let zona(a, b, relleno, etq) = {
      rect((x(a), 0), (x(b), 0.7), fill: relleno, stroke: 0.4pt + col.gris)
      content(((x(a) + x(b)) / 2, 0.35), align(center, text(size: 6.5pt, etq)))
    }
    zona(0.1, 1, col.gris-claro, [no se nota])
    zona(1, 10, col.verde-claro, [se percibe:\ hormigueo])
    zona(10, 30, col.ambar-claro, [contracción:\ no poder soltar])
    zona(30, 1000, col.naranja-claro, [riesgo de fibrilación ventricular y quemaduras])
    for (i, e) in ((0.1, [0,1]), (1, [1]), (10, [10]), (30, [30]), (50, [50]), (100, [100]), (1000, [1000 mA])) {
      line((x(i), 0), (x(i), -0.12), stroke: 0.5pt)
      content((x(i), -0.15), anchor: "north", text(size: 7pt, e))
    }
    line((x(30), 0.7), (x(30), 1.2), stroke: 1.2pt + col.senal2)
    content((x(30), 1.25), anchor: "south", text(size: 7pt, fill: col.senal2)[diferencial: 30 mA])
  })
] <t10-fig-umbrales>

#ejemplo(titulo: [Piel seca y piel mojada])[
  - Con las manos secas, entre la piel y el calzado la resistencia del camino mano-pies puede ser de unos 10 kΩ. Tocar 230 V da $230 slash 10 000 = 23$ mA: no puedes soltar, y estás al borde de la fibrilación.
  - Con las manos mojadas y descalzo, la resistencia baja a 1 kΩ o menos: $230 slash 1000 = 230$ mA. Es una corriente muy por encima del umbral de fibrilación (T10.37).
  - Con 12 V y 10 kΩ, en cambio, pasan 1,2 mA: apenas se notan. Por eso las tensiones bajas son seguras en seco, y por eso la pregunta «qué es más peligroso» se contesta mirando los miliamperios (T10.21, T10.36): 500 V y 100 mA es la peor combinación.
]

#ojo[La corriente tetaniza los músculos, puede llevar el corazón a la fibrilación y quema por efecto Joule por dentro y por fuera. La «somnolencia» no es un efecto de la descarga (T10.35). Y el agua *no* protege: el cuerpo mojado conduce mejor, y el riesgo aumenta (T10.37).]

=== Quemaduras de RF y exposición a los campos

#motivacion[Los nervios y el corazón reaccionan a corrientes lentas, como los 50 Hz de la red. A millones de hercios el sistema nervioso ya no responde y no hay calambre. ¿Significa eso que la RF no es peligrosa?]

No. La RF no da calambre, pero calienta: hace oscilar las moléculas del tejido y deposita energía en él, igual que un horno de microondas. Si tocas el extremo de una antena que transmite, la corriente de RF entra por un punto pequeño de la piel y produce una quemadura profunda, a veces sin dolor inmediato. Y los extremos de un dipolo, donde la tensión es máxima, pueden estar a cientos o miles de voltios de RF con solo 100 W. De ahí la regla: una antena que transmite no se toca, sea cual sea la potencia o la polarización (T10.2), y se instala donde nadie pueda tocarla.

Lejos de la antena el peligro es más sutil: la *exposición* prolongada a campos intensos. La Recomendación 1999/519/CE del Consejo de la Unión Europea, recogida en España por el Real Decreto 1066/2001, fija niveles de referencia para el público. Entre 10 y 400 MHz, el nivel de referencia es de 28 V/m (#box[2 W/m²]), promediado durante 6 minutos. El campo baja con la distancia, y con la fórmula de campo lejano del tema T8 se puede estimar a qué distancia se cumple.

#ejemplo[
  Una antena colineal de 2 m con una ganancia de 5 veces y 50 W de potencia continua (FM con el pulsador apretado): $E approx sqrt(30 dot 50 dot 5) slash d approx 87 slash d$. El campo baja a 28 V/m a $d approx 87 slash 28 approx 3$ m. A 1 m, el campo sería de unos 87 V/m. Conclusión práctica: la antena, en el tejado, lejos de las personas; nunca en el balcón a la altura de la cabeza. En SSB o CW la potencia media es mucho menor que la de pico, y la exposición promediada también.
]

La *puesta a tierra* es la columna vertebral de todo lo anterior: una toma de tierra de calidad conectada a _cada uno_ de los chasis metálicos de la estación, interconectados entre sí, deriva las corrientes de fuga (protege de contactos indirectos), da referencia a los equipos y ayuda frente a las descargas. Un solo equipo sin tierra rompe la cadena de protección. Y cuando la seguridad es la de otros — una interferencia que afecta a un servicio de seguridad de la vida humana, del tipo que sea — la norma es única e inmediata: dejar de emitir hasta resolver el problema.

=== La toma de tierra: un camino preparado para la fuga

#motivacion[Con los años, el aislamiento de un cable se agrieta dentro de un equipo y la fase toca el chasis metálico. El equipo sigue funcionando, nadie lo nota… y la caja está a 230 V esperando a que alguien la toque. Es un *contacto indirecto*: tocas algo que no debería tener tensión.]

#circuito(caption: [Defecto de aislamiento en un equipo con el chasis a tierra. La corriente de defecto $I_d$ sale por la fase, pasa al chasis y vuelve por el conductor de protección y la toma de tierra $R_T$; no vuelve por el neutro. La persona que toca el chasis queda en paralelo con un conductor de pocos ohmios.])[
  #esquema({
    import zap: *
    import cetz.draw: content, rect, line
    trafo("t", (0, 2))
    wire("t.s1", (8.6, 2.8))
    wire("t.s2", (8.6, 1.2))
    node("kn", (1.6, 1.2))
    wire((1.6, 1.2), (1.6, 0))
    earth("en", (1.6, 0))
    content((1.6, -1.0), _t10-chico[tierra del\ transformador])
    content((1.3, 3.0), anchor: "south-west", _t10-chico[fase])
    content((2.0, 1.0), anchor: "north-west", _t10-chico[neutro])
    rect((3.1, 0.75), (4.5, 3.25), radius: 0.1, fill: col.acento-claro.transparentize(30%), stroke: (paint: col.acento, thickness: 0.7pt, dash: "dashed"))
    content((3.8, 3.5), _t10-chico[diferencial])
    // aparato
    rect((6.2, 0.5), (9.4, 4.1), radius: 0.12, stroke: 1.3pt + col.gris)
    content((7.8, 4.35), _t10-chico[chasis metálico del aparato])
    resistor("carga", (8.6, 2.8), (8.6, 1.2), label: (content: _t10-chico[carga], anchor: "south"))
    node("kf", (7.1, 2.8))
    resistor("def", (7.1, 2.8), (7.1, 4.1), label: (content: text(fill: col.senal2, size: 7.5pt)[defecto], anchor: "south"))
    node("kd", (7.1, 4.1))
    // conductor de protección y toma de tierra
    wire((7.6, 0.5), (7.6, -0.2))
    node("kpe", (7.6, 0.5))
    resistor("rt", (7.6, -0.2), (7.6, -1.6), label: $R_T$)
    earth("et", (7.6, -1.6))
    // persona
    wire((9.4, 2.0), (10.4, 2.0))
    node("kp", (9.4, 2.0))
    resistor("rp", (10.4, 2.0), (10.4, -1.6), label: _t10-chico[persona])
    earth("ep", (10.4, -1.6))
    content((5.4, -0.55), anchor: "east", text(size: 7.5pt, fill: col.senal2)[$I_d$ vuelve por tierra])
    line((7.2, -0.3), (5.5, -0.3), mark: (end: ">", fill: col.senal2), stroke: 0.7pt + col.senal2)
  })
] <t10-fig-tierra>

#porque[
  - *Con el chasis a tierra*, el defecto se convierte en una fuga franca: en cuanto aparece, la corriente $I_d$ circula por el conductor de protección hacia la toma de tierra. Esa corriente sale por la fase y no vuelve por el neutro, así que el diferencial la detecta y corta *antes* de que nadie toque el equipo (T10.3).
  - Mientras tanto, la persona que tocara el chasis estaría en paralelo con un conductor de pocos ohmios: la corriente prefiere el camino fácil y por ella pasa muy poca.
  - *Sin tierra*, el defecto no hace circular nada: el chasis queda a 230 V, en silencio. El diferencial solo actuará cuando alguien lo toque y la corriente atraviese su cuerpo.
  - Por eso *todos* los chasis deben ir unidos a la misma tierra (T10.4, T10.22): un solo equipo sin conectar es justo el punto peligroso. Y por eso el conductor de tierra *nunca* lleva fusible ni interruptor (T10.26): lo dejarían abierto justo cuando hace falta.
]

#ejemplo(titulo: [Cuánta resistencia de tierra hace falta])[
  En las viviendas (esquema TT), la norma pide que una fuga igual a la sensibilidad del diferencial no ponga el chasis a más de 50 V (24 V en locales húmedos): $R_T dot I_(Delta n) <= 50$ V. Con un diferencial de 30 mA, $R_T <= 50 slash 0,03 approx 1700$ Ω. Con una toma de tierra de 100 Ω, una fuga de 30 mA eleva el chasis a solo $100 dot 0,03 = 3$ V, y cualquier fuga mayor dispara el diferencial. Cuanto menor es la resistencia de tierra, mejor (T10.22).
]

La resistencia de la toma de tierra depende sobre todo del terreno: la humedad lo hace conductor, y por eso las picas se clavan en zonas húmedas y frescas, nunca en terreno seco y soleado (T10.28). No hace falta una pica propia: sirve la tierra del edificio si existe y está en buen estado (T10.27). Lo que nunca sirve es el *neutro* — es un conductor activo, por el que vuelve la corriente de la casa — ni una tubería, y menos la del gas.

#idea[Los fusibles y el magnetotérmico protegen la *instalación* (vigilan cuánta corriente pasa). El diferencial y la toma de tierra protegen a las *personas* (vigilan que la corriente no se escape por donde no debe).]

=== Condensadores que guardan la carga

#motivacion[Desenchufas un amplificador de válvulas, esperas un minuto y metes la mano. Te llevas una descarga de 2000 V. ¿De dónde sale, si no está enchufado?]

#circuito(caption: [Fuente de alta tensión con resistencia de descarga. (a) $R_D$, en paralelo con el condensador de filtro, lo descarga cuando se desconecta el equipo. (b) Tensión del condensador tras desenchufar, con $C = 20$ μF y $R_D = 500$ kΩ: la constante de tiempo es de 10 s y la tensión tarda más de medio minuto en bajar de 50 V.], sim: "cap.txt")[
  #grid(
    columns: (1.15fr, 1fr),
    align: center + bottom,
    esquema({
      import zap: *
      import cetz.draw: content
      trafo("t", (0, 1.4), espiras: (3, 5))
      content((-1.15, 1.4), anchor: "east", _t10-chico[230 V])
      diode("d", "t.s1", (3.0, 2.4))
      capacitor("c", (3.0, 2.4), (3.0, 0.4), label: (content: $C$, anchor: "south"))
      resistor("rd", (4.4, 2.4), (4.4, 0.4), label: $R_D$)
      wire((3.0, 2.4), (5.6, 2.4))
      wire("t.s2", (5.6, 0.4))
      node("k1", (3.0, 2.4))
      node("k2", (4.4, 2.4))
      node("k3", (3.0, 0.4))
      node("k4", (4.4, 0.4))
      node("o1", (5.6, 2.4), fill: false)
      node("o2", (5.6, 0.4), fill: false)
      content((5.75, 1.4), anchor: "west", _t10-chico[alta\ tensión])
      content((2.6, -0.5), text(size: 8.5pt)[(a)])
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 5.2, 0, 2.9, etq-x: [$t$ (s)], etq-y: [$V$])
      let xt(t) = t / 12
      onda(x => 2.4 * calc.exp(-x * 12 / 10), 0, 4.8, n: 160, stroke: 1.2pt + col.senal1)
      line((0, 2.4 * 50 / 2000), (5, 2.4 * 50 / 2000), stroke: (paint: col.senal2, thickness: 0.5pt, dash: "dashed"))
      content((5.0, 0.12), anchor: "south-east", text(size: 6.5pt, fill: col.senal2)[50 V])
      content((-0.08, 2.4), anchor: "east", text(size: 6.5pt)[2000 V])
      for t in (10, 20, 30, 40) {
        line((xt(t), 0), (xt(t), -0.08), stroke: 0.5pt)
        content((xt(t), -0.1), anchor: "north", text(size: 6.5pt, str(t)))
      }
      content((2.6, -0.85), text(size: 8.5pt)[(b)])
    }),
  )
] <t10-fig-descarga>

#porque[
  - El condensador de filtro (#ver(<sec-fuente>)) se carga a la tensión de pico y, si nada lo descarga, la *conserva* durante horas después de desenchufar: es una pila que nadie ve. En una fuente de 2000 V con 20 μF hay almacenados $1/2 C V^2 = 1/2 dot 20 dot 10^(-6) dot 2000^2 = 40$ J, energía de sobra para matar.
  - La *resistencia de descarga* $R_D$ (en inglés, _bleeder_) está siempre conectada en paralelo: mientras el equipo funciona consume un poco ($2000^2 slash 500 000 = 8$ W) y, al apagarlo, vacía el condensador con la constante de tiempo $tau = R_D C = 10$ s.
  - Aun así, la tensión baja de forma exponencial y tarda $tau ln(2000 slash 50) approx 37$ s en caer a 50 V. Y una resistencia de descarga puede abrirse con los años sin que nadie se entere.
]

#ojo[Desenchufar no basta (T10.16, T8.24). Antes de meter la mano en un equipo: desconectarlo de la red, esperar, *descargar los condensadores* con una punta o pértiga de descarga unida a masa, y comprobar con el voltímetro que no queda tensión. Nunca se trabaja en un equipo en tensión «para localizar la avería».]

=== Baterías: mucha corriente y algo de química

Una batería de 12 V parece inofensiva — no da calambre —, pero tiene dos peligros propios:
- *Corriente de cortocircuito enorme.* Una batería de coche puede entregar cientos de amperios. Una llave inglesa, un anillo o una pulsera que caigan entre los bornes se ponen al rojo en segundos y queman la piel. Por eso se trabaja sin anillos ni relojes metálicos, y el fusible del cable de alimentación va *junto a la batería* (@t10-fig-fusible).
- *Química.* Las de plomo y ácido desprenden hidrógeno al cargarse: hay que ventilar y evitar chispas cerca, por ejemplo al conectar o desconectar las pinzas. Las de litio no toleran la sobrecarga, los golpes ni los cortocircuitos: pueden entrar en embalamiento térmico y arder con un fuego difícil de apagar. Se cargan solo con su cargador.

=== Rayos, mástiles y líneas eléctricas

#motivacion[Una antena es un conductor alto y puntiagudo unido, a través del coaxial, al interior de tu casa. Para un rayo es el camino ideal. Y un mástil es una estructura alta que algún día puede caer.]

#circuito(caption: [Protección de la instalación de antena. El mástil y la malla del coaxial se unen a tierra por el exterior, con conductores cortos y directos; un descargador en la entrada del cable deriva a tierra las sobretensiones. La línea eléctrica aérea debe quedar más lejos que la altura total del conjunto: si este cae, no debe poder alcanzarla.])[
  #cetz.canvas({
    import cetz.draw: *
    let verde = col.verde
    // terreno
    line((-0.5, 0), (11.5, 0), stroke: 0.8pt + col.gris)
    for i in range(24) { line((-0.3 + i * 0.5, 0), (-0.5 + i * 0.5, -0.18), stroke: 0.4pt + col.gris) }
    // casa
    rect((0, 0), (4, 3), stroke: 0.9pt + col.tinta)
    content((2, 0.3), _t10-chico[vivienda])
    // mástil y antena
    line((3, 3), (3, 6.2), stroke: 1.6pt + col.gris)
    line((2.0, 6.2), (4.0, 6.2), stroke: 1.2pt)
    for xe in (2.2, 2.8, 3.4, 3.9) { line((xe, 5.85), (xe, 6.55), stroke: 1pt) }
    content((3, 6.75), anchor: "south", _t10-chico[antena])
    // bajada de tierra (verde) por el exterior
    line((3, 3.15), (4.6, 3.15), (4.6, 0), (4.6, -1.2), stroke: 1.6pt + verde)
    line((4.6, -0.2), (4.6, -1.3), stroke: 2.5pt + verde)
    content((4.45, -0.95), anchor: "east", text(size: 7pt, fill: verde)[pica de tierra])
    // coaxial
    line((2.85, 6.1), (2.85, 3.35), (4.3, 3.35), (4.3, 1.8), (2.6, 1.8), stroke: 1.1pt + col.tinta)
    // descargador
    rect((4.15, 1.95), (4.45, 2.45), fill: col.ambar-claro, stroke: 0.6pt + col.ambar)
    line((4.45, 2.2), (4.6, 2.2), stroke: 1.2pt + verde)
    content((4.75, 2.25), anchor: "west", _t10-chico[descargador])
    // transceptor
    _t10-caja((1.2, 1.4), (2.6, 2.2), [transceptor])
    line((1.9, 1.4), (1.9, 0.9), (4.6, 0.9), stroke: 1.2pt + verde)
    content((3.3, 1.0), anchor: "south", text(size: 6.5pt, fill: verde)[tierra única])
    content((6.9, 3.2), anchor: "west", text(size: 7pt, fill: verde)[mástil a tierra:\ conductor grueso,\ corto y sin curvas])
    // radio de caída
    arc((3, 3), start: 90deg, stop: 0deg, radius: 3.6, anchor: "origin", stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    content((5.75, 5.75), anchor: "south-west", text(size: 7pt, fill: col.senal2)[si el conjunto cae…])
    // línea eléctrica
    line((10.2, 0), (10.2, 5.4), stroke: 2pt + col.gris)
    line((9.6, 5.2), (10.8, 5.2), stroke: 1.2pt + col.gris)
    line((9.0, 5.25), (11.4, 5.15), stroke: 0.7pt)
    content((10.2, 5.65), anchor: "south", _t10-chico[línea eléctrica aérea])
    line((3, -1.6), (10.2, -1.6), mark: (start: ">", end: ">", fill: black, scale: 0.7), stroke: 0.6pt)
    content((6.6, -1.75), anchor: "north", _t10-chico[distancia mayor que la altura total de mástil y antena])
  })
] <t10-fig-rayo>

#porque[
  - *Mástil a tierra.* Un rayo que cae sobre la antena busca el camino más corto al suelo. Si le das uno — un conductor grueso que baja por el exterior hasta la pica, sin curvas cerradas —, no necesita buscarlo a través de la casa.
  - *Descargador en la entrada.* Aunque no caiga un rayo directo, una tormenta cercana induce sobretensiones en el coaxial. El descargador (de gas o de chispa) no conduce a la tensión normal de la RF, pero ante una sobretensión se ceba y la deriva a tierra antes de que entre en la casa.
  - *Una sola tierra.* El mástil, el descargador y los chasis de la estación se unen a la misma toma de tierra. Si hubiera tierras separadas, durante una descarga aparecerían miles de voltios entre ellas, es decir, entre los equipos.
  - *Ante una tormenta*, lo más seguro es desconectar la antena del equipo (mejor aún, dejarla unida a tierra) y desenchufar el equipo de la red: así se cortan los dos caminos de entrada (T10.13).
]

El mástil plantea además riesgos mecánicos:
- *Las líneas eléctricas aéreas.* Es el riesgo más grave de toda la instalación: un mástil que cae sobre una línea es mortal para quien lo sujeta, y que la línea parezca aislada no cambia nada. La distancia debe ser mayor que la altura total del conjunto (T10.14, T10.31).
- *Los vientos (tirantes).* Se reparten alrededor del mástil y se tensan por igual, para que lo mantengan vertical venga el viento de donde venga (T10.15). Si son metálicos y miden cerca de un cuarto o media longitud de onda, resuenan, captan energía y deforman el diagrama de la antena: se trocean con aisladores en tramos que no resuenen (T10.29).
- *El soporte.* La antena va en un mástil propio, no en el de la antena colectiva de televisión del edificio (T10.30). El rotor debe aguantar el peso y el par de la antena, y su cable de control, que también puede llevar RF y sobretensiones, se protege y se separa del coaxial (T10.24).
- *El trabajo en altura.* Arnés y calzado adecuado, comprobar antes la estructura, suspender el trabajo si empeora el tiempo y *nunca trabajar solo* (T10.23).

=== Primeros auxilios ante un accidente eléctrico

#motivacion[El accidente eléctrico casi nunca lo presencia un médico, sino un familiar que está cerca. Lo que haga en el primer minuto decide. Y el error más común convierte a quien ayuda en la segunda víctima.]

+ *Cortar la corriente* con el interruptor general (por eso todos en casa deben saber dónde está). Mientras haya tensión, quien toque a la víctima entra en el circuito (T10.17, T10.19).
+ Si no se puede cortar enseguida, *separar a la víctima con un objeto aislante y seco*: una pértiga o un palo de madera seca, una silla de madera, una prenda seca. Nunca con las manos desnudas, nunca con agua (T10.18).
+ *Avisar a los servicios de emergencia* (112).
+ *Comprobar si respira.* Si no respira, iniciar enseguida la reanimación (compresiones torácicas y, si se sabe hacer, respiración boca a boca) hasta que llegue la ayuda: cada minuto cuenta (T10.34).
+ *Cubrirla* para que no pierda calor. *No darle de beber*: puede estar semiinconsciente y atragantarse (T10.33).
+ Las *quemaduras* se enfrían con agua abundante y se dejan para el médico, sin pomadas ni remedios caseros: la lesión de fuera puede ser pequeña y el daño de dentro, profundo (T10.32).

Ante un *conato de incendio* en un equipo conectado a la red, primero se corta la corriente y después se usa un extintor apto para fuego eléctrico (de CO#text(size: 0.7em, baseline: 0.22em)[2] o de polvo), nunca agua (T10.39). Y conviene que tanto el operador como su familia conozcan estas prácticas básicas (T10.38): el titular de la estación es el responsable de cumplir la normativa de seguridad (T10.40).

#q("T10.1", "c",
  [Como medida de protección y seguridad, toda estación radioeléctrica debe disponer de:],
  ([un extintor de espuma junto a cada equipo], [un sistema de alimentación ininterrumpida], [un interruptor general de suministro eléctrico], [un armario ignífugo para los transceptores]),
  sol: [El interruptor general permite cortar de un solo gesto el suministro de toda la estación ante cualquier emergencia.],
)

#q("T10.2", "a",
  [Una antena que está transmitiendo:],
  ([no se debe tocar con las manos], [puede tocarse si la potencia es inferior a 100 W], [puede tocarse si está polarizada verticalmente], [solo puede tocarse con guantes de lana]),
  sol: [Una antena en transmisión lleva RF de alta tensión en los extremos: tocarla produce quemaduras por radiofrecuencia.],
)

#q("T10.3", "b",
  [El transceptor debe estar conectado a tierra para:],
  ([mejorar la modulación], [proteger al operador de descargas eléctricas], [aumentar el alcance de las emisiones], [reducir el consumo eléctrico]),
  sol: [Si un defecto pone el chasis en tensión, la toma de tierra ofrece un camino de baja resistencia que lo mantiene a ∼0 V y deriva la corriente de fuga; esa corriente dispara el diferencial (sensible a unos 30 mA) antes de que el operador, al tocar el chasis, se convierta en el camino de retorno. Es la protección frente a contactos indirectos.],
)

#q("T10.4", "d",
  [La toma de tierra de la estación debe conectarse:],
  ([solo al equipo de mayor potencia], [únicamente al mástil de la antena], [solo a los equipos alimentados con corriente alterna], [a cada uno de los chasis metálicos de los distintos equipos]),
  sol: [La toma de tierra debe llegar a todos los chasis metálicos interconectados; un equipo sin tierra rompe la protección.],
)

#q("T10.5", "a",
  [Cuando una interferencia perjudicial afecta a la seguridad de la vida humana, el radioaficionado debe:],
  ([dejar de emitir hasta que el problema esté resuelto], [reducir la potencia a la mitad], [cambiar de modo de emisión], [seguir emitiendo si su estación está autorizada]),
  sol: [Ante una interferencia que afecte a la seguridad de la vida humana: dejar de emitir hasta resolver el problema.],
)

#q("T10.6", "c",
  [Si al emitir en la banda de 2 metros se tiene conocimiento de que se están produciendo interferencias al Servicio Móvil Aeronáutico, se deberá:],
  ([avisar por radio a las aeronaves], [seguir emitiendo con la mitad de potencia], [dejar de emitir], [cambiar a polarización horizontal]),
  sol: [Igual con un servicio de seguridad como el Móvil Aeronáutico: cesar las emisiones.],
)

#q("T10.7", "b",
  [Cuando una instalación de radioaficionado interfiere a una infraestructura común de telecomunicaciones (ICT) del edificio:],
  ([la comunidad debe blindar la ICT a su costa], [se tiene que dejar de emitir, al menos temporalmente], [basta con reducir la potencia un 10 %], [puede seguirse emitiendo si la instalación está autorizada]),
  sol: [Si la instalación interfiere a la ICT del edificio (antenas colectivas de TV, etc.), hay que dejar de emitir, al menos temporalmente, hasta corregir el problema.],
)

== Fusibles y protecciones <t10-sec-protecciones>

El cuaderno ha nombrado ya las protecciones de la estación; conviene saber exactamente de qué protege cada una, porque el examen las confunde a propósito (@t10-fig-protecciones).

El *fusible* es el más simple: un hilo calibrado, en _serie_ con el circuito, que se funde cuando la corriente pasa de cierto valor. Protege contra *sobreintensidades* — sobrecargas y cortocircuitos — y su virtud es que se sacrifica antes de que se queme nada más caro. De ahí la regla de oro: se sustituye por otro del _mismo calibre_. Poner uno de más amperios, o peor, un puente de hilo, es dejar el circuito desprotegido justo donde ya se sabe que puede fallar. El *magnetotérmico* hace el mismo trabajo con dos mecanismos —uno térmico, lento, para las sobrecargas; otro magnético, instantáneo, para los cortocircuitos— con la ventaja de que se rearma.

El *interruptor diferencial* protege otra cosa distinta, y esa es la pregunta que más se falla. No mira cuánta corriente pasa, sino si la que _va_ y la que _vuelve_ son iguales. Si no lo son, la diferencia se está escapando por algún sitio — típicamente, a través de una persona o de un aislamiento defectuoso — y el aparato corta. Por eso su sensibilidad, 30 mA en las instalaciones domésticas, coincide con el umbral de fibrilación: está pensado para salvar personas, no equipos. Protege frente a los *contactos indirectos* y los defectos de aislamiento. El papel de la *toma de tierra* merece aquí un matiz: sin ella el diferencial no queda ciego — si la fuga atraviesa a una persona, esa corriente también va y no vuelve, y el aparato corta igualmente —, pero entonces solo dispara cuando alguien ya está recibiendo la descarga. Con los chasis puestos a tierra, el defecto de aislamiento deriva corriente en cuanto aparece y el diferencial salta _antes_ de que nadie toque el equipo — y ese disparo previo al contacto es precisamente el que salva.

#circuito(caption: [Las protecciones de la estación, cada una en su sitio. El magnetotérmico y el fusible vigilan la _intensidad_; el diferencial, el _desequilibrio_ entre ida y vuelta — por eso el conductor de tierra no pasa por el diferencial, que solo vigila fase y neutro.])[
  #cetz.canvas({
    import cetz.draw: *
    let verde = col.verde
    // red
    content((-0.15, 1.0), anchor: "east", _t10-chico[red])
    content((-0.15, 0.4), anchor: "east", _t10-chico[230 V])
    line((0, 1.0), (1.4, 1.0), stroke: 0.8pt)
    line((0, 0.4), (1.4, 0.4), stroke: 0.8pt)
    _t10-caja((1.4, 0.15), (2.9, 1.25), [magneto-\ térmico])
    line((2.9, 1.0), (3.5, 1.0), stroke: 0.8pt)
    line((2.9, 0.4), (3.5, 0.4), stroke: 0.8pt)
    _t10-caja((3.5, 0.15), (5.0, 1.25), [diferencial\ 30 mA])
    line((5.0, 1.0), (5.6, 1.0), stroke: 0.8pt)
    line((5.0, 0.4), (5.6, 0.4), stroke: 0.8pt)
    _t10-caja((5.6, 0.15), (7.1, 1.25), [fuente])
    line((7.1, 1.0), (7.75, 1.0), stroke: 0.8pt)
    rect((7.75, 0.88), (8.45, 1.12), stroke: 0.8pt, fill: white)
    line((8.45, 1.0), (9.1, 1.0), stroke: 0.8pt)
    line((7.1, 0.4), (9.1, 0.4), stroke: 0.8pt)
    _t10-caja((9.1, 0.15), (10.6, 1.25), [transceptor])
    // etiquetas
    content((2.15, 1.45), anchor: "south", align(center, text(size: 7pt, fill: col.gris)[sobrecargas\ y cortocircuitos]))
    content((4.25, 1.45), anchor: "south", align(center, text(size: 7pt, fill: col.gris)[fugas a tierra\ (contacto indirecto)]))
    content((8.1, 1.3), anchor: "south", text(size: 7pt, fill: col.gris)[fusible])
    // tierra única
    line((6.35, 0.15), (6.35, -0.35), stroke: 0.9pt + verde)
    line((9.85, 0.15), (9.85, -0.35), stroke: 0.9pt + verde)
    line((3.2, -0.35), (9.85, -0.35), stroke: 0.9pt + verde)
    line((3.2, -0.35), (3.2, -0.75), stroke: 0.9pt + verde)
    line((2.95, -0.75), (3.45, -0.75), stroke: 1pt + verde)
    line((3.03, -0.85), (3.37, -0.85), stroke: 1pt + verde)
    line((3.11, -0.95), (3.29, -0.95), stroke: 1pt + verde)
    content((8.1, -0.5), anchor: "north", text(size: 7pt, fill: verde)[tierra única de la estación])
  })
] <t10-fig-protecciones>

=== El diferencial por dentro

#motivacion[¿Cómo puede un aparato saber si una corriente de 10 A que entra por la fase vuelve entera por el neutro, y notar que faltan 0,03 A, es decir, tres milésimas del total?]

#circuito(caption: [Principio del interruptor diferencial. La fase y el neutro atraviesan juntos un núcleo magnético en forma de anillo. Si la corriente de ida $I_F$ y la de vuelta $I_N$ son iguales, sus campos se anulan. Si una fuga $I_d$ se escapa a tierra, sobra campo, la bobina de detección da una tensión y el disparador abre los contactos.])[
  #esquema({
    import zap: *
    import cetz.draw: content, circle, line, rect, arc
    // contactos
    wire((0, 2.2), (1.0, 2.2))
    wire((0, 1.2), (1.0, 1.2))
    node("a1", (0, 2.2), fill: false)
    node("a2", (0, 1.2), fill: false)
    content((-0.15, 2.2), anchor: "east", _t10-chico[fase])
    content((-0.15, 1.2), anchor: "east", _t10-chico[neutro])
    switch("s1", (1.0, 2.2), (2.0, 2.2), closed: true)
    switch("s2", (1.0, 1.2), (2.0, 1.2), closed: true)
    wire((2.0, 2.2), (9.0, 2.2), i: (content: $I_F$, position: 14%, anchor: "south"))
    wire((9.0, 1.2), (2.0, 1.2), i: (content: text(size: 8pt, $I_N = I_F - I_d$), position: 44%, anchor: "north"))
    // núcleo toroidal
    circle((4.6, 1.7), radius: (0.42, 1.0), stroke: 4.5pt + col.gris.lighten(20%))
    content((4.6, 3.0), _t10-chico[núcleo])
    // bobina de detección
    for k in range(4) { arc((4.35 + k * 0.17, 0.62), start: 180deg, stop: 0deg, radius: 0.085, stroke: 0.8pt) }
    line((4.35, 0.62), (4.35, -0.4), stroke: 0.6pt)
    line((5.03, 0.62), (5.03, -0.4), stroke: 0.6pt)
    rect((3.8, -1.1), (5.6, -0.4), radius: 0.08, fill: col.acento-claro, stroke: 0.7pt + col.acento)
    content((4.7, -0.75), _t10-chico[disparador])
    // enlace mecánico
    line((3.8, -0.75), (1.5, -0.75), (1.5, 1.0), stroke: (paint: col.acento, thickness: 0.7pt, dash: "dashed"))
    content((1.4, -0.95), anchor: "north-east", _t10-chico[abre los contactos])
    // aparato con fuga
    rect((7.4, 0.6), (9.6, 3.0), radius: 0.1, stroke: 1.2pt + col.gris)
    content((8.5, 3.25), _t10-chico[chasis del aparato])
    resistor("carga", (9.0, 2.2), (9.0, 1.2))
    node("k1", (7.9, 2.2))
    line((7.9, 2.2), (7.9, 3.0), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
    content((7.98, 2.62), anchor: "west", text(size: 6.5pt, fill: col.senal2)[defecto])
    wire((9.6, 1.8), (10.3, 1.8), (10.3, 0.2))
    earth("e", (10.3, 0.2))
    content((10.45, 1.1), anchor: "west", text(size: 7.5pt, fill: col.senal2)[fuga $I_d$\ a tierra])
  })
] <t10-fig-diferencial>

#porque[
  - La corriente de la fase crea un campo magnético en el anillo; la del neutro, que va en sentido contrario, crea otro igual y opuesto. Si son iguales, el campo neto es *cero* y la bobina de detección no da nada, pase 1 A o pasen 20 A. Por eso el diferencial no protege contra sobrecargas: ese es trabajo del magnetotérmico.
  - Si parte de la corriente se escapa por otro camino (un chasis a tierra, una persona), por el neutro vuelve menos de lo que salió. Queda un campo neto proporcional a la fuga $I_d$, la bobina de detección da una tensión y el disparador abre los contactos en unas decenas de milisegundos (T10.10).
  - El conductor de tierra *no* pasa por el anillo: si pasara, la corriente de fuga volvería por dentro y el diferencial no la vería.
  - El botón de prueba («T») de todo diferencial hace pasar a propósito una pequeña corriente que esquiva el anillo, para comprobar que dispara. Conviene pulsarlo de vez en cuando.
]

=== El fusible: calibre y tipo

#motivacion[El fusible se funde para que no se queme otra cosa. Pero ¿qué otra cosa? ¿Y por qué uno de 25 A no sirve igual que uno de 30 A, «que aguanta más»?]

#circuito(caption: [Alimentación de 13,8 V de un transceptor. El fusible va en el positivo, lo más cerca posible de la batería o de la fuente: así protege también el cable. Un cortocircuito del cable contra el chasis (en rojo) quedaría sin protección si el fusible estuviera junto al equipo.])[
  #esquema({
    import zap: *
    import cetz.draw: content, rect, line
    bateria("b", (0, 2), (0, 0), label: [13,8 V])
    wire((0, 2), (0.7, 2))
    fuse("f", (0.7, 2), (2.3, 2), label: [25 A])
    wire((2.3, 2), (5.4, 2))
    wire((0, 0), (5.4, 0))
    rect((5.4, -0.4), (7.6, 2.4), radius: 0.12, fill: col.acento-claro, stroke: 0.7pt + col.acento)
    content((6.5, 1.0), align(center, _t10-chico[transceptor\ 100 W\ (≈ 20 A)]))
    line((3.0, 2), (2.8, 1.4), (3.2, 0.9), (3.0, 0), stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    content((3.3, 1.1), anchor: "west", text(size: 7pt, fill: col.senal2)[cortocircuito\ en el cable])
  })
] <t10-fig-fusible>

#porque[
  - El fusible es el *eslabón débil a propósito* del circuito: un hilo calculado para fundirse con una corriente algo mayor que la normal. Así, si algo falla aguas abajo — un cortocircuito en el cable, un transistor perforado en el equipo —, el hilo se funde antes de que el cable se ponga al rojo o arda el equipo.
  - Su *calibre* (la corriente nominal) debe ser *ligeramente superior al consumo máximo* del equipo (T10.25): con un transceptor que consume unos 20 A, un fusible de 25 A. Más bajo, saltaría sin avería; mucho más alto, el cable se quemaría antes de que el fusible se enterase.
  - Por eso se cambia siempre por *otro del mismo calibre* (T10.9). Un fusible fundido es un aviso: algo ha consumido de más. Uno mayor o un puente de hilo quitan la protección justo donde ya se sabe que hay un problema.
  - El *tipo* también importa. Los fusibles *rápidos* (F) se funden enseguida; los *temporizados* o lentos (T) aguantan sin fundirse las puntas breves de corriente del arranque — la carga de los condensadores de una fuente, la magnetización de un transformador — y solo se funden si la sobrecarga dura. Poner un rápido donde va uno lento hace que salte en cada encendido; al revés, el equipo queda peor protegido.
]

El *magnetotérmico* reúne los dos comportamientos en un aparato rearmable: una lámina bimetálica que se curva al calentarse (dispara despacio, ante sobrecargas mantenidas) y una bobina que atrae un núcleo de hierro (dispara al instante, ante un cortocircuito, cuando la corriente multiplica varias veces la nominal). Protege la instalación frente a sobrecargas y cortocircuitos (T10.12), pero no a las personas: los 30 mA que matan son una corriente insignificante para él.

#figure(kind: table, caption: [Cada protección, con lo que vigila y lo que protege.],
{
  set par(justify: false)
  set text(size: 9pt)
  table(
    columns: (auto, 1fr, 1fr, auto),
    align: left,
    [*Protección*], [*Qué vigila*], [*Contra qué protege*], [*Se rearma*],
    [Fusible], [La intensidad que pasa], [Sobrecargas y cortocircuitos], [No: se sustituye],
    [Magnetotérmico], [La intensidad que pasa], [Sobrecargas (térmico) y cortocircuitos (magnético)], [Sí],
    [Diferencial], [La diferencia entre ida y vuelta], [Fugas a tierra: contactos indirectos y defectos de aislamiento], [Sí],
    [Toma de tierra], [—], [Da camino a la fuga y mantiene los chasis cerca de 0 V], [—],
  )
},
) <t10-tab-protecciones>

#ojo[Es la distinción que más se pregunta (T10.8, T10.11, T10.12): fusible y magnetotérmico vigilan la _intensidad_ y protegen la instalación; el diferencial vigila el _desequilibrio_ y protege a las personas. Si la pregunta habla de «contactos indirectos» o de «defectos de aislamiento», la respuesta es el diferencial.]

#q("T10.8", "b",
  [Un fusible protege un circuito frente a:],
  ([las variaciones de frecuencia de la red], [las sobreintensidades, fundiéndose antes de que se dañe el equipo], [los contactos indirectos de las personas], [las descargas atmosféricas sobre la antena]),
  sol: [Es un hilo calibrado en serie con el circuito: cuando la corriente supera cierto valor, se funde y abre el paso. Se sacrifica él para que no se queme lo que hay detrás. De las personas se ocupa el diferencial.],
)

#q("T10.9", "d",
  [Cuando se funde el fusible de un equipo, debe sustituirse por:],
  ([uno de mayor calibre, para que no vuelva a fundirse], [un puente de hilo de cobre], [cualquiera que quepa en el portafusibles], [otro del mismo calibre que el original]),
  sol: [Un fusible fundido es un aviso, no una molestia: algo ha consumido más de la cuenta. Poner uno mayor o un puente elimina la protección justo donde ya se sabe que hay un problema, y el siguiente en fundirse será el equipo.],
)

#q("T10.10", "a",
  [Un interruptor diferencial actúa cuando en el circuito que protege:],
  ([la corriente de entrada y la de retorno dejan de ser iguales], [se supera la potencia contratada], [la tensión de red baja de un valor mínimo], [la frecuencia se aparta de los 50 Hz]),
  sol: [Toda la corriente que entra debe volver por el neutro. Si falta parte, se está yendo por otro camino —una persona, un aislamiento defectuoso— y el diferencial corta. Los 30 mA de sensibilidad no son casualidad: es el umbral de la fibrilación.],
)

#q("T10.11", "c",
  [El dispositivo que proporciona protección frente a los defectos de aislamiento y los contactos indirectos se denomina:],
  ([fusible], [magnetotérmico], [interruptor diferencial], [limitador de sobretensiones]),
  sol: [Fusible y magnetotérmico vigilan la _intensidad_ y protegen la instalación; el diferencial vigila el _desequilibrio_ y protege a las personas. Es la distinción que más se pregunta.],
)

#q("T10.12", "b",
  [Un interruptor magnetotérmico protege la instalación frente a:],
  ([las fugas de corriente a tierra], [las sobrecargas y los cortocircuitos], [las interferencias de radiofrecuencia], [las variaciones de la tensión de red]),
  sol: [Su nombre describe los dos mecanismos: el térmico actúa despacio ante una sobrecarga sostenida y el magnético, de forma instantánea, ante un cortocircuito. Hace lo mismo que un fusible, pero se rearma.],
)

#q("T10.13", "d",
  [Ante la previsión de una tormenta, lo recomendable es:],
  ([transmitir con la mínima potencia posible], [cambiar a una banda de frecuencia más alta], [conectar la antena directamente al equipo], [desconectar la antena y el equipo de la red eléctrica]),
  sol: [El mástil es un pararrayos involuntario y la bajada, el camino de entrada a la casa. Desconectar la antena y desenchufar el equipo corta las dos vías; dejar la antena derivada a tierra es aún mejor.],
)

#q("T10.14", "a",
  [Al elegir el emplazamiento de una antena hay que asegurarse, ante todo, de que:],
  ([queda alejada de las líneas eléctricas aéreas], [queda orientada al norte geográfico], [su mástil es de material aislante], [está a menos de un metro del suelo]),
  sol: [Es el riesgo más grave de toda la instalación: un mástil que caiga —al montarlo, o años después con un temporal— sobre una línea eléctrica es mortal. La distancia debe ser mayor que la altura total del conjunto.],
)

#q("T10.15", "c",
  [Respecto de los vientos que sujetan un mástil de antena, es correcto afirmar que:],
  ([basta con uno, siempre que sea de acero], [deben quedar flojos para absorber las rachas], [deben repartirse alrededor del mástil y tensarse por igual], [conviene anclarlos al propio mástil]),
  sol: [Los vientos trabajan por oposición: repartidos alrededor y tensados por igual, mantienen el mástil vertical venga el viento de donde venga. Uno solo, o varios flojos, no sujetan nada; y anclarlos al propio mástil no sujeta absolutamente nada.],
)

#q("T10.16", "b",
  [Antes de manipular el interior de un equipo es imprescindible:],
  ([ponerlo en funcionamiento para localizar la avería], [desconectarlo de la red y descargar los condensadores], [conectar la antena a la carga artificial], [aumentar la ventilación del equipo]),
  sol: [Desenchufar no basta: los condensadores del filtro conservan la carga, y en un equipo valvular esa carga está a cientos o miles de voltios. Hay que descargarlos antes de meter la mano.],
)

#q("T10.17", "d",
  [Al producirse un accidente por electricidad, la primera medida que debe tomarse es:],
  ([practicar la respiración artificial a la víctima], [dar de beber a la víctima], [apartar a la víctima tirando de su ropa], [cortar la corriente eléctrica]),
  sol: [Mientras haya tensión, quien se acerque se convierte en la segunda víctima. Primero se corta la corriente; solo después se atiende al accidentado.],
)

#q("T10.18", "a",
  [Si la víctima de una descarga no puede desprenderse de la instalación y no es posible cortar la corriente de inmediato, la persona más próxima debe:],
  ([separarla empleando un elemento aislante, sin tocarla directamente], [agarrarla de las manos y tirar con fuerza], [echarle agua para enfriar la zona del contacto], [esperar a que llegue el servicio de emergencias sin actuar]),
  sol: [Una pértiga de madera seca, un mango aislante, una prenda seca: cualquier cosa que impida que la corriente pase también por el que auxilia. Tocarla directamente, o mojar la escena, es multiplicar el accidente.],
)

#q("T10.19", "c",
  [En la atención a un accidentado por electricidad, _no_ debe hacerse lo siguiente:],
  ([avisar a los servicios de emergencia], [comprobar si respira una vez liberado de la corriente], [tocarlo con las manos desnudas mientras siga en contacto con la instalación], [cubrirlo para evitar que pierda calor]),
  sol: [Las otras tres son correctas. Tocar a la víctima mientras sigue bajo tensión convierte al auxiliador en parte del circuito: es el error clásico y el más grave.],
)

#q("T10.20", "b",
  [La peligrosidad de una descarga eléctrica sobre el cuerpo humano depende principalmente de:],
  ([el color del aislante del conductor], [la intensidad que lo atraviesa, su recorrido y su duración], [la frecuencia de resonancia del circuito], [la potencia contratada en la vivienda]),
  sol: [Lo que daña es la corriente, no la tensión por sí sola. Y el recorrido importa tanto como el valor: el trayecto mano-mano o mano-pie atraviesa el corazón, que es lo que convierte unas décimas de amperio en un accidente mortal.],
)

#q("T10.21", "d",
  [De las siguientes intensidades atravesando el cuerpo humano, la más peligrosa es:],
  ([1 mA], [5 mA], [10 mA], [50 mA]),
  sol: [Hacia 1 mA solo se percibe; en torno a 10–20 mA los músculos dejan de obedecer y no se puede soltar el conductor; desde unos 30 mA acecha la fibrilación ventricular. 50 mA está de lleno en esa zona, y por eso los diferenciales domésticos cortan a 30.],
)

#q("T10.22", "a",
  [La toma de tierra de la instalación de una estación de radioaficionado debe:],
  ([presentar la menor resistencia posible y conectar todos los chasis metálicos], [tener la mayor resistencia posible para limitar la corriente], [conectarse únicamente al neutro de la red], [instalarse solo en las estaciones de más de 100 vatios]),
  sol: [Cuanto menor sea la resistencia, mejor deriva la corriente de fuga y antes actúa el diferencial. Y debe llegar a _todos_ los chasis: uno solo sin conectar rompe la cadena y se convierte en el punto peligroso.],
)

#q("T10.23", "c",
  [En los trabajos de instalación de antenas en altura, es incorrecto:],
  ([emplear arnés de seguridad y calzado adecuado], [comprobar antes la estabilidad de la estructura], [trabajar en solitario y sin avisar a nadie], [suspender el trabajo si empeora la meteorología]),
  sol: [Trabajar solo en altura significa que, si algo va mal, nadie se entera ni puede auxiliar. Las otras tres son precisamente las medidas correctas.],
)

#q("T10.24", "b",
  [Respecto de los rotores de las antenas directivas, es correcto afirmar que:],
  ([deben instalarse siempre en el extremo superior del mástil], [deben dimensionarse para soportar el peso y el par de la antena, y su cableado ha de protegerse], [no necesitan ninguna protección eléctrica], [su cableado puede compartirse con el de la línea de alimentación de RF]),
  sol: [El rotor sostiene y gira una estructura pesada sometida al viento: si se queda corto, acaba partiéndose. Su cable de control es además una vía de entrada de RF y de sobretensiones, así que se protege y se separa del coaxial.],
)

#q("T10.25", "a",
  [El valor nominal del fusible que protege un equipo debe ser:],
  ([ligeramente superior al consumo máximo previsto del equipo], [muy inferior al consumo del equipo, para que salte enseguida], [diez veces el consumo máximo del equipo], [indiferente, mientras encaje en el portafusibles]),
  sol: [Debe dejar pasar el consumo normal sin fundirse y cortar en cuanto se supere: un poco por encima del máximo previsto. Muy por debajo saltaría constantemente sin que hubiera avería, y diez veces por encima no protegería de nada.],
)

#q("T10.26", "c",
  [El conductor que une la estación con la toma de tierra:],
  ([debe llevar un fusible de protección], [debe llevar un interruptor para poder aislarlo], [no debe llevar fusible ni interruptor alguno], [debe ser del mismo color que el conductor de fase]),
  sol: [El conductor de tierra tiene que estar disponible siempre y sin excepción. Un fusible o un interruptor en él lo dejaría abierto justo cuando más falta hace, dejando los chasis en tensión sin que nada corte.],
)

#q("T10.27", "d",
  [Como toma de tierra de la estación:],
  ([debe emplearse siempre una pica propia, nunca la del edificio], [basta con conectar los chasis al neutro de la red], [basta con conectar los chasis a la tubería del gas], [puede emplearse la de la instalación eléctrica del edificio, si existe y está en buenas condiciones]),
  sol: [No hace falta duplicar instalaciones: la tierra del edificio sirve si está en condiciones. Lo que nunca vale es el neutro de la red —que es un conductor activo— ni una tubería, y menos la del gas.],
)

#q("T10.28", "b",
  [Respecto del terreno en que se entierra una pica de toma de tierra:],
  ([conviene un terreno seco y soleado], [conviene un terreno húmedo, porque conduce mejor], [el tipo de terreno es indiferente], [conviene rodearla de material aislante]),
  sol: [La resistencia de la toma de tierra depende de la conductividad del terreno, y la humedad la mejora mucho. Por eso las picas se entierran en zonas frescas y a veces se riegan; un terreno seco y soleado es el peor sitio.],
)

#q("T10.29", "a",
  [En los vientos metálicos que sujetan un mástil de antena conviene:],
  ([intercalar aisladores a tramos, para que no resuenen en las bandas de trabajo], [tensarlos al máximo hasta que vibren], [conectarlos al conductor central del coaxial], [sustituirlos por cable de alimentación de red]),
  sol: [Un viento metálico continuo de longitud parecida a la de trabajo se comporta como un elemento resonante, capta energía y deforma el diagrama de radiación. Los aisladores lo trocean en tramos que ya no resuenan.],
)

#q("T10.30", "c",
  [La antena de la estación de aficionado debe fijarse:],
  ([al mismo mástil de la antena colectiva de televisión del edificio], [directamente a la barandilla de la terraza], [a un mástil propio, independiente del de la antena colectiva del edificio], [a la chimenea, por ser el punto más alto]),
  sol: [Compartir mástil con la antena colectiva del edificio es fuente segura de conflictos e interferencias, y además implica manipular una instalación que no es propia. La antena de aficionado va en su propio soporte.],
)

#q("T10.31", "d",
  [La distancia entre una antena y una línea eléctrica aérea debe ser:],
  ([de al menos un metro], [la que permita el espacio disponible], [indiferente si la línea está aislada], [mayor que la altura total del conjunto de mástil y antena]),
  sol: [El criterio no es una distancia fija sino geométrico: si el conjunto cae, no debe poder alcanzar la línea. Que el conductor parezca aislado no cambia nada — a esas tensiones el aislamiento exterior no es una garantía.],
)

#q("T10.32", "b",
  [Ante una quemadura producida por un accidente eléctrico se debe:],
  ([aplicar pomadas o remedios caseros sobre la zona], [lavar la zona con agua abundante y avisar al servicio médico], [frotar la quemadura para activar la circulación], [cubrirla con algodón y no avisar a nadie]),
  sol: [Agua abundante para enfriar y frenar el daño, y asistencia médica. Las quemaduras eléctricas engañan: la lesión externa puede ser pequeña y el daño interno, profundo, porque la corriente ha atravesado el tejido.],
)

#q("T10.33", "a",
  [En la atención a una persona accidentada por electricidad, no se le debe:],
  ([dar de beber], [cubrir para que no pierda calor], [avisar a los servicios de emergencia], [comprobar si respira]),
  sol: [Nunca se da de beber a un accidentado: puede estar inconsciente o tener alterados los reflejos y provocarse un atragantamiento. Cubrirlo, comprobar si respira y avisar a emergencias sí es correcto.],
)

#q("T10.34", "c",
  [Si tras liberar de la corriente a un accidentado se comprueba que no respira, procede:],
  ([esperar sin tocarlo a que llegue la ambulancia], [sentarlo y darle aire con un abanico], [practicarle la respiración artificial, boca a boca si es posible], [aplicarle de nuevo una descarga para reanimarlo]),
  sol: [Si no respira, cada minuto cuenta y no se puede esperar. Se inicia la respiración artificial —boca a boca si es posible— hasta que llegue la asistencia. Volver a aplicar corriente es un mito peligroso.],
)

#q("T10.35", "d",
  [De los siguientes efectos, el que _no_ produce una descarga eléctrica sobre el cuerpo humano es:],
  ([la tetanización muscular], [la fibrilación ventricular], [las quemaduras internas y externas], [la somnolencia]),
  sol: [La corriente tetaniza los músculos, puede llevar el corazón a fibrilación y quema por efecto Joule dentro y fuera. La somnolencia no es un efecto de la descarga eléctrica.],
)

#q("T10.36", "b",
  [En condiciones ambientales semejantes, de las siguientes combinaciones la más perjudicial para el organismo es:],
  ([12 V y 10 mA], [500 V y 100 mA], [24 V y 5 mA], [50 V y 1 mA]),
  sol: [Lo que daña es la corriente que atraviesa el cuerpo, y 100 mA está muy por encima del umbral de fibrilación (unos 30 mA). La tensión importa porque es la que empuja esa corriente: 500 V la fuerzan con facilidad a través del cuerpo.],
)

#q("T10.37", "a",
  [Si el cuerpo de una persona está mojado, frente a una descarga eléctrica:],
  ([el riesgo aumenta, porque disminuye la resistencia del cuerpo], [queda protegido, porque el agua forma una jaula de Faraday], [el riesgo no varía], [el riesgo disminuye si el agua es destilada]),
  sol: [La piel seca ofrece bastantes miles de ohmios; mojada, esa resistencia se desploma y la misma tensión produce mucha más corriente. Por eso los baños y las zonas húmedas son las de mayor riesgo eléctrico. Lo de la jaula de Faraday es un disparate.],
)

#q("T10.38", "c",
  [En relación con la seguridad de la estación, es recomendable que:],
  ([solo el titular sepa dónde está el interruptor general], [no se informe a nadie de la existencia de la estación], [tanto el operador como sus familiares conozcan las prácticas básicas de primeros auxilios], [los equipos se manipulen siempre en tensión para detectar la avería]),
  sol: [Un accidente eléctrico lo suele presenciar quien está cerca, no un especialista. Que la familia sepa cortar la corriente y dar los primeros auxilios es, en la práctica, parte de la seguridad de la estación.],
)

#q("T10.39", "d",
  [Ante un conato de incendio en un equipo eléctrico conectado a la red, lo correcto es:],
  ([arrojar agua abundante sobre el equipo], [abrir el equipo para localizar el componente afectado], [desconectar únicamente la antena], [cortar la corriente y emplear un extintor adecuado para equipos eléctricos]),
  sol: [Primero cortar la corriente, porque mientras haya tensión el fuego se realimenta y el agua conduce. Después, extintor apto para equipos eléctricos — de CO#text(size: 0.7em, baseline: 0.22em)[2] o de polvo—, nunca agua.],
)

#q("T10.40", "b",
  [A efectos de evitar accidentes derivados del uso de su estación, el titular de una autorización de radioaficionado:],
  ([queda exento de responsabilidad si la instalación la hizo un tercero], [está obligado a cumplir la normativa vigente en materia de seguridad], [solo responde de los equipos, no de las antenas], [únicamente debe atender a las recomendaciones de su asociación]),
  sol: [La responsabilidad es del titular de la autorización, con independencia de quién montara la instalación, y alcanza a todo el conjunto: equipos, antenas y soportes. Las recomendaciones de una asociación no sustituyen a la normativa.],
)
