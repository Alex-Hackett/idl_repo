PRO ZE_READ_DATA_FROM_TOM,filename,l_over_a_for_prim,rho_prim,rho_sec,l_over_a_for_den,rho_los,vel_los,header

header=''
data=read_ascii(filename,DATA_START=1, MISSING_VALUE=0., DELIMITER=',', header=header)
count=(size(data.field1))[2]
l_over_a_for_prim=dblarr(count)
rho_prim=l_over_a_for_prim & rho_sec=rho_prim & l_over_a_for_den=rho_prim & rho_los=rho_prim & vel_los=rho_prim

l_over_a_for_prim[*]=data.field1[1,*]
rho_prim[*]=data.field1[2,*]
rho_sec[*]=data.field1[3,*]
l_over_a_for_den[*]=data.field1[6,*]
rho_los[*]=data.field1[7,*]
vel_los[*]=data.field1[8,*]
END
