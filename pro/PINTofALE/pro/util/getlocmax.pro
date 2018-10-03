function getlocmax,x,y,width=width,sigma=sigma,nsigma=nsigma, _extra=e
;+
;function	getlocmax
;	returns the position indices where y(x) is a local maximum
;
;syntax
;	ilm=getlocmax(x,y,width=width,sigma=sigma,nsigma=nsigma)
;
;parameters
;	x	[INPUT; required] abscissae where input function is defined
;	y	[INPUT] input function.  if not given, X is taken to be Y
;		and array position indices are taken to be X
;
;keywords
;	width	[INPUT; default: 1] window in which to search for local
;		maxima -- window width = 2*abs(WIDTH)+1 or 3, whichever
;		is greater.
;	sigma	[INPUT; default: 1+sqrt(abs(Y)+0.75)] error at each point
;		* if scalar and NSIGMA is not defined, then SIGMA->NSIGMA
;	nsigma	[INPUT; default: 1] multiple of SIGMA to consider as a
;		threshold filter
;		* to use var(y) as a constant value of SIGMA, do
;		  ilm=getlocmax(x,y,sigma=sqrt((moment(y))(1)),/nsigma)
;
;	_extra	[INPUT] junk -- here only to keep routine from crashing
;
;history
;	vinay kashyap (Dec96)
;	corrected bug with 1-, 2-, or 3-element inputs (VK; Nov98)
;-

;	usage
if n_params(0) eq 0 then begin
  print,'Usage: ilm=getlocmax(x,y,width=width,sigma=sigma,nsigma=nsigma)'
  print,'  returns position indices of local maxima in y(x)'
  return,-1L
endif

;	check input
xx=[x] & nx=n_elements(xx)
if n_elements(y) ne nx then begin		;X->Y
  yy=xx & xx=lindgen(nx)
endif else yy=[y]

;	trivial results
if nx eq 1 then return,[0L]
if nx eq 2 then begin
  if yy(0) ge yy(1) then return,[0L] else return,[1L]
endif
if nx eq 3 then begin
  tmp=max(yy,ilm) & return,[ilm]
endif

;	check keywords
if not keyword_set(width) then w=1 else w=fix(abs(width(0)))>1
if not keyword_set(sigma) then begin		;{SIGMA
  s=1.+sqrt(abs(yy)+0.75)			;default poisson errors
endif else begin
  ns=n_elements(sigma)
  if ns eq 1 then begin				;(if scalar...
    if not keyword_set(nsigma) then begin	;set NSIGMA, default SIGMA
      nsigma=abs(sigma) & s=1.+sqrt(abs(yy)+0.75)
    endif else s=0*yy+sigma 			;set to constant
  endif else begin
    s=0*yy	;use as many elements as are available and/or necessary
    if ns le nx then s(0)=sigma else s(*)=sigma(0:nx-1)
  endelse					;ns=1)
endelse						;SIGMA}
if not keyword_set(nsigma) then nsig=1. else nsig=float(nsigma)

;	initialize
ilm=lonarr(nx)-1L			;Indices where Local Maxima exist

;	sort inputs in ascending order of abscissa
oo=sort(xx) & xx=xx(oo) & yy=yy(oo)

;	define the search windows
yr=lindgen(w)+1 & yl=reverse(yr)

;	find local maxima
for i=0L,nx-1L do if (where(yy(i) le yy([i-yl,i+yr])))(0) eq -1 then ilm(i)=i

;	how many are significant?
oo=where(yy lt nsig*s) & if oo(0) ne -1 then ilm(oo)=-1L

;	shorten the output
ilm=where(ilm ge 0)

return,ilm
end
