FUNCTION READ_PGPLOT_BIN,file,arrsize
data=DBLARR(1, arrsize)
OPENR, lun, file, /GET_LUN
READU, lun, data
RETURN,data
CLOSE,lun
END
;*****************************************
PRO WRITE_PGPLOT_TXT,data_bin,file_txt
OPENW,2,file_txt
PRINTF,2,data_bin
CLOSE,2
END
;*****************************************

;PRO ZE_EVOL_PLOT
filename_pgplot_bin='/Users/jgroh/evol_models/Z014/P020z14S0/.PlotData_P020z14S0'
arrsize=10000
pgplot_txt=READ_PGPLOT_BIN(filename_pgplot_bin,arrsize)
WRITE_PGPLOT_TXT,pgplot_txt,'/Users/jgroh/temp/P020z14S0_plotdata.txt'




END