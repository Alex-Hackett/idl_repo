;PRO AH_P015z000S0_OVERSHOOTING_COMPARE

;Reads in the corresponding wg and structure files for the
;P015z000S0d010/d030/d050 Stellar evolution models and computes and
;visualizes key differences between the models

tempdir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015_d010_d030_d050_compare'

;Reading in the 10% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d010'
model='P015d010'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar10,logg10,vesc10,vinf10,eta_star10,Bmin10,Jdot10,logg_rphot10,rphot10,beq10,beta10,ekin10,teffjump110,teffjump210,model=model,logtcollapse=logtcollapse10


;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm10,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u110,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xl10,index_varnamex_wgfile,return_valx
;log10 teff not wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xte10,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmnc10,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhoc10,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tc10,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u1510,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u1710,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33m10,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u1810,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u1910,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u2010,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u2210,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u2310,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u2410,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u1610,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u2110,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7m10,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8m10,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddesc10,index_varnamex_wgfile,return_valx
;Convective Zones
zones10 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d010
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune
  
d010_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
d010_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
d010_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
d010_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
d010_O_End_nm = modelnumber_endo
ENDIF
;######################################################################


;Reading in the 30% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d030'
model='P015d030'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar30,logg30,vesc30,vinf30,eta_star30,Bmin30,Jdot30,logg_rphot30,rphot30,beq30,beta30,ekin30,teffjump130,teffjump230,model=model,logtcollapse=logtcollapse30

;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm30,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u130,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xl30,index_varnamex_wgfile,return_valx
;log10 teff wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xte30,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmnc30,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhoc30,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tc30,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u1530,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u1730,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33m30,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u1830,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u1930,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u2030,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u2230,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u2330,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u2430,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u1630,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u2130,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7m30,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8m30,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddesc30,index_varnamex_wgfile,return_valx
;Convective Zones
zones30 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d030
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune

d030_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
d030_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
d030_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
d030_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
d030_O_End_nm = modelnumber_endo
ENDIF
;######################################################################

;Reading in the 40% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d040'
model='P015d040'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar40,logg40,vesc40,vinf40,eta_star40,Bmin40,Jdot40,logg_rphot40,rphot40,beq40,beta40,ekin40,teffjump140,teffjump240,model=model,logtcollapse=logtcollapse50

;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm40,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u140,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xl40,index_varnamex_wgfile,return_valx
;log10 teff wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xte40,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmnc40,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhoc40,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tc40,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u1540,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u1740,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33m40,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u1840,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u1940,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u2040,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u2240,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u2340,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u2440,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u1640,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u2140,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7m40,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8m40,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddesc40,index_varnamex_wgfile,return_valx
;Convective Zones
zones40 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d040
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune

d040_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
  d040_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
  d040_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
  d040_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
  d040_O_End_nm = modelnumber_endo
ENDIF

;######################################################################
;######################################################################

;Reading in the 45% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d045'
model='P015d045'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar45,logg45,vesc45,vinf45,eta_star45,Bmin45,Jdot45,logg_rphot45,rphot45,beq45,beta45,ekin45,teffjump145,teffjump245,model=model,logtcollapse=logtcollapse50

;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm45,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u145,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xl45,index_varnamex_wgfile,return_valx
;log10 teff wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xte45,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmnc45,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhoc45,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tc45,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u1545,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u1745,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33m45,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u1845,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u1945,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u2045,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u2245,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u2345,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u2445,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u1645,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u2145,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7m45,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8m45,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddesc45,index_varnamex_wgfile,return_valx
;Convective Zones
zones45 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d045
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune

d045_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
  d045_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
  d045_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
  d045_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
  d045_O_End_nm = modelnumber_endo
ENDIF

;######################################################################


;Reading in the 50% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d050'
model='P015d050'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar50,logg50,vesc50,vinf50,eta_star50,Bmin50,Jdot50,logg_rphot50,rphot50,beq50,beta50,ekin50,teffjump150,teffjump250,model=model,logtcollapse=logtcollapse50

