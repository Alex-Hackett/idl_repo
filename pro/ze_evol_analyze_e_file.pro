;PRO ZE_EVOL_ANALYZE_E_FILE
;general routine for loading, plotting and analyzing a .e file from the Geneva Stellar Evolution Code Origin2010 

modeldir='/Users/jgroh/evol_models/Grids2010/P060z14S0'
model_name='P060z14S0'
timestep=1001


ZE_EVOL_READ_E_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_efile,header_efile

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'xtt','xl',zstr='u15',/rebin,/xreverse
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','eta_star',zstr='Bmin',/rebin,yext=eta_star,zext=Bmin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe1',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_V_FILE_V2,vfile,data_vfile,'xmr','omega';,/rebin

;ZE_EVOL_PLOT_V_FILE_V2,vfile,data_vfile,'zensi','xmr';,/rebin

;eta_star_array=[0,0.01,0.1,0.5,0.7,0.9,1.0,1.2,1.5,2,5,10,20,50,100,200,500,1000]
;Jdot_as_a_function_eta_Star=(0.29+(eta_star_array+0.25)^0.25)^2

;ZE_EVOL_PLOT_XY_GENERAL_EPS,eta_star_array,Jdot_as_a_function_eta_Star,SCOPE_VARNAME(eta_star_array),SCOPE_VARNAME(Jdot_as_a_function_eta_Star),'',XRANGE=[1e-2,1e3],/xlog



!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j)

END