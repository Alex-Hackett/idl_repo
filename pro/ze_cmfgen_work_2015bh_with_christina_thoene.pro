;PRO ZE_CMFGEN_WORK_2015BH_WITH_CHRISTINA_THOENE

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/grid_P060z14S0/model004744_T008011_L0842525_logg0.635/obs/obs_fin',l1,f1,/FLAM,lmin=3000,lmax=9000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/grid_P060z14S0/model004734_T010594_L0838434_logg1.123/obs/obs_fin',l2,f2,/FLAM,lmin=3000,lmax=9000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/obs_fin',l2,f2,/FLAM,lmin=3000,lmax=9000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/obs_fin',l3,f3,/FLAM,lmin=3000,lmax=9000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/grid_P060z14S0/model4729_T12785_L834422_logg1d4519_with_lowion/obs/obs_fin',l3,f3,/FLAM,lmin=3000,lmax=9000,/AIR

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/2015bh_thoene/forJose/20131111_GTC_flx.txt',lobs,fobs

f1cnvl=ZE_SPEC_CNVL_VEL(l1,f1,100.0)
f2cnvl=ZE_SPEC_CNVL_VEL(l2,f2,300.0)
f3cnvl=ZE_SPEC_CNVL_VEL(l3,f3,300.0)

;lineplot,l1,f1cnvl*5e-07
lineplot,l2,f2cnvl/(27*1e3)^2
lineplot,l3,f3cnvl/(27*1e3)^2

fobsv=ZE_SHIFT_SPECTRA_VEL(lobs,fobs,-1860.0)

vel=1600.0
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l2,ZE_SHIFT_SPECTRA_VEL(l2,f2cnvl/(27*1e3)^2*2e2,vel),'Wavelength','Flux','',linestyle1=0,color1=colorhyd,$ ;H0
                                _EXTRA=extra,/ylog,xrange=[3600,7800],yrange=[3e-17,5e-15],psxsize=900,psysize=550,filename='15bh_try1',$                                                                                       
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8,ystyle=0,xstyle=0;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues


END