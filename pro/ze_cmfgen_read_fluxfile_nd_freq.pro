PRO ZE_CMFGEN_READ_FLUXFILE_ND_FREQ,data,ND,NCF,RECL,depth,freq,lambda,flux,fluxvec
;CONSTANTS
C=299792000.
;define 1D arrays
depth=dblarr(ND)
freq=dblarr(NCF)
FLUXDIM=ND*NCF
flux=dblarr(ND,NCF)
fluxvec=dblarr(FLUXDIM) ;one dimensional vector

;create the depth vector
for i=0., ND-1 do depth[i]=i+1

;create the frequency vector
startfreq=RECL+(ND+1.) -1.
n=0.
FOR i=0., NCF-1. do begin
  freq[i]=data[n + startfreq]
  n=n+ND+1.
ENDFOR

;create lambda vector in Angstrom vaccum
lambda=C/freq*1E-05

;create the FLUXVEC(depth*nu) vector, working now!
startflux=RECL
m=1.
t=-1.
FOR i=0., FLUXDIM-1 DO BEGIN
  if (i eq m*ND) then begin
  t=t+2.
  m=m+1.
  endif else begin
  t=t+1.  
        endelse
   fluxvec[i]=data[startflux + t]   
ENDFOR

m=0.
;create the FLUX(depth,nu) vector, working now!
FOR I=0.D, NCF -1  DO BEGIN 
  flux[*,i]=fluxvec[m:(ND-1)+m]
  m=ND*(i+1)
ENDFOR

END