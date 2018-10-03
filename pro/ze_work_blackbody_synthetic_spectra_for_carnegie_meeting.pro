;PRO ZE_WORK_BLACKBODY_SYNTHETIC_SPECTRA_FOR_CARNEGIE_MEETING

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_jcbouret_izw18/T47p5g400M76p80L5p984Md10m7p14V1647H1p0He0p1Z0p01/obs/obs_fin','/Users/jgroh/ze_models/ogrid_jcbouret_izw18/T47p5g400M76p80L5p984Md10m7p14V1647H1p0He0p1Z0p01/obs/obs_cont',l1n,f1n,lmin=100,lmax=9000;,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/ogrid_jcbouret_izw18/T47p5g400M76p80L5p984Md10m7p14V1647H1p0He0p1Z0p01/obs/obs_fin',l1,f1,/flam
lplanck=findgen(10000)*10
bbflux=planck(lplanck,47750.)
bbflux=bbflux*1.2734d-25
lineplot,lplanck,bbflux*113445.*3.75*1.5095

bbflux2=planck(lplanck,60000.)
bbflux2=bbflux2*1.2734d-25
lineplot,lplanck,bbflux2*113445.*5.0*0.795

lineplot,l1,f1,title='obs' ;* 1e-15

;restore,'/Users/jgroh/temp/ze_evol_cmfgen_work_atmospheric_modeling_variables_to_george.sav'
dirmod='/Users/jgroh/ze_models/grid_P060z14S0/'
model='model001750_T043261_L0597948_logg3.907_f0d2'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l1750,f1750,LMIN=900,LMAX=50000
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l1750_nonn,f1750_nonn,LMIN=50,LMAX=50000,/FLAM

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l1750,f1750,TEXTOIDL('Wavelength [Angstrom]'),'Normalized Flux','',linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xrange=[4000,4800],yrange=[0,1.6],psxsize=900,psysize=400,filename='comparison_z014_zm4_mid_MS',$
                                x2=l1n,y2=f1n,color2='red',linestyle2=0,$;H+  
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l1750,f1750,TEXTOIDL('Wavelength [Angstrom]'),'Normalized Flux','',linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xrange=[1200,1700],yrange=[0,2.0],psxsize=900,psysize=400,filename='comparison_z014_zm4_mid_MS_UV',$
                              ;  x2=l1n,y2=f1n,color2='red',linestyle2=0,$;H+  
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l1750_nonn,f1750_nonn,TEXTOIDL('Wavelength [Angstrom]'),'Flux (erg/s/cm^2/Angstrom]','',/ylog,/xlog,linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xrange=[50,50000],yrange=[1e-25,1e-5],psxsize=900,psysize=400,filename='comparison_z014_zm4_mid_MS_ion',$
                                x2=l1,y2=f1,color2='red',linestyle2=0,$;H+  
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l1,f1,TEXTOIDL('Wavelength [Angstrom]'),'Flux (erg/s/cm^2/Angstrom]','',/ylog,/xlog,linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xrange=[50,50000],yrange=[1e-20,1e-5],psxsize=900,psysize=400,filename='comparison_bb',$
                                x2=lplanck,y2=bbflux*113445.*3.75*1.5095,color2='red',linestyle2=0,$;H+
                                x3=lplanck,y3=bbflux2*113445.*5.0*0.795,  color3='blue',linestyle3=0,$;H+
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues 

END