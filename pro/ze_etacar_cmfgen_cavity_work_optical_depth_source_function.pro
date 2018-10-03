;PRO ZE_ETACAR_CMFGEN_CAVITY_WORK_OPTICAL_DEPTH_SOURCE_FUNCTION
!P.Background = fsc_color('white')
AU_TO_CM=1.49e8
CM_TO_CMFGEN=1e-10
file='/Users/jgroh/ze_models/etacar/mod43_groh/tauc1000_dtauc1000_tauc6000_dtauc6000_au.txt'
readcol,file,rau,tauc1000,rau2,dtauc1000,rau3,tauc6000,rau4,dtauc6000
file2='/Users/jgroh/ze_models/etacar/mod43_groh/tauc1384_dtauc1384_au.txt'
readcol,file2,rau,tauc1384,rau2,dtauc1384

file3='/Users/jgroh/ze_models/etacar/mod43_groh/tauc21200_dtauc_21200_au.txt'
readcol,file3,rau3,tauc21200,rau4,dtauc21200
;lineplot,rau,tauc1000
;lineplot,rau,dtauc1000
;lineplot,rau,tauc6000
;lineplot,rau,dtauc6000


nd=n_elements(rau)
tauc1000c=dblarr(ND)
tauc1000c2=dblarr(ND)
tauc6000c2=dblarr(ND)
tauc1384c2=dblarr(ND)
tauc21200c2=dblarr(ND)

tauc1000c[0]=10^tauc1000[0]


ndmax=27
tauc1000c2[0]=1e-12
dtauc1000c2=dtauc1000
dtauc1000c2[0:ndmax]=dtauc1000c2[0:ndmax]-6

tauc1384c2[0]=1e-12
dtauc1384c2=dtauc1384
dtauc1384c2[0:ndmax]=dtauc1384c2[0:ndmax]-6

tauc6000c2[0]=1e-12
dtauc6000c2=dtauc6000
dtauc6000c2[0:ndmax]=dtauc6000c2[0:ndmax]-6

tauc21200c2[0]=1e-12
dtauc21200c2=dtauc21200
dtauc21200c2[0:ndmax]=dtauc21200c2[0:ndmax]-6


for i=1, nd -1 do tauc1000c[i]=tauc1000c[i-1]+10^dtauc1000[i-1]   ;WORKING, assumes DTAUC is in log scale
for i=1, nd -1 do tauc1000c2[i]=tauc1000c2[i-1]+10^dtauc1000c2[i-1]   ;WORKING
for i=1, nd -1 do tauc1384c2[i]=tauc1384c2[i-1]+10^dtauc1384c2[i-1]   ;WORKING
for i=1, nd -1 do tauc6000c2[i]=tauc6000c2[i-1]+10^dtauc6000c2[i-1]   ;WORKING
for i=1, nd -1 do tauc21200c2[i]=tauc21200c2[i-1]+10^dtauc21200c2[i-1]   ;WORKING

file='/Users/jgroh/ze_models/etacar/mod43_groh/s_tau_1000_6000.txt'
readcol,file,logtau1000,logs1000,logtau6000,logs6000

file='/Users/jgroh/ze_models/etacar/mod43_groh/s_tau_1384_21200.txt'
readcol,file,logtau1384,logs1384,logtau21200,logs21200

;;plot of log S x log tau
;lineplot,logtau1000,logs1000
;lineplot,logtau1384,logs1384
;lineplot,logtau6000,logs6000
;lineplot,logtau21200,logs21200

;;plot of log tau x distance
;lineplot,rau,logtau1000
;lineplot,rau,logtau1384
;lineplot,rau,logtau6000
;lineplot,rau,logtau21200

;;plot of log modified tau x distance
;lineplot,rau,logtau1000
;lineplot,rau,alog10(tauc1000c2)
;lineplot,rau,alog10(tauc1384c2)
;lineplot,rau,alog10(tauc6000c2)
;lineplot,rau,alog10(tauc21200c2)

