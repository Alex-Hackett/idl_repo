

; Define main event handler
PRO ah_genec_struc_plotter_event, event

  COMPILE_OPT hidden

  ; Test for button event to end application and running the plotting script

    widget_control,event.TOP,get_uvalue=BUTTON_UVALUE
    themodel = event.value
    ah_kippenhahn_plotter, themodel, 0.08, /TOSAVE


END

; Create GUI
PRO ah_genec_struc_plotter

  ;Find the model dirs
  modelsdir = '/home/AHACKETT_Project/_PopIIIProject/geneva_models/'
  ;Check if they exist
  all_models = FIND_ALL_DIR(STRING(modelsdir))
  IF N_ELEMENTS(all_models) LE 1 THEN BEGIN
    warnmes = STRTRIM('No Valid Model Dirs Found in ' + modelsdir, 2)
    PRINT, warnmes
    STOP
  ENDIF
  goodModels = []
  FOREACH modeldir, all_models DO BEGIN
    ;Filter out just the ones that contain stuct and .wg files
    IF (FILE_TEST(STRTRIM(modeldir+'/'+'*Struc*',2)) AND FILE_TEST(STRTRIM(modeldir+'/'+'*.wg',2))) THEN BEGIN
      goodModels = [goodModels, STRMID(modeldir, 52)] 
    ENDIF
  ENDFOREACH
  ;goodModels now holds all the valid model names

  topLevelBase = WIDGET_BASE(/COLUMN)
  wText = WIDGET_TEXT(topLevelBase, VALUE="GENEC Plotter", $
    /ALL_EVENTS)
  modelSelectButtons = CW_BGROUP(topLevelBase, goodModels, BUTTON_UVALUE=goodModels, /COLUMN, $
  LABEL_TOP='Select a Model')
  ; Display the GUI.
  WIDGET_CONTROL, topLevelBase, /REALIZE

  ; Handle the events from the GUI.
  XMANAGER, 'ah_genec_struc_plotter', topLevelBase, /NO_BLOCK

END
