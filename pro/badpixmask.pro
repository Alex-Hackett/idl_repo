pro badpixmask

;get filenames of image files to have bad pixels masked
filenames = dialog_pickfile(/multiple_files, filter = '*.fits', $
                            title = 'FITS files to have bad pixels masked')
;how many images?
nimages = n_elements(filenames)
;get filename of the pixel map file to use
map = dialog_pickfile(title = 'bad pixel map FITS file', filter = '*.fits')
;get path where masked files are to be written
bpm_path = dialog_pickfile(title = $
                          'choose directory to write masked FITS', $
                          /directory)
;read in bad pixel map image, convert to float
map = float(mrdfits(map, 0, header, /unsigned))
;create a 1024 by 1024 array of 1's
map2=replicate(1,1024,1024)
;put the bad pixel map in the center (for map's without border pixels only)
;give the bad pixel map '1 valued' border pixels
map2[4:1019,4:1019] = map
FOR i = 0, nimages-1 DO BEGIN
;for each image file
;read in image, convert to float; get header as well
   image = float(mrdfits(filenames[i], 0, header, /unsigned))
;convert '0 valued' bad pixels to not a number value
image[where(map2 eq 0)] = !values.f_nan
;mapstack = rebin(map2,1024,1024,nimages)
;strip directory path from image filename (oth element)
   file_nopath = reverse(strsplit(filenames[i], '/', /extract))
;strip off .fits suffix
   file_begin = strsplit(file_nopath[0], '.fits', /extract, /regex)
;add write path and _ds.fits suffix
 bpm_filename = file_begin[0] + '_masked.fits'
;write masked image and original image header to file
   print, 'WRITING TO ' + bpm_filename
   mwrfits, image, bpm_filename, header
ENDFOR
END