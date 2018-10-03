mdotsym= '!3!sM!r!u^!n'
sun = '!D!9n!3!N'
DEGTORAD=!PI/180.0D



inc=90.

teff=[22.800,21.500,17.000,16.400,14.000,14.300] ;in units kK
tstar=[26.200,24.600,21.900,18.700,16.650,17.420] ; in units kK
mdot=[1.5,1.5,3.7,4.72,6.0,6.0];in units 10^-5 Msun/yr
vinf=[300.,300.,105.,195.,200,150.]
tefferr=[0.5,.500,.300,.300,.300,.300,.300] ;assuming that is 2 sigma error
mdoterr=0.3*mdot
vinferr=[30,30,20,30,30,30]
;tstarerr=1

mass=70.
eta=[0.16,0.16,0.10,0.45,0.43]
gammafull=[0.77,0.78,0.79,0.68,0.70,0.70]
gammavel2=[0.50,0.54,0.57,0.40,0.38,0.38]
errgv2=0.1*gammavel2
rstar=[59.6,67.4,85.3,95.5,120.4,115.2]
vrot=[220.,220.,190.,110.,80.,80]/SIN(inc*DEGTORAD)
vcrit1=SQRT(0.666*0.0000000667*mass*1.989E+33/(rstar*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)
errgam=[0.02,0.02,0.02,0.02,0.02]
omega1=vrot/vcrit1
factor=[0.7,0.7,0.7,0.9,0.9,0.9] ;from Fig. 1 of MM2000,A&A361,159
vcrit2=vcrit1
for i=0, 4 do vcrit2[i]=factor[i]*vcrit1[i]
omega2=vrot/vcrit2
omegagamma=gammafull*(1./(1.-4.*vrot*vrot/(9.*vcrit1*vcrit1)))
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


;set_plot,'x'
;!p.multi=[0, 1, 2, 0, 0]
;;plotting gamma full (at tau=100) as function of M for 1985-1990 minimum models (89 mar).  
;
;window,0
;plot,teff,alog10(mdot*1.E-05),xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
;xrange=[23.600,13.000],yrange=[-5.0,-4.0],$
;ytitle=TEXTOIDL('log (dM/dt) M'+sun+' yr^{-1}'),/nodata,charsize=1.2,XMARGIN=[10,5];,POSITION=[0.11,0.10,0.959,0.49]
;plots,teff,alog10(mdot*1.E-05),color=fsc_color('red'),noclip=0,psym=2
;;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;;plotting gamma propto M^-1 line 
;;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;oploterror,teff,alog10(mdot*1.E-05),tefferr,mdoterr/(2.3*mdot),psym=2,color=fsc_color('white'),ERRCOLOR=fsc_color('white')
;;oploterror,alog10(mass),alog10(gammavel2),errgv2/(2.3*gammavel2),psym=4,color=fsc_color('red'),ERRCOLOR=fsc_color('red')
;;plots,alog10(xfit2),yfit4,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
;
;;xyouts,1.65,-0.5,'1989 march', charsize=2
;;xyouts,2.05,-0.17,TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=2
;;xyouts,2.05,-0.43,TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=2
;plot,teff,vinf,xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
;xrange=[23.600,13.000],yrange=[70,370],$
;ytitle=TEXTOIDL('v_\infty [km/s]'),/nodata,charsize=1.2,XMARGIN=[10,5];,POSITION=[0.11,0.10,0.959,0.49]
;plots,teff,vinf,color=fsc_color('white'),noclip=0,psym=2
;oploterror,teff,vinf,tefferr,vinferr,psym=2,color=fsc_color('white'),ERRCOLOR=fsc_color('white')
;
;window,1
;plot,teff,omegagamma,xstyle=1,ystyle=1,xtitle=TEXTOIDL('T_{eff} [kK]'),$
;xrange=[23.6,13.0],yrange=[0.5,1.10],$
;ytitle=TEXTOIDL('\Gamma '),/nodata,charsize=1.2,XMARGIN=[10,10];,POSITION=[0.11,0.10,0.959,0.49]
;plots,teff,omegagamma,color=fsc_color('red'),noclip=0,psym=2
;plots,teff,gammafull,color=fsc_color('blue'),noclip=0,psym=1
;AXIS,YAXIS=1,YSTYLE=1,YRANGE=[0.5,1.1],charsize=1.2,ytitle=TEXTOIDL('\Omega\Gamma ')


;eps plots
a=10.0
b=7.5

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/output_mdot_vinf_min.eps',/encapsulated,/color,bit=8,xsize=a,ysize=b,/inches

ticklen = 0.15
yticklen = ticklen/a
xticklen = ticklen/b*2.

!p.multi=[0, 1, 2, 0, 0]
ca=10
cp=10
cs=2.1
!Y.OMARGIN=[0,1]
!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=8
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

xa=9.1
xb=3.0

plot,teff,alog10(mdot*1.E-05),xstyle=1,ystyle=1,charthick=ca,$
xrange=[13.000,23.6],yrange=[-5.0,-4.0],xtickformat='(A1)',$
ytitle=TEXTOIDL('log (dM/dt) [M'+sun+' yr^{-1}]'),/nodata,charsize=cs,XMARGIN=[xa,xb],YMARGIN=[1,0.2],xticklen=xticklen, yticklen=yticklen;,POSITION=[0.11,0.10,0.959,0.49]
plots,teff,alog10(mdot*1.E-05),color=fsc_color('black'),noclip=0,psym=2
;plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
oploterror,teff,alog10(mdot*1.E-05),tefferr,mdoterr/(2.3*mdot),psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp

;plots,alog10(xfit2),yfit4,color=fsc_color('white'),noclip=0,thick=1,linestyle=3

;xyouts,1.65,-0.5,'1989 march', charsize=2
;xyouts,2.05,-0.17,TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=2
;xyouts,2.05,-0.43,TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=2

plot,teff,vinf,xstyle=1,ystyle=1,xtitle='T!deff!N [kK]',charthick=ca,$
xrange=[13.000,23.6],yrange=[70,370],$
ytitle=TEXTOIDL('v_\infty [km/s]'),/nodata,charsize=cs,XMARGIN=[xa,xb],YMARGIN=[3.2,-1],xticklen=xticklen, yticklen=yticklen;,POSITION=[0.11,0.10,0.959,0.49]
plots,teff,vinf,color=fsc_color('black'),noclip=0,psym=2
oploterror,teff,vinf,tefferr,vinferr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=cp


device,/close



set_plot,'x'

END
