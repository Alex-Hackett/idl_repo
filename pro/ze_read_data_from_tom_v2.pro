PRO ZE_READ_DATA_FROM_TOM_V2,filename,l_over_a_for_prim,rho_prim,rho_sec,l_over_a_for_den,rho_los_i60w243,vel_los_i60w243,rho_los_i0w243,vel_los_i0w243,rho_los_i41w243,vel_los_i41w243,rho_los_i41w270,vel_los_i41w270,header
;reading new files from Tom Madura from 29.09.2009, various orientations as separate cols 
header=''
data=read_ascii(filename,DATA_START=1, MISSING_VALUE=0., DELIMITER=',', header=header)
count=(size(data.field01))[2]
l_over_a_for_prim=dblarr(count)
rho_prim=l_over_a_for_prim & rho_sec=rho_prim & l_over_a_for_den=rho_prim 

l_over_a_for_prim[*]=data.field01[1,*]
rho_prim[*]=data.field01[2,*]
rho_sec[*]=data.field01[3,*]
l_over_a_for_den[*]=data.field01[6,*]
rho_los_i60w243=REFORM(data.field01[7,*])
vel_los_i60w243=REFORM(data.field01[8,*])

rho_los_i0w243=REFORM(data.field01[13,*])
vel_los_i0w243=REFORM(data.field01[14,*])

rho_los_i41w243=REFORM(data.field01[19,*])
vel_los_i41w243=REFORM(data.field01[20,*])

rho_los_i41w270=REFORM(data.field01[25,*])
vel_los_i41w270=REFORM(data.field01[26,*])
END
