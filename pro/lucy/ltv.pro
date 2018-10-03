pro ltv, image, win, imscale

COMMON chars,   log_unit
COMMON display, z1, z2, z1Field, z2Field, autoscale, bdelay, biter, bcount

; display result as linear or log(image) zoomed to 512x512 if dimensions 
; are 256x256

  WSET, win
  colors = min([!d.n_colors, 255])
  if (imscale EQ 1) $
    then img = alog10(image>min(image(where(image GT 0)))) $
    else img = image
  imsiz = size(image)
  if (imsiz[1] EQ 256 AND imsiz[2] EQ 256) $
    then tv, bytscl(rebin(img, 512, 512, sample=1),top=colors-1,$
	min=z1,max=z2) $
    else tv, bytscl(congrid(img,512,512),top=colors-1,min=z1,max=z2)
  return
end
