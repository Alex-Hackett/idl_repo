PRO ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar,logg,vesc,vinf,eta_star,Bmin,Jdot,logg_rphot,rphot,beq,beta,ekin,teffjump1,teffjump2,logtcollapse=logtcollapse,model=model
                                         

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u2
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rot1',data_wgfile_cut,rot1
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesc',data_wgfile_cut,eddesc60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u7,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'b33',data_wgfile_cut,b33,return_valz  ;He3 surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u8,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u12,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u6,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1,return_valz   ; Age in years
nmodels=n_elements(xl)
vinf=dblarr(nmodels)
beta=dblarr(nmodels)
;compute rstar
rstar=dblarr(nmodels)
for i=0., n_elements(nmodels) -1. DO BEGIN
ZE_COMPUTE_R_FROM_T_L,10^xte/1e3,10^xl,rstart
rstar[i]= rstart
ENDFOR

;compute rphot
rphot=dblarr(nmodels)
for i=0., n_elements(nmodels) -1. DO BEGIN
ZE_COMPUTE_R_FROM_T_L,10^xtt/1e3,10^xl,rphott
rphot[i]= rphott
ENDFOR

logg=alog10(cst_G*u2*Msol/(rstar*Rsol)^2)
logg_rphot=alog10(cst_G*u2*Msol/(rphot*Rsol)^2)

vesc=sqrt(2d0*rstar*Rsol*(10^logg)*(1-eddesm60))/1e5 ;from Kudritzki & Puls 2000

zsol=0.014
xlogz60=alog10((1d0-(u5+u7+b33))/zsol)

charrho=-14.94d0+3.1857d0*eddesc60+0.85d0*xlogz60
teffjump1=61.2d0+2.59d0*charrho
teffjump1=teffjump1*1000.d0
teffjump2=100.d0+6.d0*charrho
teffjump2=teffjump2*1000.d0

;;previously
;teffjump2=replicate(10000.0,nmodels)
;teffjump1=replicate(21000.0,nmodels)

For i=0., nmodels -1 DO BEGIN
  IF 10^xtt[i] lt teffjump2[i] THEN vinf[i]=1.0*vesc[i] ELSE BEGIN
    IF 10^xtt[i] gt teffjump1[i] THEN vinf[i]=2.65*vesc[i] ELSE vinf[i]=1.4*vesc[i]
  ENDELSE
  
  IF u7[i] gt 0.7 THEN  BEGIN
   ; vinf[i]=vesc[i]*10^(0.61-0.13*xl[i]+0.30*alog10(u7[i])) ;it's a WN star according to Georgy+12
    if vinf[i] GT 2000.0 THEN vinf[i]=2000.0
  ENDIF
  
  IF ((u5[i] lt 1e-5) AND (u8[i] GT u10[i])) THEN  BEGIN
    vinf[i]=vesc[i]*10^(-2.37+0.43*xl[i]-0.07*alog10(u6[i]+u8[i]+u10[i]+u12[i])) ;it's a WC star according to Georgy+12
  ENDIF
  
  IF ((u10[i] lt 1e-5) AND (xte[i] GT 5.2 )) THEN vinf[i]=5000.0 ;we assume it's a WO star, attention it uses xte
  
  IF 10^xtt[i] lt 7000.0 THEN vinf[i]=20.0  ;assuming that for T < 7000K, vinf=20 km/s 
ENDFOR

For i=0., nmodels -1 DO BEGIN
  beta[i]=1.0 ;default beta
  IF ((u5[i] lt 0.6)) THEN BEGIN 
     IF 10^xte[i] lt teffjump1[i] THEN beta[i]=2.5 
  ENDIF
ENDFOR

ekin=0.5D0 * (10^xmdot)*(Msol/year)*(vinf*1e5)^2

;computes log time before core collapse, needs model input;

IF N_ELEMENTS(model) GT 0 THEN logtcollapse=ZE_EVOL_COMPUTE_LOGT_TO_COLLAPSE(model,u1)        




IF n_elements(beq) LT 1 THEN Beq=200.0
eta_star= Beq * (rstar*Rsol)^2/ ((10^xmdot)*(Msol/year)*vinf*1e5)  ; eta_star = Beq^2 Rstar ^2 / (Mdot * vinf)
Bmin=SQRT((10^xmdot)*(Msol/year)*vinf*1e5)/ (rstar*Rsol)
;!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j)

Jdot=0.66666*(10^xmdot)*(Msol/year)*rot1*(rstar*Rsol)^2*(0.29+(eta_star+0.25)^0.25)^0.5

END