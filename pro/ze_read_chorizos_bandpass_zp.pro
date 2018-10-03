PRO ZE_READ_CHORIZOS_BANDPASS_ZP,band,lambda,pass,passband,zp
;reads chorizos bandpasses and zeropoints

CASE band of

'U': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_u.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.055   ;form Maiz-Appelaniz Chorizos
END

'B': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_b.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.034   ;form Maiz-Appelaniz Chorizos
END

'V': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_v.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.026   ;form Maiz-Appelaniz Chorizos
END

'R': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_r.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.030   ;form Maiz-Appelaniz Chorizos
END

'I': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_i.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.017   ;form Maiz-Appelaniz Chorizos
END

'J': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_j.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=-0.021   ;form Maiz-Appelaniz Chorizos
END

'H': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_h.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.009   ;form Maiz-Appelaniz Chorizos
END

'Ks': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_ks.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F170W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f170w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END


'WFPC2_F300W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f300w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END


'WFPC2_F336W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f336w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F450W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f450w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F555W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f555w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F606W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f606w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F814W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f814w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

ENDCASE

END