;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm50,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u150,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xl50,index_varnamex_wgfile,return_valx
;log10 teff wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xte50,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmnc50,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhoc50,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tc50,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u1550,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u1750,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33m50,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u1850,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u1950,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u2050,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u2250,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u2350,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u2450,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u1650,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u2150,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7m50,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8m50,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddesc50,index_varnamex_wgfile,return_valx
;Convective Zones
zones50 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d050
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune

d050_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
d050_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
d050_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
d050_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
d050_O_End_nm = modelnumber_endo
ENDIF
;goto, fullhrd
;goto, Y
;==================================================================================
;Reading in the 40 solar mass 30% overshooting model
dir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P040z000S0d030'
model='P040d030'
wgfile=dir+'/'+model+'.wg'

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstarm40d30,loggm40d30,vescm40d30,vinfm40d30,eta_starm40d30,Bminm40d30,Jdotm40d30,logg_rphotm40d30,rphotm40d30,beqm40d30,betam40d30,ekinm40d30,teffjump1m40d30,teffjump2m40d30,model=model,logtcollapse=logtcollapsem40d30

;Timestep #
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nmm40d30,index_varnamex_wgfile,return_valx
;Age yrs
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u1m40d30,index_varnamex_wgfile,return_valx
;log10 luminosity/Lsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xl',data_wgfile_cut,xlm40d30,index_varnamex_wgfile,return_valx
;log10 teff wind corrected
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'xte',data_wgfile_cut,xtem40d30,index_varnamex_wgfile,return_valx
;Convective core mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'qmnc',data_wgfile_cut,qmncm40d30,index_varnamex_wgfile,return_valx
;Log10 Central Density (g/cm^3)
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'rhoc',data_wgfile_cut,rhocm40d30,index_varnamex_wgfile,return_valx
;Log10 Central temperature
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'tc',data_wgfile_cut,tcm40d30,index_varnamex_wgfile,return_valx
;X Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u15',data_wgfile_cut,u15m40d30,index_varnamex_wgfile,return_valx
;Y Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u17',data_wgfile_cut,u17m40d30,index_varnamex_wgfile,return_valx
;He3 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'b33m',data_wgfile_cut,b33mm40d30,index_varnamex_wgfile,return_valx
;C12 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u18',data_wgfile_cut,u18m40d30,index_varnamex_wgfile,return_valx
;C13 Central mass fraction
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u19',data_wgfile_cut,u19m40d30,index_varnamex_wgfile,return_valx
;N14 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u20',data_wgfile_cut,u20m40d30,index_varnamex_wgfile,return_valx
;O16 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u22',data_wgfile_cut,u22m40d30,index_varnamex_wgfile,return_valx
;O17 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u23',data_wgfile_cut,u23m40d30,index_varnamex_wgfile,return_valx
;O18 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u24',data_wgfile_cut,u24m40d30,index_varnamex_wgfile,return_valx
;Ne20 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u16',data_wgfile_cut,u16m40d30,index_varnamex_wgfile,return_valx
;Ne22 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u21',data_wgfile_cut,u21m40d30,index_varnamex_wgfile,return_valx
;Be7 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'ybe7m',data_wgfile_cut,ybe7mm40d30,index_varnamex_wgfile,return_valx
;B8 CMF
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'yb8m',data_wgfile_cut,yb8mm40d30,index_varnamex_wgfile,return_valx
;Eddington Parameter
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'eddesc',data_wgfile_cut,eddescm40d30,index_varnamex_wgfile,return_valx
;Convective Zones
zonesm40d30 = AH_READ_CZS(data_wgfile_cut)

;Compute burning phases for d0m40d30
ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
  tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
  tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
  tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
  tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune

m40d30_MS_End_nm = modelnumber_endh
IF ISA(modelnumber_end_he) GT 0 THEN BEGIN
  m40d30_He_End_nm = modelnumber_end_he
ENDIF
IF ISA(modelnumber_endc) GT 0 THEN BEGIN
  m40d30_C_End_nm = modelnumber_endc
ENDIF
IF ISA(modelnumber_endne) GT 0 THEN BEGIN
  m40d30_Ne_End_nm = modelnumber_endne
