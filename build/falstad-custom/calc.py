import cmath, math
f=1000.0; w=2*math.pi*f
par=lambda a,b: a*b/(a+b)
# red L: Rs=50, RL=200, series L + shunt C at load
L=86.6/w; C=1/(w*115.47)
print("L-net L=%.4g H C=%.4g F" % (L,C))
Zin = 1j*w*L + par(200, 1/(1j*w*C))
print(" Zin", Zin)
# T high-pass: series C1, shunt L, series C2, load 200
X1=150.0; X2=math.sqrt(1.5)*200; XL=par(500/3, 500/math.sqrt(1.5))
C1=1/(w*X1); C2=1/(w*X2); LT=XL/w
print("T-net C1=%.4g C2=%.4g L=%.4g" % (C1,C2,LT))
Zin = 1/(1j*w*C1) + par(1j*w*LT, 1/(1j*w*C2)+200)
print(" Zin", Zin)
# pi low-pass 50->50 Q=3
Q=3; R=50; Rv=R/(Q*Q+1); XC=R/Q; XLp=2*Q*Rv
Cp=1/(w*XC); Lp=XLp/w
print("pi C=%.4g L=%.4g" % (Cp,Lp))
def pi_tf(fr):
    ww=2*math.pi*fr
    zc=1/(1j*ww*Cp); zl=1j*ww*Lp
    zout=par(zc,R)
    z2=zl+zout
    zin=par(zc,z2)
    vin=zin/(zin+R)          # source 50 ohm
    vout=vin*zout/z2
    return abs(vout), abs(zin)
for n in (1,3,5,7):
    a,zi=pi_tf(n*f)
    print(" n=%d |Vout/Vs|=%.4f  (%.1f dB rel. fund) Zin=%.1f" % (n,a,20*math.log10(a/pi_tf(f)[0]),zi))
# mixer LPF
fc=800; w0=2*math.pi*fc; LC=1/w0**2; k=0.7071/1000
print("LPF C=%.4g L=%.4g" % (math.sqrt(LC)*k, math.sqrt(LC)/k))
