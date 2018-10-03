function roofn,m,n,floor=floor,pwr=pwr, _extra=e
;+
;function	roofn
;	returns the smallest integer greater than the specified number
;	that is a power of the specified base.
;
;syntax
;	nroof=roofn(m,n,floor=floor,pwr=pwr)
;
;parameters
;	m	[INPUT; required] integer to "round up"
;	n	[INPUT; default=2] base
;
;keywords
;	floor	[INPUT] if set, returns the largest integer LESS THAN M
;		that is a power of N.
;	pwr	[OUTPUT] the appropriate index [N^(PWR)]
;	_extra	[JUNK] here only to prevent crashing the program
;
;history
;	vinay kashyap (April 1995)
;	added keyword _EXTRA (VK; Mar99)
;	cleaned up a bit (VK; Apr99)
;	cleaned up some more (VK; Dec07)
;-

;	usage
ok='ok' & np=n_params() & n_m=n_elements(m) & n_n=n_elements(n)
if np lt 2 then ok='insufficient parameters' else $
 if n_m eq 0 then ok='M: missing number' else $
  if n_m gt 1 then ok='M: cannot be an array' else $
   if m[0] ge 2L^(30) then ok='M: too large to handle'
;n_m=n_elements(m) & mm=abs(m) & n_n=n_elements(n)
;if np lt 2 then ok='insufficient parameters' else $
; if n_m eq 0 then ok='M: missing number' else $
;  if n_m gt 1 then ok='M: cannot be an array' else $
;   if mm ge 2L^(30) then ok='M: too large to handle' else $
;    if mm lt 0 then ok='M: cannot be negative'
if ok ne 'ok' then begin
  print, 'Usage: nroof=roofn(m,n,pwr=pwr) & nfloor=roofn(m,n,/floor,pwr=pwr)'
  print, '  returns the nearest integer (higher or lower) to a given integer'
  print, '  M that is a power of a specified integer N'
  if np ne 0 then message,ok,/info
  return,0L
endif
mm=abs(m)

;	check parameters
if n_n eq 0 then begin
  message,'assuming base 2',/info & n=2L
endif

mm = long(abs(m))
nn = long(abs(n))

m0 = 1L & k = 0L & diff = mm-m0

while diff gt 0 do begin
  k=k+1L & m0 = m0*nn & diff = mm-m0
endwhile
pwr = k

if keyword_set(floor) then m0 = m0/nn
if keyword_set(floor) then pwr = pwr-1

return,m0
end
