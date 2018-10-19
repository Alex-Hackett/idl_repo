PRO ah_plot_strucs_test
CD, '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/'
SPAWN, 'ls', dirlist
modelnames = dirlist
modelnames = ['P060z000S0d030', 'P075z000S0d030', 'P085z000S0d030', 'P100z000S0d030', 'P100z000S0d040', 'P100z000S0d050']
FOREACH modelname, modelnames DO BEGIN
  ah_plot_framework, STRING(modelname), /TOSAVE
  thisonesdone = STRTRIM('PLOT GENERATION FINISHED FOR: ' + STRING(modelname), 2)
  PRINT, thisonesdone
ENDFOREACH
END