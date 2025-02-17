;+
; NAME:   
;	CONCAT_DIR
;               
; PURPOSE:     
;	To concatenate directory and file names for current OS.
; EXPLANATION:
; 	The given file name is appended to the given directory name with the 
;	format appropriate to the current operating system.
;
; CALLING SEQUENCE:               
;	result = concat_dir( directory, file) 
;
; INPUTS:
;	directory  - the directory path (string)
;       file       - the basic file name and extension (string)
;                                   can be an array of filenames.
;
; OUTPUTS:     
;	The function returns the concatenated string.  If the file input
;	is a string array then the output will be a string array also.
;               
; EXAMPLES:         
;	IDL> pixfile = concat_dir('$DIR_GIS_MODEL','pixels.dat')
;
;	IDL> file = ['f1.dat','f2.dat','f3.dat']
;	IDL> dir = '$DIR_NIS_CAL'
;	IDL> f = concat_dir(dir,file)
;
; RESTRICTIONS: 
;	Assumes Unix type format if os is not VMS or windows.
;               
; CATEGORY    
;	 Utilities, Strings
;               
; REVISION HISTORY:
; 	Prev Hist. : Yohkoh routine by M. Morrison
;	Written     : CDS version by C D Pike, RAL, 19/3/93
;	Version     : Version 1  19/3/93
;	Documentation modified Nov-94   W. Landsman 
;	Add V4.0 support for Windows    W. Landsman   Aug 95
;	Converted to IDL V5.0   W. Landsman   September 1997
;-            
;
function concat_dir, dir, filnam
;
;  Check number of parameters
;
if n_params() lt 2 then begin
   print,'Syntax - out_string = concat_dir( directory, filename)'
   print,' ' 
   return,''
endif
;
;  remove leading/trailing blanks
;
dir0 = strtrim(dir, 2)	
;
;  act according to operating system
;
if (!version.os eq 'vms') then begin
    for i=0,n_elements(dir0)-1 do begin
	last = strmid(dir0(i), strlen(dir0(i))-1, 1)
	if ((last ne ']') and (last ne ':')) then begin 
           dir0(i) = dir0(i) + ':'                       ;append an ending ':'
        endif
    endfor

endif else if (!version.os eq 'windows') or (!version.os eq 'Win32') then begin
    for i=0,n_elements(dir0)-1 do begin
	last = strmid(dir0(i), strlen(dir0(i))-1, 1)
	if (last ne '\') and (last ne ':') then begin
           dir0(i) = dir0(i) + '\'                       ;append an ending '\' 
        endif
    endfor

endif else begin
    for i=0,n_elements(dir0)-1 do begin
       if (strmid(dir0(i), strlen(dir0(i))-1, 1) ne '/') then begin
          dir0(i) = dir0(i) + '/'                        ;append an ending '/' 
       endif
    endfor
endelse
;
;  no '/' needed when using default directory
;
for i=0,n_elements(dir0)-1 do begin
   if (dir(i) eq '') then dir0(i) = ''
endfor

return, dir0 + filnam

end
