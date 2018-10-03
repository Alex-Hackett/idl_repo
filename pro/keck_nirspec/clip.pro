;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Apply the trimmed sigma-clipping method to a data vector.
  

;===============================================================================
PRO clip, data, clipflag, sigmafactor, trimfrac, minfrac

;;; data	: input vector
;;; clipflag	: output vector with the same size as 'data'; clipped data will
;;;		  have a value of 0; otherwise, 1.
;;; sigmafactor	: data outside sigmafactor*stdev from the mean will be clipped
;;;		  out.
;;; trimfrac	: fraction of data to be trimmed before calculating an average
;;; minfrac	: minimum fraction of data that should not be clipped

COMPILE_OPT idl2, hidden

ndata=N_ELEMENTS(data)
minn=fix(ndata*minfrac)
clipflag=intarr(ndata)+1
maxiter=100

indxnow=indgen(ndata)
datanow=data
nnow=ndata

for iter=0,maxiter-1 do begin
  sortnow=sort(datanow)
  trima=fix(nnow*trimfrac/2.)
  trimb=fix(nnow*(1.-trimfrac/2.))-1
  trimb=max([trima,trimb])
  datatemp=datanow[sortnow[trima:trimb]]
  result=moment(datatemp)
  mean=result[0]
; SZK: Need to check why there is a non-standard definition of
;      Standard Deviation. The easiest definition would have 
;      been "stan_dev=sqrt(result[1])"
  stan_dev=sqrt(total((datanow-mean)^2)/nnow)
;  stan_dev=sqrt(result[1])
  sortdev=reverse(sort(abs(datanow-mean)))
  nnowsoon=nnow
  for i=0,nnow-1 do begin
    if abs(datanow[sortdev[i]]-mean) gt abs(sigmafactor*stan_dev) then begin
      nnowsoon=nnowsoon-1
      if nnowsoon lt minn then goto, jump1
      clipflag[indxnow[sortdev[i]]]=0
    endif
  endfor
  if nnowsoon eq nnow then goto, jump1
  nnow=nnowsoon
  indxnow=where(clipflag eq 1)
  datanow=data[indxnow]
  nnow=N_ELEMENTS(datanow)
endfor

jump1:

END
