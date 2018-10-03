PRO ZE_CMFGEN_READ_MOD_SUM,modsum_file,modsum
;reads MOD_SUM file from a CMGEN model to string array called modsum
print,'mod ', modsum_file
nlines=FILE_LINES(modsum_file)
modsum=strarr(nlines)
OPENR,88,modsum_file;,/Get_lun
readf,88,modsum
CLOSE,88
END
