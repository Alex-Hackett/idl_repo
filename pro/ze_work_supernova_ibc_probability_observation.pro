;PRO ZE_WORK_SUPERNOVA_IBC_PROBABILITY_OBSERVATION
;computes the probability of non-detection of a given observed SN Ibc from its upper magnitude limit

;ROTATION
mlowibtotrot=[25.,82]
mupibtotrot=[30.1,87.]
mlowictotrot=[30.1,87.]
mupictotrot=[82.0,120.]
mlowibctotrot=[25.0]
mupibctotrot=[120.0]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibtotrot[0],mupibtotrot[0],nstarsibtotrot1,mstarsibtotrot1
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibtotrot[1],mupibtotrot[1],nstarsibtotrot2,mstarsibtotrot2
nstarsibtotrot=nstarsibtotrot1+nstarsibtotrot2
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowictotrot[0],mupictotrot[0],nstarsictotrot1,mstarsictotrot1
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowictotrot[1],mupictotrot[1],nstarsictotrot2,mstarsictotrot2
nstarsictotrot=nstarsictotrot1+nstarsictotrot2
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibctotrot,mupibctotrot,nstarsibctotrot,mstarsibctotrot

;NO ROTATION
mlowibtotnorot=[32.0,106.4]
mupibtotnorot=[52.2,120.0]
mlowictotnorot=[52.2]
mupictotnorot=[106.4]
mlowibctotnorot=[32.0]
mupibctotnorot=[120.0]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibtotnorot[0],mupibtotnorot[0],nstarsibtotnorot1,mstarsibtotnorot1
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibtotnorot[1],mupibtotnorot[1],nstarsibtotnorot2,mstarsibtotnorot2
nstarsibtotnorot=nstarsibtotnorot1+nstarsibtotnorot2
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowictotnorot,mupictotnorot,nstarsictotnorot,mstarsictotnorot
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlowibctotnorot,mupibctotnorot,nstarsibctotnorot,mstarsibctotnorot



mlow10brdetnorot=[32.0]
mup10brdetnorot=[42.5]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlow10brdetnorot,mup10brdetnorot,nstars10brdetnorot,mstars10brdetnorot

print,(1-nstars10brdetnorot/nstarsibtotnorot)
print,(1-nstars10brdetnorot/nstarsibctotnorot)

mlow10brdetrot=[25.0]
mup10brdetrot=[30.1]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlow10brdetrot,mup10brdetrot,nstars10brdetrot,mstars10brdetrot

print,(1-nstars10brdetrot/nstarsibtotrot)
print,(1-nstars10brdetrot/nstarsibctotrot)

mlow04gtdetnorot=[109.0]
mup04gtdetnorot=[110.5]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlow04gtdetnorot,mup04gtdetnorot,nstars04gtdetnorot,mstars04gtdetnorot

print,(1-nstars04gtdetnorot/nstarsibtotnorot)
print,(1-nstars04gtdetnorot/nstarsibctotnorot)

mlow04gtdetrot=[25.0]
mup04gtdetrot=[30.1]
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlow04gtdetrot,mup04gtdetrot,nstars04gtdetrot,mstars04gtdetrot

print,(1-nstars04gtdetrot/nstarsibtotrot)
print,(1-nstars04gtdetrot/nstarsibctotrot)


END