;+
;This proc reads in two different .wg files,
;P015z000S0d010 and P015z000S0d030, and produces plots comparing differences between the
;two different overshooting models in terms of HRD, rho_c vs T_c and central abundances
;
; :Author: Alex
;
;-
PRO AH_P015_d010_and_d030_compare

d010file='~/_PopIIIProject/geneva_models/P015z000S0d010/P015d010.wg'
d030file='~/_PopIIIProject/geneva_models/P015z000S0d030/P015d030.wg' 
d050file='~/_PopIIIProject/geneva_models/P015z000S0d050/P015d050.wg'
d010Data = ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V4(d010file, tempdir = '~/_PopIIIProject/geneva_models/P015d010_tmp')
d030Data = ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V4(d030file, tempdir = '~/_PopIIIProject/geneva_models/P015d030_tmp')
d050Data = ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V4(d050file, tempdir = '~/_PopIIIProject/geneva_models/P015d050_tmp')


d010_ages = REFORM(d010Data[1,*])
d030_ages = REFORM(d030Data[1,*])
d050_ages = REFORM(d050Data[1,*])

d010_LLsun = REFORM(d010Data[3,*])
d030_LLsun = REFORM(d030Data[3,*])
d050_LLsun = REFORM(d050Data[3,*])

d010_Teff = REFORM(d010Data[4,*])
d030_Teff = REFORM(d030Data[4,*])
d050_Teff = REFORM(d050Data[4,*])

d010_Tc = REFORM(d010Data[20,*])
d030_Tc = REFORM(d030Data[20,*])
d050_Tc = REFORM(d050Data[20,*])

d010_rhoc = REFORM(d010Data[19,*])
d030_rhoc = REFORM(d030Data[19,*])
d050_rhoc = REFORM(d050Data[19,*])

d010_coremass = REFORM(d010Data[16,*])
d030_coremass = REFORM(d030Data[16,*])
d050_coremass = REFORM(d050Data[16,*])

d010_c = REFORM(d010Data[24,*]) + REFORM(d010Data[25,*])
d030_c = REFORM(d030Data[24,*]) + REFORM(d030Data[25,*])
d050_c = REFORM(d050Data[24,*]) + REFORM(d050Data[25,*])

d010HRD = PLOT(d010_Teff, d010_LLsun, TITLE = 'HRD for P015z000S0d010, P015z000S0d030 & P015z000S0d050', XTITLE = 'Log $T_{eff} (K)$',$
 YTITLE = 'Log $L/L_{\odot}$', COLOR = 'red', NAME = 'P015z000S0d010', xrange = [4.8,4.2])
d030HRD = PLOT(d030_Teff, d030_LLsun, COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT, xrange = [4.8,4.2])
d050HRD = PLOT(d050_Teff, d050_LLsun, COLOR = 'black', NAME = 'P015z000S0d050', /OVERPLOT, xrange = [4.8,4.2])
leg1 = LEGEND(TARGET = [d010HRD, d030HRD, d050HRD], SHADOW = 0)

d010CoreCondition = PLOT(d010_rhoc, d010_Tc, TITLE = 'Comparison of Core Conditions for P015z000S0d010,P015z000S0d030 & P015z000S0d050',$ 
  XTITLE = 'Log $\rho _{C}$ (g/$cm^{3}$)', YTITLE = 'Log $T_{C}$ (K)', COLOR = 'red', NAME = 'P015z000S0d010')
d030CoreCondition = PLOT(d030_rhoc, d030_Tc, COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
d050CoreCondition = PLOT(d050_rhoc, d030_Tc, COLOR = 'black', NAME = 'P015z000S0d050', /OVERPLOT)
leg2 = LEGEND(TARGET = [d010CoreCondition, d030CoreCondition, d050CoreCondition], SHADOW = 0)

d010CoreMass = PLOT(d010_ages, d010_coremass, TITLE = 'Comparison of Mass of CC with Time', XTITLE = 'Age (yrs)',$
  YTITLE = 'Mass of Convective Core', COLOR = 'red', NAME = 'P015z000S0d010')
d030CoreMass = PLOT(d030_ages, d030_coremass, COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
d050CoreMass = PLOT(d050_ages, d050_coremass, COLOR = 'black', NAME = 'P015z000S0d050', /OVERPLOT)
leg3 = LEGEND(TARGET = [d010CoreMass,d030CoreMass,d050CoreMass], SHADOW = 0)

d010_c_tc = PLOT(d010_Tc, d010_c, XTITLE = 'Log $T_{C}$ (K)', YTITLE = 'Central Mass Fraction of C', COLOR = 'red', NAME = 'P015z000S0d010')
d030_c_tc = PLOT(d030_Tc, d030_c, COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
d050_c_tc = PLOT(d050_Tc, d050_c, COLOR = 'black', NAME = 'P015z000S0d050', /OVERPLOT)
leg4 = LEGEND(TARGET = [d010_c_tc,d030_c_tc,d050_c_tc], SHADOW = 0)


END






