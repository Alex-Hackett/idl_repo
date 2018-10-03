;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD43_COMPARE_MODELS_OBS_LATITUDE_AZIMUTHAL_DEPENDENCE_WEIGELT_BLOBS_FOS4
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'


restore,'/Users/jgroh/temp/etc_stis_halpha_obs_apastron_norm.sav'
restore,'/Users/jgroh/temp/etc_hst_stis_cA20_0020_Weigelt_blobs_offset_5_to_10.sav'
RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod43groh.sav'
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod44groh.sav'
restore,'/Users/jgroh/temp/etc_hst_stis_cA20_0030_offset_minus58_227_to_237.sav'
restore,'/Users/jgroh/temp/etc_hst_stis_cA20_0030_offset_minus45_175_to_185.sav'
RESTORE,'/Users/jgroh/temp/etc_mod111_john_cut_v4_halpha_polar_spectrum_lm00_500_fn00_500.sav'

restore,'/Users/jgroh/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod43groh_post_peri_phi0d05h.sav'
;models around apastron
dirperi='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh/'
modelperi='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix001020='0_10_20'

;filename10='OBSFRAME2'
;filename20='OBSFRAME3'
sufixperi='post_peri_phi0d05h'
filename00peri='OBSFRAME1'
filename49peri='OBSFRAME2'
filename90peri='OBSFRAME3'
;filename00='OBSFRAME1'
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperi,filename00peri,lm00peri,fm00peri,fn00peri,inc00peri,inc_str00peri,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperi,filename90peri,lm90peri,fm90peri,fn90peri,inc90peri,inc_str90peri,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperi,filename49peri,lm49peri,fm49peri,fn49peri,inc49peri,inc_str49peri,/FLAM
;save,dirperi,modelperi,sufixperi,filename00peri,lm00peri,fm00peri,fn00peri,inc00peri,inc_str00peri,filename49peri,lm49peri,fm49peri,fn49peri,inc49peri,inc_str49peri,filename90peri,lm90peri,fm90peri,fn90peri,inc90peri,inc_str90peri,filename='/Users/jgroh/ze_etacar_cmfgen_model_obs_optical_full_var_inc_mod43groh_post_peri_phi0d05h.sav'
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/etacar/mod_111/etacar_john_mod111_full_n.txt',l500,f500n

filename_19mar98='/Users/jgroh/data/hst/stis/etacar_from_john/star_19mar98'
ZE_READ_STIS_DATA_FROM_JOHN,filename_19mar98,lambda_19mar98,flux_19mar98,mask_19mar98

LOADCT,0,/silent
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')


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
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+sufix00+'_lati_azi_wb.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
!p.multi=[0, 0, 0, 0, 0]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

LOADCT,13

nmodels=2
minc=30
maxc=255
colorm1=fsc_color('red')

lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
!P.Color = fsc_color('black')
plot,ZE_LAMBDA_TO_VEL(lm00,lambda0),fn00,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,80],ytickinterval=0,$
/nodata,xtitle='Velocity [km/s]', ytitle='Normalized Flux';,POSITION=[0.11,0.25,0.96,0.96]
;plots,ZE_LAMBDA_TO_VEL(lm00,lambda0),fn00,color=colorm1,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm10,lambda0),fn10,color=colorm1,linestyle=0,noclip=0

plots,ZE_LAMBDA_TO_VEL(lwb,lambda0),fwbn,color=color0,linestyle=0,noclip=0
;labels
;xyouts,2700,7500,extra_labelomega0,color=minc,orientation=0,/DEVICE
;xyouts,2700,7000,extra_labelomega90,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,6500,extra_labelomega180,color=minc+2*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;xyouts,2700,6000,extra_labelomega270,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
;!p.multi=[0, 0, 0, 0, 0]

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+sufix00+'_lati_azi_onstar.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
!p.multi=[0, 0, 0, 0, 0]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

LOADCT,13

nmodels=2
minc=30
maxc=255
colorm1=fsc_color('red')

lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
!P.Color = fsc_color('black')
plot,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,80],ytickinterval=0,$
/nodata,xtitle='Velocity [km/s]', ytitle='Normalized Flux';,POSITION=[0.11,0.25,0.96,0.96]
plots,ZE_LAMBDA_TO_VEL(lm49,lambda0),fn49,color=colorm1,linestyle=0,noclip=0
;plots,ZE_LAMBDA_TO_VEL(lm40,lambda0),fn40,color=colorm2,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0



device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+sufix00+'_lati_azi_SElobe_5d8.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
!p.multi=[0, 0, 0, 0, 0]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8

coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

LOADCT,13

nmodels=2
minc=30
maxc=255
colorm1=fsc_color('red')

lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
!P.Color = fsc_color('black')


plot,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,80],ytickinterval=0,$
/nodata,xtitle='Velocity [km/s]', ytitle='Normalized Flux';,POSITION=[0.11,0.25,0.96,0.96]
plots,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,color=colorm1,linestyle=0,noclip=0
;plots,ZE_LAMBDA_TO_VEL(l58,lambda0),f58shiftn,color=coloro,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(l58,lambda0),ZE_SHIFT_SPECTRA_VEL(l58,f58shiftn,50),color=coloro,linestyle=0,noclip=0 ;using the shift from the Mehner paper
;plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm00_500,lambda0),fn00_500,color=colorm2,linestyle=0,noclip=0


