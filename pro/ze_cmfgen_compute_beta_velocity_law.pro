PRO ZE_CMFGEN_COMPUTE_BETA_VELOCITY_LAW,r1,vinf1,beta1,v0_1,vcore,sclht_1,v1

nd1=n_elements(r1)
v1=dblarr(nd1)

;FOR k=0, nd1-1 do begin
; v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))/(1.0+(v0_1/vcore)*exp((r1[nd1-1]-r1[k])/(sclht_1*r1[nd1-1])))
;endfor

FOR k=0, nd1-1 do begin
 v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))
endfor

END