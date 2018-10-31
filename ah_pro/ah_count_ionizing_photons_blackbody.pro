;+
; :Author: AHACKETT
; This rountine takes the temperature and luminosity of
; a stellar model at a given snapshot, and computes a blackbody curve fit to
; the output of the model, as a rapid alternative to using CMFGEN
; 
; The number of ionizing photons, and the astrophysical flux of 
; photons above/below certain ionization thresholds are then computed
;-
FUNCTION ah_count_ionizing_photons_blackbody, model, modelTracker, file_to_print, XFRAC = xfrac, output
  ;Read in the sav files for the given model
  modelsav = ah_load_savs(model, /STRUC, /XDRIVE)
  RESTORE, modelsav
  LumSun = 3.839d33
  ;Determine the closest age for which we
  ;have a snapshot
  wvls = DINDGEN(10000) + 1
  wg_age_arr = wg_u1
  IF KEYWORD_SET(xfrac) THEN BEGIN
    selected_age = wg_age_arr[FINDEL(modelTracker, wg_u15)]
  ENDIF ELSE BEGIN
    selected_age = wg_age_arr[FINDEL(modelTracker, wg_age_arr)]
  ENDELSE
  
  
  Teff = 10d^(wg_xte[WHERE(wg_age_arr EQ selected_age)])
  Lum = 10d^(wg_xl[WHERE(wg_age_arr EQ selected_age)]) * LumSun
  ;determine the blackbody
  fluxes = PLANCK(wvls, Teff[0]) * !DPI
  lumCorr = (Lum / INT_TABULATED(wvls, fluxes))
  fluxes = fluxes * lumCorr[0]
  
  ;Determine the total luminosity (sanity check) in erg/s
  totLum = INT_TABULATED(wvls, fluxes)
  
  ;Cutoff wavelength for H ionization
  HI = 911.267d
  ;Cutoff wavelength for HeI ionizatoin
  HeI = 504.259d
  ;Cutoff wavelength for HeII ionization
  HeII = 227.8377d
  
  subHILum = INT_TABULATED(wvls[WHERE(wvls LE HI)], fluxes[WHERE(wvls LE HI)])
  subHeILum = INT_TABULATED(wvls[WHERE(wvls LE HeI)], fluxes[WHERE(wvls LE HeI)])
  subHeIILum = INT_TABULATED(wvls[WHERE(wvls LE HeII)], fluxes[WHERE(wvls LE HeII)])
  
  subHINPhot = INT_TABULATED(wvls[WHERE(wvls LE HI)], fluxes[WHERE(wvls LE HI)] / wvls[WHERE(wvls LE HI)])
  subHeINPhot = INT_TABULATED(wvls[WHERE(wvls LE HeI)], fluxes[WHERE(wvls LE HeI)] / wvls[WHERE(wvls LE HeI)])
  subHeIINPhot = INT_TABULATED(wvls[WHERE(wvls LE HeII)], fluxes[WHERE(wvls LE HeII)] / wvls[WHERE(wvls LE HeII)])
  
  PRINT, 'Model Luminosity: ', Lum, ' erg/s'
  PRINT, 'Total Calculated Luminosity: ', totLum, ' erg/s'
  
  PRINT, 'Luminosity above Hydrogen Ionization Threshold: ', subHILum, ' erg/s'
  PRINT, 'Number of Photons above Hydrogen Ionization Threshold: ', subHINPhot
   
  PRINT, 'Luminosity above Helium I Ionization Threshold: ', subHeILum, ' erg/s'
  PRINT, 'Number of Photons above Helium I Ionization Threshold: ', subHeINPhot
  
  PRINT, 'Luminosity above Helium II Ionization Threshold: ', subHeIILum, ' erg/s'
  PRINT, 'Number of Photons above Helium II Ionization Threshold: ', subHeIINPhot
  
  output = LIST(model, selected_age, Teff, Lum, subHILum, subHINPhot, subHeILum, subHeINPhot, subHeIILum, subHeIINPhot)
  IF N_ELEMENTS(file_to_print) NE 0 THEN BEGIN
    dataKeys = LIST('Model', 'Model Age', 'Teff', 'Luminosity', 'HI Luminosity', 'HI #', 'HeI Luminosity', 'HeI #', 'HeII Luminosity', 'HeII #')
    dataVals = LIST(model, selected_age, Teff, Lum, subHILum, subHINPhot, subHeILum, subHeINPhot, subHeIILum, subHeIINPhot)
    datasetOutput = ORDEREDHASH(dataKeys, dataVals)
    OPENW, lun, STRING(file_to_print), /APPEND, /GET_LUN
    PRINTF, lun, datasetOutput
    FREE_LUN, lun
    PRINT, 'Data Written to File'
 ENDIF
 
 RETURN, output
END