;;plot S e-tau versus tau
;lineplot,10^logtau1000,10^logs1000*exp(-10^logtau1000)
;lineplot,tauc1000c2,10^logs1000*exp(-tauc1000c2)
;lineplot,10^logtau1384,10^logs1384*exp(-10^logtau1384)
;lineplot,tauc1384c2,10^logs1384*exp(-tauc1384c2)
;lineplot,10^logtau6000,10^logs6000*exp(-10^logtau6000)
;lineplot,tauc6000c2,10^logs6000*exp(-tauc6000c2)
;lineplot,10^logtau21200,10^logs21200*exp(-10^logtau21200)
;lineplot,tauc21200c2,10^logs21200*exp(-tauc21200c2)

;compute I(p)  
ip_0_1000=int_tabulated(10^logtau1000,10^logs1000*exp(-10^logtau1000))
ip_0_1000c=int_tabulated(tauc1000c2,10^logs1000*exp(-tauc1000c2))

factor=20
ip_0_1000r=int_tabulated((REBIN(10^logtau1000,nd*factor))[0:nd*factor-factor],(REBIN(10^logs1000*exp(-10^logtau1000),nd*factor))[0:nd*factor-factor])
ip_0_1000cr=int_tabulated((REBIN(tauc1000c2,nd*factor))[0:nd*factor-factor],(REBIN(10^logs1000*exp(-tauc1000c2),nd*factor))[0:nd*factor-factor])
ip_0_1384r=int_tabulated((REBIN(10^logtau1384,nd*factor))[0:nd*factor-factor],(REBIN(10^logs1384*exp(-10^logtau1384),nd*factor))[0:nd*factor-factor])
ip_0_1384cr=int_tabulated((REBIN(tauc1384c2,nd*factor))[0:nd*factor-factor],(REBIN(10^logs1384*exp(-tauc1384c2),nd*factor))[0:nd*factor-factor])
ip_0_6000r=int_tabulated((REBIN(10^logtau6000,nd*factor))[0:nd*factor-factor],(REBIN(10^logs6000*exp(-10^logtau6000),nd*factor))[0:nd*factor-factor])
ip_0_6000cr=int_tabulated((REBIN(tauc6000c2,nd*factor))[0:nd*factor-factor],(REBIN(10^logs6000*exp(-tauc6000c2),nd*factor))[0:nd*factor-factor])
ip_0_21200r=int_tabulated((REBIN(10^logtau21200,nd*factor))[0:nd*factor-factor],(REBIN(10^logs21200*exp(-10^logtau21200),nd*factor))[0:nd*factor-factor])
ip_0_21200cr=int_tabulated((REBIN(tauc21200c2,nd*factor))[0:nd*factor-factor],(REBIN(10^logs21200*exp(-tauc21200c2),nd*factor))[0:nd*factor-factor])

ip_0_1384=int_tabulated(10^logtau1384,10^logs1384*exp(-10^logtau1384))
ip_0_1384c=int_tabulated(tauc1384c2,10^logs1384*exp(-tauc1384c2))
ip_0_6000=int_tabulated(10^logtau6000[0:55],10^logs6000[0:55]*exp(-10^logtau6000[0:55]))
ip_0_6000c=int_tabulated(tauc6000c2[0:55],10^logs6000[0:55]*exp(-tauc6000c2[0:55]))
ip_0_21200=int_tabulated(10^logtau21200[0:55],10^logs21200[0:55]*exp(-10^logtau21200[0:55]))
ip_0_21200c=int_tabulated(tauc21200c2[0:55],10^logs21200[0:55]*exp(-tauc21200c2[0:55]))

print,ip_0_1000,ip_0_1000c,ip_0_1384,ip_0_1384c,ip_0_6000,ip_0_6000c,ip_0_21200,ip_0_21200c
print,ip_0_1000r,ip_0_1000cr,ip_0_1384r,ip_0_1384cr,ip_0_6000r,ip_0_6000cr,ip_0_21200r,ip_0_21200cr

