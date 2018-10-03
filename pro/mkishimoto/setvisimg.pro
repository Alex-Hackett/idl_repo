pro setvisimg, img

; calculate visibility amplitudes
img.visobs = calcvisamp(img.obs, img.imh, imhvis=imhvis)
imhvis.xname='spatial frequency (mas!U-1!N)'
imhvis.yname='spatial frequency (mas!U-1!N)'
img.vispsf = calcvisamp(img.psf)

;img.vis    = img.visobs /img.vispsf

img.vis = calcvisamp(img.pix, xc=img.xcen,yc=img.ycen, $
          phase=phase, real=real, imag=imag)
img.vis = img.vis / max(img.vis)
img.phs = phase
img.phsdeg = phase *(180.d /!dpi)
img.visreal = real
img.visimag = imag
img.imhvis = imhvis

return
end

