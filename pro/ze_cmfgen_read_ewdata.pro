PRO ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;reads EW data file form obs dir
openu,1,ewdata     ; open file without writing

linha=''

;finds the i number of points in ewdata
i=0.
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1.
skip1:
endwhile
close,1


;declare arrays
lambdac=dblarr(i) & cont=lambdac & ew=lambdac & sob=strarr(i) & sobc=strarr(i) & id =sobc
lambdac1=0. & cont1=0. & ew1=0. & sob1='A2' 

;read lambda central, continuum intensity, EW and transition ID
ewdata_header=''
openu,1,ewdata
readf,1,ewdata_header
for k=0., i-2. do begin
readf,1,lambdac1,cont1,ew1,sob1
sob1=strsub(sob1,4,50)
lambdac[k]=lambdac1 & cont[k]=cont1 & ew[k]=ew1 & sob[k]=sob1
pos=strpos(strtrim(sob[k],1),'(')
id[k]=strmid(sob[k],4,pos)
endfor
close,1

;substitute names
names=['He2','N2','O2','C2','Fe2','Sk2','SkIII','SkIV','OSIX','OSEV','Mg2']
namesnew=['HeII','NII','OII','CII','FeII','SiII','SiIII','SiIV','OVI','OVII','MgII']
for i=0, n_elements(names) -1 DO BEGIN
 dummy_val=where(id eq names[i])
 if (where(dummy_val EQ -1) NE 0) THEN id(dummy_val)=namesnew[i]
endfor

;substitute close lines e.g. H, He I for H + HeI



END