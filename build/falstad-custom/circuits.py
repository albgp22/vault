# Custom Falstad circuits for the textbook. Run: python3 -I circuits.py [id ...]
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen import Circuit, circuit, build

F0_L = 0.01        # 10 mH
F0_C = 2.533e-6    # 2.533 uF -> f0 = 1000 Hz


def bridge(k, cx, cy, h=48, prefix="D"):
    """Diode bridge: top (cx,cy-h) and bottom (cx,cy+h) are AC inputs, right = +, left = -."""
    top, right, bot, left = (cx, cy - h), (cx + h, cy), (cx, cy + h), (cx - h, cy)
    k.d(*left, *top, name=prefix + "1")
    k.d(*left, *bot, name=prefix + "2")
    k.d(*top, *right, name=prefix + "3")
    k.d(*bot, *right, name=prefix + "4")
    return top, right, bot, left


# 1 ------------------------------------------------------------------------
@circuit
def resonancia_serie():
    k = Circuit("resonancia-serie", dt=1e-5, speed=200)
    k.text(48, 40, "Resonancia serie RLC: la corriente es máxima en f0 = 1/(2π√(LC)) ≈ 1 kHz", 16)
    k.text(48, 64, "Generador de barrido 250 Hz → 4 kHz y vuelta (valores escalados a audio)", 12)
    k.sweep(128, 160, 64, 160, 250, 4000, 5, 0.5, name="gen")
    k.r(128, 160, 272, 160, 10, name="R")
    k.l(272, 160, 416, 160, F0_L, name="L")
    k.c(416, 160, 416, 288, F0_C, name="C")
    k.g(416, 288)
    k.text(168, 200, "R = 10 Ω", 12)
    k.text(312, 200, "L = 10 mH", 12)
    k.text(320, 248, "C = 2,53 µF", 12)
    k.text(48, 344, "Mire el osciloscopio: la corriente sube al acercarse a 1 kHz y baja después.", 12)
    k.text(48, 364, "El generador muestra la frecuencia de cada momento.", 12)
    k.scope([("R", 3)], speed=256, position=0, showI=True, showV=False,
            label="Corriente (máxima en f0)", scaleA=0.5)
    return k


# 2 ------------------------------------------------------------------------
@circuit
def tanque_paralelo():
    k = Circuit("tanque-paralelo", dt=1e-5, speed=200)
    k.text(48, 40, "Circuito tanque LC en paralelo: la tensión es máxima en f0 ≈ 1 kHz", 16)
    k.text(48, 64, "Generador de barrido 250 Hz → 4 kHz y vuelta, a través de R = 330 Ω (valores escalados a audio)", 12)
    k.sweep(128, 160, 64, 160, 250, 4000, 5, 0.5, name="gen")
    k.r(128, 160, 304, 160, 330, name="R")
    k.w(304, 160, 400, 160)
    k.l(304, 160, 304, 288, F0_L, name="L")
    k.c(400, 160, 400, 288, F0_C, name="C")
    k.w(304, 288, 400, 288)
    k.g(304, 288)
    k.text(184, 200, "R = 330 Ω", 12)
    k.text(216, 232, "L = 10 mH", 12)
    k.text(448, 232, "C = 2,53 µF", 12)
    k.text(48, 344, "En f0 el tanque tiene impedancia muy alta: casi toda la tensión del generador queda en él.", 12)
    k.text(48, 364, "Lejos de f0, L o C se comportan como un cortocircuito y la tensión baja.", 12)
    k.scope([("C", 0)], speed=256, position=0, label="Tensión en el tanque (máxima en f0)")
    return k


def direct_row(k, y, tag):
    """50 ohm source connected straight to a 200 ohm load (comparison row)."""
    yb = y + 128
    k.v(64, yb, 64, y, 1, 1000, 10, name="V" + tag)
    k.r(64, y, 176, y, 50, name="Rg" + tag)
    k.w(176, y, 432, y)
    k.r(432, y, 432, yb, 200, name="RL" + tag)
    k.w(432, y, 528, y)
    k.probe(528, y, 528, yb, meter=1, name="P" + tag)
    k.w(64, yb, 432, yb)
    k.w(432, yb, 528, yb)
    k.g(64, yb)


