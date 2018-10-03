;PRO ZE_ETACAR_CMFGEN_WORK_OPTICAL_DEPTH_HALPHA
!P.Background = fsc_color('white')

CMFGEN_TO_AU=1/(1.49e3)

linedata_file='/Users/jgroh/ze_models/etacar/mod43_groh/LINEDATA'
ZE_CMFGEN_READ_LINEDATA_FROM_DISPGEN,linedata_file,freq,r,t,sigma,v,eta,chi_th,esec,etal,chil,nd
ZE_CMFGEN_COMPUTE_TAUL,freq,nd,chil,r,v,sigma,taul,ELEC=0,RADS=1

chil2d=chil
chil2d[0:28]=1e-20
ZE_CMFGEN_COMPUTE_TAUL,freq,nd,chil2d,r,v,sigma,taul2d,ELEC=0,RADS=0

dtaul=dblarr(nd)
dtaul[0]=-12
FOR I=1, nd -1 do BEGIN 
diff=10^(taul[i]) - 10^(taul[i-1])
IF diff le 0. THEN dtaul[i]=-15 ELSE dtaul[i]=alog10(diff)

ENDfOR
;FOR I=1, nd -1 do dtaulor[i]=alog10((10^(taul[i]) - 10^(taul[i-1]))/r[)

taul2=dblarr(nd)
taul2[0]=1e-5
for i=1, nd -1 do taul2[i]=taul2[i-1]+10^dtaul[i-1]   ;WORKING, assumes DTAUC is in log scale

;lineplot,alog10(r/r[nd-1]),taul
;lineplot,alog10(r/r[nd-1]),dtaul

lineplot,r*CMFGEN_TO_AU,taul
lineplot,r*CMFGEN_TO_AU,taul2d

END