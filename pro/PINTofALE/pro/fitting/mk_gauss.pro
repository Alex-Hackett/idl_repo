function mk_gauss,x,mean,sig,peak,pder,fwhm=fwhm,normflx=normflx,$
	missing=missing, _extra=e
;+
;function	mk_gauss
;	returns a gaussian G(X)
;
;syntax
;	g=mk_gauss(x,mean,sig,peak,pder,/fwhm,/normflx,missing=missing)
;
;parameters
;	x	[INPUT array; required] where G(X) must be computed
;	mean	[INPUT; default: mid_point(X)] position of peak
;	sig	[INPUT; default: 0.1*range(X)] std. deviation
;	peak	[INPUT; default: 1] max(G)
;	pder	[OUTPUT; optional] partial derivatives of model wrt parameters
;		at each X; calculated only if 5 parameters are supplied in call.
;
;keywords
;	fwhm	[INPUT] if set, the std.deviation is SIG/2.355
;	normflx	[INPUT] if set, the *normalization* is set to PEAK
;	missing	[INPUT] 3 element array to populate missing values of
;		MEAN, SIG, and PEAK
;	_extra	[JUNK] here only to prevent program from crashing
;
;description
;    if NORMFLX == 0 && FWHM == 0:
;	G(X)=PEAK*exp((X-MEAN)^2/2/SIGMA^2)
;    if NORMFLX != 0 && FWHM == 0:
;	G(X)=(PEAK/SIGMA/sqrt(2*!PI))*exp((X-MEAN)^2/2/SIGMA^2)
;    if NORMFLX == 0 && FWHM != 0:
;	G(X)=PEAK*exp(2.355^2*(X-MEAN)^2/2/SIGMA^2)
;    if NORMFLX != 0 && FWHM != 0:
;	G(X)=(2.355*PEAK/SIGMA/sqrt(2*!PI))*exp(2.355^2*(X-MEAN)^2/2/SIGMA^2)
;
;usage summary
;	* call as a function
;	* generates gaussian model only at specified points X
;	* needs MEAN, SIG, PEAK for complete specification
;
;subroutines
;	NONE
;
;history
;	vinay kashyap (Oct96)
;	added PDER (VK; Nov96)
;	added _EXTRA, changed SIGMA to SIG (VK; Oct98)
;	big correction, if MEAN,SIG,PEAK are undefined on input (VK; JunMM)
;	now works even if X are integers (VK; Jul01)
;	converted array notation to IDL 5 (VK; Apr02)
;	check to see if X is defined (VK; Sep02)
;	changed keyword NORM to NORMFLX (VK; Oct02)
;-

np=n_params()
if np lt 1 then begin
  print, 'Usage: g=mk_gauss(x,mean,sigma,peak,pder,missing=m,/fwhm,/normflx)'
  print, '  generates a gaussian G(x)' & return,[-1L]
endif

;initialize
nx=n_elements(x)
if nx eq 0 then begin
  message,'X is undefined',/info & return,[-1L]
endif
x0=x[nx/2] & mxx=max(x,min=mnx)

;figure out the defaults
if not keyword_set(missing) then missing=[x0,0.1*(mxx-mnx),1.]
if np lt 4 or n_elements(peak) eq 0 then p=missing[2] else p=peak[0]
	peak=p
if np lt 3 or n_elements(sig) eq 0 then s=missing[1] else s=sig[0]
	sig=s
if s lt 0 then s=abs(s) & if s eq 0 then s=missing[1]
if np lt 2 or n_elements(mean) eq 0 then m=missing[0] else m=mean[0]
	mean=m
if keyword_set(fwhm) then s=s/2.355

;compute exponential part of gaussian
z=(x-m)^2/2./s^2 & hz=where(z lt 60.) & g=make_array(size=size(0.*x))
if hz[0] ne -1 then g[hz]=exp(-z[hz])

;compute partial derivatives
if np ge 5 then begin
  pder = fltarr(nx,3)
  tmp = ((x-m+0.0)/s^2) * p * g
  pder[*,0] = tmp[*]				;partial wrt mean
  if keyword_set(normflx) then begin
    tmp = (((x-m+0.0)^2-s^2)/s^3) * p * g
  endif else begin
    tmp = ((x-m+0.0)^2/s^3) * p * g
  endelse
  pder[*,1] = tmp[*]				;partial wrt sigma
  pder[*,2] = g[*]				;partial wrt peak
endif

;set proper normalizations
g = p*g
;
if keyword_set(normflx) then begin
  nrm=1.
  if s ne 0 then nrm=1.0/s/sqrt(2*!pi)
  g=g*nrm
  if np ge 5 then pder=pder*nrm
  ;
  ;renorm=1.
  ;if total(abs(g)) gt 0 then renorm=p/total(g)
  ;g=g*renorm
  ;if np ge 5 then pder=pder*renorm
endif

return,g
end
