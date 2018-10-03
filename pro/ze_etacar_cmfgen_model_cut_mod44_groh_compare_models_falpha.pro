PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD44_GROH_COMPARE_MODELS_FALPHA
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')

dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
model2='var_falpha'   ;b,c,o,r,t,u,v don't cover the UV range
sufix2='1' ;opening angle 50.4
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm36scl,fm36scl,nm00,/FLAM
ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm36scl,fn36scl

dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
model2='var_falpha'   ;b,c,o,r,t,u,v don't cover the UV range
sufix2='2d5' ;opening angle 50.4
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm50scl,fm50scl,nm00,/FLAM
ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm50scl,fn50scl

dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
model2='var_falpha'   ;b,c,o,r,t,u,v don't cover the UV range
sufix2='4' ;opening angle 57.4
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm57scl,fm57scl,nm00,/FLAM
ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm57scl,fn57scl

dir2='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/cut_v4_vstream/'
model2='var_falpha'   ;b,c,o,r,t,u,v don't cover the UV range
sufix2='10' ;opening angle 72.4
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir2+model2+'/'+sufix2+'/',lm72scl,fm72scl,nm00,/FLAM
ZE_BH05_CREATE_OBSNORM,filename1,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lm72scl,fn72scl


restore,'/Users/jgroh/espectros/etacar/etc_hst_stis_17apr01_1700_10400_norm.sav'


;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod44groh_plus_cavity_compare_models_uv_optical_falpha.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
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

coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('cyan')
colorm6=fsc_color('green')
colorm7=fsc_color('cyan')
colorm8=fsc_color('purple')

!p.multi=[4, 1, 3, 0, 0]
x1l=2420
x1u=2550
s=45000.
s2=1e-12
plot,lm36scl,fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,0.5e-11/s2],ytickinterval=2,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='F [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]'
plots,lm36scl,fm36scl/s/s2,color=colorm8,linestyle=0,noclip=0
plots,lm50scl,fm50scl/s/s2,color=colorm6,linestyle=0,noclip=0
plots,lm72scl,fm72scl/s/s2,color=colorm5,linestyle=0,noclip=0
plots,lm57scl,fm57scl/s/s2,color=colorm1,linestyle=0,noclip=0
plots,lambda_17apr01,flux_17apr01/s2,color=fsc_color('black'),linestyle=0,noclip=0
xyouts,2425,4.3,TEXTOIDL('(a) near-UV'),color=FSC_COLOR('black'),orientation=0,/DATA
!p.multi=[4, 2, 3, 0, 0]

lambda0=4102.892 
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,20],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl*0.895,color=colorm8,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm50scl,lambda0),fn50scl*0.895,color=colorm6,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm72scl,lambda0),fn72scl*0.895,color=colorm5,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm57scl,lambda0),fn57scl*0.895,color=colorm1,linestyle=0,noclip=0

xyouts,-1100,10,TEXTOIDL('(b) H\delta'),color=FSC_COLOR('black'),orientation=0,/DATA

;labels
xyouts,8000,13500,TEXTOIDL('\omega=0^\circ'),color=minc,orientation=0,/DeVICE
xyouts,8000,13000,TEXTOIDL('i=90^\circ'),color=minc+1*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12500,TEXTOIDL('i=180^\circ'),color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,8000,12000,TEXTOIDL('i=260^\circ'),color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE

lambda0=4862.683
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,50],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl*1.06,color=colorm8,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm50scl,lambda0),fn50scl*1.06,color=colorm6,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm72scl,lambda0),fn72scl*1.06,color=colorm5,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm57scl,lambda0),fn57scl*1.06,color=colorm1,linestyle=0,noclip=0

xyouts,-1100,20,TEXTOIDL('(c) H\beta'),color=FSC_COLOR('black'),orientation=0,/DATA

lambda0=6564.61
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=2,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',/ylog
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl*1.1,color=colorm8,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm50scl,lambda0),fn50scl*1.1,color=colorm6,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm72scl,lambda0),fn72scl*1.1,color=colorm5,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm57scl,lambda0),fn57scl*1.1,color=colorm1,linestyle=0,noclip=0
xyouts,-1100,40,TEXTOIDL('(d) H\alpha'),color=FSC_COLOR('black'),orientation=0,/DATA

x1l=4500
x1u=4600
plot,lm36scl,fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,3],ytickinterval=1,$
/nodata,xtitle='Wavelength ['+Angstrom+' ]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lm36scl,fn36scl,color=colorm8,linestyle=0,noclip=0
plots,lm50scl,fn50scl,color=colorm6,linestyle=0,noclip=0
plots,lm72scl,fn72scl,color=colorm5,linestyle=0,noclip=0
plots,lm57scl,fn57scl,color=colorm1,linestyle=0,noclip=0

xyouts,4508,2.6,TEXTOIDL('(e) Fe II lines'),color=FSC_COLOR('black'),orientation=0,/DATA

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod44groh_plus_cavity_compare_models_halpha_emiss_falpha.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=6

LOADCT,13
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('cyan')
colorm6=fsc_color('green')
colorm7=fsc_color('cyan')
colorm8=fsc_color('purple')

lambda0=6564.61
x1l=-1300
x1u=1300
plot,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.00,70],ytickinterval=20,$
/nodata,xtitle='Velocity (km/s)', ytitle='Normalized Flux',POSITION=[0.11,0.25,0.96,0.96]
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl*1.1,color=colorm8,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm50scl,lambda0),fn50scl*1.1,color=colorm6,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm72scl,lambda0),fn72scl*1.0,color=colorm5,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm57scl,lambda0),fn57scl*1.1,color=colorm1,linestyle=0,noclip=0
xyouts,-1100,60,TEXTOIDL('(b) H\alpha'),color=FSC_COLOR('black'),orientation=0,/DATA
;labels
xyouts,-1100,50,TEXTOIDL('f_\alpha=1.0, \delta\alpha=0^\circ'),color=colorm8,orientation=0,/DATA
xyouts,-1100,40,TEXTOIDL('f_\alpha=2.5, \delta\alpha=11^\circ'),color=colorm6,orientation=0,/data
xyouts,-1100,30,TEXTOIDL('f_\alpha=4.0, \delta\alpha=7^\circ'),color=colorm1,orientation=0,/data
xyouts,-1100,20,TEXTOIDL('f_\alpha=10, \delta\alpha=3^\circ'),color=colorm5,orientation=0,/data



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
;lineplot,ZE_LAMBDA_TO_VEL(lm36scl,lambda0),fn36scl*1.1
;lineplot,ZE_LAMBDA_TO_VEL(lm50scl,lambda0),fn50scl*1.1
;lineplot,ZE_LAMBDA_TO_VEL(lm72scl,lambda0),fn72scl*1.1
;lineplot,ZE_LAMBDA_TO_VEL(lm57scl,lambda0),fn57scl*1.1
;lineplot,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_alpha.sav'
END