;solar symbol
;v2 uses updated values of Teff
sun = '!D!9n!3!N'
DEGTORAD=!PI/180.0D
modelsnumber=[386,368,367,365,346] ;maybe should use 390 instead of 367 for M=70
lstar=1.5e+06
inc=90.   ;inclination angle in degrees
mass=[40.,50.,70.,100.,150.]; in units Msun
gammafull=[0.97,0.88,0.78,0.67,0.60]
gammavel2=[0.99,0.73,0.54,0.46,0.25]
errgv2=0.1*gammavel2
rstar=[45.66,54.89,59.6,61.0,62.2] ;for model 386 I increased rstar from 39 Rsun to 45, since model does not fit obs (has to have lower Teff)
r_at_v2=[503., 493., 475., 473., 440.]
r_at_v2=r_at_v2/6.96
errgam=[0.02,0.02,0.02,0.02,0.02]
vrot=220./SIN(inc*DEGTORAD)
tstar=5.780*(lstar^0.25/(rstar^0.5) )
teff=[17500, 19550, 21000, 21600,22800] ;old values of teff
teff=[19610, 21050, 22800, 23400,23800] ;edited to comply with new results (2010sep07)
errteff=[800.,800.,800.,800.,800.]

;for tau=100, i.e. v~0.02 km/s
vcrit1=SQRT(0.666666*0.0000000667*mass*1.989E+33/(rstar*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)
omega1=vrot/vcrit1
factor=[0.2,0.5,0.7,0.9,1.] ;from Fig. 1 of MM2000,A&A361,159; VALID ONLY FOR THE ABOVE VALUES OF GAMMA at tau=100! 
vcrit2=vcrit1
for i=0, 4 do vcrit2[i]=factor[i]*vcrit1[i]
omega2=vrot/vcrit2
omegagamma=gammafull*(1./(1.-4.*vrot*vrot/(9.*vcrit1*vcrit1)))
omegagamma_depsph=gammafull*(1./(1.-4.*vrot*vrot/(9.*vcrit1*vcrit1)*0.813)) ;assuming the factor V' * (Rpb/Re)^2 is equal to 0.813, i.e. the minimum value which occurs at break up (MM2000)
;closer to the sonic point, for v=2km/s

vcrit1_v2=SQRT(0.66666*0.0000000667*mass*1.989E+33/(r_at_v2*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)
omega1_v2=vrot/vcrit1_v2
factor_v2=[0.2,0.7,1.0,1.0,1.0] ;from Fig. 1 of MM2000,A&A361,159; VALID ONLY FOR THE ABOVE VALUES OF GAMMA at v=2! 
vcrit2_v2=vcrit1_v2
for i=0, 4 do vcrit2_v2[i]=factor_v2[i]*vcrit1_v2[i]
omega2_v2=vrot/vcrit2_v2
omegagammavel2=gammavel2*(1./(1.-4.*vrot*vrot/(9.*vcrit1_v2*vcrit1_v2)))

print,gammafull,omegagamma
print,gammavel2,omegagammavel2

;gtot= -3.3272E+02
;grad=6.6084E+02 
;ggrav=grad-gtot
;gamma=grad/ggrav


;linear fit to logM log GAMMA FULL
 
result = linfit(alog10(mass), alog10(gammafull), sdev=errgam/(2.3*gammafull), chisq = chisq, prob = prob, yfit=yfit, sigma=sigma)
xfit=indgen(20)
xfit=10.*xfit
yfit2=result[0]+alog10(xfit)*result[1]
minus1=-1.0

;linear fit to logM log gamma at vel=2 km/s
result2 = linfit(alog10(mass), alog10(gammavel2), sdev=errgv2/(2.3*gammavel2), chisq = chisq2, prob = prob2, yfit=yfit3, sigma=sigma2)
xfit2=indgen(20)
xfit2=10.*xfit2
yfit4=result2[0]+alog10(xfit2)*result2[1]
minus1=-1.0

;calculating Ledd following Hillier et al. 2001 eta car paper
;Ledd=3.22e+04*(NhNhe + 4.)* mass / (NhNhe + 2.)
NhNhe=2.32
Ledd=3.22e+04*(NhNhe + 4.)* mass / (NhNhe + 2.)
gammajohn=lstar/ledd

set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]
;plotting gamma full (at tau=100) as function of M for 1985-1990 minimum models (89 mar).  

window,0
plot,alog10(mass),alog10(gammafull),xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (M_*/M_{sun})'),$
xrange=[1.55,2.25],yrange=[-0.70,0.00],$
ytitle=TEXTOIDL('log \Gamma '),/nodata,charsize=1.2,XMARGIN=[10,5];,POSITION=[0.11,0.10,0.959,0.49]
plots,alog10(mass),alog10(gammafull),color=fsc_color('red'),noclip=0,psym=2
plots,alog10(xfit),yfit2,color=fsc_color('blue'),noclip=0,thick=1,linestyle=2
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
oploterror,alog10(mass),alog10(gammafull),errgam/(2.3*gammafull),psym=2,color=fsc_color('white'),ERRCOLOR=fsc_color('white')
oploterror,alog10(mass),alog10(gammavel2),errgv2/(2.3*gammavel2),psym=4,color=fsc_color('red'),ERRCOLOR=fsc_color('red')
plots,alog10(xfit2),yfit4,color=fsc_color('white'),noclip=0,thick=1,linestyle=3

xyouts,1.65,-0.5,'1985-1990', charsize=2
xyouts,2.05,-0.17,TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=2
xyouts,2.05,-0.43,TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=2

window,1
plot,mass,omegagamma,xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (M_*/M_{sun})'),$
xrange=[30,170],yrange=[0.5, 1.4],$
ytitle=TEXTOIDL('log \Omega\Gamma '),/nodata,charsize=1.2,XMARGIN=[10,5] ;,POSITION=[0.11,0.10,0.959,0.49]
plots,mass,omegagamma,color=fsc_color('red'),noclip=0,psym=2
plots,mass,omegagammavel2,color=fsc_color('blue'),noclip=0,psym=2
plots,mass,omegagamma_depsph,color=fsc_color('green'),noclip=0,psym=2
plots,[30,170],[1,1],color=fsc_color('yellow'),noclip=0,linestyle=2


;eps plots

set_plot,'ps'
device,/close
sun = '!D!9n!3!N'
device,filename='/Users/jgroh/temp/output_gammafull_mass_mar89.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!p.multi=[0, 1, 3, 0, 0]

!Y.ThICK=3.5
!X.thick=3.5
!P.CHARTHICK=3.5
!X.OMARGIN=[-2,-3]

cs=3.9
ct=4.5


; LOG PLOTS
plot,alog10(mass),teff/10.^4,xstyle=1,ystyle=1,charthick=ct,$
xrange=[1.55,2.25],yrange=[1.6000,2.4000],xtickformat='(A1)',$
ytitle=TEXTOIDL('T!deff!N [10!U4!N K]'),/nodata,charsize=cs,XMARGIN=[10,5],YMARGIN=[1.0,0.5];,POSITION=[0.11,0.10,0.959,0.49]
plots,alog10(mass),teff/10.^4,color=fsc_color('black'),noclip=0,psym=2,thick=ct
;oploterror,alog10(mass),teff/10.^4,errteff/10.^4,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black')

plot,alog10(mass),alog10(gammafull),xstyle=1,ystyle=1,charthick=ct,$
xrange=[1.55,2.25],yrange=[-0.7,0.08],xtickformat='(A1)',$
ytitle=TEXTOIDL('log \Gamma '),/nodata,charsize=cs,XMARGIN=[10,5],YMARGIN=[1.5,-1.0];,POSITION=[0.11,0.10,0.959,0.49]
plots,alog10(mass),alog10(gammafull),color=fsc_color('black'),noclip=0,psym=2,thick=ct
plots,alog10(xfit),yfit2,color=fsc_color('black'),noclip=0,linestyle=2,thick=ct
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
oploterror,alog10(mass),alog10(gammafull),errgam/(2.3*gammafull),psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=ct
oploterror,alog10(mass),alog10(gammavel2),errgv2/(2.3*gammavel2),psym=4,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=ct
plots,alog10(xfit2),yfit4,color=fsc_color('black'),noclip=0,thick=ct,linestyle=3
xyouts,1.65,-0.5,'1985-1990', charsize=1.7,charthick=ct
xyouts,2.05,-0.17,TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=1.5,charthick=ct
xyouts,2.05,-0.43,TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=1.5,charthick=ct

plot,alog10(mass),alog10(omegagamma),xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (M/M')+sun+')',charthick=ct,$
xrange=[1.55,2.25],yrange=[-0.7,0.08],$
ytitle=TEXTOIDL('log \Omega\Gamma '),/nodata,charsize=cs,XMARGIN=[10,5],YMARGIN=[3.5,-1.5];,POSITION=[0.11,0.10,0.959,0.49]
plots,alog10(mass),alog10(omegagamma),color=fsc_color('black'),noclip=0,psym=5,thick=ct
for i=2, 4 do begin 
plots,alog10(mass[i]),alog10(omegagammavel2[i]),color=fsc_color('black'),noclip=0,psym=6,thick=ct
endfor
;plotting up arrows for gammaomega > 1.
plots,[alog10(mass[0])-0.005,alog10(mass[0])+0.005],[0.0,0.0],linestyle=0
plotsym,2,thick=ct
plots,alog10(mass[0]),0.0,color=fsc_color('black'),noclip=0,psym=8,symsize=1.8,thick=ct
xyouts,1.65,-0.5,'1985-1990', charsize=1.7,charthick=ct
plots,[alog10(mass[1])-0.005,alog10(mass[1])+0.005],[0.0,0.0],linestyle=0,thick=ct
plotsym,2,thick=ct
plots,alog10(mass[1]),0.0,color=fsc_color('black'),noclip=0,psym=8,symsize=1.8,thick=ct
device,/close

device,filename='/Users/jgroh/temp/output_gammafull_mass_mar89_linear.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!p.multi=[0, 1, 3, 0, 0]

!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=6
!P.CHARSIZE=2.9
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')



ticklen = 0.30
yticklen = ticklen/a
xticklen = ticklen/b


ca=2.9
ct=7
cc=6
cplot=8
cline=8
cl=1.4
!X.OMARGIN=[-2,-3]

cs=3.9
ct=8
xticklen=0.06
yticklen=xticklen/6.48*8.48/3.

;LINEAR PLOTS
plot,mass,teff/10.^4,xstyle=1,ystyle=1,charthick=ct,$
xrange=[10^1.50,10^2.20],yrange=[18,25],xtickformat='(A1)',$
ytitle=TEXTOIDL('T!deff!N [10!U4!N K]'),/nodata,charsize=cs,ytickinterval=2,XMARGIN=[10,5],YMARGIN=[1.0,0.5],xticklen=xticklen,yticklen=yticklen;,POSITION=[0.11,0.10,0.959,0.49]
plots,mass,teff/10.^3,color=fsc_color('black'),noclip=0,psym=2,thick=ct
;oploterror,alog10(mass),teff/10.^4,errteff/10.^4,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black')

plot,mass,gammafull,xstyle=1,ystyle=1,charthick=ct,$
xrange=[10^1.50,10^2.20],yrange=[0.201,1.19],xtickformat='(A1)',$
ytitle=TEXTOIDL('\Gamma '),/nodata,charsize=cs,XMARGIN=[10,5],YMARGIN=[1.5,-1.0],xticklen=xticklen,yticklen=yticklen;,POSITION=[0.11,0.10,0.959,0.49]
plots,mass,gammafull,color=fsc_color('black'),noclip=0,psym=2,thick=ct
plots,xfit,10^yfit2,color=fsc_color('blue'),noclip=0,linestyle=2,thick=ct
;plotting gamma propto M^-1 line 
;plots,alog10(xfit),result[0]+1.008+alog10(xfit)*minus1,color=fsc_color('white'),noclip=0,thick=1,linestyle=3
oploterror,mass,gammafull,errgam,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=ct
oploterror,mass,gammavel2,errgv2,psym=4,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=ct
plots,xfit2,10^yfit4,color=fsc_color('red'),noclip=0,thick=ct,linestyle=3
;xyouts,10^1.65,10^(-0.5),'1985-1990', charsize=1.7,charthick=ct
xyouts,10^2.05,10^(-0.17),TEXTOIDL('\Gamma \propto M^{-0.37 \pm 0.02}'), charsize=1.5,charthick=ct
xyouts,10^2.05,10^(-0.43),TEXTOIDL('\Gamma \propto M^{-0.96 \pm 0.09}'), charsize=1.5,charthick=ct

plot,mass,omegagamma,xstyle=1,ystyle=1,xtitle=TEXTOIDL('M (M')+sun+')',charthick=ct,$
xrange=[10^1.50,10^2.20],yrange=[0.35,1.19],$
ytitle=TEXTOIDL('\Gamma_\Omega'),/nodata,charsize=cs,XMARGIN=[10,5],YMARGIN=[3.5,-1.5],xticklen=xticklen,yticklen=yticklen
;plots,mass,omegagamma,color=fsc_color('black'),noclip=0,psym=5,thick=ct
for i=2, 4 do begin 
plots,mass[i],omegagamma[i],color=fsc_color('black'),noclip=0,psym=6,thick=ct
endfor
;plotting up arrows for gammaomega > 1.
plots,[mass[0]-1,mass[0]+1],[1.0,1.0],linestyle=0,thick=ct
plotsym,2,thick=ct
plots,mass[0],1.0,color=fsc_color('black'),noclip=0,psym=8,symsize=1.8,thick=ct
;xyouts,10^1.65,0.5,'1985-1990', charsize=1.7,charthick=ct
plots,[mass[1]-1,mass[1]+1],[1.0,1.0],linestyle=0,thick=ct
plotsym,2,thick=ct
plots,mass[1],1.0,color=fsc_color('black'),noclip=0,psym=8,symsize=1.8,thick=ct
device,/close
;
;



set_plot,'x'


END
