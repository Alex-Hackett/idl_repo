PRO ZE_CMFGEN_EVOL_CREATE_HEADER_FOR_OBS_FILES,modsum_file,header,norm=norm
;modsum_file='/Users/jgroh/ze_models/SN_progenitor_grid/P025z14S0_model030888_T027115_L0239316_logg2.663/MOD_SUM'
ZE_CMFGEN_PARSE_ALL_QUANTITIES_FROM_MOD_SUM,modsum_file,lstar,tstar,teff,rstar,rphot,v_tau23,mdot,vinf1,beta1,maxcorr,mu,habund,heabund,cabund,nabund,oabund,$
                                            feabund,t_tau20,r_tau20,logg_phot,logg_tau20,finf,vstclump,flabund,neabund,naabund,mgabund,alabund,siabund,pabund,$
                                            sabund,clabund,arabund,kabund,caabund,scabund,tiabund,vaabund,crabund,mnabund,coabund,niiabund,babund

;computes mass from log g, r
M=(10^logg_tau20)*(R_tau20*6.9599e10)^2/6.67259e-8/1.9891e33

header=strarr(42)
header[0]='Col1              = "vacuum wavelength in Angstrom"'
IF KEYWORD_SET(norm) THEN header[1]='Col2              = "continuum-normalized flux"' ELSE header[1]='Col2              = "flux at 1 kpc in erg/cm^2/s/A"'
header[2]='T_20              = '+strcompress(string(t_tau20))+'    # Temperature (K) at tau_ross=20'
header[3]='T_2_3             = '+strcompress(string(teff))+'    # Temperature (K) at tau_ross=2/3'
header[4]='R_20              = '+strcompress(string(r_tau20))+'    # Radius (Rsun) at tau_ross=20'
header[5]='R_2_3             = '+strcompress(string(rphot))+'    # Radius (Rsun) at tau_ross=2/3'
header[6]='logg_20           = '+strcompress(string(logg_tau20))+'    # log10(Gravity) (cgs) at tau_ross=20'
header[7]='logg_2_3          = '+strcompress(string(logg_phot))+'    # log10(Gravity) (cgs) at tau_ross=2/3'
header[8]='L                 = '+strcompress(string(lstar))+'    # Luminosity (Lsun)'
header[9]='M                 = '+strcompress(string(m))+'    # Mass (Msun)'
header[10]='Mdot              = '+strcompress(string(alog10(mdot)))+'    # log10(Mass-loss rate) (Msun/yr)'
header[11]='Vinf              = '+strcompress(string(vinf1))+'    # wind terminal velocity (km/s)'
header[12]='Beta              = '+strcompress(string(beta1))+'    # beta of velocity law '
header[13]='Finf              = '+strcompress(string(finf))+'    # clumping parameter f at infinity'
header[14]='V_st_clump        = '+strcompress(string(vstclump))+'    # velocity where clumps start to form'
header[15]='Abund_H           = '+strcompress(string(habund,format='(E15.6)'))+'    # Hydrogen abundance (mass fraction)'
header[16]='Abund_He          = '+strcompress(string(heabund,format='(E15.6)'))+'    # Helium abundance (mass fraction)'
header[17]='Abund_C           = '+strcompress(string(cabund,format='(E15.6)'))+'    # Carbon abundance (mass fraction)'
header[18]='Abund_N           = '+strcompress(string(nabund,format='(E15.6)'))+'    # Nitrogen abundance (mass fraction)'
header[19]='Abund_O           = '+strcompress(string(oabund,format='(E15.6)'))+'    # Oxygen abundance (mass fraction)'
header[20]='Abund_Fl          = '+strcompress(string(flabund,format='(E15.6)'))+'    # Fluorine abundance (mass fraction)'
header[21]='Abund_Ne          = '+strcompress(string(neabund,format='(E15.6)'))+'    # Neon abundance (mass fraction)'
header[22]='Abund_Na          = '+strcompress(string(naabund,format='(E15.6)'))+'    # Sodium abundance (mass fraction)'
header[23]='Abund_Mg          = '+strcompress(string(mgabund,format='(E15.6)'))+'    # Magnesium abundance (mass fraction)'
header[24]='Abund_Al          = '+strcompress(string(alabund,format='(E15.6)'))+'    # Aluminun abundance (mass fraction)'
header[25]='Abund_Si          = '+strcompress(string(siabund,format='(E15.6)'))+'    # Silicon abundance (mass fraction)'
header[26]='Abund_P           = '+strcompress(string(pabund,format='(E15.6)'))+'    # Phosphorus abundance (mass fraction)'
header[27]='Abund_S           = '+strcompress(string(sabund,format='(E15.6)'))+'    # Sulphur abundance (mass fraction)'
header[28]='Abund_Cl          = '+strcompress(string(clabund,format='(E15.6)'))+'    # Chlorine abundance (mass fraction)'
header[29]='Abund_Ar          = '+strcompress(string(arabund,format='(E15.6)'))+'    # Argon abundance (mass fraction)'
header[30]='Abund_K           = '+strcompress(string(kabund,format='(E15.6)'))+'    # Potassium abundance (mass fraction)'
header[31]='Abund_Ca          = '+strcompress(string(caabund,format='(E15.6)'))+'    # Calcium abundance (mass fraction)'
header[32]='Abund_Sc          = '+strcompress(string(scabund,format='(E15.6)'))+'    # Scandium abundance (mass fraction)'
header[33]='Abund_Ti          = '+strcompress(string(tiabund,format='(E15.6)'))+'    # Titanium abundance (mass fraction)'
header[34]='Abund_Va          = '+strcompress(string(vaabund,format='(E15.6)'))+'    # Vanadium abundance (mass fraction)'
header[35]='Abund_Cr          = '+strcompress(string(crabund,format='(E15.6)'))+'    # Chromium abundance (mass fraction)'
header[36]='Abund_Mn          = '+strcompress(string(mnabund,format='(E15.6)'))+'    # Manganese abundance (mass fraction)'
header[37]='Abund_Fe          = '+strcompress(string(feabund,format='(E15.6)'))+'    # Iron abundance (mass fraction)'
header[38]='Abund_Co          = '+strcompress(string(coabund,format='(E15.6)'))+'    # Cobalt abundance (mass fraction)'
header[39]='Abund_Ni          = '+strcompress(string(niiabund,format='(E15.6)'))+'    # Nickel abundance (mass fraction)'
header[40]='Abund_Ba          = '+strcompress(string(babund,format='(E15.6)'))+'    # Barium abundance (mass fraction)'
header[41]='#'


;turbvel    = '10.0'   /microturbulent velocity (km/s) - model atmosphere data  
;turbvel_Vmin  = '5.0'           /microturbulent velocity (km/s) (t) - synthetic spectrum data 
;turbvel_Vmax  = '5.0'           /microturbulent velocity (km/s)     - synthetic spectrum data 
;column1      = 'wavelength'     / vacuum wavelength in Angstrom
;lambda_min   = '3000.0'   /wavelength minimum (A)
;lambda_max   = '12500.0'  /wavelength maximum (A)
;nlambda      = '213787'         /number of wavelengths




END