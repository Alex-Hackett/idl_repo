;+
; :Author: AHACKETT
;-
PRO ah_track_energy_generation_profiles, model, tracker, AGETRACK=agetrack, $
   XFRACTRACK=xfractrack, YFRACTRACK=yfractrack, CFRACTRACK=cfractrack
   
   ;##################
   ;##FILE I/O STUFF##
   ;##################
   
   savtobeloaded = ah_load_savs(model, /STRUC, /VFILE, /XDRIVE)
   RESTORE, savtobeloaded[0]
   RESTORE, savtobeloaded[1]
   
   IF KEYWORD_SET(agetrack) THEN BEGIN
    input_age = tracker
    set_age = wg_u1[FINDEL(input_age, wg_u1)]
    eps_arr = v_epsData[set_age]
    epsy_arr = v_epsyData[set_age]
    epsc_arr = v_epscData[set_age]
    epsnu_arr = v_epsnuData[set_age]
    eps3a_arr = v_eps3aData[set_age]
    epsCO_arr = v_epsCOData[set_age]
    epsON_arr = v_epsONedata[set_age]
    egrav_arr = v_egravData[set_age]
   ENDIF
   
   ;Plotting Section
   P = LIST()
   settitle = STRTRIM('Energy Sources for ' + STRING(model) + ' at ' + set_age + ' yrs', 2)
   P.ADD, PLOT([0,0],[0,0], XTITLE = 'Mass Coordinate', YTITLE = 'Energy (erg) / Energy Generation Rate (erg/s/g)', $
    TITLE = settitle)
   P.ADD, PLOT(v_xmrData, eps_arr, OVERPLOT = P[-1], NAME = 'Hydrogen Burning')
   P.ADD, PLOT(v_xmrData, epsy_arr, OVERPLOT = P[-1], NAME = 'Helium Burning')
   P.ADD, PLOT(v_xmrData, epsc_arr, OVERPLOT = P[-1], NAME = 'Carbon Burning')
   P.ADD, PLOT(v_xmrData, epsnu_arr, OVERPLOT = P[-1], NAME = 'Overall Nuclear Burning')
   P.ADD, PLOT(v_xmrData, eps3a_arr, OVERPLOT = P[-1], NAME = '3a Burning')
   P.ADD, PLOT(v_xmrData, epsCO_arr, OVERPLOT = P[-1], NAME = 'CO Burning')
   P.ADD, PLOT(v_xmrData, epsON_arr, OVERPLOT = P[-1], NAME = 'ON Burning')
   P.ADD, PLOT(v_xmrData, egrav_arr, OVERPLOT = P[-1], NAME = 'Gravitational Energy')
   leg1 = LEGEND(TARGET = [P], SHADOW = 0)
   
   
  END