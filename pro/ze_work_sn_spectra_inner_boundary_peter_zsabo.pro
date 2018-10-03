;PRO ZE_WORK_SN_SPECTRA_INNER_BOUNDARY_PETER_ZSABO

;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/13dqy/74/j_innerboundary_depth80.dat',l80,f80
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/13dqy/74/jd_1.dat',l1,f1

;readcol,'/Users/jgroh/ze_models/13dqy/74/flux_depth_70_60_50_40_30_20_10.dat',l70,f70,l60,f60,l50,f50,l40,f40,l30,f30,l20,f20,l10,f10
;readcol,'/Users/jgroh/ze_models/13dqy/74/obs_depth/flux_file_depth.dat',l80,f80,l70,f70,l60,f60,l50,f50,l40,f40,l30,f30,l20,f20,l10,f10,l1,f1
;save,/all,filename='/Users/jgroh/temp/13dqy_EDDFACTOR_spectra_jd_74_for_zsabo.sav'
restore,'/Users/jgroh/temp/13dqy_EDDFACTOR_spectra_jd_74_for_zsabo.sav'
lineplot,l80,f80
lineplot,l70,f70
lineplot,l60,f60
lineplot,l50,f50
lineplot,l40,f40
lineplot,l30,f30
lineplot,l20,f20
lineplot,l10,f10
lineplot,l1,f1

lplanck=findgen(10000)*10
bbflux2=planck(lplanck,150000.)
bbflux2=bbflux2*1e9
bbflux3=planck(lplanck,170000.)
bbflux3=bbflux3*1e9
lineplot,lplanck,bbflux2

bbflux3=planck(lplanck,50000.)
bbflux3=bbflux3*1e9


;for inner boundary
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,l80,f80,TEXTOIDL('Wavelength [Angstrom]'),'Flux (erg/s/cm^2/Angstrom]','',/ylog,/xlog,linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xrange=[50,50000],yrange=[1e-20,1e-5],psxsize=900,psysize=400,filename='comparison_bb_innerboundary',$
                                x2=lplanck,y2=bbflux2*1e9,color2='red',linestyle2=0,$;H+
                             ;   x3=lplanck,y3=bbflux2*113445.*5.0*0.795,  color3='blue',linestyle3=0,$;H+
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues 


END