# 3 ------------------------------------------------------------------------
@circuit
def red_L():
    k = Circuit("red-L", dt=5e-6, speed=10)
    k.text(48, 40, "Red L: adapta una fuente de 50 Ω a una carga de 200 Ω (1 kHz, valores escalados)", 16)
    k.text(160, 120, "Con red L (L serie + C en paralelo con la carga)", 12)
    y, yb = 160, 288
    k.v(64, yb, 64, y, 1, 1000, 10, name="V1")
    k.r(64, y, 176, y, 50, name="Rg1")
    k.l(176, y, 320, y, 0.01378, name="L")
    k.c(320, y, 320, yb, 1.378e-6, name="C")
    k.w(320, y, 432, y)
    k.r(432, y, 432, yb, 200, name="RL1")
    k.w(432, y, 528, y)
    k.probe(528, y, 528, yb, meter=1, name="P1")
    k.w(64, yb, 320, yb)
    k.w(320, yb, 432, yb)
    k.w(432, yb, 528, yb)
    k.g(64, yb)
    k.text(160, 336, "Sin red: la misma fuente conectada directamente a la carga", 12)
    direct_row(k, 376, "2")
    k.text(48, 560, "Fuente: 10 V de pico con 50 Ω internos. Con red L la carga recibe 0,25 W", 12)
    k.text(48, 580, "(la máxima potencia que da la fuente); sin red recibe 0,16 W.", 12)
    k.scope([("RL1", 0), ("RL2", 0)], speed=2, position=0,
            label="Tensión en la carga: con red L (10 V) y sin red (8 V)")
    k.scope([("RL1", 7), ("RL2", 7)], speed=2, position=1, label="Potencia en la carga")
    return k


# 4 ------------------------------------------------------------------------
@circuit
def red_pi():
    k = Circuit("red-pi", dt=5e-6, speed=10)
    k.text(48, 40, "Red en pi (C-L-C, paso bajo) a la salida de un amplificador de potencia", 16)
    k.text(48, 64, "El PA se representa con una onda cuadrada de 1 kHz y 50 Ω de salida; carga de 50 Ω (valores escalados)", 12)
    y, yb = 160, 288
    k.v(64, yb, 64, y, 2, 1000, 10, name="PA")
    k.r(64, y, 176, y, 50, name="Rg")
    k.w(176, y, 240, y)
    k.c(240, y, 240, yb, 9.549e-6, name="C1")
    k.l(240, y, 400, y, 4.775e-3, name="L")
    k.c(400, y, 400, yb, 9.549e-6, name="C2")
    k.w(400, y, 496, y)
    k.r(496, y, 496, yb, 50, name="RL")
    k.w(64, yb, 240, yb)
    k.w(240, yb, 400, yb)
    k.w(400, yb, 496, yb)
    k.g(64, yb)
    k.text(16, 120, "«PA»: cuadrada 1 kHz", 12)
    k.text(264, 200, "L = 4,77 mH", 12)
    k.text(160, 320, "C1 = 9,55 µF", 12)
    k.text(352, 320, "C2 = 9,55 µF", 12)
    k.text(464, 320, "Carga 50 Ω", 12)
    k.text(48, 360, "La red deja pasar 1 kHz y frena los armónicos 3, 5, 7... de la onda cuadrada:", 12)
    k.text(48, 380, "en la carga queda una senoide limpia. Compare los dos espectros (FFT).", 12)
    k.scope([("PA", 0), ("RL", 0)], speed=2, position=0, label="Salida del PA (cuadrada) y tensión en la carga")
    k.scope([("PA", 0)], speed=8, position=1, showV=False, fft=True, label="Espectro de la cuadrada: 1, 3, 5, 7... kHz")
    k.scope([("RL", 0)], speed=8, position=1, showV=False, fft=True, label="Espectro en la carga: solo 1 kHz")
    return k


