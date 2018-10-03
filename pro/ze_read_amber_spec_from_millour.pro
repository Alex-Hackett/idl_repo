PRO ZE_READ_AMBER_SPEC_FROM_MILLOUR,filename,lambda,flux,lambda_err
data=read_ascii(filename,DATA_START=1, MISSING_VALUE=0.)
count=(size(data.field1))[2]
lambda=dblarr(count)
lambda_err=lambda
flux=lambda
flux[*]=data.field1[0,*]
lambda_err[*]=data.field1[1,*]
lambda_err=lambda_err*1E10
lambda[*]=data.field1[2,*]
lambda=lambda*1E10
END

