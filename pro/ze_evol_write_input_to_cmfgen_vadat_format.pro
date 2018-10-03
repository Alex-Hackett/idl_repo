PRO ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,timestep,u1,u2,xte,xtt,xl,rstar,logg,xmdot,vinf,beta,$
                                                 u5,u7,u8,u10,u12,u6,evol_vadat_file,model,popscl=popscl,zscale=zscale,zonzsun=zonzsun
                                                 
IF KEYWORD_SET(zscale) THEN print,'Abundances scaled to Z/Zsun= ',zonzsun ELSE BEGIN
                            zscale=0 ;wE PUT 0 so no abundance is scaled
                            zonzsun=1 ;wE PUT 1 so no abundance is scaled
                            ENDELSE                                                      
IF KEYWORD_SET(popscl) THEN ZE_EVOL_SCALE_POPULATIONS_TO_CMFGEN,u5,u7,u8,u10,u12,u6,u5,u7,u8,u10,u12,u6,zscale=zscale,zonzsun=zonzsun                                               
                                                                                               
openw,6,evol_vadat_file     ; open file to write, careful here because we do not want to overwrite an existing VADAT, 
;creates output from EVOL models in VADAT format for input in CMFGEN
printf,6,'! EVOL_output created by ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT.PRO (IDL)'
printf,6,'! ', systime()
printf,6,'! evol timestep= ', timestep,'  evol age= ',u1, ' model= ', model 
printf,6,''
printf,6,strtrim(string(10^xte/1e4,FORMAT='(F8.5,3x,A)'),2),'        [TEFF]       !Temperature at TAU_REF in HYDRO_DEFAULTS'
printf,6,FORMAT='(E11.5,A)',10^xl       ,'        [LSTAR]      !Luminosity (Lo)'
printf,6,FORMAT='(F7.5,4x,A)',logg      ,'        [LOGG]       !log g at TAU_REF in HYDRO_DEFAULTS'
printf,6,FORMAT='(F6.3,5x,A)',u2        ,'        [MASS]       !Mass (Msun)'
printf,6,' '
printf,6,FORMAT='(E11.5,A)',vinf        ,'        [VINF]       !Wind terminal velocity (km/s)'
printf,6,FORMAT='(E11.5,A)',10^xmdot    ,'        [MDOT]       !Mass-loss rate (msun/yr)'
printf,6,FORMAT='(F4.2,7x,A)',beta      ,'        [BETA]       !Beta of velocity law'
printf,6,' '
printf,6,FORMAT='(E12.5,A)',-1d0*u5  ,'       [HYD/X]      !H abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-1d0*u7  ,'       [HE/X]       !He abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-1d0*u8  ,'       [CARB/X]     !C abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-1d0*u10  ,'       [NIT/X]      !N abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-1d0*u12  ,'       [OXY/X]      !O abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-1d0*u6  ,'       [NEON/X]     !Ne abundance (mass fraction)'
printf,6,FORMAT='(E12.5,A)',-2.66D-05*zonzsun,   '       [SOD/X]      !Na abundance (by mass: solar=3.45E-05)'
printf,6,FORMAT='(E12.5,A)',-6.46D-04*zonzsun,   '       [MAG/X]      !Mg abundance (by mass: solar=6.47E-04)'
printf,6,FORMAT='(E12.5,A)',-5.58D-05*zonzsun,   '       [ALUM/X]     !Al abundance (by mass: solar=5.58D-05)'
printf,6,FORMAT='(E12.5,A)',-6.60E-04*zonzsun,   '       [SIL/X]      !Si abundance (by mass: solar=8.60E-04)'
printf,6,FORMAT='(E12.5,A)',-3.82E-04*zonzsun,   '       [SUL/X]      !S abundance  (by mass: solar=3.82E-04)'
printf,6,FORMAT='(E12.5,A)',-6.12E-06*zonzsun,   '       [PHOS/X]     !P abundance  (by mass: solar=6.12E-06)'
printf,6,FORMAT='(E12.5,A)',-7.87E-06*zonzsun,   '       [CHL/X]      !Cl abundance (by mass: solar=7.87E-06)'
printf,6,FORMAT='(E12.5,A)',-1.02E-04*zonzsun,   '       [ARG/X]      !Ar abundance (by mass: solar=1.04E-04)'
printf,6,FORMAT='(E12.5,A)',-3.61E-06*zonzsun,   '       [POT/X]      !K abundance  (by mass: solar=3.61E-06)'
printf,6,FORMAT='(E12.5,A)',-6.15E-05*zonzsun,   '       [CAL/X]      !Ca abundance (by mass: solar=6.15E-05)'
printf,6,FORMAT='(E12.5,A)',-3.28D-06*zonzsun,   '       [TIT/X]      !Ti mass fraction (by mass: solar=3.28E-06)'
printf,6,FORMAT='(E12.5,A)',-1.70E-05*zonzsun,   '       [CHRO/X]     !Cr abundance (by mass: solar=1.70E-05)'
printf,6,FORMAT='(E12.5,A)',-9.44E-06*zonzsun,   '       [MAN/X]      !Mn abundance (by mass: solar=9.44E-06)'
printf,6,FORMAT='(E12.5,A)',-1.36E-03*zonzsun,   '       [IRON/X]     !Fe abundance (by mass: solar=1.36E-03)'
printf,6,FORMAT='(E12.5,A)',-7.32D-05*zonzsun,   '       [NICK/X]     !Ni abunances (by mass: solar=7.32E-05)'
printf,6,''







close,6


END