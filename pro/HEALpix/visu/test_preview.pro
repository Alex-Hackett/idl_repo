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
pro find_in_path, file, finalpath, count, crash_on_error=crash
;+
;
; look for a specified file in !path
;
; Mar 2006: added comments before crash
;_

version = float(!version.release)
if (version ge 5.3) then begin
    listpath = strsplit(!path,':',/extract)
endif else begin
    listpath = str_sep(!path,':')
endelse
nl = n_elements(listpath)
for i=0, nl-1 do begin
    fullpath = filepath(file,root=listpath[i])
    finalpath = findfile(fullpath,count=count)
    if count gt 0 then goto, found
endfor

comments=["-----------------------------------------------------------------------------",$
          "You can choose the facilities used to visualize Postscript, PNG and GIF files",$
          "and the hard copy paper size,",$
          "by running the config_preview script in the main Healpix directory.",$
;          "           (no need to restart IDL ;-)",$
          "-----------------------------------------------------------------------------"]

print,comments,form='(a)'
if (keyword_set(crash)) then message, file+' not found'

found :

return
end
    
;=====================================================

pro test_preview, count,crash_on_error=crash
;+
; look for idl_default_previewer.pro in !path
; if not found issues a warning and/or crash
;
;-

prevdef = 'idl_default_previewer.pro'
find_in_path, prevdef,finalpath,count,crash_on_error=crash


if (count eq 0) then begin
    message,/info,prevdef+' not found,'
    message,/info,'can not preview file.'
    message,/info,'Run ./config_preview in Healpix main directory'
endif

return
end
