;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_PRODUCE_PLOTS
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'

;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/etacar/etacar_john_mod111_full_flam.txt',lmfull,fmfull
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/etacar/etacar_john_mod111_full_n.txt',lmfulln,fmfulln

RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'

dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'
model='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix='m13'
filename='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lm1,fm1,nm1,/FLAM
;line_norm,lm1,fm1,fm1n


;grep inclination angle info from OBS_INP
CASE filename of

'OBSFRAME1': BEGIN
spawn,'grep ANG1 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc_str=strcompress(string(90-result, format='(I02)'))
print,inc_str
END

'OBSFRAME2': BEGIN
spawn,'grep ANG2 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc_str=strcompress(string(90-result, format='(I02)'))
print,inc_str
END

'OBSFRAME3': BEGIN
spawn,'grep ANG3 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc_str=strcompress(string(90-result, format='(I02)'))
print,inc_str
END

ENDCASE

;filename_19mar98='/Users/jgroh/data/hst/stis/etacar_from_john/star_19mar98'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_19mar98,lambda_19mar98,flux_19mar98,mask_19mar98

;filename_21feb99='/Users/jgroh/data/hst/stis/etacar_from_john/star_21feb99'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_21feb99,lambda_21feb99,flux_21feb99,mask_21feb99

;filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01
;
;filename_04jul02='/Users/jgroh/data/hst/stis/etacar_from_john/star_04jul02'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02,lambda_04jul02,flux_04jul02,mask_04jul02
;
;filename_04jul02_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_04jul02_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02_e140m,lambda_04jul02_e140m,flux_04jul02_e140m,mask_04jul02_e140m

scale_halpha=5.71e-9/6.1e-12/0.89
scale_halpha_full=5.71e-9/6.1e-12/1.05
fm1scl=fm1/scale_halpha
;fm4scl=fm4/scale_halpha

fmfullscl=fmfull/scale_halpha_full

;scales the flux to 2.3 kpc (Eta Car)
dist=2.3
fm1d23=fm1/dist^2
;fmfulld23=fmfull/dist^2
;final redenning
minusebv=-0.40
a=3.1
fm_unred, lm1, fm1d23, minusebv, fm1d23r, R_V = a
;fm_unred,lmfull,fmfulld23,-1.0,fmfulld23r,R_V = 5.0


;set plot range
;x1l=925. & x1u=1055.
x1l=1270. & x1u=1390.
x2l=1385. & x2u=1500.
x3l=1500. & x3u=1702.
x4l=1750. & x4u=1952.
x5l=2500. & x5u=2820.
x6l=2850. & x6u=3120.

lambdafuse=lambda_04jul02_e140m
fluxfuse=flux_04jul02_e140m

scale=278.
scale_full=4.0
f1=fm1d23r/scale
;f2=fmfulld23r/scale_full

;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/output_etc_stis_uv_cmfgen_mod111_plus_cavity_'+model+'_'+sufix+'_'+filename+'_i'+inc_str+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 3, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
coloro=fsc_color('black')
colorm=fsc_color('red')

s=1.0e-12
plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0,0.5e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=a
plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[1270.0,0,x1u,1.9e-11/s],thick=b+1.5

;putting labels on the first panel
;plots, [930,934],[5.3e-13,5.3e-13],color=fsc_color('grey')
;xyouts,935,5.1e-13,'AG Car FUSE obs. 2001 May',alignment=0,orientation=0
;plots, [930,934],[4.5e-13,4.5e-13],color=coloro,linestyle=1
;xyouts,935,4.3e-13,'CMFGEN model no IS abs.',alignment=0,orientation=0
;plots, [930,934],[3.7e-13,3.7e-13],color=fsc_color('purple')
;xyouts,935,3.5e-13,'CMFGEN model + IS abs. (N!IH!N=10!E21!N cm!E-2!N, N!IH2!N=10!E21!N cm!E-2!N)',alignment=0,orientation=0


plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x2l-1,x2u+1],yrange=[0,0.5e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,$
thick=3.5,xthick=3.5,ythick=3.5,/nodata;,POSITION=[0.126,0.40,0.99,0.67]
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=a
plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=b+1.5


plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x3l-1,x3u+1],yrange=[0,0.6e-11/s],ytickinterval=5.,$
xtitle=TEXTOIDL('Wavelength [ '+Angstrom+' ]'),$
thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=a
plots,lm1,fm1d23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=b+1.5

;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x4l-1,x4u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x5l-1,x5u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b
;
;plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x6l-1,x6u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
;thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
;plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
;plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b

xyouts,1500,8200,model+'_'+sufix+'_'+filename+'_i'+inc_str ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/output_etc_stis_halpha_cmfgen_mod111_plus_cavity_'+model+'_'+sufix+'_'+filename+'_i'+inc_str+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
x1l=6530
x1u=6590
s98mar=3.06e-12
plot,lambda_04jul02,flux_04jul02/s,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],/ylog,yrange=[0.1,100],xcharsize=2.0,ytickinterval=20,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
;plots,lambda_04jul02,flux_04jul02/s,color=coloro,noclip=0,clip=[x1l,0,x1u,9.5e-11/s],thick=a
;plots,lambda_17apr01,flux_17apr01/s,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s],thick=a
plots,lambda_19mar98,flux_19mar98/s98mar,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=a
plots,lm1,fm1n,color=colorm,linestyle=lm,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
;plots,lm4,fm4scl/s,color=colorm,linestyle=lm,noclip=0,clip=[x1l,0,x1u,9.5e-11/s],thick=b+1.5
plots,lmfull,fmfulln,color=colorm2,linestyle=lm,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/output_etc_halpha_cmfgen_mod111_plus_cavity_'+model+'_'+sufix+'_'+filename+'_i'+inc_str+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
colorm=fsc_color('blue')
!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
x1l=6530
x1u=6590
s98mar=3.06e-12
plot,lambda_04jul02,flux_04jul02/s,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[-5,70],xcharsize=2.0,ytickinterval=20,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
;plots,lambda_04jul02,flux_04jul02/s,color=coloro,noclip=0,clip=[x1l,0,x1u,9.5e-11/s],thick=a
;plots,lambda_17apr01,flux_17apr01/s,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s],thick=a
;plots,lambda_19mar98,flux_19mar98/s98mar,color=coloro,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=a
plots,lm1,fm1n,color=colorm,linestyle=lm,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
;plots,lm4,fm4scl/s,color=colorm,linestyle=lm,noclip=0,clip=[x1l,0,x1u,9.5e-11/s],thick=b+1.5
plots,lmfull,fmfulln,color=colorm2,linestyle=lm,noclip=0,clip=[x1l,0,x1u,39.5e-11/s98mar],thick=b+1.5
xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

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