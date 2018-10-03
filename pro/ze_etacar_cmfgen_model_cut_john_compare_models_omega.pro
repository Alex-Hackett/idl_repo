;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_MODELS_OMEGA
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'

dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'

model30='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
sufix30='i30'
filename30='OBSFRAME1'
extra_label0=TEXTOIDL('\omega=0^\circ')
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model30,sufix30,filename30,lm0,fm0,fm0n,inc0,inc_str0,/FLAM

model00='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
sufix00='i00'
filename00='OBSFRAME1'
extra_label90=TEXTOIDL('\omega=90^\circ')
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model00,sufix00,filename00,lm90,fm90,fm90n,inc90,inc_str90,/FLAM

model30='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
sufix30='i30'
filename30='OBSFRAME1'
extra_label180=TEXTOIDL('\omega=180^\circ')
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model30,sufix30,filename30,lm180,fm180,fm180n,inc180,inc_str180,/FLAM

model41='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
sufix41='i41'
filename41='OBSFRAME1'
extra_label270=TEXTOIDL('\omega=270^\circ')
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model41,sufix41,filename41,lm270,fm270,fm270n,inc270,inc_str270,/FLAM


;model36='cut_v4_var_inc'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix36='i36'
;filename36='OBSFRAME1'
;extra_label36=TEXTOIDL(',i=36^\circ')
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model36,sufix36,filename36,lm36,fm36,fn36,inc36,inc_str36,/FLAM

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

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_uv_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

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



;xyouts,1500,8200,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close
a=8.48
b=3.48


device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_emiss_omega.eps',/encapsulated,/color,bit=8,xsize=a,ysize=b,/inches
colorm=fsc_color('blue')

!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=6
!P.CHARSIZE=1.0
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')



ticklen = 0.15
yticklen = ticklen/a
xticklen = ticklen/b

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
plot,lm0,fm0n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.0,50],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,xticklen=xticklen,yticklen=yticklen,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,lm0,fm0n,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm90,fm90n,color=colorm2,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm180,fm180n,color=colorm3,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
plots,lm270,fm270n,color=colorm4,linestyle=0,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5

xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2700,7500,extra_label0 ,charthick=3.5,color=colorm1,orientation=0,/DEVICE
xyouts,2700,7000,extra_label90 ,charthick=3.5,color=colorm2,orientation=0,/DEVICE
xyouts,2700,6500,extra_label180,charthick=3.5,color=colorm3,orientation=0,/DEVICE
xyouts,2700,6000,extra_label270,charthick=3.5,color=colorm4,orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_halpha_abs_omega.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
cs=1.6
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

lambda0=6562.8
x1l=ZE_LAMBDA_TO_VEL(6530.,lambda0)
x1u=ZE_LAMBDA_TO_VEL(6590.,lambda0)
s98mar=3.06e-12
plot,lm0,fm0n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[-0.5,10],xcharsize=2.0,ytickinterval=2,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,xticklen=xticklen,yticklen=yticklen,$
/nodata,POSITION=[0.11,0.25,0.96,0.96]
plots,ZE_LAMBDA_TO_VEL(lm0,lambda0),fm0n,color=colorm1,linestyle=lo,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lm90,lambda0),fm90n,color=colorm2,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lm180,lambda0),fm180n,color=colorm3,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,ZE_LAMBDA_TO_VEL(lm270,lambda0),fm270n,color=colorm4,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
xyouts,2900,7500,extra_label0 ,charthick=3.5,color=colorm1,orientation=0,/DEVICE,charsize=cs
xyouts,2900,7000,extra_label90 ,charthick=3.5,color=colorm2,orientation=0,/DEVICE,charsize=cs
xyouts,2900,6500,extra_label180,charthick=3.5,color=colorm3,orientation=0,/DEVICE,charsize=cs
xyouts,2900,6000,extra_label270,charthick=3.5,color=colorm4,orientation=0,/DEVICE,charsize=cs



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