pro setvis1d, img

; assuming the pixel img.vis[img.xcen, img.ycen] is the image center of
; the visibility image, take visibility values along the +x-axis
; from this pixel 

img.vis1d = img.vis[img.xcen:*, img.ycen]
img.phs1d = img.phs[img.xcen:*, img.ycen]
img.phs1ddeg = img.phsdeg[img.xcen:*, img.ycen]

; calc corresponding x
pos       = pixelpos(img.vis, img.imhvis); , /onlyinfo)
img.sfreq = pos.x[img.xcen:*, img.ycen]

;img.appix = lindgen(img.nx - img.xcen)
;img.sfreq = pos.dx *img.appix

; assume lam_um in micron, sfreq in mas^-1
; convert mas^-1 to radian^-1
from_rad_to_mas = 1./!dpi *180. *3600. *1000.

img.u        = img.sfreq *from_rad_to_mas  ; in rad^1 or in units of lambda_obs
img.baseline = img.u *img.lam_um *1.d-6    ; in meter

img.sfreq_to_bline = from_rad_to_mas *img.lam_um *1.d-6

return
end
 

