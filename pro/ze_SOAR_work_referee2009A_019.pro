V=12   ; in mag
texp=2 ;in min
SN=80

V2=19.5
texp2=3.5*60

fluxratio=10^[(v2-v)/(-2.5)]
texpratio=texp2/texp
print,fluxratio,texpratio
;fluxratio=0.5
;texpratio=2

SN2=SN*(fluxratio*texpratio)^0.5

print,SN2

END