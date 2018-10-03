;PRO ZE_AMBER_PLOT_LBVs

dir_obs='/Users/jgroh/data/eso/amber/lbvs_p85/lbvs_amber_ascii/'
;file='SCIENCE_wray1796_AMBER.2010-06-27T03:08:54.832-AMBER.2010-06-27T03:14:37.961_K_AVG__DIV__CALIB_hd163197_AMBER.2010-06-27T03:30:44.719-AMBER.2010-06-27T03:54:06.935_K_AVG.fits.ascii'
;file_obs='SCIENCE_wray1796_AMBER.2010-08-25T01:26:29.573-AMBER.2010-08-25T01:32:40.582_K_AVG__DIV__CALIB_hd163197_AMBER.2010-08-25T01:54:21.699-AMBER.2010-08-25T02:00:05.132_K_AVG.fits.ascii'

file_obs='SCIENCE_hde316285_AMBER.2011-03-26T08:48:49.863-AMBER.2011-03-26T08:56:44.341_K_AVG__DIV__CALIB_hd156992_AMBER.2011-03-26T08:25:58.018-AMBER.2011-03-26T08:34:07.497_K_AVG.fits.ascii'
sufix=strmid(file_obs,8,9)
ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,dir_obs+file_obs,data,header

lobs=REFORM(data[0,*]*10000.)-24. ;for HD 316285
;lobs=REFORM(data[0,*]*10000.)-6.   ;for wray 1796
fobs=REFORM(data[19,*])
vsys=0
lambda0=21661.2

vis12_ut=REFORM(data[1,*])
vis23_ut=REFORM(data[3,*])
vis31_ut=REFORM(data[5,*])

;for wray 7196 only
;vis12_ut=vis12_ut/0.8

phase12_ut=REFORM(data[7,*])
phase23_ut=REFORM(data[9,*])
phase31_ut=REFORM(data[11,*])

cp_ut=REFORM(data[13,*])

vis12err_ut=REFORM(data[2,*])/(2.*vis12_ut)
vis23err_ut=REFORM(data[4,*])/(2.*vis23_ut)
vis31err_ut=REFORM(data[6,*])/(2.*vis31_ut)


phase12err_ut=REFORM(data[8,*])
phase23err_ut=REFORM(data[10,*])
phase31err_ut=REFORM(data[12,*])

cperr_ut=REFORM(data[14,*])

restore,'/Users/jgroh/hd316285_mod31_sph_allinterf.sav',/verbose
restore,'/Users/jgroh/hd316285_mod34_64_45_allinterf.sav',/verbose
lambda_vector=lambda_vector-24.

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
set_plot,'ps'
!P.THICK=8
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12

xmin=21560.
xmax=21780.

;xmin=min(lobs)
;xmax=max(lobs)

!P.FONT=-1
ticklen = 15.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
device,/close
device,filename='/Users/jgroh/temp/vis_wavelength'+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lobs,vis12_ut,yrange=[0,1.1],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.12, 0.95, 0.9],xrange=[xmin,xmax]
plots,lambda_vector,vis_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[1,*],noclip=0,color=FSC_COLOR('green'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=2
plots,lobs,vis31_ut,color=FSC_COLOR('blue'),noclip=0
plots,lobs,vis23_ut,color=FSC_COLOR('green'),noclip=0
plots,lobs,vis12_ut,color=FSC_COLOR('red'),noclip=0
oploterror,[21500,21500],[0.3,0.3],[mean(vis12err_ut),mean(vis12err_ut)],psym=symcat(16),color=fsc_color('red'),ERRCOLOR=fsc_color('red'),thick=6
oploterror,[21500,21500],[0.2,0.2],[mean(vis23err_ut),mean(vis23err_ut)],psym=symcat(16),color=fsc_color('green'),ERRCOLOR=fsc_color('green'),thick=6
oploterror,[21500,21500],[0.1,0.1],[mean(vis31err_ut[0:100]),mean(vis31err_ut[0:100])],psym=symcat(16),color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=6
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0)-vsys,ZE_LAMBDA_TO_VEL(xmax,lambda0)-vsys]

