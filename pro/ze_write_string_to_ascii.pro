PRO ZE_WRITE_STRING_TO_ASCII,filename,string
;write string array to ascii file
   openw,lun2, filename, /get_lun
   for i=0, n_elements(string)-1 do printf, lun2, string[i]
   close, lun2
   free_lun, lun2
END