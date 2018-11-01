;+
; :Author: AHACKETT
; This rountine calcs and plots the ionizaing photons generated for each
; model set xfracs to the central hydrogen fraction at which you wish to
; sample each model
;-
PRO ah_ionization_sum, xfracs, NOBUFFER = nobuffer
modelList = (FIND_ALL_DIR('/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/')).REPLACE('/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/', '')
mods = LIST()
modAges = LIST()
modTeffs = LIST()
modLums = LIST()
modsubHILum = LIST()
modsubHINPhot = LIST()
modsubHeILum = LIST()
modsubHeINPhot = LIST()
modsubHeIILum = LIST()
modsubHeIINPhot = LIST()

FOREACH selectedModel, modelList[2:*] DO BEGIN
  out = AH_COUNT_IONIZING_PHOTONS_BLACKBODY(selectedModel, xfracs, /XFRAC)
  mods.ADD, out[0]
  modAges.ADD, out[1]
  modTeffs.ADD, out[2]
  modLums.ADD, out[3]
  modsubHILum.ADD, out[4]
  modsubHINPhot.ADD, out[5]
  modsubHeILum.ADD, out[6]
  modsubHeINPhot.ADD, out[7]
  modsubHeIILum.ADD, out[8]
  modsubHeIINPhot.ADD, out[9]
ENDFOREACH
IF KEYWORD_SET(nobuffer) THEN buffervar = 0 ELSE buffervar = 1
;Setup barplot
gentitle = STRTRIM('Re-Ionization Contributions per Model at' + STRING((1-xfracs) * 100) + '% Core X Exhaustion', 2)
;gentitle = STRTRIM('Re-Ionization Contributions per Model at First Model', 2)
xvals = (INDGEN(N_ELEMENTS(mods))) + 1
ticks = ['0', (STRING(mods.TOARRAY())).REPLACE('z000S0', '')]

P0 = BARPLOT(xvals, ALOG10(modsubHINPhot.TOARRAY()), INDEX = 0, NBARS = 3, FILL_COLOR = 'black', $
   TITLE = gentitle, XTITLE = 'Model', YTITLE = 'Log # Of Photons', NAME = 'HI Ionization', BUFFER = buffervar)
P0.xtickname = ticks
P1 = BARPLOT(xvals, ALOG10(modsubHeINPhot.TOARRAY()), INDEX = 1, NBARS = 3, FILL_COLOR = 'green', /OVERPLOT, NAME = 'HeI Ionization', BUFFER = buffervar)
P2 = BARPLOT(xvals, ALOG10(modsubHeIINPhot.TOARRAY()), INDEX = 2, NBARS = 3, FILL_COLOR = 'gold', /OVERPLOT, NAME = 'HeII Ionization', BUFFER = buffervar)
leg0 = LEGEND(TARGET = [P0,P1,P2], SHADOW = 0, POSITION = [0.005,1])
p0savename = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/IDL_Plots/IONIZATION_PLOTS/group/' + 'photonnumber_' + STRING(ROUND((1-xfracs) * 100)) + 'percent_xfrac.pdf', 2)
P0.SAVE, p0savename, /BITMAP


;Setup plot of ionization luminosity as a function of model
ititle = STRTRIM('Re-Ionizing Luminosity per Model at' + STRING((1-xfracs) * 100) + '% Core X Exhaustion', 2)
P3 = BARPLOT(xvals, ALOG10(modsubHILum.TOARRAY()), INDEX = 0, NBARS = 3, FILL_COLOR = 'black',  $
  TITLE = ititle, XTITLE = 'Model', YTITLE = 'Log Luminosity of Ionization (erg/s)', NAME = 'HI Ionization', BUFFER = buffervar)
P3.xtickname = ticks

P4 = BARPLOT(xvals, ALOG10(modsubHeILum.TOARRAY()), INDEX = 1, NBARS = 3, FILL_COLOR = 'green',/OVERPLOT, NAME = 'HeI Ionization', BUFFER = buffervar)
P5 = BARPLOT(xvals, ALOG10(modsubHeIILum.TOARRAY()), INDEX = 2, NBARS = 3, FILL_COLOR = 'gold',/OVERPLOT, NAME = 'HeII Ionization', BUFFER = buffervar)
leg1 = LEGEND(TARGET = [P3, P4, P5], SHADOW = 0, POSITION = [0.005,1])
p3savename = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/IDL_Plots/IONIZATION_PLOTS/group/' + 'luminosity_' + STRING(ROUND((1-xfracs) * 100)) + 'percent_xfrac.pdf', 2)
P3.SAVE, p3savename, /BITMAP
IF KEYWORD_SET(nobuffer) THEN WINDOWDELETEALL
END
