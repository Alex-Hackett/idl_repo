PRO ZE_READ_STIS_DATA_FROM_JOHN,filename,lambda,flux,mask

data=read_ascii(filename, MISSING_VALUE=0.,DATA_START=17)

lambda=REFORM(data.field1[0,*])
flux=REFORM(data.field1[1,*])
mask=REFORM(data.field1[2,*])

END