file='/Users/jgroh/ze_models/etacar/mod43_groh/logrtau0d66_over_rstar_loglambda.txt'
readcol,file,loglambda,logrtau_over_rstar
rstar=60. ;in Rsun
lambda=10^loglambda
;lineplot,10^loglambda,(10^logrtau_over_rstar)*rstar/204.

;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_plus_cavity_mod43_groh_compare_photospheric_radius_0d66_apex.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=6
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 0, 0, 0, 0]
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
;b=0


xmin=150
xmax=1e6
plot,10^loglambda,(10^logrtau_over_rstar)*rstar/204.,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[0,40],/xlog,$
/nodata,POSITION=[0.15,0.15,0.94,0.99],xtitle='Wavelength [Angstrom]',ytitle=TEXTOIDL('R (\tau=2/3) [AU]'),yticklen=0.025
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
plots,10^loglambda,(10^logrtau_over_rstar)*rstar/204.,color=coloro,linestyle=0,noclip=0,thick=b+3.5
plots,[xmin,xmax],[23.4,23.4],linestyle=2,noclip=0,thick=b+3.5,color=colorm1
plots,[xmin,xmax],[10.0,10.0],linestyle=2,noclip=0,thick=b+3.5,color=colorm2
plots,[xmin,xmax],[5.0,5.0],linestyle=2,noclip=0,thick=b+3.5,color=colorm3
plots,[xmin,xmax],[1.5,1.5],linestyle=2,noclip=0,thick=b+3.5,color=colorm4
;label horizontal lines
xyouts,180,25,TEXTOIDL('\phi_{orb}=0.50'),/DATA,color=colorm1,charsize=1.6,charthick=6
xyouts,180,11,TEXTOIDL('\phi_{orb}=0.90'),/DATA,color=colorm2,charsize=1.6,charthick=6
xyouts,180,6,TEXTOIDL('\phi_{orb}=0.95'),/DATA,color=colorm3,charsize=1.6,charthick=6
xyouts,180,2.5,TEXTOIDL('\phi_{orb}=1.00'),/DATA,color=colorm4,charsize=1.6,charthick=6

;plots,
!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_plus_cavity_mod43_groh_compare_sourcefunction_tau_cavity_nocavity.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8
!p.multi=[0, 0, 0, 0, 0]

coloro=fsc_color('black')
LOADCT,13,/SILENT

nmodels=4
minc=30
maxc=255

;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

plot,logtau1000,logs1000,xstyle=1,ystyle=1,xrange=[-2,2],$
/nodata,POSITION=[0.14,0.23,0.96,0.96],xtitle=TEXTOIDL('log \tau'),ytitle=TEXTOIDL('log S [cgs]')
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,logtau1000,logs1000,color=minc,linestyle=0,noclip=0
plots,logtau1384,logs1384,color=colorm1,linestyle=0,noclip=0
;plots,logtau6000,logs6000,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,logtau21200,logs21200,color=colorm2,linestyle=0,noclip=0
xyouts,-1.8,-2,TEXTOIDL('UV (\lambda1384)'),orientation=0,/DATA,color=colorm1
xyouts,-1.8,-3,TEXTOIDL('NIR (\lambda21200)'),orientation=0,/DATA,color=colorm2
xyouts,0.85,0.3,'(b)',orientation=0,/NORMAL;,charsize=2.0
;plots,
!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_plus_cavity_mod43_groh_compare_sourcefunction_exp_tau_versus_tau_cavity_nocavity.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8
!p.multi=[0, 0, 0, 0, 0]

coloro=fsc_color('black')
LOADCT,13,/SILENT

nmodels=4
minc=30
maxc=255

;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('green')
colorm4=fsc_color('brown')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

