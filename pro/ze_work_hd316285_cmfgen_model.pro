;PRO ZE_WORK_HD316285_CMFGEN_MODEL
;compares observations of HD 316285 with CMFGEN models

!P.Background = fsc_color('white')
set_plot, 'x'

restore,'/Users/jgroh/espectros/HD316285/hd316285_2011may22_45_nosat.sav'
l45=lambda_fin
f45narray=spectrum_array_norm

restore,'/Users/jgroh/espectros/HD316285/hd316285_2011may22_66_nosat.sav'
l66=lambda_fin
f66narray=spectrum_array_norm

dir_obs='/Users/jgroh/data/eso/amber/lbvs_p85/lbvs_amber_ascii/'
file_obs='SCIENCE_hde316285_AMBER.2011-03-26T08:48:49.863-AMBER.2011-03-26T08:56:44.341_K_AVG__DIV__CALIB_hd156992_AMBER.2011-03-26T08:25:58.018-AMBER.2011-03-26T08:34:07.497_K_AVG.fits.ascii'
ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,dir_obs+file_obs,obsdata,header
lobs=REFORM(obsdata[0,*]*10000.)
fobs=REFORM(obsdata[19,*])

dir316mod='/Users/jgroh/ze_models/HD316285/'


;ZE_CMFGEN_CREATE_OBSNORM,dir316mod+'M1'+'/obs/obs_fin',dir316mod+'M1'+'/obs/obs_cont',l1,f1,/AIR ;model M1
;f1(where(f1 lt 0 or f1 gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,dir316mod+'M4'+'/obs/obs_fin',dir316mod+'M4'+'/obs/obs_cont',l4,f4,/AIR ;model M4
;f4(where(f4 lt 0 or f4 gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod7_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod7_groh/obscont/obs_fin',l7e,f7e,/AIR ;model M1
;f7e(where(f7e lt 0 or f7e gt 90))=0.

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod106_john/obs_groh/obs_fin','/Users/jgroh/ze_models/etacar/mod106_john/obs/obs_cont',l106e,f106e,/AIR ;model M1
f106e(where(f106e lt 0 or f106e gt 90))=0.
;
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod25_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod25_groh/obscont/obs_fin',l25e,f25e,/AIR ;model M1
;f25e(where(f25e lt 0 or f25e gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod23_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod25_groh/obscont/obs_fin',l23e,f23e,/AIR ;model M1
;f23e(where(f23e lt 0 or f23e gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod26_groh/obs_opt/obs_fin','/Users/jgroh/ze_models/etacar/mod26_groh/obscont/obs_fin',l26e,f26e,/AIR ;model M1
;f26e(where(f26e lt 0 or f26e gt 90))=0.

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod31_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod31_groh/obscont/obs_fin',l31e,f31e,/AIR ;model M1
;f31e(where(f31e lt 0 or f31e gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod33_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod33_groh/obscont/obs_fin',l33e,f33e,/AIR ;model M1
;f33e(where(f33e lt 0 or f33e gt 90))=0.
;
;
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod34_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod34_groh/obscont/obs_fin',l34e,f34e,/AIR ;model M1
f34e(where(f34e lt 0 or f34e gt 90))=0.
;
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod35_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod35_groh/obscont/obs_fin',l35e,f35e,/AIR ;model M1
f35e(where(f35e lt 0 or f35e gt 90))=0.

;lineplot,l45,f45narray[*,0]
;lineplot,l66,f66narray[*,0]
;;lineplot,l1,f1
;;lineplot,l4,f4
;;lineplot,l23e,f23e
;;lineplot,l25e,f25e
;;lineplot,l26e,f26e
;lineplot,lobs,fobs
;;lineplot,l7e,f7e
;;lineplot,l106e,f106e
;;lineplot,l31e,f31e
;;lineplot,l33e,f33e
;lineplot,l34e,f34e
;lineplot,l35e,f35e

set_plot,'ps'
xwindowsize=800.
ywindowsize=400.
device,filename='/Users/jgroh/temp/spec_wavelength.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches

!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=2.5
!Y.CHARSIZE=2.5
!P.CHARSIZE=0
!P.CHARTHICK=8
!P.THICk=12
!P.FONT=-1
ticklen = 15.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot,l35e,f35e,xrange=[3500,23000],yrange=[-3,59.0],XTITLE='Wavelength (Angstrom)', YTITLE='Normalized Flux',$
/nodata,XTICKFORMAT='(I6)',xstyle=1,ystyle=1,Position=[0.08, 0.11, 0.95, 0.96]
plots,l35e,f35e,color=FSC_COLOR('red'),noclip=0,linestyle=2

device,/close

device,filename='/Users/jgroh/temp/obs_wavelength.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,l45,f45narray[*,0],xrange=[4000,4900],yrange=[-0.2,10],XTITLE='Wavelength (Angstrom)', YTITLE='Normalized Flux',$
/nodata,XTICKFORMAT='(I6)',xstyle=1,ystyle=1,Position=[0.08, 0.11, 0.95, 0.96]
plots,l45,f45narray[*,0],color=FSC_COLOR('black'),noclip=0,linestyle=0
plots,l34e,f34e,color=FSC_COLOR('red'),noclip=0,linestyle=2

device,/close

set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
!P.THICk=0

END