ENDIF
IF ISA(modelnumber_endo) GT 0 THEN BEGIN
  m40d30_O_End_nm = modelnumber_endo
ENDIF
GOTO, ys
;---------------------------------------------------------------------------------
;Produce some sample plots

;MS HRD
;label1 = 'P015z000S0d010'
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2, xte10, xl10,'Log Temperature (K)','Log Luminosity (Lsun)',xreverse=1, x2=xte30, y2=xl30,x3=xte50,y3=xl50
rd:
HRD_Plot1 = PLOT(xte10[1:d010_MS_End_nm], xl10[1:d010_MS_End_nm], TITLE = 'MS HRD', XTITLE = 'Log Teff (K)',$
   YTITLE = 'Log Luminosity ($L_{\odot}$)', COLOR = 'black', NAME = 'P015z000S0d010', xrange = [5,4.6])
HRD_Plot2 = PLOT(xte30[150:d030_MS_End_nm], xl30[150:d030_MS_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
HRD_Plot3 = PLOT(xte50[1:d050_MS_End_nm], xl50[1:d050_MS_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
HRD_Plot4 = PLOT(xte40[270:d040_MS_End_nm], xl40[270:d040_MS_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
HRD_Plot45 = PLOT(xte45[1:d045_MS_End_nm], xl45[1:d045_MS_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
HRD_Plotm40d30 = PLOT(xtem40d30[1:m40d30_MS_End_nm], xlm40d30[1:m40d30_MS_End_nm], COLOR = 'brown', NAME = 'P040z000S0d030', /OVERPLOT)
leg1 = LEGEND(TARGET = [HRD_PLOT1, HRD_PLOT2, HRD_PLOT4,HRD_Plot45,HRD_Plot3, HRD_Plotm40d30], SHADOW = 0)
;t1 = text(0.5,0.5,'')
STOP
;PMS HRDs
ys:
HRD_Plot1 = PLOT(xte10[1:d010_MS_End_nm], xl10[1:d010_MS_End_nm], TITLE = 'He Burn HRD', XTITLE = 'Log Teff (K)',$
   YTITLE = 'Log Luminosity ($L_{\odot}$)', COLOR = 'black', NAME = 'P015z000S0d010', LINESTYLE='--',xrange = [4.9,4.55])
HRD_Plot2 = PLOT(xte30[150:d030_MS_End_nm], xl30[150:d030_MS_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT,LINESTYLE='--')
HRD_Plot3 = PLOT(xte50[1:d050_MS_End_nm], xl50[1:d050_MS_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT,LINESTYLE='--')
HRD_Plot4 = PLOT(xte40[270:d040_MS_End_nm], xl40[270:d040_MS_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT,LINESTYLE='--')
HRD_Plot45 = PLOT(xte45[1:d045_MS_End_nm], xl45[1:d045_MS_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT,LINESTYLE='--')
HRD_Plotm40d30 = PLOT(xtem40d30[1:m40d30_MS_End_nm], xlm40d30[1:m40d30_MS_End_nm], COLOR = 'brown', NAME = 'P040z000S0d030', /OVERPLOT,LINESTYLE='--')
;He
HRD_Plot1 = PLOT(xte10[d010_MS_End_nm:d010_He_End_nm], xl10[d010_MS_End_nm:d010_He_End_nm], COLOR = 'black', NAME = 'P015z000S0d040', /OVERPLOT)
HRD_Plot2 = PLOT(xte30[d030_MS_End_nm:d030_He_End_nm], xl30[d030_MS_End_nm:d030_He_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
HRD_Plot3 = PLOT(xte50[d050_MS_End_nm:d050_He_End_nm], xl50[d050_MS_End_nm:d050_He_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
HRD_Plot4 = PLOT(xte40[d040_MS_End_nm:d040_He_End_nm], xl40[d040_MS_End_nm:d040_He_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
HRD_Plot45 = PLOT(xte45[d045_MS_End_nm:d045_He_End_nm], xl45[d045_MS_End_nm:d045_He_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
HRD_Plotm40d30 = PLOT(xtem40d30[m40d30_MS_End_nm:m40d30_He_End_nm], xlm40d30[m40d30_MS_End_nm:m40d30_He_End_nm], COLOR = 'brown', NAME = 'P040z000S0d030', /OVERPLOT)
leg1 = LEGEND(TARGET = [HRD_PLOT1, HRD_PLOT2, HRD_PLOT4,HRD_PLOT45,HRD_Plot3,HRD_Plotm40d30], SHADOW = 0)
STOP
;C
cburn:
HRD_Plot1 = PLOT(xte10[1:d010_He_End_nm], xl10[1:d010_He_End_nm], TITLE = 'C Burn HRD', XTITLE = 'Log Teff (K)',$
  YTITLE = 'Log Luminosity ($L_{\odot}$)', COLOR = 'black', NAME = 'P015z000S0d010', LINESTYLE='--',xrange = [4.8,4.2])
HRD_Plot2 = PLOT(xte30[150:d030_He_End_nm], xl30[150:d030_He_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT,LINESTYLE='--')
HRD_Plot3 = PLOT(xte50[1:d050_He_End_nm], xl50[1:d050_He_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT,LINESTYLE='--')
HRD_Plot4 = PLOT(xte40[270:d040_He_End_nm], xl40[270:d040_He_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT,LINESTYLE='--')
HRD_Plot45 = PLOT(xte45[270:d045_He_End_nm], xl45[270:d045_He_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT,LINESTYLE='--')

HRD_Plot1 = PLOT(xte10[d010_He_End_nm:d010_C_End_nm], xl10[d010_He_End_nm:d010_C_End_nm], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT)
HRD_Plot2 = PLOT(xte30[d030_He_End_nm:d030_C_End_nm], xl30[d030_He_End_nm:d030_C_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
HRD_Plot3 = PLOT(xte50[d050_He_End_nm:d050_C_End_nm], xl50[d050_He_End_nm:d050_C_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
HRD_Plot4 = PLOT(xte40[d040_He_End_nm:d040_C_End_nm], xl40[d040_He_End_nm:d040_C_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
HRD_Plot45 = PLOT(xte45[d045_He_End_nm:d045_C_End_nm], xl45[d045_He_End_nm:d045_C_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
leg1 = LEGEND(TARGET = [HRD_PLOT1, HRD_PLOT2,HRD_Plot4,HRD_Plot45, HRD_PLOT3], SHADOW = 0)
STOP
;;post C burn
;HRD_Plot1 = PLOT(xte10[1:d010_C_End_nm], xl10[1:d010_C_End_nm], TITLE = 'Post C Burn HRD', XTITLE = 'Log Teff (K)',$
;  YTITLE = 'Log Luminosity ($L_{\odot}$)', COLOR = 'black', NAME = 'P015z000S0d010', LINESTYLE='--',xrange = [4.8,4.2])
;HRD_Plot2 = PLOT(xte30[150:d030_C_End_nm], xl30[150:d030_C_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT,LINESTYLE='--')
;HRD_Plot3 = PLOT(xte50[1:d050_C_End_nm], xl50[1:d050_C_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT,LINESTYLE='--')
;HRD_Plot4 = PLOT(xte40[270:d040_C_End_nm], xl40[270:d040_C_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT,LINESTYLE='--')
;
;HRD_Plot1 = PLOT(xte10[d010_C_End_nm:*], xl10[d010_C_End_nm:*], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT)
;HRD_Plot2 = PLOT(xte30[d030_C_End_nm:*], xl30[d030_C_End_nm:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
;HRD_Plot3 = PLOT(xte50[d050_C_End_nm:*], xl50[d050_C_End_nm:*], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
;HRD_Plot4 = PLOT(xte40[d040_C_End_nm:*], xl40[d040_C_End_nm:*], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
;leg1 = LEGEND(TARGET = [HRD_PLOT1, HRD_PLOT2,HRD_PLOT4, HRD_PLOT3], SHADOW = 0)
STOP

fullhrd:
;Full HRDs for comparison
HRD_Plot1 = PLOT(xte10[1:*], xl10[1:*], TITLE = 'Full HRD', XTITLE = 'Log Teff (K)', YTITLE = 'Log Luminosity ($L_{\odot}$)', xrange=[4.8,4.2],yrange=[4.2,5], COLOR = 'black', NAME = 'P015z000S0d010')
HRD_Plot2 = PLOT(xte30[150:*], xl30[150:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
HRD_Plot3 = PLOT(xte50[1:*], xl50[1:*], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
HRD_Plot4 = PLOT(xte40[270:*], xl40[270:*], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
leg1 = LEGEND(TARGET = [HRD_PLOT1, HRD_PLOT2,HRD_Plot4, HRD_PLOT3], SHADOW = 0)



;Core Conditions
;Core_Plot1 = PLOT(rhoc10,tc10, TITLE = 'Full Evolution Central Conditions', XTITLE = 'Log $\rho_{c}$ ($g/cm^3$)', YTITLE = 'Log $T_{c} (K)$', COLOR = 'black', NAME = 'P015z000S0d010')
;Core_Plot2 = PLOT(rhoc30,tc30, COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
;Core_Plot4 = PLOT(rhoc40, tc40, COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
;Core_Plot3 = PLOT(rhoc50, tc50, COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
;leg1 = LEGEND(TARGET = [Core_Plot1, Core_Plot2,Core_Plot4, Core_Plot3], SHADOW = 0)
;
co:
Core_Plot1 = PLOT(rhoc10[1:d010_MS_End_nm],tc10[1:d010_MS_End_nm], TITLE = 'MS Central Conditions',$
   XTITLE = 'Log $\rho_{c}$ ($g/cm^3$)', YTITLE = 'Log $T_{c} (K)$', COLOR = 'black', NAME = 'P015z000S0d010')
Core_Plot2 = PLOT(rhoc30[150:d030_MS_End_nm],tc30[150:d030_MS_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
Core_Plot3 = PLOT(rhoc50[1:d050_MS_End_nm], tc50[1:d050_MS_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
Core_Plot4 = PLOT(rhoc40[270:d040_MS_End_nm], tc40[270:d040_MS_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
Core_Plot45 = PLOT(rhoc45[1:d045_MS_End_nm], tc45[1:d045_MS_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
leg1 = LEGEND(TARGET = [Core_Plot1, Core_Plot2,Core_Plot4,Core_Plot45, Core_Plot3], SHADOW = 0)
STOP
;He burn
Y:
Core_Plot1 = PLOT(rhoc10[1:d010_MS_End_nm],tc10[1:d010_MS_End_nm], TITLE = 'He Burn Central Conditions',$
   XTITLE = 'Log $\rho_{c}$ ($g/cm^3$)', YTITLE = 'Log $T_{c} (K)$', COLOR = 'black', NAME = 'P015z000S0d010',LINESTYLE='--')
Core_Plot2 = PLOT(rhoc30[150:d030_MS_End_nm],tc30[150:d030_MS_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT,LINESTYLE='--')
Core_Plot3 = PLOT(rhoc50[1:d050_MS_End_nm], tc50[1:d050_MS_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT,LINESTYLE='--')
Core_Plot4 = PLOT(rhoc40[270:d040_MS_End_nm], tc40[270:d040_MS_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT,LINESTYLE='--')
Core_Plot45 = PLOT(rhoc45[1:d045_MS_End_nm], tc45[1:d045_MS_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT,LINESTYLE='--')

Core_Plot1 = PLOT(rhoc10[d010_MS_End_nm:d010_He_End_nm],tc10[d010_MS_End_nm:d010_He_End_nm], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT)
Core_Plot2 = PLOT(rhoc30[d030_MS_End_nm:d030_He_End_nm],tc30[d030_MS_End_nm:d030_He_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
Core_Plot3 = PLOT(rhoc50[d050_MS_End_nm:d050_He_End_nm], tc50[d050_MS_End_nm:d050_He_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
Core_Plot4 = PLOT(rhoc40[d040_MS_End_nm:d040_He_End_nm], tc40[d040_MS_End_nm:d040_He_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
Core_Plot45 = PLOT(rhoc45[d045_MS_End_nm:d045_He_End_nm], tc45[d045_MS_End_nm:d045_He_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
leg1 = LEGEND(TARGET = [Core_Plot1, Core_Plot2,Core_Plot4,Core_Plot45, Core_Plot3], SHADOW = 0)
STOP
;
;C burn
C:
Core_Plot1 = PLOT(rhoc10[1:d010_He_End_nm],tc10[1:d010_He_End_nm], TITLE = 'C Burn Central Conditions',$
  XTITLE = 'Log $\rho_{c}$ ($g/cm^3$)', YTITLE = 'Log $T_{c} (K)$', COLOR = 'black', NAME = 'P015z000S0d010',LINESTYLE='--')
  Core_Plot2 = PLOT(rhoc30[150:d030_He_End_nm],tc30[150:d030_He_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT,LINESTYLE='--')
Core_Plot3 = PLOT(rhoc50[1:d050_He_End_nm], tc50[1:d050_He_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT,LINESTYLE='--')
Core_Plot4 = PLOT(rhoc40[270:d040_He_End_nm], tc40[270:d040_He_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT,LINESTYLE='--')
Core_Plot45 = PLOT(rhoc45[1:d045_He_End_nm], tc45[1:d045_He_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT,LINESTYLE='--')

Core_Plot1 = PLOT(rhoc10[d010_He_End_nm:d010_C_End_nm],tc10[d010_He_End_nm:d010_C_End_nm], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT)
Core_Plot2 = PLOT(rhoc30[d030_He_End_nm:d030_C_End_nm],tc30[d030_He_End_nm:d030_C_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
Core_Plot3 = PLOT(rhoc50[d050_He_End_nm:d050_C_End_nm], tc50[d050_He_End_nm:d050_C_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
Core_Plot4 = PLOT(rhoc40[d040_He_End_nm:d040_C_End_nm], tc40[d040_He_End_nm:d040_C_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
Core_Plot45 = PLOT(rhoc45[d045_He_End_nm:d045_C_End_nm], tc45[d045_He_End_nm:d045_C_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
leg1 = LEGEND(TARGET = [Core_Plot1, Core_Plot2,Core_Plot4, Core_Plot45, Core_Plot3], SHADOW = 0)
STOP
edd:
;
;Eddington Parameter with time
edd_Plot1 = PLOT(u110,eddesc10, TITLE = 'Full Evolution Eddington Parameter with Age', XTITLE = 'Age (yrs)', YTITLE = '$\Gamma$', COLOR = 'black', NAME = 'P015z000S0d010')
edd_Plot2 = PLOT(u130[150:*],eddesc30[150:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
edd_Plot3 = PLOT(u150, eddesc50, COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
leg1 = LEGEND(TARGET = [edd_Plot1, edd_Plot2, edd_Plot3], SHADOW = 0)

;Eddington Parameter with Effective Temperature
edd_Plot1 = PLOT(xte10,eddesc10, TITLE = 'Full Evolution Eddington Parameter with Teff', XTITLE = 'Log $T_{eff}$ (K)', YTITLE = '$\Gamma$', COLOR = 'black', NAME = 'P015z000S0d010')
edd_Plot2 = PLOT(xte30[150:*],eddesc30[150:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
edd_Plot3 = PLOT(xte50, eddesc50, COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
leg1 = LEGEND(TARGET = [edd_Plot1, edd_Plot2, edd_Plot3], SHADOW = 0)

;Eddington Parameter with Luminosity
edd_Plot1 = PLOT(xl10,eddesc10, TITLE = 'Full Evolution Eddington Parameter with Luminosity', XTITLE = 'Luminosity (L/$L_{\odot}$)', YTITLE = '$\Gamma$', COLOR = 'black', NAME = 'P015z000S0d010')
edd_Plot2 = PLOT(xl30[150:*],eddesc30[150:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
edd_Plot3 = PLOT(xl50, eddesc50, COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
leg1 = LEGEND(TARGET = [edd_Plot1, edd_Plot2, edd_Plot3], SHADOW = 0)

;Eddington Parameter with Logg
edd_Plot1 = PLOT(logg10,eddesc10, TITLE = 'Full Evolution Eddington Parameter with Log g', XTITLE = 'Surface Gravity (Log g)', YTITLE = '$\Gamma$', COLOR = 'black', NAME = 'P015z000S0d010')
edd_Plot2 = PLOT(logg30[150:*],eddesc30[150:*], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
edd_Plot3 = PLOT(logg50, eddesc50, COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
leg1 = LEGEND(TARGET = [edd_Plot1, edd_Plot2, edd_Plot3], SHADOW = 0)

zo:
fdsa = PLOT(zones10)


coremass:
;MS Convective core mass
Coremass10 = PLOT(u110[0:d010_MS_End_nm],qmnc10[0:d010_MS_End_nm], TITLE = 'C Burning Plot of Mass of Convective Core as a Function of Age', XTITLE = 'Age (yrs)',$
  YTITLE = 'Fractional Mass of Convective Core', COLOR = 'black', NAME = 'P015z000S0d010', LINESTYLE = '--')
Coremass30 = PLOT(u130[150:d030_MS_End_nm], qmnc30[150:d030_MS_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT, LINESTYLE = '--')
Coremass40 = PLOT(u140[270:d040_MS_End_nm], qmnc40[270:d040_MS_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT, LINESTYLE = '--')
Coremass45 = PLOT(u145[0:d045_MS_End_nm], qmnc45[0:d045_MS_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT, LINESTYLE = '--')
Coremass50 = PLOT(u150[0:d050_MS_End_nm], qmnc50[0:d050_MS_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT, LINESTYLE = '--')
;leg1 = LEGEND(TARGET = [Coremass10, Coremass30, Coremass40, Coremass45, Coremass50], SHADOW = 0)

Coremass10 = PLOT(u110[d010_MS_End_nm:d010_He_End_nm], qmnc10[d010_MS_End_nm:d010_He_End_nm], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT, LINESTYLE = '--')
Coremass30 = PLOT(u130[d030_MS_End_nm:d030_He_End_nm], qmnc30[d030_MS_End_nm:d030_He_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT, LINESTYLE = '--')
Coremass40 = PLOT(u140[d040_MS_End_nm:d040_He_End_nm], qmnc40[d040_MS_End_nm:d040_He_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT, LINESTYLE = '--')
Coremass45 = PLOT(u145[d045_MS_End_nm:d045_He_End_nm], qmnc45[d045_MS_End_nm:d045_He_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT, LINESTYLE = '--')
Coremass50 = PLOT(u150[d050_MS_End_nm:d050_He_End_nm], qmnc50[d050_MS_End_nm:d050_He_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT, LINESTYLE = '--')
;leg1 = LEGEND(TARGET = [Coremass10, Coremass30, Coremass40, Coremass45, Coremass50], SHADOW = 0)

Coremass10 = PLOT(u110[d010_He_End_nm:d010_C_End_nm], qmnc10[d010_He_End_nm:d010_C_End_nm], COLOR = 'black', NAME = 'P015z000S0d010', /OVERPLOT)
Coremass30 = PLOT(u130[d030_He_End_nm:d030_C_End_nm], qmnc30[d030_He_End_nm:d030_C_End_nm], COLOR = 'blue', NAME = 'P015z000S0d030', /OVERPLOT)
Coremass40 = PLOT(u140[d040_He_End_nm:d040_C_End_nm], qmnc40[d040_He_End_nm:d040_C_End_nm], COLOR = 'green', NAME = 'P015z000S0d040', /OVERPLOT)
Coremass45 = PLOT(u145[d045_He_End_nm:d045_C_End_nm], qmnc45[d045_He_End_nm:d045_C_End_nm], COLOR = 'purple', NAME = 'P015z000S0d045', /OVERPLOT)
Coremass50 = PLOT(u150[d050_He_End_nm:d050_C_End_nm], qmnc50[d050_He_End_nm:d050_C_End_nm], COLOR = 'red', NAME = 'P015z000S0d050', /OVERPLOT)
leg1 = LEGEND(TARGET = [Coremass10, Coremass30, Coremass40, Coremass45, Coremass50], SHADOW = 0)
STOP



END










