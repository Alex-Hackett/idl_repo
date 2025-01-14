mdotsym= '!3!sM!r!u^!n'

sun = '!D!9n!3!N'

teff=[22.800,21.500,17.000,16.400,14.000,14.300] ;in units kK
tstar=[26.200,24.600,21.900,18.700,16.650,17.420] ; in units kK
mdot=[1.5,1.5,3.7,4.72,6.0,6.0];in units 10^-5 Msun/yr
vinf=[300.,300.,105.,195.,200,150.]
tefferr=[0.5,.500,.300,.300,.300,.300,.300] ;assuming that is 2 sigma error
mdoterr=0.3*mdot
vinferr=[30,30,20,30,30,30]
rstar=[59.6,67.4,85.3,95.5,120.4,115.2] 	  ;from CMFGEN in Rsun
reff=[78.7,88.5,141.6,124.2,179.4,171.3]          ;from CMFGEN in Rsun
rstarerr=rstar*.05 ;assuming 1-sigma error is 5 %
rstarerr=rstar*0.0001
lstar=[1.5,1.5,1.5,1.0,1.0,1.1]                   ;from CMFGEN in 10^6 Lsun units

;tstarerr=1

mass=70.
eta=[0.16,0.16,0.10,0.45,0.43]
gammafull=[0.77,0.78,0.79,0.68,0.70,0.70]
gammavel2=[0.50,0.54,0.57,0.40,0.38,0.38]
errgv2=0.1*gammavel2
vrot=[220.,220.,190.,110.,80.,80]
vroterr=REVERSE([10.0,10.0,10.0, 30.0, 50.0]) ;assuming that is 2 sigma error
vroterr=vroterr/2.
vcrit1=SQRT(0.0000000667*mass*1.989E+33/(rstar*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)
errgam=[0.02,0.02,0.02,0.02,0.02,0.02]
omega1=vrot/vcrit1
factor=[0.7,0.7,0.7,0.9,0.9,0.9] ;from Fig. 1 of MM2000,A&A361,159
vcrit2=vcrit1
for i=0, 4 do vcrit2[i]=factor[i]*vcrit1[i]
omega2=vrot/vcrit2
omegagamma=gammafull*(1./(1.-4.*vrot*vrot/(9.*vcrit2*vcrit2)))
print,gammafull,omegagamma

;gtot= -3.3272E+02
;grad=6.6084E+02 
;ggrav=grad-gtot
;gamma=grad/ggrav


;linear fit to logM log GAMMA FULL
 
;result = linfit(alog10(mass), alog10(gammafull), sdev=errgam/(2.3*gammafull), chisq = chisq, prob = prob, yfit=yfit, sigma=sigma)
;xfit=indgen(20)
;xfit=10.*xfit
;yfit2=result[0]+alog10(xfit)*result[1]
;minus1=-1.0

;linear fit to logM log gamma at vel=2 km/s
;result2 = linfit(alog10(mass), alog10(gammavel2), sdev=errgv2/(2.3*gammavel2), chisq = chisq2, prob = prob2, yfit=yfit3, sigma=sigma2)
;xfit2=indgen(20)
;xfit2=10.*xfit2
;yfit4=result2[0]+alog10(xfit2)*result2[1]
;minus1=-1.0


set_plot,'x'
!p.multi=[0, 1, 2, 0, 0]
;plotting gamma full (at tau=100) as function of M for 1985-1990 minimum models (89 mar).  

window,0
plot,teff,alog10(mdot*1.E-05),xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
xrange=[23.600,13.000],yrange=[-5.0,-4.0],$
ytitle=TEXTOIDL('log (dM/dt) M'+sun+' yr^{-1}'),/nodata,charsize=1.2,XMARGIN=[10,5];,POSITION=[0.11,0.10,0.959,0.49]
plots,teff,alog10(mdot*1.E-05),color=fsc_color('red'),noclip=0,psym=2
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
oploterror,teff,alog10(mdot*1.E-05),tefferr,mdoterr/(2.3*mdot),psym=2,color=fsc_color('white'),ERRCOLOR=fsc_color('white')
;oploterror,alog10(mass),alog10(gammavel2),errgv2/(2.3*gammavel2),psym=4,color=fsc_color('red'),ERRCOLOR=fsc_color('red')
;plots,alog10(xfit2),yfit4,color=fsc_color('white'),noclip=0,thick=1,linestyle=3

;xyouts,1.65,-0.5,'1989 march', charsize=2
;xyouts,2.05,-0.17,TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=2
;xyouts,2.05,-0.43,TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=2
plot,teff,vinf,xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
xrange=[23.600,13.000],yrange=[70,370],$
ytitle=TEXTOIDL('v_\infty [km/s]'),/nodata,charsize=1.2,XMARGIN=[10,5];,POSITION=[0.11,0.10,0.959,0.49]
plots,teff,vinf,color=fsc_color('white'),noclip=0,psym=2
oploterror,teff,vinf,tefferr,vinferr,psym=2,color=fsc_color('white'),ERRCOLOR=fsc_color('white')

window,1
plot,teff,omegagamma,xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
xrange=[23.6,13.0],yrange=[0.5,1.10],$
ytitle=TEXTOIDL('\Gamma '),/nodata,charsize=1.2,XMARGIN=[10,10];,POSITION=[0.11,0.10,0.959,0.49]
plots,teff,omegagamma,color=fsc_color('red'),noclip=0,psym=2
plots,teff,gammafull,color=fsc_color('blue'),noclip=0,psym=1
AXIS,YAXIS=1,YSTYLE=1,YRANGE=[0.5,1.1],charsize=1.2,ytitle=TEXTOIDL('\Omega\Gamma ')


;eps plots

set_plot,'ps'
device,/close
a=6.48
b=8.48

device,filename='/Users/jgroh/temp/output_physpar_min.eps',/encapsulated,/color,bit=8,xsize=a,ysize=b,/inches

!p.multi=[0, 1, 8, 0, 0]
ca=3
cp=3

!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=6
!P.CHARSIZE=2.9
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')



ticklen = 0.10
yticklen = ticklen/a
xticklen = ticklen/b*8.


ca=6
cp=6
ct=7
cc=6
cplot=8
cline=8
cl=1.4
cs=3.9
ct=8


!X.OMARGIN=[-1.5,-2.5]
!Y.OMARGIN=[2.5,1.5]

ym1=1
ym2=-1

to=6.
tl=6.
cz=2.1

typesym1=4
typesym2=5
ss=1.4   ;symbol size

x1l=57.
x1u=123

plot,rstar,teff,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[12.200,28.000],xtickformat='(A1)',ytickinterval=4.,$
ytitle=TEXTOIDL('T [kK]'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,teff,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
plots,rstar,tstar,color=fsc_color('red'),noclip=0,psym=typesym2,thick=to,symsize=ss
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,teff,rstarerr,tefferr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
;oploterror,rstar,tstar,rstarerr,tefferr,psym=2,color=fsc_color('red'),ERRCOLOR=fsc_color('red'),thick=cp
plots,rstar(reverse(sort(rstar))),teff(reverse(sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
plots,rstar(reverse(sort(rstar))),tstar(reverse(sort(rstar))),color=fsc_color('red'),noclip=0,thick=tl,linestyle=3
xyouts,82,24,TEXTOIDL('T_{*}'),charsize=1.3,charthick=ca-1.0,color=fsc_color('red')
xyouts,82,14.5,TEXTOIDL('T_{eff}'),charsize=1.3,charthick=ca-1.0,color=fsc_color('black')
xyouts,118,24,TEXTOIDL('(a)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

plot,rstar,lstar,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[0.8,1.700],xtickformat='(A1)',$
ytitle=TEXTOIDL('L_{*} [10^6 L'+sun+' ]'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,lstar,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,lstar,rstarerr,lstar*0.1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar(reverse(sort(rstar))),lstar(reverse(sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,1.45,TEXTOIDL('(b)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')


plot,rstar,reff,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[x1l-4,x1u+67],xtickformat='(A1)',ytickinterval=40.,$
ytitle=TEXTOIDL('R_{phot} [R'+sun+' ]'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,reff,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
plots,[x1l,x1u],[x1l,x1u],linestyle=2,thick=to
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,teff,alog10(mdot*1.E-05),tefferr,mdoterr/(2.3*mdot),psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar(reverse(sort(rstar))),reff(reverse(sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,80,TEXTOIDL('(c)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

plot,rstar,gammafull,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[0.6,0.91],xtickformat='(A1)',ytickinterval=0.1,$
ytitle=TEXTOIDL('\Gamma'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,gammafull,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,gammafull,rstarerr,errgam,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar(reverse(sort(rstar))),gammafull(reverse(sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,0.83,TEXTOIDL('(d)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

plot,rstar,omegagamma,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[0.6,1.1],xtickformat='(A1)',ytickinterval=0.2,$
ytitle=TEXTOIDL('\Omega\Gamma'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,omegagamma,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,omegagamma,rstarerr,errgam*2.,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar(reverse(sort(rstar))),omegagamma(reverse(sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,0.95,TEXTOIDL('(e)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

;rstarvr=[59.6,85.3,95.5,120.4]
rstarvr=rstar
;vrot=[220.,190.,110.,80.]
plot,rstarvr,vrot,xstyle=1,ystyle=1,charthick=ca,$
xrange=[x1l,x1u],yrange=[51,270],xtickformat='(A1)',$
ytitle=TEXTOIDL('v_{rot} [km/s]'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2],xticklen=xticklen,yticklen=yticklen,yminor=2;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstarvr,vrot,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,vrot,rstarerr,vroterr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstarvr(reverse(sort(rstarvr))),vrot(reverse(sort(rstarvr))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,205,TEXTOIDL('(f)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

plot,rstar,alog10(mdot*1.E-05),xstyle=1,ystyle=1,charthick=ca,ytickinterval=0.5,$
xrange=[x1l,x1u],yrange=[-5.0,-4.0],xtickformat='(A1)',YMARGIN=[ym1,ym2],$
ytitle=TEXTOIDL('log Mdot'),/nodata,charsize=cz,XMARGIN=[10,5],xticklen=xticklen,yticklen=yticklen,yminor=4;,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,alog10(mdot*1.E-05),color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,rstar,alog10(mdot*1.E-05),rstarerr,mdoterr/(2.3*mdot),psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar(reverse(sort(rstar))),alog10(mdot[reverse(sort(rstar))]*1.E-05),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,-4.8,TEXTOIDL('(g)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

plot,rstar,vinf,xstyle=1,ystyle=1,xtitle=TEXTOIDL('R_{*} [R')+sun+' ]',charthick=ca,xticklen=xticklen,yticklen=yticklen,yminor=4,$
xrange=[x1l,x1u],yrange=[70,340],ytickinterval=100.,$
ytitle=TEXTOIDL('v_\infty [km/s]'),/nodata,charsize=cz,XMARGIN=[10,5],YMARGIN=[ym1,ym2];,POSITION=[0.11,0.10,0.959,0.49]
plots,rstar,vinf,color=fsc_color('black'),noclip=0,psym=typesym1,thick=to,symsize=ss
;oploterror,rstar,vinf,rstarerr,vinferr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp
plots,rstar((sort(rstar))),vinf((sort(rstar))),color=fsc_color('black'),noclip=0,thick=tl
xyouts,118,269,TEXTOIDL('(h)'),charsize=1.1,charthick=ca-1.0,color=fsc_color('black')

device,/close



set_plot,'x'

END