# 5 ------------------------------------------------------------------------
@circuit
def red_T():
    k = Circuit("red-T", dt=5e-6, speed=10)
    k.text(48, 40, "Red T (C-L-C, paso alto) como en un acoplador de antena: 50 Ω → 200 Ω (1 kHz, valores escalados)", 16)
    k.text(160, 120, "Con red T (C1 serie, L a masa, C2 serie)", 12)
    y, yb = 160, 288
    k.v(64, yb, 64, y, 1, 1000, 10, name="V1")
    k.r(64, y, 176, y, 50, name="Rg1")
    k.c(176, y, 288, y, 1.061e-6, name="C1")
    k.l(288, y, 288, yb, 0.01884, name="L")
    k.c(288, y, 400, y, 6.497e-7, name="C2")
    k.w(400, y, 432, y)
    k.r(432, y, 432, yb, 200, name="RL1")
    k.w(432, y, 528, y)
    k.probe(528, y, 528, yb, meter=1, name="P1")
    k.w(64, yb, 288, yb)
    k.w(288, yb, 432, yb)
    k.w(432, yb, 528, yb)
    k.g(64, yb)
    k.text(184, 200, "C1 = 1,06 µF", 12)
    k.text(304, 248, "L = 18,8 mH", 12)
    k.text(320, 200, "C2 = 0,65 µF", 12)
    k.text(160, 336, "Sin red: la misma fuente conectada directamente a la carga", 12)
    direct_row(k, 376, "2")
    k.text(48, 560, "Fuente: 10 V de pico con 50 Ω internos. Con la red T la carga recibe 0,25 W", 12)
    k.text(48, 580, "(la máxima potencia que da la fuente); sin red recibe 0,16 W.", 12)
    k.scope([("RL1", 0), ("RL2", 0)], speed=2, position=0,
            label="Tensión en la carga: con red T (10 V) y sin red (8 V)")
    k.scope([("RL1", 7), ("RL2", 7)], speed=2, position=1, label="Potencia en la carga")
    return k


def rect_row(k, y0, tag):
    """AC source + bridge; returns the + node (x, y) and the - (ground) level y."""
    k.v(96, y0 + 224, 96, y0, 1, 50, 15, name="V" + tag)
    top, right, bot, left = bridge(k, 224, y0 + 112, prefix="D" + tag)
    k.w(96, y0, 224, y0)
    k.w(224, y0, *top)
    k.w(*bot, 224, y0 + 224)
    k.w(224, y0 + 224, 96, y0 + 224)
    k.g(*left)
    k.w(*right, 336, right[1])
    return (336, right[1]), y0 + 208


# 6 ------------------------------------------------------------------------
@circuit
def filtro_pi_fuente():
    k = Circuit("filtro-pi-fuente", dt=2e-5, speed=50, vrange=15)
    k.text(48, 40, "Rectificador en puente: filtro con un condensador frente a filtro en pi (50 Hz, carga 100 Ω)", 16)
    # row A: one capacitor
    y0 = 96
    (x, y), yg = rect_row(k, y0, "A")
    k.text(320, y0 + 40, "Solo un condensador (470 µF)", 12)
    k.c(x, y, x, yg, 470e-6, name="CA")
    k.g(x, yg)
    k.w(x, y, 432, y)
    k.r(432, y, 432, yg, 100, name="RLA")
    k.g(432, yg)
    # row B: pi filter
    y0 = 384
    (x, y), yg = rect_row(k, y0, "B")
    k.text(320, y0 + 40, "Filtro en pi: C1 = 470 µF, L = 1 H, C2 = 470 µF", 12)
    k.c(x, y, x, yg, 470e-6, name="C1")
    k.g(x, yg)
    k.l(x, y, 464, y, 1.0, name="L")
    k.c(464, y, 464, yg, 470e-6, name="C2")
    k.g(464, yg)
    k.w(464, y, 560, y)
    k.r(560, y, 560, yg, 100, name="RLB")
    k.g(560, yg)
    k.text(48, 664, "Arriba: la carga ve un diente de sierra de unos 3 V. Abajo: la bobina frena el rizado", 12)
    k.text(48, 684, "y C2 lo deriva a masa; la tensión es casi continua.", 12)
    k.scope([("RLA", 0), ("RLB", 0)], speed=8, position=0,
            label="Carga: solo C (rizado grande) y filtro en pi (casi continua)")
    k.scope([("C1", 0), ("C2", 0)], speed=8, position=1,
            label="Filtro en pi: rizado en C1 (antes de L) y en C2 (después)")
    return k