device,/close

!p.multi=[0, 2, 1, 0, 0]
device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+sufix00+'_lati_azi_WB_onstar_SElobe_5d8_apastron.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=5.48,/inches
!p.multi=[0, 2, 1, 0, 0]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8
;!Y.OMARGIN=[0,0]
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

LOADCT,13

nmodels=2
minc=30
maxc=255
colorm1=fsc_color('red')

lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
!P.Color = fsc_color('black')

plot,ZE_LAMBDA_TO_VEL(lwb,lambda0),fwbn,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=0,/ylog,xtickinterval=1000,$
/nodata,xtitle='Velocity [km/s]', ytitle='Normalized Flux',POSITION=[0.13,0.16,0.55,0.98]
plots,ZE_LAMBDA_TO_VEL(lwb,lambda0),fwbn,color=colorm1,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=coloro,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(l58,lambda0),ZE_SHIFT_SPECTRA_VEL(l58,f58shiftn,50),color=colorm2,linestyle=0,noclip=0 ;using the shift from the Mehner paper
xyouts,3300,12500,'a) obs',color=coloro,orientation=0,/DEVICE
xyouts,3300,4600,'equator',color=colorm1,orientation=0,/DEVICE
xyouts,3300,3800,TEXTOIDL('41^\circ'),color=coloro,orientation=0,/DEVICE
xyouts,3300,3000,'pole',color=colorm2,orientation=0,/DEVICE


plot,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=0,/ylog,xtickinterval=1000,$
/nodata,xtitle='Velocity [km/s]',POSITION=[0.55,0.16,0.97,0.98],YTICKFORMAT='(A2)'
plots,ZE_LAMBDA_TO_VEL(lm10,lambda0),fn10,color=colorm1,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm40,lambda0),fn40,color=coloro,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,color=colorm2,linestyle=0,noclip=0
xyouts,12300,12500,'b) models',color=coloro,orientation=0,/DEVICE
xyouts,12300,4600,'equator',color=colorm1,orientation=0,/DEVICE
xyouts,12300,3800,TEXTOIDL('41^\circ'),color=coloro,orientation=0,/DEVICE
xyouts,12300,3000,'pole',color=colorm2,orientation=0,/DEVICE


device,/close

!p.multi=[0, 2, 1, 0, 0]
device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+sufix00+'_lati_azi_WB_onstar_SElobe_5d8_periastron.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=5.48,/inches
!p.multi=[0, 2, 1, 0, 0]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=8
!X.THICK=6
!Y.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=1.5
!P.CHARTHICK=8
;!Y.OMARGIN=[0,0]
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

LOADCT,13

nmodels=2
minc=30
maxc=255
colorm1=fsc_color('red')

lambda0=6564.61
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
!P.Color = fsc_color('black')

plot,ZE_LAMBDA_TO_VEL(lwb,lambda0),fwbn,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=0,/ylog,xtickinterval=1000,$
/nodata,xtitle='Velocity [km/s]', ytitle='Normalized Flux',POSITION=[0.13,0.16,0.55,0.98]
plots,ZE_LAMBDA_TO_VEL(lwb,lambda0),fwbn,color=colorm1,linestyle=0,noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_17apr01,lambda0),flux_17apr01n,color=coloro,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_19mar98,lambda0),flux_19mar98/3e-12,color=coloro,linestyle=0,noclip=0 ;CRUDE estimate of spectrum on the central star, not publication quality
plots,ZE_LAMBDA_TO_VEL(l58,lambda0),ZE_SHIFT_SPECTRA_VEL(l58,f58shiftn,50),color=colorm2,linestyle=0,noclip=0 ;using the shift from the Mehner paper
xyouts,3300,12500,'a) obs',color=coloro,orientation=0,/DEVICE
xyouts,3300,4600,'equator',color=colorm1,orientation=0,/DEVICE
xyouts,3300,3800,TEXTOIDL('41^\circ'),color=coloro,orientation=0,/DEVICE
xyouts,3300,3000,'pole',color=colorm2,orientation=0,/DEVICE


plot,ZE_LAMBDA_TO_VEL(lm90,lambda0),fn90,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.05,99],ytickinterval=0,/ylog,xtickinterval=1000,$
/nodata,xtitle='Velocity [km/s]',POSITION=[0.55,0.16,0.97,0.98],YTICKFORMAT='(A2)'
plots,ZE_LAMBDA_TO_VEL(lm00peri,lambda0),fn00peri,color=colorm1,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm49peri,lambda0),fn49peri,color=coloro,linestyle=0,noclip=0
plots,ZE_LAMBDA_TO_VEL(lm90peri,lambda0),fn90peri,color=colorm2,linestyle=0,noclip=0
xyouts,12300,12500,'b) models',color=coloro,orientation=0,/DEVICE
xyouts,12300,4600,'equator',color=colorm1,orientation=0,/DEVICE
xyouts,12300,3800,TEXTOIDL('41^\circ'),color=coloro,orientation=0,/DEVICE
xyouts,12300,3000,'pole',color=colorm2,orientation=0,/DEVICE


device,/close


set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]
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
!P.Color = fsc_color('black')

END