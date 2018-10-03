;PRO ZE_EVOL_ANALYZE_WGFILE
;general routine for loading, plotting and analyzing a .wg file from the Geneva Stellar Evolution Code Origin2010 

;initilization of variables


;dir='/Users/jgroh/evol_models/Z014/'
;model='P010z14S4'
;model='P010z14S4nomagbreaking'
;model='P010z14S4magbreaking200G'
;model='P010z14S4_1G_RSG'

dir='/Users/jgroh/evol_models/Z014/'
model='P060z14S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;print,'wg file for this model should be: ', wgfile

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,/reload

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar,logg,vesc,vinf,eta_star,Bmin,Jdot

ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'xtt','xl',zstr='xmdot',/rebin,/xreverse


;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','eta_star',zstr='Bmin',/rebin,yext=eta_star,zext=Bmin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe1',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',/rebin


;eta_star_array=[0,0.01,0.1,0.5,0.7,0.9,1.0,1.2,1.5,2,5,10,20,50,100,200,500,1000]
;Jdot_as_a_function_eta_Star=(0.29+(eta_star_array+0.25)^0.25)^2

;ZE_EVOL_PLOT_XY_GENERAL_EPS,eta_star_array,Jdot_as_a_function_eta_Star,SCOPE_VARNAME(eta_star_array),SCOPE_VARNAME(Jdot_as_a_function_eta_Star),'',XRANGE=[1e-2,1e3],/xlog



;!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j)





END