# 7 ------------------------------------------------------------------------
@circuit
def fuente_completa():
    k = Circuit("fuente-completa", dt=2e-5, speed=50, vrange=20)
    k.text(48, 32, "Fuente de alimentación completa: transformador, puente, filtro y regulador (13,8 V, 0,5 A)", 16)
    k.v(64, 256, 64, 128, 1, 50, 325.27, name="Vred")
    k.w(64, 128, 160, 128)
    k.T(160, 128, 240, 10, 1 / 15, name="T")
    k.w(160, 160, 160, 256)
    k.w(160, 256, 64, 256)
    k.g(64, 256)
    # secondary and voltmeter
    k.w(240, 128, 240, 96)
    k.w(240, 96, 272, 96)
    k.w(272, 96, 368, 96)
    k.w(240, 160, 240, 224)
    k.w(240, 224, 272, 224)
    k.w(272, 224, 368, 224)
    k.probe(272, 96, 272, 224, meter=1, name="Psec")
    top, right, bot, left = bridge(k, 368, 144)
    k.w(368, 224, *bot)
    k.g(*left)
    k.w(*right, 480, 144)
    k.c(480, 144, 480, 256, 2200e-6, name="Cf")
    k.g(480, 256)
    # regulator: Zener + series pass NPN (base below, collector left, emitter right)
    k.w(480, 144, 544, 144)
    k.r(544, 144, 544, 208, 270, name="Rb")
    base, coll, emit = k.trans(608, 208, 608, 144, pnp=1, flip=True, name="Q")
    assert coll == (592, 144) and emit == (624, 144), (coll, emit)
    k.w(544, 144, *coll)
    k.w(544, 208, *base)
    k.z(608, 288, 608, 208, 14.6, name="Z")
    k.g(608, 288)
    k.w(*emit, 704, 144)
    k.r(704, 144, 704, 256, 27.6, name="RL")
    k.g(704, 256)
    k.text(24, 304, "Red 230 V, 50 Hz", 12)
    k.text(152, 72, "Transformador 15:1", 12)
    k.text(328, 264, "Puente", 12)
    k.text(440, 296, "Filtro 2200 µF", 12)
    k.text(536, 328, "Zener 14,6 V + transistor en serie", 12)
    k.text(672, 296, "Carga 27,6 Ω", 12)
    k.text(48, 376, "Siga la tensión etapa por etapa: alterna en el secundario, continua con rizado en el condensador", 12)
    k.text(48, 396, "y continua casi perfecta a la salida (Vsalida ≈ Vzener − 0,7 V).", 12)
    k.scope([("Psec", 0), ("Cf", 0), ("RL", 0)], speed=8, position=0,
            label="Secundario, condensador y salida regulada")
    k.scope([("RL", 0, 1)], speed=8, position=1, label="Rizado que queda en la salida (solo alterna)")
    return k


