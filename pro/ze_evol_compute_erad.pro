FUNCTION ZE_EVOL_COMPUTE_ERAD,T,r,integrated=integrated
;computes radiation energy in the Geneva evolution code; 
; if scalar is provided, use the direct values 
; if array is provided with nshell > 2, uses the average T and r for layers i and i-1, starting with i=1
;  drad(nmb)=(4.d0*pi*cst_a/3.d0)*(ray(nmb-1)**3.d0-ray(nmb)**3.d0)*((xtemp(nmb)+xtemp(nmb-1))/2.d0)**4.d0
;result OK benchmarked against .g file  
 
 
ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

nshell=n_elements(T)
if Nshell GT 2 THEN BEGIN 
  erad=dblarr(nshell)
  FOR I=1, nshell-1 DO erad[i]=(r[i]^3-r[i-1]^3d0)*((T[i]+T[i-1])/2d0)^4d0
  erad[0]=erad[1]
  ;multiplies by numerical factor 3/2 k/mh
  erad=erad*4.d0*pi*cst_a/3.d0
endif ELSE erad=(4.d0*pi*cst_a/3.d0)*(r[i]^3d0)*(T[i]^4d0)

IF KEYWORD_SET(INTEGRATED) THEN BEGIN
    print,'total radiation energy: ',TOTAL(erad,/DOUBLE)
;    print,'total radiation energy int_tabulated: ',int_tabulated(r,erad,/DOUBLE)
endif
return,erad
END