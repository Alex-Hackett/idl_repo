; -----------------------------------------------------------------------------
;
;  Copyright (C) 1997-2008  Krzysztof M. Gorski, Eric Hivon, Anthony J. Banday
;
;
;
;
;
;  This file is part of HEALPix.
;
;  HEALPix is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  HEALPix is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with HEALPix; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
;  For more information about HEALPix see http://healpix.jpl.nasa.gov
;
; -----------------------------------------------------------------------------
PRO read_tqu, fitsfile, TQU, EXTENSION=extension_id, HDR = hdr, XHDR = xhdr, HELP = help, NSIDE=nside, ORDERING=ordering, COORDSYS=coordsys

;+
; NAME:
;    read_tqu
;
; PURPOSE:
;    reads a temperature+polarization Healpix map (T,Q,U)  from a
;    binary table FITS file
;    with optionally the error (dT,dQ,dU) and correlation (dQU, dTU, dTQ)
;    from separate extensions
;
; CALLING SEQUENCE:
;    READ_TQU, fitsfile, TQU, EXTENSION=, HDR = , XHDR = , HELP =, NSIDE=, ORDERING=, COORDSYS=
; 
; INPUTS:
;    fitsfile = String containing the name of the file to be read   
;
; OPTIONAL INPUTS:
;    Extension : extension to be read (0 based)
;         if absent, all the extensions found are read
;
; KEYWORDS:
;    Help : if set, provides help on routine
;
; OUTPUTS:
;
;   TQU : array of Healpix maps of size (npix,3,n_ext) where npix is the total
;   number of Healpix pixels on the sky, and (n_ext <=3) the number of
;   extensions read
;     3 maps are present in each extension of the FITS file : 
;      -the temperature+polarization Stokes parameters maps (T,Q,U) in extension 0
;      -the error maps (dT,dQ,dU) in extension 1 (if applicable)
;      -the correlation maps (dQU, dTU, dTQ) in extension 2 (if applicable)
;
;
; OPTIONAL OUTPUT KEYWORDS:
;       HDR      = String array containing the header of the FITS file.
;       XHDR     = String array containing the extension header(s). If 
;                  several extensions are read, then the extension 
;                  headers are returned appended into one string array.
;
;       NSIDE = Healpix resolution parameter read from FITS file, set to -1 if
;          not found
;
;       ORDERING = pixel ordering, as read from FITS header, either 'RING' or
;          'NESTED' or ' ' (unkwnown)
;
;       COORDSYS = astrophysical coordinate system used, as read from FITS
;          header (value of keywords COORDSYS or SKYCOORD)
;
; EXAMPLE:
;
;
; PROCEDURES CALLED:
;       DOC_LIBRARY, FILE_TEST, FITS_INFO, HEADFITS, SELECTREAD
;
; MODIFICATION HISTORY:
;       Dec 2002, E. Hivon (McMurdo)
;       Feb 2005, EH, replaces READ_FITS_S by faster SELECTREAD
;       May 2005, EH, replaces FINDFILE by FILE_TEST
;
; requires the THE IDL ASTRONOMY USER'S LIBRARY 
; that can be found at http://idlastro.gsfc.nasa.gov/homepage.html
;
;-

if (keyword_set(help)) then begin
    doc_library,'read_tqu'
    return
endif

syntax = 'SYNTAX : READ_TQU, fitsfile, TQU, [Extension=, Hdr=, Xhdr=, Help=, NSIDE=, ORDERING=, COORDSYS=]'
if n_params() eq 0 then begin
    print,syntax,form='(a)'
    return
end
if n_params() ne 2 then begin
    print,syntax,form='(a)'
    message,'Not enough argument, no file read'
endif

if (not file_test(fitsfile)) then message,'file '+fitsfile+' not found'

; run astrolib routine to set up non-standard system variables
defsysv, '!DEBUG', EXISTS = i  ; check if astrolib variables have been set-up
if (i ne 1) then astrolib      ; if not, run astrolib to do so

fits_info, fitsfile, /silent, n_ext = n_ext

if undefined(extension_id) then begin
    x0 = 0
    xf = n_ext - 1
