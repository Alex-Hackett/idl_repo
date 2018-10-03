;PRO ZE_BH05_RUN_OBS_IP_DELTA_ALL_OWOCKI

dir='/Users/jgroh/ze_models/2D_models/etacar/'
model='mod111_john'
model2d='tilted_owocki'
pa=130.
sufix='70_90'

ZE_READ_OBS_DELTA_IP_ETACAR_V4,dir,model,model2d,sufix,pa,cp_kband

END