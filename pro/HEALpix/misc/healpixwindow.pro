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
function healpixwindow, nside, dim, directory = dir_usr
;+
; NAME:
;   healpixwindow
;
; PURPOSE:
;   returns the Healpix pixel window corresponding to resolution parameter Nside
;
; CATEGORY:
;
; CALLING SEQUENCE:
;   result = healpixwindow(nside, [dim, DIRECTORY=])
;
; INPUTS:
;   nside : scalar integer, should be a power of 2 in {2,4,8,16,...,8192}
;
; OPTIONAL INPUT:
;   dim  : scalar integer, dimension of the output
;     if absent or set to 0 or 1,
;          the output has size (lmax+1) and is the temperature window function
;     if set to >= 2 <= 4,
;          the output has size (lmax+1,dim)
;          and contains in that order the TEMPERATURE window function,
;          the GRAD/ELECTRIC polarisation window function
;          the CURL/MAGNETIC polarisation window function
;          the TEMPERATURE*GRAD window function
;
;   DIRECTORY : directory in which the pixel window file is looked for
;       ( $HEALPIX/data/ by default)
;
; OUTPUTS:
;   result = Healpix pixel window corresponding to resolution parameter Nside
;
; PROCEDURE:
;   reads the file $HEALPIX/data/pixel_window_n*.fits unless specified otherwise
;   by DIRECTORY
;
; EXAMPLE:
;   wpix = healpixwindow(1024)
;
; MODIFICATION HISTORY:
;     version 1.0, EH, Caltech, 11-1999
;     version 1.1, EH, Caltech, 2002-08
;        uses !healpix variable
;        deals with polarized pixel window function
;
;-

syntax = 'Window = healpixwindow (nside [, dim, DIRECTORY=])'
defsysv, '!healpix', exists = exists
if (exists ne 1) then init_healpix

ns = long(nside)
routine = 'HEALPIXWINDOW'

; check nside
err = 0
npix = nside2npix(ns,err=err)

; test, complain and exit
if (err ne 0) then begin
    print,routine +': invalid Nside ',nside
    return,-1
endif

if (ns le 1) then begin
    print,routine +print,'Nside out of range ',nside
    return,-1
endif

; form file name
snside = string(ns,form='(i4.4)')
file1 = 'pixel_window_n'+snside+'.fits'

if (defined(dir_usr)) then begin
    file = dir_usr+file1
    junk=findfile(file,count=count)
    if (count eq 0) then begin
        file = dir_usr+'/'+file1
        junk=findfile(file,count=count)
        if (count eq 0) then begin
            print,'Could not find the file '+file
            print,' in the directory '+dir_usr
            message,'Abort'
        endif
    endif
endif else begin
    dir = !healpix.directory
    if (strtrim(dir) eq '') then begin
        print,'The Unix system variable HEALPIX is not correctly defined'
        print,'It should contain the full path to the Healpix directory'
        message,'Abort'
    endif

    file = dir+'/data/'+file1

    junk=findfile(file,count=count)
    if (count eq 0) then begin
        print,'Could not find the file '+file
        print,'Are you sure the Healpix system variable is correcly defined'
        print,'current value HEALPIX = '+!healpix.directory
        message,'Abort'
    endif
endelse

; read in file data
read_fits_map, file, w1,/silent

nc = n_elements(w1[0,*])

if (n_params() eq 2) then begin
    ndim = nint(dim)

    if (ndim lt 0 or ndim gt 4) then begin
        message,syntax,/info
        message,' Invalid dim : '+string(dim)+' (should be in [0, 4])'
    endif

    if (ndim eq 0) then begin
        wpix = w1
    endif else begin
        if (nc eq 1) then begin
            print,'The polarization information is not available in the file'
            print,file
            print,'Please make sure you are using the most recent version of that file.'
            message,'Abort'
        endif else begin
            wfull = [ [w1[*,0]],[w1[*,1]],[w1[*,1]],[sqrt(w1[*,0]*w1[*,1])]]
            wpix = wfull[*,0:ndim-1]
        endelse
     endelse

endif else begin
    wpix = w1
endelse

; exit
return,wpix
end
