;PRO ZE_TIMEDEP_ARMAGH_WORK_OPTICAL_DEPTH_HALPHA
!P.Background = fsc_color('white')

linedata_file='/Users/jgroh/ze_models/timedep_armagh/8/LINEDATA'
ZE_CMFGEN_READ_LINEDATA_FROM_DISPGEN,linedata_file,freq,r,t,sigma,v,eta,chi_th,esec,etal,chil,nd
ZE_CMFGEN_COMPUTE_TAUL,freq,nd,chil,r,v,sigma,taul,ELEC=0,RADS=1

dtaul=dblarr(nd)
dtaul[0]=0
FOR I=1, nd -1 do dtaul[i]=alog10(10^(taul[i]) - 10^(taul[i-1]))
;FOR I=1, nd -1 do dtaulor[i]=alog10((10^(taul[i]) - 10^(taul[i-1]))/r[)

;lineplot,alog10(r/r[nd-1]),taul
;lineplot,alog10(r/r[nd-1]),dtaul

lineplot,v,dtaul

END