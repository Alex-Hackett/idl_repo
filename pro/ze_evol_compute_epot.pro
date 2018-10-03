FUNCTION ZE_EVOL_COMPUTE_EPOT,Mr,r,integrated=integrated
;computes the potential energy in the Geneva evolution code; 
; if scalar is provided, use the direct values 
; if array is provided with nshell > 2, uses the average T and mu for layers i and i-1, starting with i=1
;remember that Mr is the shell mass, not the internal mass Mint given by the structure file!


;! ENERGIE POTENTIELLE
;  epote=-cst_G*xmasr(m-1)*xmasr(m-1)/ray(m-1)*3.d0/5.d0
;  dpot(m)=epote
;  epot(m)=epote
;  do imb=2,m-1
;   nmb=m-imb+1
;   dpot(nmb)=-cst_G*dmasr(nmb)/2.d0*(xmasr(nmb)/ray(nmb)+xmasr(nmb-1)/ray(nmb-1))
;   epote=epote+dpot(nmb)
;   epot(nmb)=epote
;  enddo

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

nshell=n_elements(Mr)
epot=dblarr(nshell)
epot=-cst_G*Mint[nshell-1]*Mint[nshell-1]/r[nshell-1]*3.d0/5.d0
if Nshell GT 2 THEN BEGIN 
  FOR I=1, nshell-1 DO BEGIN
  epot[i]=
  ekin[0]=ekin[1]
  ;multiplies by numerical factor 3/2 k/mh
  ekin=ekin*(1.50d0*cst_k/cst_mh)
endif ELSE ekin=(1.50d0*cst_k/cst_mh)*Mr[i]*T[i]/mu[i]

IF KEYWORD_SET(INTEGRATED) THEN print,'total thermal energy of gas: ',TOTAL(ekin,/DOUBLE)

return,ekin
END