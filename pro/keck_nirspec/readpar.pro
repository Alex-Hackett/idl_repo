;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Read a single line from the parameter file.


;===============================================================================
PRO readpar, str, outfile, err, parfilename, no_parfile_error=no_parfile_error,$
    no_field_error=no_field_error, no_file_check=no_file_check, $
    no_file_error=no_file_error

;;; str		: field name (string variable; input)
;;; outfile	: content read from the parameter file (usually a file name;
;;;		      output)
;;; err		: error flag (see below; output)
;;; parfilename	: name of the parameter file (default is 'files.in'; input)
;;; no_parfile_error	: flag for neglecting no parameter file error
;;; no_field_error	: flag for neglecting no field error
;;; no_file_check	: flag for not checking the existence of the file
;;;			:     read from the parameter file
;;; no_file_error	: flag for not prompting error message when the file
;;;			:     read from the parameter file does not exist

COMPILE_OPT idl2, hidden

; err=1  : field not found
; err=2  : file specified by the field not found
; err=99 : 'files.in' not found

;;; Initialize flags.
outfile=''
if (n_elements(parfilename) eq 0) then parfilename='files.in'
if (n_elements(no_parfile_error) eq 0) then no_parfile_error=0
if (n_elements(no_field_error) eq 0) then no_field_error=0
if (n_elements(no_file_check) eq 0) then no_file_check=0
if (n_elements(no_file_error) eq 0) then no_file_error=0

;;; Open the parameter file.
get_lun,funit
openr,funit,parfilename,ERROR=err
if (err ne 0) then begin
  free_lun,funit
  err=99
  if (no_parfile_error eq 0) then $
      errmessage = DIALOG_MESSAGE("Can not find file 'files.in'.",/ERROR)
  return
endif

;;; Read all parameters.
stemp='' & strread=strarr(2,1000)
i=0
while not eof(funit) do begin
  readf,funit,stemp
  stemp2=str_sep(stemp,':',/trim)
  if n_elements(stemp2) gt 1 then begin
    strread[*,i]=stemp2[0:1]
    i=i+1
  endif
endwhile
iread=i
close,funit
free_lun,funit

;;; Find the field of request and copy its field into an output variable.
for i=0,iread-1 do begin
  if (strread[1,i] eq str) then begin
    outfile=strread[0,i]
    if (outfile ne '') then goto, jump1
  endif
endfor

if (no_field_error eq 0) then begin
  errmessage = DIALOG_MESSAGE("Can not find field '"+str+ $
			"' in file 'files.in'.",/ERROR)
endif

err=1
return


;
; File check
;

;; See if the file exists.
jump1:
get_lun,funit
if (no_file_check eq 0) then begin
  openr,funit,outfile,ERROR=err
  if (err ne 0) then begin
    if (no_file_error eq 0) then errmessage = DIALOG_MESSAGE( $
			"Can not find file '"+outfile+"'.",/ERROR)
    err=2
    free_lun,funit
    return
  endif
  close,funit
endif
free_lun,funit

END
