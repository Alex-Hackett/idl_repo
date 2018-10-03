;PRO ZE_WORK_SUPERNOVA_PROGENITORS_NUMBER_STARS_MASS_BIN_BASED_SMARTT
mass_vector=dblarr(9)
for i=0, n_elements(mass_vector) -1 Do mass_vector[i]=ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS(8+i,9+i)
for i=0, n_elements(mass_vector) -1 do print,8+i,9+i,mass_vector[i]/TOTAL(mass_vector) * 13 
END