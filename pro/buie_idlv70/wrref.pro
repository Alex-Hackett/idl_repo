;+
; NAME:
;  wrref
; PURPOSE:   (one line only)
;  Write a astrometry support (.ref) file.
; DESCRIPTION:
; CATEGORY:
;  File I/O
; CALLING SEQUENCE:
;  wrref,file,ref,error
; INPUTS:
;  file - Name of file to be written
;  ref  - Anonymous structure that contains the information read from file.
;            Tags in structure always provided:
;              objrad - object aperture radius (pixels)
;              nstars - Number of stars in the list
;            Tags needed if nstars > 0
;              xpos    - float, X position of star
;              ypos    - float, Y position of star
;              fwhm    - float, FWHM of object (pixels)
;              mag     - float, instrumental magnitude of star
;              err     - float, uncertainty on magnitude
;              sig_max - float, DN value of peak pixel in image
;              ra      - double, RA of star (radians)
;              dec     - double, Dec of star (radians)
;              catmag  - float, Catalog magnitude for star
; OPTIONAL INPUT PARAMETERS:
; KEYWORD INPUT PARAMETERS:
; OUTPUTS:
;  error  - Flag, if set indicates there was a problem writing the file.
; KEYWORD OUTPUT PARAMETERS:
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;  Written 2008/10/31 by Marc W. Buie, Southwest Research Institute.
;-
pro wrref,file,ref,error

   self='wdref: '
   if badpar(file,7,0,caller=self+'(file) ') then return
   if badpar(ref,8,1,caller=self+'(ref) ') then return

   on_ioerror,bad

   ; Write the object radius and number of stars to the file
   lun = -100
   openw,lun,file,/get_lun
   writeu,lun,swap_endian(ref.objrad,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.nstars,/swap_if_little_endian)

   if ref.nstars eq 0 then goto,done

   writeu,lun,swap_endian(ref.xpos,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.ypos,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.fwhm,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.mag,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.err,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.sig_max,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.ra,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.dec,/swap_if_little_endian)
   writeu,lun,swap_endian(ref.catmag,/swap_if_little_endian)

   error=0
   goto,done

bad:
   print,self,'File name - ',file
   print,!error_state.msg
   print,!error_state.sys_msg
   error=1

done:
   if lun ge 100 then free_lun,lun

end