# 8 ------------------------------------------------------------------------
@circuit
def clase_c():
    k = Circuit("clase-c", dt=2e-6, speed=50, vrange=12)
    k.text(48, 0, "Amplificador sintonizado en clase C (1 kHz, valores escalados)", 16)
    k.rail(336, 64, 336, 32, 0, 40, 12, name="Vcc")
    k.w(336, 64, 336, 96)
    k.w(272, 96, 336, 96)
    k.w(336, 96, 400, 96)
    k.l(272, 96, 272, 176, F0_L, name="L")
    k.c(336, 96, 336, 176, F0_C, name="C")
    k.r(400, 96, 400, 176, 1000, name="RL")
    k.w(272, 176, 336, 176)
    k.w(336, 176, 400, 176)
    base, coll, emit = k.npn(272, 240, name="Q")
    k.w(336, 176, *coll)
    k.g(*emit)
    k.r(160, 240, 272, 240, 4700, name="Rb")
    k.v(96, 304, 96, 240, 1, 1000, 1.5, name="Vin")
    k.w(96, 240, 160, 240)
    k.g(96, 304)
    k.text(432, 120, "Tanque: L = 10 mH, C = 2,53 µF", 12)
    k.text(432, 140, "f0 = 1 kHz, carga 1 kΩ", 12)
    k.text(40, 336, "Excitación 1,5 V, sin polarización", 12)
    k.text(48, 384, "La base no tiene polarización: el transistor solo conduce en los picos positivos (más de 0,6 V).", 12)
    k.text(48, 404, "La corriente de colector son impulsos; el tanque los convierte en una senoide limpia.", 12)
    k.scope([("Vin", 0)], speed=4, position=0, label="Excitación en la base")
    k.scope([("Q", 2)], speed=4, position=0, showI=True, showV=False, label="Corriente de colector: impulsos")
    k.scope([("RL", 0)], speed=4, position=1, label="Tensión en el tanque: senoide limpia")
    return k


# 9 ------------------------------------------------------------------------
@circuit
def base_comun():
    k = Circuit("base-comun", dt=1e-5, speed=50, vrange=12)
    k.text(48, 0, "Amplificador en base común (1 kHz): la salida está en fase con la entrada", 16)
    k.v(48, 320, 48, 192, 1, 1000, 0.02, name="Vin")
    k.g(48, 320)
    k.r(48, 192, 128, 192, 50, name="Rg")
    k.c(128, 192, 208, 192, 22e-6, name="Cin")
    k.r(208, 192, 208, 320, 1500, name="Re")
    k.g(208, 320)
    base, coll, emit = k.trans(320, 256, 320, 192, pnp=1, flip=False, name="Q")
    assert emit == (304, 192) and coll == (336, 192), (coll, emit)
    k.w(208, 192, *emit)
    k.w(*coll, 432, 192)
    k.r(432, 192, 432, 80, 4700, name="Rc")
    k.rail(432, 80, 432, 48, 0, 40, 12, name="Vcc")
    k.c(432, 192, 528, 192, 1e-6, name="Cout")
    k.r(528, 192, 528, 320, 10000, name="RL")
    k.g(528, 320)
    k.w(*base, 320, 288)
    k.r(320, 288, 320, 368, 10000, name="R2")
    k.g(320, 368)
    k.w(320, 288, 272, 288)
    k.c(272, 288, 272, 368, 2.2e-6, name="Cb")
    k.g(272, 368)
    k.r(320, 288, 448, 288, 47000, name="R1")
    k.rail(448, 288, 480, 288, 0, 40, 12, name="Vcc2")
    k.text(16, 160, "Entrada 20 mV", 12)
    k.text(160, 136, "Entrada por el emisor", 12)
    k.text(456, 224, "Salida por el colector", 12)
    k.text(128, 400, "Base a masa en alterna (Cb)", 12)
    k.text(48, 440, "La señal entra por el emisor y sale por el colector. Cuando la entrada sube, la salida también sube:", 12)
    k.text(48, 460, "no hay inversión de fase. Ganancia de tensión ≈ 40.", 12)
    k.scope([("Vin", 0)], speed=1, position=0, label="Entrada (20 mV)")
    k.scope([("RL", 0)], speed=1, position=0, label="Salida (unos 0,8 V), en fase con la entrada")
    return k


