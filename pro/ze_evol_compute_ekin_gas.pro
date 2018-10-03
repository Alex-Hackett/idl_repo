FUNCTION ZE_EVOL_COMPUTE_EKIN_GAS,Mr,T,mu,integrated=integrated
;computes thermal energy of gas in the Geneva evolution code; 
; if scalar is provided, use the direct values 
; if array is provided with nshell > 2, uses the average T and mu for layers i and i-1, starting with i=1
;result NOT ok benchmarked against .g file SOMETHING IS WRONG 2014jul31
;REASON: was using Mint for the shell mass, but remember that Mr is the shell mass, not the internal mass Mint given by the structure file!
;NOW WORKS 2014aug01 benchmarked againt .g file

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

nshell=n_elements(Mr)
if Nshell GT 2 THEN BEGIN 
  ekin=dblarr(nshell)
  FOR I=1, nshell-1 DO ekin[i]=Mr[i]*(T[i]/mu[i]+T[i-1]/mu[i-1])/2d0
  ekin[0]=ekin[1]
  ;multiplies by numerical factor 3/2 k/mh
  ekin=ekin*(1.50d0*cst_k/cst_mh)
endif ELSE ekin=(1.50d0*cst_k/cst_mh)*Mr[i]*T[i]/mu[i]

IF KEYWORD_SET(INTEGRATED) THEN print,'total thermal energy of gas: ',TOTAL(ekin,/DOUBLE)

return,ekin
END