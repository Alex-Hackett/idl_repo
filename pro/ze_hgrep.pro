pro ze_hgrep, header, substring,line_numbers,keepcase=keepcase, linenum=linenum,silent=silent,result=result

;+
; NAME:
;     ZE_HGREP
;
; PURPOSE:
;       Find a substring in a FITS header (or any other string array) and return line numbers
;
; CALLING SEQUENCE:
;       HGREP, header, substring, [/KEEPCASE, /LINENUM ]
;
; INPUTS: 
;       header -  FITS header or other string array
;       substring - scalar string to find in header; if a numeric value is 
;                 supplied, it will be converted to type string
;
; OPTIONAL INPUT KEYWORDS:
;       /KEEPCASE: if set, then look for an exact match of the input substring 
;                 Default is to ignore case .
;       /LINENUM: if set, prints line number of header in which
;                substring appears 
;
; OUTPUTS:
;       None, results are printed to screen
;
; EXAMPLE: 
;       Find every place in a FITS header that the word 'aperture'
;       appears in lower case letters and print the element number 
;       of the header array:
;       
;       IDL> hgrep, header, 'aperture', /keepcase, /linenum
;
; HISTORY: 
;       Written, Wayne Landsman (Raytheon ITSS)      August 1998
;       Adapted from STIS version by Phil Plait/ ACC November 14, 1997
;       Remove trailing spaces if a non-string is supplied W. Landsman Jun 2002
;       Return line numbers Jose H Groh 2012

   if (N_params() LT 2) then begin
      print,'Syntax - HGREP, header, substring, [/KEEPCASE, /LINENUM ]'
      return
   endif

   if N_elements(header) eq 0 then begin
      print,'first parameter not defined. Returning...'
      return
   endif
   hh = strtrim(header,2)
   if size(substring,/tname) NE 'STRING' then substring = strtrim(substring,2)

   if keyword_set(keepcase) then $
         flag = strpos(hh,substring) $
   else  flag = strpos(strlowcase(hh),strlowcase(substring))
     

   g = where(flag NE -1, Ng)
   line_numbers=g
   
   IF KEYWORD_SET(SILENT) THEN dummy='' ELSE BEGIN 
    if Ng GT 0 then begin
       if keyword_set(linenum) then $
           for i = 0, Ng-1 do print, string(g[i],f='(i4)') + ': ' + hh[g[i]] $
       else $
           for i = 0, Ng-1 do print,hh[g[i]] 
     endif  
   ENDELSE
   
   IF Ng GT 0 then begin
       result=strarr(Ng)
       for i = 0, Ng-1 do result[i]=hh[line_numbers[i]]
   ENDIF else result='-1000.0' ;i.e. we didn't find what we were lookng for
              
   return
   end
