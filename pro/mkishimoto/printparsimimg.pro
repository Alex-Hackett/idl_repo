pro printparsimimg, imgorg

nim = n_elements(imgorg)

for i=0, nim-1 do begin
  img = imgorg[i]

  print, '-------------------------------------------------------------'
  print, 'MODEL', i
  print, 'wavelength               (micron):', img.lam_um
  print, 'pixel size                  (mas):', img.xpixsize
  print, 'FOV                         (mas):', img.xpixsize *img.nx
  print, 'sp.freq sampling interval (1/mas): 1 /', img.xpixsize *img.nx
  print, 'highest spatial freq      (1/mas): 1 /', 2 *img.xpixsize
  print, 'model                            :', img.model

  case img.model of
    'torus': begin
      print, 'r_in        (mas):', img.rdin
      print, 'r_out       (mas):', img.rdout
      print, 'density index r^-:', img.beta
      print, 'abs eff index nu^:', img.gam
      end
    'ring': begin
      print, 'radius     (mas):', img.rdeff
      print, 'width FWHM (mas):', img.wdust
      end
    else: begin
      print, 'r_eff      (mas):', img.rdeff
    end
  endcase

endfor

return
end

