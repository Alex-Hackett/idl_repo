PRO ZE_VH1_READ_INDAT,dir,quant,val_quant
;routine to read output file vh1.out from a 1-D VH-1 run.
CLOSE,/ALL

nlines=FILE_LINES(dir+'indat')
indat_str_array=strarr(nlines)

;read indat file
OPENR,1,dir+'indat'
READF,1,indat_str_array
CLOSE,1

n_quant=n_elements(quant)
val_quant=dblarr(n_quant)

FOR I=0, n_elements(quant) -1 DO BEGIN
len_quant=strlen(quant[i])
pos = WHERE(STRPOS(indat_str_array, quant[i]) ge 0)
val_quant_pos=STRPOS(indat_str_array[pos],'=')
val_quant_str=STRMID(indat_str_array[pos],val_quant_pos+1)
val_quant[i]=DOUBLE(val_quant_str)
ENDFOR

END