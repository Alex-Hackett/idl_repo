;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_MODELS_INCLINATION_WALL
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'

dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'

restore,'/Users/jgroh/temp/etc_stis_halpha_obs_apastron_norm.sav'

;restore,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_alpha.sav'
;restore,'/Users/jgroh/espectros/etacar/etc_stis_20mar00_onstar_groh.sav' ;xray phase 0.403
;restore,'/Users/jgroh/espectros/etacar/etc_stis_09oct00_onstar_groh.sav' ;xray phase 0.507 
;;observations
;filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01
;
;;normalize observations?
;line_norm,lambda_20mar00,flux_20mar00,flux_20mar00n,norm20mar00,xnodes20mar00,ynodes20mar00
;line_norm,lambda_09oct00,flux_09oct00,flux_09oct00n,norm09oct00,xnodes09oct00,ynodes09oct00
;line_norm,lambda_17apr01,flux_17apr01,flux_17apr01n,norm17apr01,xnodes17apr01,ynodes17apr01

;model00='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix00='i00'
;filename00='OBSFRAME1'
;extra_label00=TEXTOIDL(',i=00^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model00,sufix00,filename00,lm00,fm00,fn00,inc00,inc_str00,/FLAM
;
;model30='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix30='i30'
;filename30='OBSFRAME1'
;extra_label30=TEXTOIDL(',i=30^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model30,sufix30,filename30,lm30,fm30,fn30,inc30,inc_str30,/FLAM
;
;model36='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix36='i36'
;filename36='OBSFRAME1'
;extra_label36=TEXTOIDL(',i=36^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model36,sufix36,filename36,lm36,fm36,fn36,inc36,inc_str36,/FLAM
;
;model41='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix41='i41'
;filename41='OBSFRAME1'
;extra_label41=TEXTOIDL(',i=41^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model41,sufix41,filename41,lm41,fm41,fn41,inc41,inc_str41,/FLAM
;
;model50='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix50='i50'
;filename50='OBSFRAME1'
;extra_label50=TEXTOIDL(',i=50^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model50,sufix50,filename50,lm50,fm50,fn50,inc50,inc_str50,/FLAM
;
;model60='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix60='i60'
;filename60='OBSFRAME1'
;extra_label60=TEXTOIDL(',i=60^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model60,sufix60,filename60,lm60,fm60,fn60,inc60,inc_str60,/FLAM
;
;model75='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix75='i75'
;filename75='OBSFRAME1'
;extra_label75=TEXTOIDL(',i=75^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model75,sufix75,filename75,lm75,fm75,fn75,inc75,inc_str75,/FLAM
;
;model90='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix90='i90'
;filename90='OBSFRAME1'
;extra_label90=TEXTOIDL(',i=90^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model90,sufix90,filename90,lm90,fm90,fn90,inc90,inc_str90,/FLAM
;


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


device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_uv_'+model00+'_wall.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 3, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lo=0

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



;xyouts,1500,8200,model00+'_'+sufix00+'_'+filename00+'_i'+inc_str00 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_emiss_'+model00+'_wall.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model

x1l=6530
x1u=6590
s98mar=3.06e-12

x1l=6528
x1u=6592
s98mar=3.06e-12
plot,lm00,fn00,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,50],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lambda_17apr01,flux_17apr01n,color=coloro,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm00,fn00,color=colorm1,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm30,fn30,color=colorm2,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm36,fn36,color=colorm3,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm41,fn41,color=colorm4,linestyle=3,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm50,fn50,color=colorm5,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm60,fn60,color=colorm6,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm75,fn75,color=colorm7,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm90,fn90,color=colorm8,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model00+'_'+sufix00+'_'+filename00+'_i'+inc_str00+extra_label00,charthick=3.5,color=colorm1,orientation=0,/DEVICE
;xyouts,2700,7000,model30+'_'+sufix30+'_'+filename30+'_i'+inc_str30+extra_label30,charthick=3.5,color=colorm2,orientation=0,/DEVICE
;xyouts,2700,6500,model36+'_'+sufix36+'_'+filename36+'_i'+inc_str36+extra_label36,charthick=3.5,color=colorm3,orientation=0,/DEVICE
;xyouts,2700,6000,model41+'_'+sufix41+'_'+filename41+'_i'+inc_str41+extra_label41,charthick=3.5,color=colorm4,orientation=0,/DEVICE
;xyouts,2700,5500,model30+'_'+sufix50+'_'+filename50+'_i'+inc_str50+extra_label50,charthick=3.5,color=colorm5,orientation=0,/DEVICE
;xyouts,2700,5000,model30+'_'+sufix60+'_'+filename60+'_i'+inc_str60+extra_label60,charthick=3.5,color=colorm6,orientation=0,/DEVICE
;xyouts,2700,4500,model30+'_'+sufix75+'_'+filename75+'_i'+inc_str75+extra_label75,charthick=3.5,color=colorm7,orientation=0,/DEVICE
;xyouts,2700,4000,model30+'_'+sufix90+'_'+filename90+'_i'+inc_str90+extra_label90,charthick=3.5,color=colorm8,orientation=0,/DEVICE

;optmized labels
xyouts,2700,7500,model00+extra_label00,charthick=3.5,color=colorm1,orientation=0,/DEVICE
xyouts,2700,7000,model30+extra_label30,charthick=3.5,color=colorm2,orientation=0,/DEVICE
xyouts,2700,6500,model36+extra_label36,charthick=3.5,color=colorm3,orientation=0,/DEVICE
xyouts,2700,6000,model41+extra_label41,charthick=3.5,color=colorm4,orientation=0,/DEVICE
xyouts,2700,5500,model30+extra_label50,charthick=3.5,color=colorm5,orientation=0,/DEVICE
xyouts,2700,5000,model30+extra_label60,charthick=3.5,color=colorm6,orientation=0,/DEVICE
xyouts,2700,4500,model30+extra_label75,charthick=3.5,color=colorm7,orientation=0,/DEVICE
xyouts,2700,4000,model30+extra_label90,charthick=3.5,color=colorm8,orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_abs_'+model00+'_wall.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
x1l=6528
x1u=6592
s98mar=3.06e-12
plot,lm00,fn00,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,10],xcharsize=2.0,ytickinterval=2,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lambda_17apr01,flux_17apr01n,color=coloro,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm00,fn00,color=colorm1,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm30,fn30,color=colorm2,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm36,fn36,color=colorm3,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm41,fn41,color=colorm4,linestyle=3,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm50,fn50,color=colorm5,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm60,fn60,color=colorm6,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm75,fn75,color=colorm7,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm90,fn90,color=colorm8,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model00+'_'+sufix00+'_'+filename00+'_i'+inc_str00+extra_label00,charthick=3.5,color=colorm1,orientation=0,/DEVICE
;xyouts,2700,7000,model30+'_'+sufix30+'_'+filename30+'_i'+inc_str30+extra_label30,charthick=3.5,color=colorm2,orientation=0,/DEVICE
;xyouts,2700,6500,model36+'_'+sufix36+'_'+filename36+'_i'+inc_str36+extra_label36,charthick=3.5,color=colorm3,orientation=0,/DEVICE
;xyouts,2700,6000,model41+'_'+sufix41+'_'+filename41+'_i'+inc_str41+extra_label41,charthick=3.5,color=colorm4,orientation=0,/DEVICE
;xyouts,2700,5500,model30+'_'+sufix50+'_'+filename50+'_i'+inc_str50+extra_label50,charthick=3.5,color=colorm5,orientation=0,/DEVICE
;xyouts,2700,5000,model30+'_'+sufix60+'_'+filename60+'_i'+inc_str60+extra_label60,charthick=3.5,color=colorm6,orientation=0,/DEVICE
;xyouts,2700,4500,model30+'_'+sufix75+'_'+filename75+'_i'+inc_str75+extra_label75,charthick=3.5,color=colorm7,orientation=0,/DEVICE
;xyouts,2700,4000,model30+'_'+sufix90+'_'+filename90+'_i'+inc_str90+extra_label90,charthick=3.5,color=colorm8,orientation=0,/DEVICE

;optmized labels
xyouts,2700,7500,model00+extra_label00,charthick=3.5,color=colorm1,orientation=0,/DEVICE
xyouts,2700,7000,model30+extra_label30,charthick=3.5,color=colorm2,orientation=0,/DEVICE
xyouts,2700,6500,model36+extra_label36,charthick=3.5,color=colorm3,orientation=0,/DEVICE
xyouts,2700,6000,model41+extra_label41,charthick=3.5,color=colorm4,orientation=0,/DEVICE
xyouts,2700,5500,model30+extra_label50,charthick=3.5,color=colorm5,orientation=0,/DEVICE
xyouts,2700,5000,model30+extra_label60,charthick=3.5,color=colorm6,orientation=0,/DEVICE
xyouts,2700,4500,model30+extra_label75,charthick=3.5,color=colorm7,orientation=0,/DEVICE
xyouts,2700,4000,model30+extra_label90,charthick=3.5,color=colorm8,orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_stis_compare_halpha_obs_apastron.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
x1l=6528
x1u=6592
ymax=20.
s98mar=3.06e-12
plot,lm00,fn00,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,ymax],xcharsize=2.0,ytickinterval=5,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lambda_20mar00,flux_20mar00n,color=colormo,linestyle=0,noclip=0,clip=[x1l,0,x1u,ymax],thick=b+1.5
plots,lambda_09oct00,flux_09oct00n,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,ymax],thick=b+1.5
plots,lambda_17apr01,flux_17apr01n,color=colorm2,linestyle=0,noclip=0,clip=[x1l,0,x1u,ymax],thick=b+1.5

xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model00+'_'+sufix00+'_'+filename00+'_i'+inc_str00+extra_label00,charthick=3.5,color=colorm1,orientation=0,/DEVICE
;xyouts,2700,7000,model30+'_'+sufix30+'_'+filename30+'_i'+inc_str30+extra_label30,charthick=3.5,color=colorm2,orientation=0,/DEVICE
;xyouts,2700,6500,model36+'_'+sufix36+'_'+filename36+'_i'+inc_str36+extra_label36,charthick=3.5,color=colorm3,orientation=0,/DEVICE
;xyouts,2700,6000,model41+'_'+sufix41+'_'+filename41+'_i'+inc_str41+extra_label41,charthick=3.5,color=colorm4,orientation=0,/DEVICE
;xyouts,2700,5500,model30+'_'+sufix50+'_'+filename50+'_i'+inc_str50+extra_label50,charthick=3.5,color=colorm5,orientation=0,/DEVICE
;xyouts,2700,5000,model30+'_'+sufix60+'_'+filename60+'_i'+inc_str60+extra_label60,charthick=3.5,color=colorm6,orientation=0,/DEVICE
;xyouts,2700,4500,model30+'_'+sufix75+'_'+filename75+'_i'+inc_str75+extra_label75,charthick=3.5,color=colorm7,orientation=0,/DEVICE
;xyouts,2700,4000,model30+'_'+sufix90+'_'+filename90+'_i'+inc_str90+extra_label90,charthick=3.5,color=colorm8,orientation=0,/DEVICE

;optmized labels
xyouts,2900,7500,TEXTOIDL('\phi=10.403'),charthick=3.5,color=coloro,orientation=0,/DEVICE,charsize=2.0
xyouts,2900,6700,TEXTOIDL('\phi=10.507'),charthick=3.5,color=colorm1,orientation=0,/DEVICE,charsize=2.0
xyouts,2900,5900,TEXTOIDL('\phi=10.601'),charthick=3.5,color=colorm2,orientation=0,/DEVICE,charsize=2.0


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
!P.Color = fsc_color('black')
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_var_alpha.sav'
END