PRO ZE_CMFGEN_COMPUTE_OPTICAL_DEPTH_TORSCL,CHI,R,tor,ri,chii,tori

;VERY CRUDE UP TO THIS POINT< NEEDS TO BETTER COMPUTE DTAU AND DCHIDR
;based on subs/torscl.f

;  CALL DERIVCHI(dCHI_dR,CHI,R,ND,METHOD)
;  CALL NORDTAU(DTAU,CHI,R,R,dCHI_dR,ND)
;!
;! Determine optical depth from outer boundary to infinity. 
;! For the extrapolations, we use depths 0 & 4 (=INDX), i.e. 1 and 5
;!
  ;INDX=4
 ND=n_elements(chi)
 tor=dblarr(ND)
 factor=10
; ri=rebin(r,nd*factor)
; ri=ri[0:nd*factor-10]
; linterp,r,chi,ri,chii
; tori=dblarr(n_elements(ri))
;  IF(TYPE_ATM(1:MIN(3,LEN(TYPE_ATM))) .EQ. 'EXP')THEN
;    IF(CHI(1) .GT. 0 .AND. CHI(INDX) .GT. CHI(1))THEN
;     TOR(1)=CHI(1)*(R(1)-R(INDX))/LOG(CHI(INDX)/CHI(1))
;    ELSE
;      TOR(1)=0.00001
;      WRITE(LUER,*)'Warning - optical depth at boundary set to 10^{-5} in TORSCL'
;    END IF
;  ELSE IF(TYPE_ATM(1:1) .EQ. 'P')THEN
;    READ(TYPE_ATM(2:),*)T1
;    TOR(1)=CHI(1)*R(1)/(T1-1.0D0)
;  ELSE
    TOR[0]=CHI[0]*R[0]
    ;tori[0]=CHIi[0]*Ri[0]
;    WRITE(LUER,*)'Warning - opacity assumed to be r**(-2) in TORSCL'
;  END IF
 

  FOR I=1,ND-1 DO BEGIN
 ;   TOR[I]=TOR[I-1]+DTAU[I-1]
    TOR[I]=TOR[I-1]+ INT_TABULATED(r[i-1:i],chi[i-1:i],/sort,/double)
  ENDFOR

;
;  FOR I=1,n_elements(ri)-1 DO BEGIN
; ;   TOR[I]=TOR[I-1]+DTAU[I-1]
;    TORi[I]=TORi[I-1]+ INT_TABULATED(ri[i-1:i],chii[i-1:i],/sort,/double)
;  ENDFOR
;
;linterp,ri,tori,r,tor


END