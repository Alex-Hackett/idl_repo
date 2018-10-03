PRO ZE_READ_DATA_FROM_TOM_V3,filename,pos_l_over_a,pos_rho_los,pos_vel_los,l_over_a_for_prim,rho_prim,rho_sec,l_over_a_for_den,rho_los,vel_los,header
;v2 reading new files from Tom Madura from 29.09.2009, various orientations as separate cols 
;v3 reading  vel and den for only one los per time with positions in tom's file given by the posvel,posden variables

header=''
data=read_ascii(filename,DATA_START=1, MISSING_VALUE=0., DELIMITER=',', header=header)
count=(size(data.field01))[2]
l_over_a_for_prim=dblarr(count)
rho_prim=l_over_a_for_prim & rho_sec=rho_prim & l_over_a_for_den=rho_prim 

l_over_a_for_prim[*]=data.field01[1,*]
rho_prim[*]=data.field01[2,*]
rho_sec[*]=data.field01[3,*]
l_over_a_for_den[*]=data.field01[pos_l_over_a,*]
rho_los=REFORM(data.field01[pos_rho_los,*])
vel_los=REFORM(data.field01[pos_vel_los,*])

END
