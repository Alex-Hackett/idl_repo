;PRO ZE_EVOL_WORK_MAGNETIC_BREAKING
; 2012 Jun 08 working on magnetic breaking in the MS and RSG phases, trying to understand if it is possible to slow down the core and produce NS with longer Periods

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg
                  
;wgfile='/Users/jgroh/evol_models/Z0004/P085zm4S0/P085zm4S0.wg'
dir='/Users/jgroh/evol_models/Z014/'
model='P010z14S4'
model='P010z14S4nomagbreaking'
model='P010z14S4magbreaking200G'
;model='P010z14S4_1G_RSG'

wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes medel directory name and .wg files have the same name 
;wgfile='/Users/jgroh/evol_models/Z014/P010z14S4nomagbreaking/P010z14S4nomagbreaking.wg'
;wgfile='/Users/jgroh/evol_models/Z014/P010z14S4_1G_RSG/P010z14S4_1G_RSG.wg'
;wgfile='/Users/jgroh/evol_models/Z014/P010z14S4magbreaking200G/P010z14S4magbreaking200G.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010,wgfile,data_wgfile,header_wgfile

nm=REFORM(data_wgfile.field001[0,*])
u1=REFORM(data_wgfile.field001[1,*])
u2=REFORM(data_wgfile.field001[2,*])
xl=REFORM(data_wgfile.field001[3,*])
xtt=REFORM(data_wgfile.field001[4,*])
xmdot=REFORM(data_wgfile.field001[18,*])
u15=REFORM(data_wgfile.field001[21,*])
u16=REFORM(data_wgfile.field001[22,*])
u17=REFORM(data_wgfile.field001[23,*])
rot1=REFORM(data_wgfile.field001[39,*])
veq=REFORM(data_wgfile.field001[52,*])
vcrit1=REFORM(data_wgfile.field001[50,*])


rstar=dblarr(n_elements(xl))
for i=0., n_elements(xl) -1. DO BEGIN
ZE_COMPUTE_R_FROM_T_L,10^xtt[i]/1e3,10^xl[i],rstart
rstar[i]= rstart
ENDFOR

logg=alog10(cst_G*u2*Msol/(rstar*Rsol)^2)


vesc=sqrt(2d0*cst_G*u2*Msol/(rstar*Rsol))/1e5
vinf=1.5*vesc
Beq=200.0
eta_star= Beq * (rstar*Rsol)^2/ ((10^xmdot)*(Msol/year)*vinf*1e5)  ; eta_star = Beq^2 Rstar ^2 / (Mdot * vinf)
Bmin=SQRT((10^xmdot)*(Msol/year)*vinf*1e5)/ (rstar*Rsol)
!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j)

Jdot=0.66666*(10^xmdot)*(Msol/year)*rot1*(rstar*Rsol)^2*(0.29+(eta_star+0.25)^0.25)^0.5

label=model

ZE_EVOL_PLOT_XY_GENERAL_EPS,xtt,xl,SCOPE_VARNAME(xtt),SCOPE_VARNAME(xl),label,z=rot1,labelz=SCOPE_VARNAME(rot1),/rebin,XRANGE=[max(xtt)*1.02,min(xtt)*0.98]
ZE_EVOL_PLOT_XY_GENERAL_EPS,u1,eta_star,SCOPE_VARNAME(u1),SCOPE_VARNAME(eta_star),label,z=u1,/rebin
ZE_EVOL_PLOT_XY_GENERAL_EPS,logg,veq,SCOPE_VARNAME(logg),SCOPE_VARNAME(veq),label,z=u15,/rebin,XRANGE=[4.3,3.2],YRANGE=[0,200]
ZE_EVOL_PLOT_XY_GENERAL_EPS,u1,bmin,SCOPE_VARNAME(u1),SCOPE_VARNAME(bmin),label
ZE_EVOL_PLOT_XY_GENERAL_EPS,u1,jdot,SCOPE_VARNAME(u1),SCOPE_VARNAME(jdot),label,z=u1,/rebin

eta_star_array=[0,0.01,0.1,0.5,0.7,0.9,1.0,1.2,1.5,2,5,10,20,50,100,200,500,1000]
Jdot_as_a_function_eta_Star=(0.29+(eta_star_array+0.25)^0.25)^2

ZE_EVOL_PLOT_XY_GENERAL_EPS,eta_star_array,Jdot_as_a_function_eta_Star,SCOPE_VARNAME(eta_star_array),SCOPE_VARNAME(Jdot_as_a_function_eta_Star),'',XRANGE=[1e-2,1e3],/xlog

u1r=REBIN(u1,n_elements(u1/10.))
eta_starr=REBIN(eta_star,n_elements(u1/10.))


END