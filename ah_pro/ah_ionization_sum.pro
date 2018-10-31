;+
; :Author: AHACKETT
; This rountine calcs and plots the ionizaing photons generated for each
; model set xfracs to the central hydrogen fraction at which you wish to
; sample each model
;-
PRO ah_ionization_sum, xfracs
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
  out = AH_COUNT_IONIZING_PHOTONS_BLACKBODY(selectedModel, xfracs)
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
;Setup barplot
;gentitle = STRTRIM('Re-Ionization Contributions per Model at' + STRING((1-xfracs) * 100) + '% Core X Exhaustion', 2)
gentitle = STRTRIM('Re-Ionization Contributions per Model at Final Model', 2)
xvals = (INDGEN(N_ELEMENTS(mods))) + 1
ticks = ['0', (STRING(mods.TOARRAY())).REPLACE('z000S0', '')]

P0 = BARPLOT(xvals, ALOG10(modsubHINPhot.TOARRAY()), INDEX = 0, NBARS = 3, FILL_COLOR = 'black', $
   TITLE = gentitle, XTITLE = 'Model', YTITLE = 'Log # Of Photons', NAME = 'HI Ionization')

P0.xtickname = ticks

P1 = BARPLOT(xvals, ALOG10(modsubHeINPhot.TOARRAY()), INDEX = 1, NBARS = 3, FILL_COLOR = 'green', /OVERPLOT, NAME = 'HeI Ionization')

P2 = BARPLOT(xvals, ALOG10(modsubHeIINPhot.TOARRAY()), INDEX = 2, NBARS = 3, FILL_COLOR = 'gold', /OVERPLOT, NAME = 'HeII Ionization')
leg0 = LEGEND(TARGET = [P0,P1,P2], SHADOW = 0)


END
