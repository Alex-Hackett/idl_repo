PRO ZE_READ_SPECTRA_COL_VEC,file,lambda,flux,nrec,skip_lines=skip_lines

IF (skip_lines GT 0) THEN print,'Skipping first ',skip_lines,' lines' ELSE skip_lines=0
;  If no file specified, use DIALOG_PICKFILE
;
if (n_elements(file) eq 0) then begin
  file = DIALOG_PICKFILE(/MUST_EXIST)
  ;if (file eq '') then RETURN, 0
endif

data = READ_ASCII(file,record_start=skip_lines)
lambda=dblarr((SIZE(data.field1))[2]) & flux=lambda
lambda[*]=data.field1[0,*]
flux[*]=data.field1[1,*]
nrec=(SIZE(flux))[2]
END
;--------------------------------------------------------------------------------------------------------------------------
