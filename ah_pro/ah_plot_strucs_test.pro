PRO ah_plot_strucs_test
CD, '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/'
SPAWN, 'ls', dirlist
modelnames = dirlist
FOREACH modelname, modelnames DO BEGIN
  ah_plot_framework, STRING(modelname), /TOSAVE
  thisonesdone = STRTRIM('PLOT GENERATION FINISHED FOR: ' + STRING(modelname), 2)
  PRINT, thisonesdone
ENDFOREACH
END