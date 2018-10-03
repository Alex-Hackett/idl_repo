FUNCTION ZE_COMPUTE_LOGG_FROM_T_L_M,t,l,m
cst_G=6.67428d-8 & Msol=1.9884d33 & Rsol=6.9551d10 & Lsol=3.8427d33 & xlsomo=1.932558841d0
;computes logg in the case where T and L are readily available
;T in K, L in Lsun

ZE_COMPUTE_R_FROM_T_L,t/1e3,l,r
 
logg=alog10(cst_G*M*Msol/(r*Rsol)^2)

return,logg

END