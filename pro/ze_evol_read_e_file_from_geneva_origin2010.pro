PRO ZE_EVOL_READ_E_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_efile,header_efile,num_model=num_model
;reads xxx.e* files that are output from Geneva Stellar Evolution code, Origin2010
;modeldir should not contain a trailing '/'
;assumes v file contains 93 columns and 10 models

model=STRMID(modeldir,strpos(modeldir,'/',/REVERSE_SEARCH) +1)
efile=modeldir+'/'+model_name+'.e'+strcompress(string(timestep, format='(I07)')) 

nlines_efile=file_lines(efile)
nshell_e=(nlines_efile-10)/10.
print,nshell_e
print,'Reading the following .e file:  ', efile
header1=''
header_efile=''
OPENR,lun,efile,/get_LUN
readf,lun,header_efile
readf,lun,data_efile
CLOSE,lun

IF KEYWORD_SET(num_model) THEN data_efile_str=read_ascii(efile,COMMENT_SYMBOL='#',num_records=nshell_e,missing_value=-1e3,data_start=(num_model-1)*nshell_e) ELSE BEGIN
 data_efile_str=read_ascii(efile,COMMENT_SYMBOL='#',num_records=nshell_e,missing_value=-1e3)
ENDELSE

data_efile=data_efile_str.field01

print,'Finished reading the following .e file:  ', efile

END