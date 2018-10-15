;PRO ZE_EVOL_ANALYZE_V_FILE
;general routine for loading, plotting and analyzing a .v file from the Geneva Stellar Evolution Code Origin2010 

modeldir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d040/'
model_name='P015z000S0d040'
timestep=0021801

;modeldir='/Users/jgroh/evol_models/Z014/P010z14S4nomagbreaking'
;model_name='P010z14S4'
;timestep=2201

;model='P010z14S4nomagbreaking'
;model='P010z14S4magbreaking200G'
;model='P010z14S4_1G_RSG'

vfile=modeldir+'/'+model_name+'.v'+strcompress(string(timestep, format='(I07)')) 
print,vfile
ZE_EVOL_READ_V_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_vfile,header_vfile,modnb,age,mtot,nbshell,deltat

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'xtt','xl',zstr='u15',/rebin,/xreverse
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','eta_star',zstr='Bmin',/rebin,yext=eta_star,zext=Bmin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe1',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',zstr='u15',/rebin,/ylog

ZE_EVOL_PLOT_V_FILE_V2,vfile,data_vfile,'xmr','eps';,/rebin

ZE_EVOL_PLOT_V_FILE_V2,vfile,data_vfile,'zensi','xmr';,/rebin

;eta_star_array=[0,0.01,0.1,0.5,0.7,0.9,1.0,1.2,1.5,2,5,10,20,50,100,200,500,1000]
;Jdot_as_a_function_eta_Star=(0.29+(eta_star_array+0.25)^0.25)^2

;ZE_EVOL_PLOT_XY_GENERAL_EPS,eta_star_array,Jdot_as_a_function_eta_Star,SCOPE_VARNAME(eta_star_array),SCOPE_VARNAME(Jdot_as_a_function_eta_Star),'',XRANGE=[1e-2,1e3],/xlog



;!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j)





END