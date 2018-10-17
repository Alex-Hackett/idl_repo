PRO ah_compute_ionizing_photons,modelname,i_age,nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2,scale_lum=scale_lum,dist=dist,savefiledir=savefiledir
  ;computes number of ionizing photons for H, He I, and He 2
  ;can be easily adapted to compute lum and n_phot below a certain frequency
  ;adapted from CMFGEN plt_spec.f
  ;cross checked with CMFGEN against model '/Users/jgroh/ze_models/etacar_john/eta_companion_r5/obs/obs_fin'
  ;input is name of obs file with full path

  !P.Background = fsc_color('white')
  C=299792000.
  ;modelname = 'P020z000S0d030'
  ;FILE I/O STUFF
  
  ;Check if the Strucsave file for the model exists
  ; on the local drive, if not, check if it exists on the hard drive
  
  IF N_ELEMENTS(savefiledir) EQ 0 THEN BEGIN
      savefiledir = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/IDL_genec_struc_saves/'
      savefile = STRTRIM(savefiledir + 'Hashed_StrucData_' + STRING(modelname) + '.sav')
      IF FILE_TEST(savefile) EQ 1 THEN BEGIN
        defdirmes = STRTRIM('Using Default Sav File Dir: ' + savefiledir , 2)
        PRINT, defdirmes
      ENDIF ELSE BEGIN
        defdirfailmes = STRTRIM('Local Sav File Dir ' + savefiledir + ' Does Not Contain Desired File, Checking External Drive', 2)
        PRINT, defdirfailmes
        savefiledir = '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/IDL_genec_struc_saves/'
        savefile = STRTRIM(savefiledir + 'Hashed_StrucData_' + STRING(modelname) + '.sav')
        IF FILE_TEST(savefile) EQ 1 THEN BEGIN
          xhdmes = STRTRIM('Using External Hard Drive Dir: ' + savefiledir, 2)
          PRINT, xhdmes
        ENDIF ELSE BEGIN
          PRINT, 'Savfile Dir Not Found! Please Input One Manually'
          RETURN
        ENDELSE
      ENDELSE
  ENDIF ELSE BEGIN
    setonemes = STRTRIM('Using Input Savefiledir: ' + savefiledir, 2)
    PRINT, setonemes
    savefiledir = savefiledir
    savefile = STRTRIM(savefiledir + 'Hashed_StrucData_' + STRING(modelname) + '.sav')
  ENDELSE

    savemesg = STRTRIM('==============.sav File ' + savefile + ' Found, Restoring==============', 2)
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, savemesg
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    RESTORE, savefile

    i_age = wg_u1[FINDEL(0.5,wg_u15)]
    bbagemes = STRTRIM('#######################' + 'Producing a Blackbody Spectrum at the Closest Input Age: ' + STRING(wg_u1[FINDEL(i_age, wg_u1)]) + '#######################', 2)
    PRINT, bbagemes
    ;Produce a wavelength range from 50 to 850000 Angstrom
    wavelengthRange = FINDGEN(300000)
    wavelengthRange = cgScaleVector(wavelengthRange, 50, 850000)
    ;Find the bb temp (teff) at the closest timestep
    bbTeff = 10^wg_xte[FINDEL(i_age, wg_u1)]
    bbtempmes = STRTRIM('Effective Temperature:                    ' + STRING(bbTeff) + 'K', 2)
    ;produce the bb with wavelength in A and flux in erg/cm^2/s/A
    producedBB = PLANCK(wavelengthRange, bbTeff)
    producedBBJy = ALOG10(producedBB) ;In Jy
    fobs = REVERSE(producedBBJy)
  lobs = REVERSE(wavelengthRange)
  obs_freq=C/lobs*1D-05
  ;get's freqeuncy in units of 10^15 Hz
  nfreq=n_elements(obs_freq)

  if keyword_set(scale_lum) then begin
    print,'luminosity scaled by ',scale_lum
    fobs=fobs*scale_lum
  endif

  if keyword_set(dist) then begin
    print,'luminosity scaled by distance',dist
    fobs=fobs*(dist^2)
  endif
  EDGE_HYD=3.28808662499619D0
  EDGE_HEI=5.94520701882481D0
  EDGE_HE2=13.1581564178623D0
  index_edge_hyd=findel(EDGE_HYD,obs_Freq)
  index_edge_hei=findel(EDGE_HEI,obs_Freq)
  index_edge_he2=findel(EDGE_HE2,obs_Freq)

  tot_lum=INT_TABULATED(obs_freq,fobs,/double)*312.7 ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun
  print,' Total luminosity is:                  ',tot_lum
  PRINT, bbtempmes
  
  ;for Hydrogen
  nphot_hyd=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_hyd:nfreq-1],fobs[index_edge_hyd:nfreq-1]/obs_freq[index_edge_hyd:nfreq-1],/double)) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
  lum_hyd=INT_TABULATED(obs_freq[index_edge_hyd:nfreq-1],fobs[index_edge_hyd:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

  print, 'Luminosity shortward of        ',lobs[index_edge_hyd],'A is:   ',lum_hyd
  print, 'Log(#) of photons shortward of ',lobs[index_edge_hyd],'A is:   ',nphot_hyd

  ;for He I
  nphot_hei=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_hei:nfreq-1],fobs[index_edge_hei:nfreq-1]/obs_freq[index_edge_hei:nfreq-1])) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
  lum_hei=INT_TABULATED(obs_freq[index_edge_hei:nfreq-1],fobs[index_edge_hei:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

  print, 'Luminosity shortward of        ',lobs[index_edge_hei],'A is:   ',lum_hei
  print, 'Log(#) of photons shortward of ',lobs[index_edge_hei],'A is:   ',nphot_hei

  ;for He II
  nphot_he2=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_he2:nfreq-1],fobs[index_edge_he2:nfreq-1]/obs_freq[index_edge_he2:nfreq-1])) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
  lum_he2=INT_TABULATED(obs_freq[index_edge_he2:nfreq-1],fobs[index_edge_he2:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

  print, 'Luminosity shortward of        ',lobs[index_edge_he2],'A is:   ',lum_he2
  print, 'Log(#) of photons shortward of ',lobs[index_edge_he2],'A is:   ',nphot_he2
END