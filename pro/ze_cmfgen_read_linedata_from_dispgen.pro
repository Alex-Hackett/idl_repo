PRO ZE_CMFGEN_READ_LINEDATA_FROM_DISPGEN,linedata_file,freq,r,t,sigma,v,eta,chi_th,esec,etal,chil,nd
CLOSE,1
Date='' & mod_id='' & tr_id='' & dif=''
OPENR,1,linedata_file
READF,1,Date
READF,1,mod_id
READF,1,tr_id
READF,1,dif
READF,1,freq
READF,1,lam
READF,1,amass
READF,1,ic
READF,1,nd
CLOSE,1

READCOL,linedata_file,r,t,sigma,v,eta,chi_th,esec,etal,chil,skipline=11
nd=n_elements(r)


END