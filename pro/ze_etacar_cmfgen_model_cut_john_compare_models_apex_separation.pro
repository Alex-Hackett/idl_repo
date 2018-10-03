;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_MODELS_APEX_SEPARATION
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'

dir='/Users/jgroh/ze_models/2D_models/etacar/mod_111_copy_groh_finer_rgrid/'
model1='cut_v4'   
sufix1='1'
extra_label1=TEXTOIDL(',1')
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir+model1+'/'+sufix1+'/',lm1,fm1,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model1,sufix1,filename1,inc1,inc_str1
line_norm,lm1,fm1,fm1n

model2='cut_v4'  
sufix2='2'
extra_label2=TEXTOIDL(',2')
filename2='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename2,dir+model2+'/'+sufix2+'/',lm2,fm2,nm2,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model2,sufix2,filename2,inc2,inc_str2
line_norm,lm2,fm2,fm2n

model3='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix3='3'
extra_label3=TEXTOIDL(',3')
filename3='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename3,dir+model3+'/'+sufix3+'/',lm3,fm3,nm3,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model3,sufix3,filename3,inc3,inc_str3
line_norm,lm3,fm3,fm3n

model4='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix4='4'
extra_label4=TEXTOIDL(',4')
filename4='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename4,dir+model4+'/'+sufix4+'/',lm4,fm4,nm4,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model4,sufix4,filename4,inc4,inc_str4
line_norm,lm4,fm4,fm4n

model5='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix5='4'
extra_label5=TEXTOIDL(',4')
filename5='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename5,dir+model5+'/'+sufix5+'/',lm5,fm5,nm5,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model5,sufix5,filename5,inc5,inc_str5
line_norm,lm5,fm5,fm5n

model6='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix6='4'
extra_label6=TEXTOIDL(',4')
filename6='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename6,dir+model6+'/'+sufix6+'/',lm6,fm6,nm6,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model6,sufix6,filename6,inc6,inc_str6
line_norm,lm6,fm6,fm6n



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

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_uv_apex_separation_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 3, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lo=0
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

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_emiss_apex_separation_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
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
x1l=6530
x1u=6590
s98mar=3.06e-12
plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.0,50],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lm1,fm1n,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm2,fm2n,color=colorm2,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm3,fm3n,color=colorm3,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm4,fm4n,color=colorm4,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm5,fm5n,color=colorm5,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm6,fm6n,color=colorm6,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2700,7500,extra_label1 ,charthick=3.5,color=colorm1,orientation=0,/DEVICE
xyouts,2700,7000,extra_label2 ,charthick=3.5,color=colorm2,orientation=0,/DEVICE
xyouts,2700,6500,extra_label3,charthick=3.5,color=colorm3,orientation=0,/DEVICE
xyouts,2700,6000,extra_label4,charthick=3.5,color=colorm4,orientation=0,/DEVICE
xyouts,2700,5500,extra_label5,charthick=3.5,color=colorm5,orientation=0,/DEVICE
xyouts,2700,5000,extra_label6,charthick=3.5,color=colorm6,orientation=0,/DEVICE
!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_abs_apex_separation_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
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
x1l=6530
x1u=6590
s98mar=3.06e-12
plot,lm1,fm1n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.0,10],xcharsize=2.0,ytickinterval=2,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lm1,fm1n,color=colorm1,linestyle=lo,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm2,fm2n,color=colorm2,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm3,fm3n,color=colorm3,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm4,fm4n,color=colorm4,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm5,fm5n,color=colorm5,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lm6,fm6n,color=colorm6,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2700,7500,extra_label1 ,charthick=3.5,color=colorm1,orientation=0,/DEVICE
xyouts,2700,7000,extra_label2 ,charthick=3.5,color=colorm2,orientation=0,/DEVICE
xyouts,2700,6500,extra_label3,charthick=3.5,color=colorm3,orientation=0,/DEVICE
xyouts,2700,6000,extra_label4,charthick=3.5,color=colorm4,orientation=0,/DEVICE
xyouts,2700,5500,extra_label5,charthick=3.5,color=colorm5,orientation=0,/DEVICE
xyouts,2700,5000,extra_label6,charthick=3.5,color=colorm6,orientation=0,/DEVICE

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