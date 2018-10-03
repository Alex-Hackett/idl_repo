;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD44_GROH_COMPARE_MODELS_OMEGA
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')

RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod44groh.sav'


extra_labelomega0=TEXTOIDL('\omega=0^\circ')
lmomega0=lm60
fnomega0=fn60
fmomega0=fm60

lmomega0scl=lm60scl
fnomega0scl=fn60scl

extra_labelomega90=TEXTOIDL('\omega=90^\circ')
lmomega90=lm90
fnomega90=fn90
fmomega90=fm90

lmomega90scl=lm90scl
fnomega90scl=fn90scl

extra_labelomega180=TEXTOIDL('\omega=180^\circ')
lmomega180=lm60
fnomega180=fn60
fmomega180=fm60

lmomega180scl=lm60scl
fnomega180scl=fn60scl

extra_labelomega270=TEXTOIDL('\omega=260^\circ')
lmomega270=lm49
fnomega270=fn49
lmomega270uv=lm49uv
fmomega270uv=fm49uv

lmomega270scl=lm49scl
fnomega270scl=fn49scl



;set plot range
;x1l=925. & x1u=1055.
x1l=1270. & x1u=1390.
x2l=1385. & x2u=1500.
x3l=1500. & x3u=1702.
x4l=1750. & x4u=1952.
x5l=2500. & x5u=2820.
x6l=2850. & x6u=3120.


;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod44groh_plus_cavity_compare_models_uv_optical_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
!p.multi=[0,2, 3, 0, 0]
!P.THICK=7
!X.THICK=8
!Y.THICK=8
!X.CHARSIZE=1.8
!Y.CHARSIZE=1.8
!P.CHARSIZE=1.5
!P.CHARTHICK=6
!Y.OMARGIN=[4,-3]
!X.OMARGIN=[8.5,-4]
!Y.MARGIN=[2,4]
!X.MARGIN=[5,9]

coloro=fsc_color('black')
LOADCT,13

nmodels=4
minc=30
maxc=255

!p.multi=[4, 1, 3, 0, 0]
x1l=2420
x1u=2550
s=45000.
s2=1e-12
plot,lmomega0,fmomega0/s/s2,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,0.5e-11/s2],ytickinterval=2,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='F [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]'
plots,lmomega0,fmomega0/s/s2,color=minc,linestyle=0,noclip=0
plots,lmomega90,fmomega90/s/s2,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega180,fmomega180/s/s2,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega270uv,fmomega270uv/s/s2,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lambda_17apr01,flux_17apr01/s2,color=fsc_color('black'),linestyle=0,noclip=0
xyouts,2425,4.3,TEXTOIDL('(a) near-UV'),color=FSC_COLOR('black'),orientation=0,/DATA
!p.multi=[4, 2, 3, 0, 0]

lambda0=4102.892 
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,20],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl*0.941,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90scl,lambda0),fnomega90scl*0.932,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180scl,lambda0),fnomega180scl*0.941,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270scl,lambda0),fnomega270scl*0.895,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

xyouts,-1100,10,TEXTOIDL('(b) H\delta'),color=FSC_COLOR('black'),orientation=0,/DATA

;labels
xyouts,8000,13500,TEXTOIDL('\omega=0^\circ'),color=minc,orientation=0,/DeVICE
xyouts,8000,13000,TEXTOIDL('\omega=90^\circ'),color=minc+1*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12500,TEXTOIDL('\omega=180^\circ'),color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12000,TEXTOIDL('\omega=260^\circ'),color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE

lambda0=4862.683
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,50],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl*1.1,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90scl,lambda0),fnomega90scl*1.1,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180scl,lambda0),fnomega180scl*1.1,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270scl,lambda0),fnomega270scl*1.06,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

xyouts,-1100,20,TEXTOIDL('(c) H\beta'),color=FSC_COLOR('black'),orientation=0,/DATA

lambda0=6564.61
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega0scl,lambda0),fnomega0scl*1.1,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90scl,lambda0),fnomega90scl*1.1,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180scl,lambda0),fnomega180scl*1.1,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270scl,lambda0),fnomega270scl*1.1,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
xyouts,-1100,40,TEXTOIDL('(d) H\alpha'),color=FSC_COLOR('black'),orientation=0,/DATA

x1l=4500
x1u=4600
plot,lmomega0,fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,3],ytickinterval=1,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lmomega0,fnomega0/1.2,color=minc,linestyle=0,noclip=0
plots,lmomega90,fnomega90/1.3,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega180,fnomega180/1.2,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega270,fnomega270/1.4,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

xyouts,4508,2.6,TEXTOIDL('(e) Fe II lines'),color=FSC_COLOR('black'),orientation=0,/DATA

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
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_alpha.sav'
END