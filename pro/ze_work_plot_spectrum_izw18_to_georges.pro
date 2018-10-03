;PRO ZE_WORK_PLOT_SPECTRUM_IZW18_TO_GEORGES
;plotting sample spectrum of Izw18 to send to Georges for his talk
;2013 aug 23
lmin=900
lmax=30000
dir='/Users/jgroh/ze_models/ogrid_jcbouret_izw18/'
dirmod='T65p0g455M100p0L6p095Md10m7p34V2472H1p0He0p1Z0p01/'
ZE_CMFGEN_CREATE_OBSNORM,dir+dirmod+'obs/obs_fin',dir+dirmod+'obs/obs_cont',lnorm,fnorm,LMIN=lmin,LMAX=lmax
 

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,lnorm,fnorm,'Wavelength (Angstrom)','Normalized Flux','',xrange=[3770,6970],yrange=[0,1.4],$
                              POSITION=[0.15,0.15,0.96,0.96],/nolabel,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra, filename='to_georges',pthick=6

END