FUNCTION ZE_COMPUTE_LOGG_FROM_R_M,r,m,cmfgen=cmfgen
cst_G=6.67428d-8 & Msol=1.9884d33 & Rsol=6.9551d10 & Lsol=3.8427d33 & xlsomo=1.932558841d0
if keyword_set(cmfgen) then r=r/6.96
 
logg=alog10(cst_G*M*Msol/(r*Rsol)^2)
return,logg
END