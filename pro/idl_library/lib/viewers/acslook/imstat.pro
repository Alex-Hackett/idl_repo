;+
; NAME:
;	imstat.pro
;
; PURPOSE:
;	This procedure calculates image statistics.
;
; CALLING SEQUENCE:
;	imstat, image, output
;
; INPUT:
;	image:	Image to compute statistics on.
;
; OUTPUT:
;      output:	IDL structured variable containing the output statistics:
;		{NPIX, MIN, MAX, MEAN, MEDIAN, STANDDEV}
;	
; HISTORY:
;	Written by: Terry Beck		ACC		28 Nov 94
;-
;______________________________________________________________________________

pro imstat, image, output

s = size(image)

standev = stdev(image, mean)
npix = s(1)*s(2)
minimum = min(image)
maximum = max(image)
med = median(image)

output = {npix:npix, min:minimum, max:maximum, mean:mean, median:med, $
    standdev:standev}

return
end
