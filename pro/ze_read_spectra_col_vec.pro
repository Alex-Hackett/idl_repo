PRO ZE_READ_SPECTRA_COL_VEC,file,lambda,flux,nrec

;  If no file specified, use DIALOG_PICKFILE
;
if (n_elements(file) eq 0) then begin
  file = DIALOG_PICKFILE(/MUST_EXIST)
  ;if (file eq '') then RETURN, 0
endif

data = READ_ASCII(file)
lambda=dblarr((SIZE(data.field1))[2]) & flux=lambda
lambda[*]=data.field1[0,*]
flux[*]=data.field1[1,*]
nrec=(SIZE(flux))[2]
END
;--------------------------------------------------------------------------------------------------------------------------
