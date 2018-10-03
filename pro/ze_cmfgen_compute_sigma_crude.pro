PRO ZE_CMFGEN_COMPUTE_SIGMA_CRUDE,r,v,sigma
;computes sigma for CMFGEN very crudely
; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
nd=n_elements(r)
sigma=dblarr(nd)

sigma[0]=-0.9999
for k=1, nd-1 do begin
sigmat=(r[k]*(v[k-1]-v[k])/(v[k]*(r[k-1]-r[k])))-1
sigma[k]=sigmat
endfor


END