PRO ZE_VH1_READ_VH1_OUT,dir,vh1_out_array
;routine to read output file vh1.out from a 1-D VH-1 run.
CLOSE,/ALL

;ZE_VH1_READ_INDAT,dir,['imax','tprin','endtime'],val_quant
ZE_VH1_READ_INDAT,dir,'imax',imax
ZE_VH1_READ_INDAT,dir,'tprin',tprin
ZE_VH1_READ_INDAT,dir,'endtime',endtime

OPENR,1,dir+'tdsw.init'
READF,1,ncol,dummy,dummy,initime
CLOSE,1

vh1_out_array=dblarr(ncol+1,imax,(endtime-initime)/tprin)

OPENR,1,dir+'vh1.out'
READF,1,vh1_out_array
CLOSE,1

END