endif else begin
    if (extension_id + 1) gt n_ext then begin
        print,' Requested extension ',extension_id,' (0 based) from ',fitsfile
        print,' Only found ',n_ext,' extensions.'
        message,' Abort'
    endif else begin
        x0 = extension_id
        xf = x0
        n_ext = 1
    endelse
endelse
hdr  = HEADFITS(fitsfile)
;print,' Reading ',n_ext,' extension(s) from ',fitsfile

; -------- extension -----------

; simply read the extensions from the FITS file
savehdr = ''
for i = 0,xf-x0 do begin
;     read_fits_s, fitsfile, prim_stc, xten_stc, exten=i+x0

;     nmaps = n_tags(xten_stc) - 1
;     if (nmaps ne 3) then begin
;         print,' WARNING : ',nmaps,' maps available in extension ',i+x0,' of '+fitsfile
;         print,'      Expected 3'
;     endif
;     xhdr = xten_stc.(0)
;     if (i eq 0) then begin
;         nside  = LONG(       SXPAR(xhdr,'NSIDE',count=count  ))
;         if (count eq 0) then nside = -1
;         ordering =  strupcase(strtrim(SXPAR(xhdr,'ORDERING', count=count),2))
;         if (count eq 0) then ordering = ' '
;         coordsys = sxpar(xhdr,'COORDSYS', count=count)
;         if (count eq 0) then coordsys = sxpar(xhdr,'SKYCOORD', count=count)
;         if (count eq 0) then coordsys = sxpar(hdr,'COORDSYS', count=count)
;         if (count eq 0) then coordsys = sxpar(hdr,'SKYCOORD', count=count)
;         if (count eq 0) then coordsys = ' ' else coordsys = strtrim(coordsys,2)
;     endif

;     savehdr = [savehdr,xhdr]
;     npix = n_elements(xten_stc.(1)) 
;     if (i eq 0) then begin
;         tqu = fltarr(npix,nmaps,n_ext)
;     endif
;     for j=1,nmaps do begin
;         tqu[*,j-1,i] = xten_stc.(j)
;     endfor

    ; read data
    if (n_ext eq 1) then begin
        ; if only 1 extension: read directly into TQU
        selectread, fitsfile, tqu, header = xhdr, exten=i+x0, /no_pdu
        nmaps = n_elements(tqu[0,*])
    endif else begin
        ; if several extensions, read into tmp array, TO BE IMPROVED
        selectread, fitsfile, tmp, header = xhdr, exten=i+x0, /no_pdu
        npix  = n_elements(tmp[*,0])
        nmaps = n_elements(tmp[0,*])
        if (i eq 0) then begin
            tqu = fltarr(npix,nmaps,n_ext)
        endif else begin
            if (npix ne npix_old or nmaps ne nmaps_old) then begin
                message,'Extensions are not consistent in '+fitsfile
            endif
        endelse
        tqu[0,0,i] = tmp
        npix_old = npix
        nmaps_old = nmaps
    endelse

    if (nmaps ne 3) then begin
        print,' WARNING : ',nmaps,' maps available in extension ',i+x0,' of '+fitsfile
        print,'      Expected 3'
    endif

    ; deal with header
    hdr_merge = [hdr, xhdr] ; to be compatible with WMAP
    if (i eq 0) then begin
        nside  = LONG(       SXPAR(hdr_merge,'NSIDE',count=count  ))
        if (count eq 0) then nside = -1
        ordering =  strupcase(strtrim(SXPAR(hdr_merge,'ORDERING', count=count),2))
        if (count eq 0) then ordering = ' '
        coordsys = sxpar(hdr_merge,'COORDSYS', count=count)
        if (count eq 0) then coordsys = sxpar(hdr_merge,'SKYCOORD', count=count)
        if (count eq 0) then coordsys = sxpar(hdr,'COORDSYS', count=count)
        if (count eq 0) then coordsys = sxpar(hdr,'SKYCOORD', count=count)
        if (count eq 0) then coordsys = ' ' else coordsys = strtrim(coordsys,2)
    endif

    savehdr = [savehdr,xhdr]

endfor

xhdr = savehdr

; Exit routine
Exit:
return
end



