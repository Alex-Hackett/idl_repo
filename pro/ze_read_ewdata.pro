PRO ZE_READ_EWDATA,ewdata_file,ewdata,nrec

;  If no file specified, use DIALOG_PICKFILE
;
if (n_elements(ewdata_file) eq 0) then begin
  ewdata_file = DIALOG_PICKFILE(/MUST_EXIST)
  ;if (ewdata_file eq '') then RETURN, 0
endif

;Restore template file
restore,'/Users/jgroh/espectros/ewdata_template.idl'

;Read the file itself, has to be in CMF_FLUX format
ewdata=READ_ASCII(ewdata_file,header=ewdata_header,count=ewdata_count,TEMPLATE=template,DATA_START=2)

;Find the number of lines of EW
t=SIZE(ewdata.lambda) & nrec=t[1]

END
;--------------------------------------------------------------------------------------------------------------------------
