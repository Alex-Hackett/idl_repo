;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD44_GROH_COMPARE_MODELS_INC_WALL_V2_PAPER
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

;dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
;model2='inc_ang_alpha57'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix2='0_30_49' ;opening angle 50.4
;filename1='OBSFRAME1'
;filename2='OBSFRAME2'
;filename3='OBSFRAME3'
;ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm00scl,fm00scl,nm00,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm00scl,fn00scl
;ZE_CMFGEN_READ_OBS_2D,filename2,dir2+model2+'/'+sufix2+'/',lm30scl,fm30scl,nm30,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename2,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm30scl,fn30scl
;ZE_CMFGEN_READ_OBS_2D,filename3,dir2+model2+'/'+sufix2+'/',lm49scl,fm49scl,nm49,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename3,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm49scl,fn49scl
;
;dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
;model2='inc_ang_alpha57'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix2='60_70_90' ;opening angle 50.4
;filename1='OBSFRAME1'
;filename2='OBSFRAME2'
;filename3='OBSFRAME3'
;ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm60scl,fm60scl,nm60,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm60scl,fn60scl
;ZE_CMFGEN_READ_OBS_2D,filename2,dir2+model2+'/'+sufix2+'/',lm70scl,fm70scl,nm70,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename2,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm70scl,fn70scl
;ZE_CMFGEN_READ_OBS_2D,filename3,dir2+model2+'/'+sufix2+'/',lm90scl,fm90scl,nm90,/FLAM
;ZE_BH05_CREATE_OBSNORM,filename3,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm90scl,fn90scl

restore,'/Users/jgroh/espectros/etacar/etc_hst_stis_17apr01_1700_10400_norm.sav'

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


device,filename='/Users/jgroh/temp/etc_cmfgen_mod44groh_plus_cavity_compare_models_uv_optical_inc.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
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

nmodels=9
minc=30
maxc=255


;near UV around 2500 angstroms
!p.multi=[4, 1, 3, 0, 0]
x1l=2420
x1u=2550
s=45000.
s2=1e-12
plot,lm00,fm00/s,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,0.5e-11/s2],ytickinterval=2,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='F [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]'
plots,lambda_17apr01,flux_17apr01/s2,color=color0,linestyle=0,noclip=0

plots,lm00,fm00/s/s2,color=minc,linestyle=0,noclip=0
plots,lm30,fm30/s/s2,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm49uv,fm49uv/s/s2,color=minc+9*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm70,fm70/s/s2,color=minc+7*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm90,fm90/s/s2,color=minc+5*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
xyouts,2425,4.3,TEXTOIDL('(a) near-UV'),color=FSC_COLOR('black'),orientation=0,/DATA
!p.multi=[4, 2, 3, 0, 0]


;hdelta
lambda0=4102.892 
x1l=-1300
x1u=1300
plot,lm00scl,fn00scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,20],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm90scl,lambda0),fn90scl*0.932,color=minc+5*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm70scl,lambda0),fn70scl*0.941,color=minc+7*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm30scl,lambda0),fn30scl*0.877,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm00scl,lambda0),fn00scl*0.86,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm49scl,lambda0),fn49scl*0.895,color=minc+9*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
xyouts,-1100,10,TEXTOIDL('(b) H\delta'),color=FSC_COLOR('black'),orientation=0,/DATA

;labels
xyouts,8000,11000,TEXTOIDL('i=90^\circ'),color=minc,orientation=0,/DeVICE
xyouts,8000,10500,TEXTOIDL('i=120^\circ'),color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,10000,TEXTOIDL('i=138^\circ'),color=minc+9*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,9500,TEXTOIDL('i=160^\circ'),color=minc+7*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,9000,TEXTOIDL('i=180^\circ'),color=minc+5*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE


;hbeta
lambda0=4862.683
x1l=-1300
x1u=1300
plot,lm00scl,fn00scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,50],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm90scl,lambda0),fn90scl*1.1,color=minc+5*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm70scl,lambda0),fn70scl*1.1,color=minc+7*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm30scl,lambda0),fn30scl*1.1,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm00scl,lambda0),fn00scl*1.1,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm49scl,lambda0),fn49scl*1.1,color=minc+9*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
xyouts,-1100,20,TEXTOIDL('(c) H\beta'),color=FSC_COLOR('black'),orientation=0,/DATA

;halpha
lambda0=6564.61
x1l=-1300
x1u=1300
plot,lm00scl,fn00scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm90scl,lambda0),fn90scl*1.1,color=minc+5*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm70scl,lambda0),fn70scl*1.1,color=minc+7*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm30scl,lambda0),fn30scl*1.1,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm00scl,lambda0),fn00scl*1.1,color=minc,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm49scl,lambda0),fn49scl*1.1,color=minc+9*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

xyouts,-1100,40,TEXTOIDL('(d) H\alpha'),color=FSC_COLOR('black'),orientation=0,/DATA

;Fe II lines around 4500 angstroms
x1l=4500
x1u=4600
plot,lm00scl,fm00scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,3],ytickinterval=1,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lm90,fn90/1.3,color=minc+5*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm70,fn70/1.3,color=minc+7*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm30,fn30,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm00,fn00,color=minc,linestyle=0,noclip=0
plots,lm49,fn49/1.4,color=minc+9*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
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
lambda0=4102.892 
;lineplot,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n
;lineplot,ZE_LAMBDA_TO_VEL(lm00scl,lambda0),fn00scl
;lineplot,ZE_LAMBDA_TO_VEL(lm30scl,lambda0),fn30scl
;lineplot,ZE_LAMBDA_TO_VEL(lm49scl,lambda0),fn49scl
;lineplot,ZE_LAMBDA_TO_VEL(lm70scl,lambda0),fn70scl
;lineplot,ZE_LAMBDA_TO_VEL(lm90scl,lambda0),fn90scl
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod44groh.sav'
END