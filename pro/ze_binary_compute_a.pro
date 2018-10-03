om=270.
gam=-430.
K=140.
i=41.
e=0.9
P=5.54
sini=SIN(i*3.141592/180.)
a=P*365.*24.*3600.*(1-e^2)^0.5*K/149000000/(2*3.141592*sini)  ; a=K *P * sqrt(1-e^2) / (2*pi*sin i)
print,a
;;he I, centered on the star
;orbitplot,a= 17.35,eccen=0.900,lonasc=270, omega= 90, starrad=4.4,phase1=0.25, symbolsize=3,/degrees
;;br gamma
;window,1
;orbitplot,a= 17.35,eccen=0.900,lonasc=270, omega= 90, starrad=10.47,phase1=0.25, symbolsize=3,/degrees
;;K band continuum
;window,2
;orbitplot,a= 17.35,eccen=0.900,lonasc=270, omega= 90, starrad=2.47,phase1=0.25, symbolsize=3,/degrees
npt=100
window,0
 phase=findgen(npt)/(npt-1)
 vel=binradvel(phase,k=K,gamma=gam,eccen=e,omega=om,/degrees)
;colors = GetColor(/Load)
 ; Show two orbits for clarity
 pp=[phase,1.+phase]
 vv=[vel,vel]
 plot,pp,vv,xtitle='Orbital Phase',ytitle='Radial Velocity [km/s]'
 xrange=!x.crange
 oplot,xrange,[0.,0.],linestyle=2
 velcomp=binradvel(phase,k=21.68,gamma=-22.52,eccen=0.372,omega=180,/degrees)
 vvcomp=[velcomp,velcomp]
 ;oplot,pp,vvcomp,color=colors.red
END 
