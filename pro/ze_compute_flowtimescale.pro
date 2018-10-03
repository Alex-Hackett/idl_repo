PRO ZE_COMPUTE_FLOWTIMESCALE,r,v,nd,vs,flowtime,rirev,virev,flowtimerev,dflowtimerev,rev=rev,method=method

IF keyword_set(method) EQ 0 THEN method_val=1 ELSE method_val=2
IF n_elements(rev) LE 0 THEN rev=1

flowtime=dblarr(nd)

IF method_val EQ 1 THEN BEGIN
  npts=75000.
  ri=indgen(npts,/DOUBLE)*1. 
  for k=0., npts-1. do begin
    ri[k]=max(r)+((ri[k])*(min(r)-max(r))/(npts-1.*1.))
  endfor
ENDIF ELSE IF method_val EQ 2 THEN ri=REBIN(r,n_elements(r)*10000)

vi=cspline(r,v,ri)

IF KEYWORD_SET(REV) THEN BEGIN
  virev=REVERSE(vi)
  rirev=REVERSE(ri)
ENDIF ELSE BEGIN
  virev=vi
  rirev=ri
ENDELSE

ndi=n_elements(rirev)
sonic=MIN(ABS(virev-vs),indexsonic)
print,indexsonic
dflowtimerev=dblarr(n_elements(rirev))
flowtimerev=dblarr(n_elements(rirev))
dflowtimerev[0:indexsonic]=0.0D
flowtimerev[0:indexsonic]=0.0D
S_TO_DAY=1.0d/(24.0D*3600.0D)

FOR l=indexsonic+1, ndi - 1.0D DO BEGIN
dflowtimerev[l]=S_TO_DAY*((rirev[l]*1.0D)-(rirev[l-1]*1.0D))*1e5/(virev[l]*1.0D) ;in days
flowtimerev[l]=flowtimerev[l-1]+dflowtimerev[l]
ENDFOR

flowtimerev[0]=0.0
dflowtimerev[0]=0.0

;downsizing flowtimerev vector into r1 grid: find index of values of the interpolated r1i grid corresponding to the original r1 grid 
;neargrid=dblarr(i) & indexgrid=neargrid 
print,'method: ',method_val
FOR k=0.0D, nd-1.0 DO BEGIN
neargridt=Min(Abs(r[k] - ri), indexgridt)
indexgridt=indexgridt*1.0D
print,k,neargridt,indexgridt,r[k],flowtimerev[ndi-1-indexgridt]
flowtime[k]=flowtimerev[ndi-1-indexgridt]
ENDFOR

END