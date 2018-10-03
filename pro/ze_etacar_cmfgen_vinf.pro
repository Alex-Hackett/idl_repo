;PRO ZE_ETACAR_CMFGEN_VINF
close,/all
!P.Background = fsc_color('white')
!P.MULTI=0
Angstrom = '!6!sA!r!u!9 %!6!n'

restore,'/Users/jgroh/temp/etc_cmfgen_vinf_allvar.sav'

;filename_19mar98='/Users/jgroh/data/hst/stis/etacar_from_john/star_19mar98'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_19mar98,lambda_19mar98,flux_19mar98,mask_19mar98

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin',lambdamod2,fluxmod2,num_rec,/flam
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod44_groh/obs/obs_fin',lambdamod2,fluxmod2,num_rec,/flam
;scales the flux to 2.3 kpc (Eta Car)
dist=2.3
fmfulld23=fmfull/dist^2
fmcavd23=fmcav/dist^2
fluxmod2d23=fluxmod2/dist^2
;final redenning
minusebv=-0.40 ;best fit with ca 2 mag of grey extinction?
;minusebv=-1.7 ;from Davidson et al
;minusebv=-1.0
a=3.1
;a=5.0
;fm_unred,lmfull,fmfulld23,-1.0,fmfulld23r,R_V = 5.0
;fm_unred,lmcav,fmcavd23,-1.0,fmcavd23r,R_V = 5.0

;from OBSFRAME
fm_unred, lmcav,fmcavd23, minusebv, fmcavd23r, R_V = a
fm_unred,lmfull,fmfulld23,minusebv,fmfulld23r,R_V = a
fm_unred,lambdamod2,fluxmod2d23,minusebv,fluxmod2d23r,R_V = a


;restore,'/Users/jgroh/temp/etc_cmfgen_vinf_allvar.sav'



;set plot range
;x1l=925. & x1u=1055.
x1l=1331. & x1u=1337.5
x2l=1385. & x2u=1500.
x3l=1500. & x3u=1702.
x4l=1700. & x4u=2252.
x5l=2250. & x5u=2702.
x6l=2750. & x6u=3202.
xpurplehazel=2000.
xpurplehazeu=2500.

lambdaobs=lambda_23mar00_e140m
fluxobs=flux_23mar00_e140m


scale=378. ;for model g
scale=300. ;for cut_v4 m15
scale=380
;scale=4.0
scale_full=4.0
scale_full=380.

;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/output_etc_stis_uv_cmfgen_vinf_determination.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=4.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[3.5,0.5]
!p.multi=[0, 4, 2, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
!X.MARGIN=[7.0,0.5]
!X.OMARGIN=[3.5,1.5]
xchar=1.8
ychar=1.8
!X.CHARSIZE=xchar
!Y.CHARSIZE=ychar
a=3.0 ;line thick obs
b=4.5 ;line thick model
lm=2
lm2=0
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('green')
s=1.0e-12
lambda0=1334.53
xmax=900
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[-0.01e-11/s,0.4e-11/s],xtickinterval=500,ytickinterval=1.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*1.0,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.36e-11/s,'CII 1334.53',alignment=0,orientation=0

;putting labels on the first panel
plots, [-950,-650],[0.34e-11/s,0.34e-11/s],color=coloro,thick=b+1.5
xyouts,-620,0.33e-11/s,'obs 2000 Mar',alignment=0,orientation=0,charsize=0.8
plots, [-950,-650],[0.31e-11/s,0.31e-11/s],color=colorm2,thick=b+1.5,linestyle=lm
xyouts,-620,0.30e-11/s,TEXTOIDL('mod v_\infty=500'),alignment=0,orientation=0,color=colorm2,charsize=0.8
plots, [-950,-650],[0.28e-11/s,0.28e-11/s],color=colorm,thick=b+1.5
xyouts,-620,0.27e-11/s,TEXTOIDL('mod v_\infty=420'),alignment=0,orientation=0,color=colorm,charsize=0.8


lambda0=1526.7066
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[-0.01e-11/s,0.5e-11/s],xtickinterval=500,ytickinterval=1.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*1.0,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.46e-11/s,'SiII 1526.72',alignment=0,orientation=0


lambda0=1533.4310
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[-0.01e-11/s,0.5e-11/s],xtickinterval=500,ytickinterval=1.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*1.0,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.46e-11/s,'SiII 1533.45',alignment=0,orientation=0

lambdaobs=lambda_17apr01
fluxobs=flux_17apr01

lambda0=2344.21
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[-0.01e-11/s,0.4e-11/s],xtickinterval=500,ytickinterval=1.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full*2.6,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*2.6,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.36e-11/s,'FeII 2344.21',alignment=0,orientation=0

lambda0=2796.35
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[-0.01e-11/s,1.0e-11/s],xtickinterval=500,ytickinterval=2.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full*1.0,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*1.0,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.86e-11/s,'MgII 2896.35',alignment=0,orientation=0

lambda0=4102.89
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[0e-12/s,15.0e-12/s],xtickinterval=500,ytickinterval=5.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full*1.93,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*1.93,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,1.30e-11/s,TEXTOIDL('H\gamma'),alignment=0,orientation=0

lambda0=4418.27
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[2e-12/s,5.0e-12/s],xtickinterval=500,ytickinterval=1.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full*2.23,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*2.28,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,0.46e-11/s,'FeII 4418',alignment=0,orientation=0

lambda0=6564.61
plot,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,xstyle=1,ystyle=1,xrange=[-1000,xmax],yrange=[0e-12/s,420.0e-12/s],xtickinterval=500,ytickinterval=100.,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,ZE_LAMBDA_TO_VEL(lambdaobs,lambda0),fluxobs/s,color=coloro,noclip=0,thick=a
plots,ZE_LAMBDA_TO_VEL(lmfull,lambda0),fmfulld23r/s/scale_full*5.35,color=colorm2,linestyle=lm, noclip=0,thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lambdamod2,lambda0),fluxmod2d23r/s/scale_full*5.40,color=colorm,linestyle=lm2, noclip=0,thick=b+1.5
xyouts,-900,37.46e-11/s,TEXTOIDL('H\alpha'),alignment=0,orientation=0

xyouts,400,3300,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',orientation=90,/DEVICE
xyouts,9500,200,'Velocity (km/s)',orientation=0,/DEVICE

;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x4l-1,x4u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x5l-1,x5u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x6l-1,x6u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b

;xyouts,1500,8200,model+'_'+sufix+'_'+filename+'_i'+inc_str ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
;xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

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