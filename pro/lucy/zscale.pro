
; ZSCALE -- Find the minimum and maximum values in an array
;            after rejecting "bad" values using the standard
;            deviation of the array.
;
; inputs are:
;    im    an array of numbers
;    ns    the number of standard deviations for rejection
;
; ouput    is an array of two values, the "good" minimum and "good" maximum.
;
; errors   an array containing [0.0,0.0] is returned if no data points in
;          the array are within "ns" standard deviations of it's mean.

function zscale, im, ns

  x = size(im)
  if x[0] lt 1 then return,[0.0,0.0]
  m = moment(im,sdev=sdev)
  g = where(abs(im-m(0)) lt (ns * sdev),n)

  if n gt 0 then return,[min(im(g)),max(im(g))] else return,[0.0,0.0]

end

