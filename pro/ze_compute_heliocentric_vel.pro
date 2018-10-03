PRO ZE_COMPUTE_HELIOCENTRIC_VEL,date_obs,ra_obs,dec_obs,vhelio=vhelio

jdcnv, date_obs[0], date_obs[1], date_obs[2],date_obs[3], jd          
baryvel, jd, 2000, vh, vb          ;Original algorithm

ra = ten(ra_obs[0],ra_obs[1],ra_obs[2])*15/!RADEG    ;RA  in radians
dec = ten(dec_obs[0],dec_obs[1],dec_obs[2])/!RADEG        ;Dec in radians
v = vb(0)*cos(dec)*cos(ra) + $   ;Project velocity toward star
    vb(1)*cos(dec)*sin(ra) + vb(2)*sin(dec)
vhelio=v ;This should be added to measured velocities!  

END