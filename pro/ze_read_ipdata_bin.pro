FUNCTION ZE_READ_IPDATA_BIN,file,arrsize
data=DBLARR(1, arrsize)
OPENR, lun, file, /GET_LUN
READU, lun, data
RETURN,data
CLOSE,lun
END