def push_pull(k, ox, tag, biased):
    """Complementary emitter follower; input rail at (ox+192, 240)."""
    xb, xe = ox + 256, ox + 320
    bn, cn, en = k.npn(xb, 192, name="QN" + tag)
    bp, cp, ep = k.pnp(xb, 288, name="QP" + tag)
    k.w(*en, xe, 240)
    k.w(xe, 240, *ep)
    k.w(*cp, xe, 352)
    k.rail(xe, 352, xe, 400, 0, 40, -10, name="VEE" + tag)
    k.w(xe, 128, *cn)
    k.rail(xe, 128, xe, 80, 0, 40, 10, name="VCC" + tag)
    k.w(xe, 240, ox + 400, 240)
    k.r(ox + 400, 240, ox + 400, 352, 10, name="RL" + tag)
    k.g(ox + 400, 352)
    if biased:
        k.r(xb, 192, xb, 128, 220)
        k.w(xb, 128, xe, 128)
        k.d(xb, 192, xb, 240)
        k.d(xb, 240, xb, 288)
        k.r(xb, 288, xb, 352, 220)
        k.w(xb, 352, xe, 352)
    else:
        k.w(xb, 192, xb, 240)
        k.w(xb, 240, xb, 288)
    k.rail(xb, 240, ox + 192, 240, 1, 1000, 5, name="Vin" + tag)


# 10 -----------------------------------------------------------------------
@circuit
def clases_ab():
    k = Circuit("clases-ab", dt=5e-6, speed=20, vrange=10)
    k.text(48, 16, "Etapa push-pull: clase B (sin polarización) frente a clase AB (polarizada con dos diodos)", 16)
    push_pull(k, 0, "B", False)
    push_pull(k, 352, "AB", True)
    k.text(208, 448, "Clase B: distorsión de cruce", 12)
    k.text(560, 448, "Clase AB: sin distorsión de cruce", 12)
    k.text(48, 488, "Las dos etapas reciben la misma señal (1 kHz, 5 V de pico) y tienen carga de 10 Ω.", 12)
    k.text(48, 508, "En clase B la salida se queda en 0 V mientras la entrada está entre −0,6 V y +0,6 V.", 12)
    k.scope([("RLB", 0), ("RLAB", 0)], speed=2, position=0, label="Salida: clase B y clase AB")
    k.scope([("RLB", 0)], speed=8, position=1, showV=False, fft=True, label="Espectro clase B: armónicos 3, 5...")
    k.scope([("RLAB", 0)], speed=8, position=1, showV=False, fft=True, label="Espectro clase AB: casi solo 1 kHz")
    return k


# 11 -----------------------------------------------------------------------
@circuit
def modulacion_am():
    k = Circuit("modulacion-am", dt=5e-6, speed=50)
    k.text(48, 40, "Modulación de amplitud (AM): portadora 2 kHz, moduladora 200 Hz, 100 %", 16)
    k.am(176, 160, 112, 160, 2000, 200, 5, name="AM")
    k.w(176, 160, 288, 160)
    k.r(288, 160, 288, 288, 1000, name="R")
    k.g(288, 288)
    k.text(48, 120, "Generador AM", 12)
    k.text(48, 344, "En el tiempo: la amplitud de la portadora sigue a la moduladora (la envolvente).", 12)
    k.text(48, 364, "En el espectro (FFT): portadora en 2 kHz y dos bandas laterales en 1,8 y 2,2 kHz.", 12)
    k.text(48, 384, "Ancho de banda = 2 × 200 Hz = 400 Hz. Frecuencias escaladas a audio.", 12)
    k.scope([("R", 0)], speed=4, position=0, label="Señal AM en el tiempo")
    k.scope([("R", 0)], speed=32, position=1, showV=False, fft=True,
            label="Espectro: portadora y dos bandas laterales")
    return k


