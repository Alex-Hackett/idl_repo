;PRO ZE_WD1_READ_MAG,file,ID,Spectype, B0,  V0,  R0,  I0,  Y0,  J0,  H0,  K0
file='/Users/jgroh/papers_in_preparation_groh/wd1_with_augusto/data_copy.txt'
header=''
id=''
spectype=''
lum=''
mag=dblarr(FILE_LINES(file),8)
openu,1,file
readf,1,header
readf,1,id,spectype,lum,B0,  V0,  R0,  I0,  Y0,  J0,  H0,  K0

close,1
;ZE_READCOL,file,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,FORMAT='(A,A,A,F,F,F,F,F,F,F,F)',SKIPLINE=1
id=v1
spectype=v2
b0=v3
v0=v4
r0=v5
i0=v6
y0=v7
j0=v8
h0=v9
k0=v10


END