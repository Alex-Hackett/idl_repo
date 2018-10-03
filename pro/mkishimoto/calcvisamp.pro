function calcvisamp, pix, imh, xcen=xcen, ycen=ycen, $
  imhvis=imhvis, phase=phase, real=real, imag=imag

nx = (size(pix, /dim))[0]
ny = (size(pix, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

if keyword_set(xcen) and keyword_set(ycen) then begin
  pix_sh = shift(pix, -xcen, -ycen)
endif else begin
  pix_sh = pix
endelse

trans = fft(pix_sh)

; determine shift amount - even -> nx/2 - 1, odd -> (nx-1)/2
xshiftamount = fix(nx/2. - 0.5)
yshiftamount = fix(ny/2. - 0.5)

strans = shift(trans, xshiftamount, yshiftamount)

imag   = imaginary(strans)
real   = real_part(strans)

visamp = abs(strans)
phase  = atan(strans, /phase)

if keyword_set(imh) then begin

  xfov=imh.xend - imh.xstart & xpixsize = 1./xfov
  yfov=imh.yend - imh.ystart & ypixsize = 1./yfov

  posx = (dindgen(nx) - xshiftamount) *xpixsize
  posy = (dindgen(ny) - yshiftamount) *ypixsize

  imhvis=allocimh()
  imhvis.xstart = min(posx) - xpixsize *0.5
  imhvis.xend   = max(posx) + xpixsize *0.5
  imhvis.ystart = min(posy) - ypixsize *0.5
  imhvis.yend   = max(posy) + ypixsize *0.5

endif

return, visamp
end