plot,tauc1000c2,10^logs1000*exp(-tauc1000c2),xstyle=1,ystyle=1,xrange=[0,15],yrange=[0,5e-5],$
/nodata,POSITION=[0.19,0.23,0.99,0.96],xtitle=TEXTOIDL('\tau'),ytitle=TEXTOIDL('S e^{-\tau} [cgs]')
;plots,10^logtau1000,1*10^logs1000*exp(-10^logtau1000),color=coloro,linestyle=0,noclip=0
plots,10^logtau1384,10^logs1384*exp(-10^logtau1384),color=colorm1,linestyle=0,noclip=0
;plots,10^logtau6000,10^logs6000*exp(-10^logtau6000),color=colorm2,linestyle=0,noclip=0
plots,10^logtau21200,10^logs21200*exp(-10^logtau21200),color=colorm2,linestyle=0,noclip=0
;plots,tauc1000c2,10^logs1000*exp(-tauc1000c2),color=coloro,linestyle=2,noclip=0
plots,tauc1384c2,10^logs1384*exp(-tauc1384c2),color=colorm1,linestyle=2,noclip=0
;plots,tauc6000c2,10^logs6000*exp(-tauc6000c2),color=colorm2,linestyle=2,noclip=0
plots,tauc21200c2,10^logs21200*exp(-tauc21200c2),color=colorm2,linestyle=2,noclip=0

xyouts,5,2.3e-5,TEXTOIDL('UV (\lambda1384)'),orientation=0,/DATA,color=colorm1
xyouts,2,1.0e-5,TEXTOIDL('NIR (\lambda21200)'),orientation=0,/DATA,color=colorm2
xyouts,0.85,0.3,'(c)',orientation=0,/NORMAL;,charsize=2.0
;plots,10^logtau1000,1*10^logs1000*exp(-10^logtau1000),color=minc,linestyle=0,noclip=0
;plots,10^logtau1384,10^logs1384*exp(-10^logtau1384),color=minc+1*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
;plots,10^logtau6000,10^logs6000*exp(-10^logtau6000),color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
;plots,10^logtau21200,10^logs21200*exp(-10^logtau21200),color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
;plots,tauc1000c2,10^logs1000*exp(-tauc1000c2),color=minc,linestyle=2,noclip=0
;plots,tauc1384c2,10^logs1384*exp(-tauc1384c2),color=minc+1*((maxc-minc)/(nmodels-1)),linestyle=2,noclip=0
;plots,tauc6000c2,10^logs6000*exp(-tauc6000c2),color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=2,noclip=0
;plots,tauc21200c2,10^logs21200*exp(-tauc21200c2),color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=2,noclip=0


;plots,
!p.multi=[0, 0, 0, 0, 0]
device,/close


device,filename='/Users/jgroh/temp/etc_cmfgen_plus_cavity_mod43_groh_compare_tau_cavity_nocavity.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8
!p.multi=[0, 0, 0, 0, 0]

coloro=fsc_color('black')
LOADCT,13,/SILENT

nmodels=4
minc=30
maxc=255

;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')



plot,rau,logtau1000,xstyle=1,ystyle=1,/xlog,$
/nodata,POSITION=[0.12,0.23,0.99,0.96],xtitle=TEXTOIDL('r [AU]'),ytitle=TEXTOIDL('log \tau')
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,rau,logtau1000,color=minc,linestyle=0,noclip=0
plots,rau,logtau1384,color=colorm1,linestyle=0,noclip=0
;plots,rau,logtau6000,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,rau,logtau21200,color=colorm2,linestyle=0,noclip=0
;plots,rau,alog10(tauc1000c2),color=minc,linestyle=2,noclip=0
plots,rau,alog10(tauc1384c2),color=colorm1,linestyle=2,noclip=0
;plots,rau,alog10(tauc6000c2),color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=2,noclip=0
plots,rau,alog10(tauc21200c2),color=colorm2,linestyle=2,noclip=0
xyouts,300,1.2,TEXTOIDL('UV (\lambda1384)'),orientation=0,/DATA,color=colorm1
xyouts,300,0.5,TEXTOIDL('NIR (\lambda21200)'),orientation=0,/DATA,color=colorm2
xyouts,0.85,0.3,'(a)',orientation=0,/NORMAL;,charsize=2.0

;plots,
!p.multi=[0, 0, 0, 0, 0]
device,/close



set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')

END