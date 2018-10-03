PRO ZE_COMPUTE_BINDING_ENERGY_ALL,logr,Mint,logT,mu,ebind,deltaebind=deltaebind,eint=eint
;computes deltaebind, which is the binding energy of EACH shell, and ebind, which is the bind energy of ALL shells above a given shell 
;recomputes ekin,erad
;IMPORTANT: Mint is the internal mass, Mr is the shell mass
 
 ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg
                  

;ISSUE: Mint is not the shell mass Mr!!!!!!!!
Mr=Mint-shift(Mint,1)
mr[0]=0
r=10^logr

ekin=ZE_EVOL_COMPUTE_EKIN_GAS(Mr,10^logT, mu,integrated=0)
erad=ZE_EVOL_COMPUTE_ERAD(10^logT,10^logr,integrated=0)
erot=0 ; does not consider rotational energy at the moment
eint=erad+ekin+erot

; Mr=Mr(uniq(Mr))
; r=r(uniq(Mr))
  
 nshells=n_elements(r)
 ebind=dblarr(nshells)
 deltaebind=dblarr(nshells)
for i=1, nshells -1 do begin
  deltaebind[i]=cst_G*Mint[i]*Mr[i]/r[i]
;  print,i,deltaebind[i],eint[i]
endfor  
deltaebind[0]=0d

for i=1, nshells -1 do begin 
  ebind[i]=TOTAL(deltaebind[i:nshells-1],/DOUBLE)-TOTAL(eint[i:nshells-1],/DOUBLE)
  ; print,  TOTAL(deltaebind[i:nshells-1],/DOUBLE), TOTAL(eint[i:nshells-1],/DOUBLE),ebind[i]
endfor

END