# 12 -----------------------------------------------------------------------
@circuit
def modulacion_fm():
    k = Circuit("modulacion-fm", dt=5e-6, speed=50)
    k.text(48, 40, "Modulación de frecuencia (FM): portadora 2 kHz, moduladora 200 Hz", 16)
    k.fm(176, 160, 112, 160, 2000, 200, 5, 100, name="FM1")
    k.w(176, 160, 288, 160)
    k.r(288, 160, 288, 256, 1000, name="R1")
    k.g(288, 256)
    k.text(320, 200, "Desviación 100 Hz (índice β = 0,5)", 12)
    k.fm(176, 352, 112, 352, 2000, 200, 5, 600, name="FM2")
    k.w(176, 352, 288, 352)
    k.r(288, 352, 288, 448, 1000, name="R2")
    k.g(288, 448)
    k.text(320, 392, "Desviación 600 Hz (índice β = 3)", 12)
    k.text(48, 504, "La amplitud no cambia; cambia la frecuencia. Las bandas laterales están separadas 200 Hz.", 12)
    k.text(48, 524, "Con más desviación aparecen más bandas: ancho de banda ≈ 2 × (desviación + 200 Hz).", 12)
    k.scope([("R2", 0)], speed=4, position=0, label="Señal FM (β = 3) en el tiempo")
    k.scope([("R1", 0)], speed=32, position=1, showV=False, fft=True, label="Espectro con β = 0,5: pocas bandas")
    k.scope([("R2", 0)], speed=32, position=1, showV=False, fft=True, label="Espectro con β = 3: muchas bandas")
    return k


# 13 -----------------------------------------------------------------------
@circuit
def mezclador():
    k = Circuit("mezclador", dt=5e-6, speed=50)
    k.text(48, 16, "Mezclador: multiplicar dos señales da la suma y la diferencia de sus frecuencias", 16)
    k.rail(144, 96, 80, 96, 1, 1000, 5, name="OL")
    k.w(144, 96, 176, 96)
    k.w(176, 96, 176, 160)
    k.w(176, 160, 208, 160)
    k.rail(144, 256, 80, 256, 1, 1500, 5, name="RF")
    k.w(144, 256, 176, 256)
    k.w(176, 256, 176, 192)
    k.w(176, 192, 208, 192)
    k.vcvs(208, 160, "a*b/5", name="X")
    k.g(304, 192)
    k.w(304, 160, 368, 160, name="P")
    k.l(368, 160, 496, 160, 0.2814, name="L")
    k.c(496, 160, 496, 288, 1.407e-7, name="C")
    k.g(496, 288)
    k.w(496, 160, 592, 160)
    k.r(592, 160, 592, 288, 1000, name="RL")
    k.g(592, 288)
    k.text(32, 64, "Oscilador local 1 kHz", 12)
    k.text(32, 304, "Señal 1,5 kHz", 12)
    k.text(200, 240, "Multiplicador ideal", 12)
    k.text(368, 128, "Filtro paso bajo (corte 800 Hz)", 12)
    k.text(48, 360, "A la salida del multiplicador hay 1,5 − 1 = 0,5 kHz (diferencia) y 1,5 + 1 = 2,5 kHz (suma).", 12)
    k.text(48, 380, "El filtro paso bajo deja pasar la diferencia (la frecuencia intermedia) y frena la suma.", 12)
    k.text(48, 400, "Frecuencias escaladas a audio.", 12)
    k.scope([("P", 0), ("RL", 0)], speed=4, position=0, label="Producto y salida del filtro")
    k.scope([("P", 0)], speed=32, position=1, showV=False, fft=True, label="Antes del filtro: 0,5 y 2,5 kHz")
    k.scope([("RL", 0)], speed=32, position=1, showV=False, fft=True, label="Después del filtro: solo 0,5 kHz")
    return k


if __name__ == "__main__":
    r = build(sys.argv[1:] or None)
    for cid, v in r.items():
        print(cid, len(v["url"]))
