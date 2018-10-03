pro rtv, image, win, imscale

COMMON chars,   log_unit
COMMON display, z1, z2, z1Field, z2Field, autoscale, bdelay, biter, bcount

; display raw scaled linearly or logarithmically 
; if dimensions are greater than 256x256 rebin to 256x256

  WSET, win
  colors = min([!d.n_colors, 255])
  if (imscale EQ 1) $
    then img = alog10(image>min(image(where(image GT 0.)))) $
    else img = image
  imsiz = size(image)
  if autoscale eq 1 then begin
    c = zscale(img, 10.0)
    z1 = c[0]
    z2 = c[1]
    Widget_Control, z1Field, set_value = z1
    Widget_Control, z2Field, set_value = z2
    print, z1, z2
  endif
  if ((imsiz(1) LE 256) AND (imsiz(2) LE 256)) $
    then tv, bytscl(img,top=colors-1,min=z1,max=z2) $
    else tv, bytscl(congrid(img, 256, 256),top=colors-1,min=z1,max=z2)
return
end