device,/close

device,filename='/Users/jgroh/temp/spec_wavelength'+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lobs,fobs,yrange=[0,5.0],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='F/Fc',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.12, 0.95, 0.9],xrange=[xmin,xmax]
plots,lobs,fobs/0.87,color=FSC_COLOR('black'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0)-vsys,ZE_LAMBDA_TO_VEL(xmax,lambda0)-vsys]

device,/close

device,filename='/Users/jgroh/temp/phase_wavelength'+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lobs,phase12_ut,yrange=[-40,40],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Differential phase [deg]',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.12, 0.95, 0.90],xrange=[xmin,xmax]
plots, lambda_vector,phase_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red')
plots, lambda_vector,phase_triplet_wavelength_cnvl[1,*],noclip=0,color=FSC_COLOR('green')
plots, lambda_vector,phase_triplet_wavelength_cnvl[2,*],noclip=0,color=FSC_COLOR('blue')
plots,lobs,phase31_ut,color=FSC_COLOR('blue'),noclip=0,linestyle=2
plots,lobs,phase23_ut,color=FSC_COLOR('green'),noclip=0
plots,lobs,phase12_ut,color=FSC_COLOR('red'),noclip=0
oploterror,[21570,21570],[-15.,-15],[mean(phase12err_ut),mean(phase12err_ut)],psym=symcat(16),color=fsc_color('red'),ERRCOLOR=fsc_color('red'),thick=6
oploterror,[21570,21570],[-25,-25.],[mean(phase23err_ut),mean(phase23err_ut)],psym=symcat(16),color=fsc_color('green'),ERRCOLOR=fsc_color('green'),thick=6
oploterror,[21570,21570],[-35,-35],[mean(phase31err_ut),mean(phase31err_ut)],psym=symcat(16),color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=6
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0)-vsys,ZE_LAMBDA_TO_VEL(xmax,lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/cp_wavelength'+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lobs,cp_ut,yrange=[-50,50],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Closure phase [deg]',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.12, 0.95, 0.90],xrange=[xmin,xmax]
plots,lobs,cp_ut,color=FSC_COLOR('black'),noclip=0
plots,lambda_vector,cp_triplet_wavelength_cnvl_sys,color=FSC_COLOR('red'),noclip=0
oploterror,[21500,21500],[-25,-25],[mean(cperr_ut),mean(cperr_ut)],psym=symcat(16),color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=6
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0)-vsys,ZE_LAMBDA_TO_VEL(xmax,lambda0)-vsys]

device,/close

device,filename='/Users/jgroh/temp/phase_wavelength_offsetclarity'+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lobs,phase12_ut,yrange=[-40,40],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Differential phase [deg]',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.12, 0.95, 0.90],xrange=[xmin,xmax]
plots, lambda_vector,phase_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red')
plots, lambda_vector,phase_triplet_wavelength_cnvl[1,*]+10.0,noclip=0,color=FSC_COLOR('green')
plots, lambda_vector,phase_triplet_wavelength_cnvl[2,*]+20.0,noclip=0,color=FSC_COLOR('blue')
plots,lobs,phase31_ut+20.0,color=FSC_COLOR('blue'),noclip=0,linestyle=0
plots,lobs,phase23_ut+10.0,color=FSC_COLOR('green'),noclip=0
plots,lobs,phase12_ut,color=FSC_COLOR('red'),noclip=0
oploterror,[21570,21570],[-15.,-15],[mean(phase12err_ut),mean(phase12err_ut)],psym=symcat(16),color=fsc_color('red'),ERRCOLOR=fsc_color('red'),thick=6
oploterror,[21570,21570],[-25,-25.],[mean(phase23err_ut),mean(phase23err_ut)],psym=symcat(16),color=fsc_color('green'),ERRCOLOR=fsc_color('green'),thick=6
oploterror,[21570,21570],[-35,-35],[mean(phase31err_ut),mean(phase31err_ut)],psym=symcat(16),color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=6
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0)-vsys,ZE_LAMBDA_TO_VEL(xmax,lambda0)-vsys]
device,/close

!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0

set_plot,'x'
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')




END