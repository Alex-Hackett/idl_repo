;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_MOD43_GROH_COMPARE_MODELS_OPENING_ANGLE_ALPHA
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')

RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_alpha_mod43groh.sav'

filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01

;normalize observations?
line_norm,lambda_17apr01,flux_17apr01,flux_17apr01n,norm17apr01,xnodes17apr01,ynodes17apr01

;flux scale observations?
scl_17apr01=1.0
flux_17apr01n=1d0+((flux_17apr01n-1d0)*scl_17apr01)

;apply radial velocity shift?
;velshift=100.
;flux_17apr01ns=ZE_SHIFT_SPECTRA_VEL(lambda_17apr01,flux_17apr01n,velshift)
;flux_17apr01n=flux_17apr01ns

dir='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh/cut_v4_vstream/'
model1='alpha'  
sufix1='36'
extra_label1=TEXTOIDL('\alpha=36^\circ')
filename1='OBSFRAME2'
ZE_CMFGEN_READ_OBS_2D,filename1,dir+model1+'/'+sufix1+'/',lm1,fm1,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model1,sufix1,filename1,inc1,inc_str1
line_norm,lm1,fm1,fm1n,normfm1,xnodesfm1,ynodesfm1


model2='alpha'  
sufix2='54'
extra_label2=TEXTOIDL('\alpha=54^\circ')
filename2='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename2,dir+model2+'/'+sufix2+'/',lm2,fm2,nm2,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model2,sufix2,filename2,inc2,inc_str2
line_norm,lm2,fm2,fm2n,normfm2,xnodesfm2,ynodesfm2

model4='alpha'  
sufix4='66halpha'
extra_label4=TEXTOIDL('\alpha=54^\circ')
filename4='OBSFRAME2'
ZE_CMFGEN_READ_OBS_2D,filename4,dir+model4+'/'+sufix4+'/',lm4,fm4,nm4,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model4,sufix4,filename4,inc4,inc_str4
line_norm,lm4,fm4,fm4n,normfm4,xnodesfm4,ynodesfm4

model3='alpha'  
sufix3='72'
extra_label3=TEXTOIDL('\alpha=72^\circ')
filename3='OBSFRAME2'
ZE_CMFGEN_READ_OBS_2D,filename3,dir+model3+'/'+sufix3+'/',lm3,fm3,nm3,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model3,sufix3,filename3,inc3,inc_str3
line_norm,lm3,fm3,fm3n,normfm3,xnodesfm3,ynodesfm3

;dir='/Users/jgroh/ze_models/2D_models/etacar/mod_111_copy_groh_finer_rgrid/'
;model3='cut_v4'   
;sufix3='1'
;extra_label3=TEXTOIDL('cut_v4 1')
;filename3='OBSFRAME1'
;ZE_CMFGEN_READ_OBS_2D,filename3,dir+model3+'/'+sufix3+'/',lm3,fm3,nm3,/FLAM
;ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model3,sufix3,filename3,inc3,inc_str3
;line_norm,lm3,fm3,fm3n,normfm3,xnodesfm3,ynodesfm3

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

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_uv_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 3, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lo=0
coloro=fsc_color('black')
colorm=fsc_color('red')

s=1.0e-12
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0,0.5e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
;/nodata;,POSITION=[0.11,0.72,0.99,0.99]
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=a
;plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[1270.0,0,x1u,1.9e-11/s],thick=b+1.5
;
;;putting labels on the first panel
;;plots, [930,934],[5.3e-13,5.3e-13],color=fsc_color('grey')
;;xyouts,935,5.1e-13,'AG Car FUSE obs. 2001 May',alignment=0,orientation=0
;;plots, [930,934],[4.5e-13,4.5e-13],color=coloro,linestyle=1
;;xyouts,935,4.3e-13,'CMFGEN model no IS abs.',alignment=0,orientation=0
;;plots, [930,934],[3.7e-13,3.7e-13],color=fsc_color('purple')
;;xyouts,935,3.5e-13,'CMFGEN model + IS abs. (N!IH!N=10!E21!N cm!E-2!N, N!IH2!N=10!E21!N cm!E-2!N)',alignment=0,orientation=0
;
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x2l-1,x2u+1],yrange=[0,0.5e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,$
;thick=3.5,xthick=3.5,ythick=3.5,/nodata;,POSITION=[0.126,0.40,0.99,0.67]
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=a
;plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=b+1.5
;
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x3l-1,x3u+1],yrange=[0,0.6e-11/s],ytickinterval=5.,$
;xtitle=TEXTOIDL('Wavelength [ '+Angstrom+' ]'),$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=a
;plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=b+1.5



xyouts,1500,8200,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_emiss_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
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

plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,78],ytickinterval=0,$
/nodata,POSITION=[0.11,0.25,0.96,0.96],xtitle='Wavelength [Angstrom]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lm1,fm1n,color=minc,linestyle=0,noclip=0
plots,lm2,fm2n,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm4,fm4n,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm3,fm3n,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

;labels
xyouts,2700,7500,extra_label1,color=minc,orientation=0,/DEVICE
xyouts,2700,7000,extra_label2,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6500,extra_label3,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE


!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod43groh_plus_cavity_compare_models_halpha_abs_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

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

plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,10],ytickinterval=2,$
/nodata,POSITION=[0.11,0.25,0.96,0.96],xtitle='Wavelength [Angstrom]', ytitle='Normalized Flux'
plots,lambda_17apr01,flux_17apr01n,color=color0,linestyle=0,noclip=0
plots,lm1,fm1n,color=minc,linestyle=0,noclip=0
plots,lm2,fm2n,color=minc+((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm4,fm4n,color=minc+2*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0
plots,lm3,fm3n,color=minc+3*((maxc-minc)/(nmodels-1)),linestyle=0,noclip=0

;labels
xyouts,2700,7500,extra_label1,color=minc,orientation=0,/DEVICE
xyouts,2700,7000,extra_label2,color=minc+((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE
xyouts,2700,6500,extra_label3,color=minc+3*((maxc-minc)/(nmodels-1)),orientation=0,/DEVICE

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