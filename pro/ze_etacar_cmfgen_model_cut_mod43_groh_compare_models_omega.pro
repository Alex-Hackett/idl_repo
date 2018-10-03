;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD43_GROH_COMPARE_MODELS_INC_WALL
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')

RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod44groh.sav'

;filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01
;
;;normalize observations?
;line_norm,lambda_17apr01,flux_17apr01,flux_17apr01n,norm17apr01,xnodes17apr01,ynodes17apr01
;
;;flux scale observations?
;scl_17apr01=1.0
;flux_17apr01n=1d0+((flux_17apr01n-1d0)*scl_17apr01)
;
;;apply radial velocity shift?
;;velshift=100.
;;flux_17apr01ns=ZE_SHIFT_SPECTRA_VEL(lambda_17apr01,flux_17apr01n,velshift)
;;flux_17apr01n=flux_17apr01ns
;
;dir='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh/cut_v4_vstream/'
;model='inc_ang'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix001020='0_10_20'
;filename00='OBSFRAME1'
;filename10='OBSFRAME2'
;filename20='OBSFRAME3'
;extra_label00=TEXTOIDL('i=90^\circ')
;extra_label10=TEXTOIDL('i=80^\circ')
;extra_label20=TEXTOIDL('i=70^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix001020,filename00,lm00,fm00,fn00,inc00,inc_str00,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix001020,filename10,lm10,fm10,fn10,inc10,inc_str10,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix001020,filename20,lm20,fm20,fn20,inc20,inc_str20,/FLAM
;
;sufix304060='30_40_60'
;filename30='OBSFRAME1'
;filename40='OBSFRAME2'
;filename60='OBSFRAME3'
;extra_label30=TEXTOIDL('i=60^\circ')
;extra_label40=TEXTOIDL('i=50^\circ')
;extra_label60=TEXTOIDL('i=30^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix304060,filename30,lm30,fm30,fn30,inc30,inc_str30,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix304060,filename40,lm40,fm40,fn40,inc40,inc_str40,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix304060,filename60,lm60,fm60,fn60,inc60,inc_str60,/FLAM
;
;sufix708090='70_80_90'
;filename70='OBSFRAME1'
;filename80='OBSFRAME2'
;filename90='OBSFRAME3'
;extra_label70=TEXTOIDL('i=20^\circ')
;extra_label80=TEXTOIDL('i=10^\circ')
;extra_label90=TEXTOIDL('i=00^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix708090,filename70,lm70,fm70,fn70,inc70,inc_str70,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix708090,filename80,lm80,fm80,fn80,inc80,inc_str80,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix708090,filename90,lm90,fm90,fn90,inc90,inc_str90,/FLAM



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

lmomega0scl=lm60scl
fnomega0scl=fn60scl

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


device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
LOADCT,13

nmodels=4
minc=30
maxc=255

x1l=6530
x1u=6590

plot,lmomega0,fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,78],ytickinterval=0,$
/nodata,POSITION=[0.11,0.25,0.96,0.96],xtitle='Wavelength [Angstrom]', ytitle='Normalized Flux'
plots,lmomega0,fnomega0,color=minc,linestyle=0,noclip=0
plots,lmomega90,fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega180,fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega270,fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
;labels
xyouts,2700,7500,extra_labelomega0,color=minc,orientation=0,/DEVICE
xyouts,2700,7000,extra_labelomega90,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6500,extra_labelomega180,color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6000,extra_labelomega270,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE


!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_abs_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
LOADCT,13

nmodels=4
minc=30
maxc=255


lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)

plot,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,10],ytickinterval=0,$
/nodata,POSITION=[0.11,0.25,0.96,0.96],xtitle='Wavelength [Angstrom]', ytitle='Normalized Flux'
plots,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90,lambda0),fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180,lambda0),fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270,lambda0),fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
;labels
xyouts,2700,7500,extra_labelomega0,color=minc,orientation=0,/DEVICE
xyouts,2700,7000,extra_labelomega90,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6500,extra_labelomega180,color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6000,extra_labelomega270,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_uv_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=5
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=0.9
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
LOADCT,13

nmodels=4
minc=30
maxc=255

x1l=2420
x1u=2550
s=45000.
s2=1e-12
plot,lmomega0,fmomega0/s/s2,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,0.5e-11/s2],ytickinterval=2,$
/nodata,POSITION=[0.11,0.25,0.96,0.96],xtitle='Wavelength [Angstrom]', ytitle='Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]'
plots,lmomega0,fmomega0/s/s2,color=minc,linestyle=0,noclip=0
plots,lmomega90,fmomega90/s/s2,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega180,fmomega180/s/s2,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega270uv,fmomega270uv/s/s2,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lambda_17apr01,flux_17apr01/s2,color=fsc_color('black'),linestyle=0,noclip=0
;labels
xyouts,2700,7500,extra_labelomega0,color=minc,orientation=0,/DEVICE
xyouts,2700,7000,extra_labelomega90,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6500,extra_labelomega180,color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6000,extra_labelomega270,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE


;labels
;xyouts,2700,7500,extra_label00,color=minc,orientation=0,/DEVICE
;xyouts,2700,7000,extra_label10,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,6500,extra_label20,color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,6000,extra_label30,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,5500,extra_label40,color=minc+4*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,5000,extra_label49,color=minc+5*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,4500,extra_label60,color=minc+6*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,4000,extra_label70,color=minc+7*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,3500,extra_label80,color=minc+8*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,3000,extra_label90,color=minc+9*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
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
plot,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,20],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90,lambda0),fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180,lambda0),fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270,lambda0),fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
xyouts,-1100,10,TEXTOIDL('(b) H\delta'),color=FSC_COLOR('black'),orientation=0,/DATA

;labels
xyouts,8000,13500,TEXTOIDL('\omega=0^\circ'),color=minc,orientation=0,/DeVICE
xyouts,8000,13000,TEXTOIDL('i=90^\circ'),color=minc+1*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12500,TEXTOIDL('i=180^\circ'),color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12000,TEXTOIDL('i=260^\circ'),color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE

lambda0=4862.683
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,50],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90,lambda0),fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180,lambda0),fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270,lambda0),fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
xyouts,-1100,20,TEXTOIDL('(c) H\beta'),color=FSC_COLOR('black'),orientation=0,/DATA

lambda0=6564.61
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lmomega0,lambda0),fnomega0,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega90,lambda0),fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega180,lambda0),fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lmomega270,lambda0),fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
xyouts,-1100,40,TEXTOIDL('(d) H\alpha'),color=FSC_COLOR('black'),orientation=0,/DATA

x1l=4500
x1u=4600
plot,lmomega0,fnomega0,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,3],ytickinterval=1,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lmomega0,fnomega0,color=minc,linestyle=0,noclip=0
plots,lmomega90,fnomega90,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega180,fnomega180,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lmomega270,fnomega270,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

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