;PRO ZE_WORK_FLOWTIMESCALE_HYDRO
!P.Background = fsc_color('white')
;r and v values of model 1, with increased teff and vinf-150 km/s
READCOL,'/Users/jgroh/ze_models/timedep_armagh/49/RVSIG_COL_NEW_v150',r1,v1,sigma1,depth1,COMMENT='!',F='D,D'
;READCOL,'/Users/jgroh/ze_models/timedep_armagh/449/RVSIG_COL',r1,v1,sigma1,depth1,COMMENT='!',F='D,D'
i=n_elements(r1)

;velocity law for epoch 1:
vinf1=70.
v0=1.0
beta1=1.0
sclht=0.04
;;v2mod=v2
FOR k=0, i-1 do begin
v1[k]=(v0+(vinf1-v0)*((1-(r1[i-1]/r1[k]))^beta1))/(1.0+(v0/sclht)*exp((r1[i-1]-r1[k])/(sclht*r1[i-1])))
endfor


flowtime=dblarr(i)
flowtimen=dblarr(i)

vs=15.0

npts=75000.
r1i=indgen(npts,/DOUBLE)*1. 
for k=0., npts-1. do begin
r1i[k]=max(r1)+((r1i[k])*(min(r1)-max(r1))/(npts-1.*1.))
endfor

r1in=r1i
v1in=cspline(r1,v1,r1in)

v1irevn=REVERSE(v1in)
r1irevn=REVERSE(r1in)
ndin=n_elements(r1irevn)
sonicn=MIN(ABS(v1irevn-vs),indexsonicn)

dflowtimerevn=dblarr(n_elements(r1irevn))
flowtimerevn=dblarr(n_elements(r1irevn))
dflowtimerevn[0:indexsonicn-1]=0.0D
flowtimerevn[0:indexsonicn-1]=0.0D
S_TO_DAY=1.0d/(24.0D*3600.0D)
FOR l=indexsonicn, ndin - 1.0D DO BEGIN
dflowtimerevn[l]=S_TO_DAY*((r1irevn[l]*1.0D)-(r1irevn[l-1]*1.0D))*1e5/(v1irevn[l]*1.0D) ;in days
flowtimerevn[l]=flowtimerevn[l-1]+dflowtimerevn[l]
ENDFOR

;downsizing flowtimerev vector into r1 grid: find index of values of the interpolated r1i grid corresponding to the original r1 grid 
;neargrid=dblarr(i) & indexgrid=neargrid 
print,'method 1'
FOR k=0.0D, i-1.0 DO BEGIN
neargridtn=Min(Abs(r1[k] - r1in), indexgridtn)
indexgridtn=indexgridtn*1.0D
print,k,neargridtn,indexgridtn,r1[k],flowtimerevn[ndin-1-indexgridtn]
;neargrid[i]=neargridt
;indexgrid[i]=index
flowtimen[k]=flowtimerevn[ndin-1-indexgridtn]
ENDFOR
print,' '

r1i=REBIN(r1,n_elements(r1)*10000)
v1i=cspline(r1,v1,r1i)

v1irev=REVERSE(v1i)
r1irev=REVERSE(r1i)
ndi=n_elements(r1irev)
sonic=MIN(ABS(v1irev-vs),indexsonic)

dflowtimerev=dblarr(n_elements(r1irev))
flowtimerev=dblarr(n_elements(r1irev))
dflowtimerev[0:indexsonic-1]=0.0D
flowtimerev[0:indexsonic-1]=0.0D
S_TO_DAY=1.0d/(24.0D*3600.0D)
FOR l=indexsonic, ndi - 1.0D DO BEGIN
dflowtimerev[l]=S_TO_DAY*((r1irev[l]*1.0D)-(r1irev[l-1]*1.0D))*1e5/(v1irev[l]*1.0D) ;in days
flowtimerev[l]=flowtimerev[l-1]+dflowtimerev[l]
ENDFOR

;downsizing flowtimerev vector into r1 grid: find index of values of the interpolated r1i grid corresponding to the original r1 grid 
;neargrid=dblarr(i) & indexgrid=neargrid 
print,'method 2'
FOR k=0.0D, i-1.0 DO BEGIN
neargridt=Min(Abs(r1[k] - r1i), indexgridt)
indexgridt=indexgridt*1.0D
print,k,neargridt,indexgridt,r1[k],flowtimerev[ndi-1-indexgridt]
;neargrid[i]=neargridt
;indexgrid[i]=index
flowtime[k]=flowtimerev[ndi-1-indexgridt]
ENDFOR
print,''


ntime=4
v1_array=dblarr(i,ntime)
r1_array=dblarr(i,ntime)

for s=0, ntime -1 DO begin
v1_array=0
endfor

;compute delta_x (spacing between the two winds) as a function of time.
;x1=position of the beginning of wind 1 (i.e., old wind) 
;x2=position of the end of wind 2 (i.e., new wind) 
;delta_x=x1 -x2



END