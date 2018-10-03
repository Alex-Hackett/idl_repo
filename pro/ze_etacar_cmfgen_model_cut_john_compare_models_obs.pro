;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_MODELS_OBS
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'
RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'
dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'
model1='cut_v4'   
sufix1='m15'
extra_label1=TEXTOIDL(',\alpha=36^\circ')
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir+model1+'/'+sufix1+'/',lm1,fm1,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model1,sufix1,filename1,inc1,inc_str1
line_norm,lm1,fm1,fm1n


model2='cut_v4'  
sufix2='m13'
extra_label2=TEXTOIDL(',\alpha=54^\circ')
filename2='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename2,dir+model2+'/'+sufix2+'/',lm2,fm2,nm2,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model2,sufix2,filename2,inc2,inc_str2
line_norm,lm2,fm2,fm2n

model3='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix3='m18'
extra_label3=TEXTOIDL(',\alpha=72^\circ')
filename3='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename3,dir+model3+'/'+sufix3+'/',lm3,fm3,nm3,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model3,sufix3,filename3,inc3,inc_str3
line_norm,lm3,fm3,fm3n


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



device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_obs_halpha_emiss_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('orange')
x1l=6530
x1u=6590
s98mar=3.06e-12
s99feb=5.38e-12
plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.0,50],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lambda_19mar98,flux_19mar98/s98mar,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=a
plots,lambda_21feb99,flux_21feb99/s99feb,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=a
plots,lm1,fm1n,color=colorm,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm2,fm2n,color=colorm2,linestyle=2,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm3,fm3n,color=colorm3,linestyle=3,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2700,7500,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+extra_label1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,2700,7000,model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+extra_label2 ,charthick=3.5,color=fsc_color('blue'),orientation=0,/DEVICE
xyouts,2700,6500,model3+'_'+sufix3+'_'+filename3+'_i'+inc_str3+extra_label3 ,charthick=3.5,color=fsc_color('orange'),orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_obs_halpha_abs_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('orange')
x1l=6530
x1u=6590
s98mar=3.06e-12
plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.0,10],xcharsize=2.0,ytickinterval=2,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lambda_19mar98,flux_19mar98/s98mar,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=a
plots,lm1,fm1n,color=colorm,linestyle=lo,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm2,fm2n,color=colorm2,linestyle=2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm3,fm3n,color=colorm3,linestyle=3,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2700,7500,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+extra_label1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,2700,7000,model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+extra_label2 ,charthick=3.5,color=fsc_color('blue'),orientation=0,/DEVICE
xyouts,2700,6500,model3+'_'+sufix3+'_'+filename3+'_i'+inc_str3+extra_label3 ,charthick=3.5,color=fsc_color('orange'),orientation=0,/DEVICE

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
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'
END