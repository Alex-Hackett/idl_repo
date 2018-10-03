;PRO ZE_EVOL_WORK_CHEMICAL_ABUNDANCE_LAYERS

remmass=[1.30,1.7,2.10,3.0,3.38] ;check values for the 18 and 28 msun progenitor
model_name=['P009z14S4','P018z14S4','P020z14S4','P028z14S4','P032z14S4']
timestep=[32931,45081,49911,63891,75291]
modeldir='/Users/jgroh/evol_models/Z014/'+model_name

jarray=dblarr(n_elements(model_name),3000) & xmrarray=jarray & rarray=jarray & lrarray=jarray & xstructarray=jarray & ystructarray=jarray & c12structarray=jarray & o16structarray=jarray  

for i=0, n_elements(model_name) -1 do begin
;for i=1, 1 do begin
  ZE_EVOL_READ_V_FILE_FROM_GENEVA_ORIGIN_RETURN_VARIABLES_FOR_CHEMICAL_ABUNDANCE_LAYERS,modeldir[i],model_name[i],timestep[i],mtot,j,xmr,r,lr,xstruct,ystruct,c12struct,o16struct,ne20struct,si28struct,fe52struct
;this doesn't work
;  xmrarray[i,*]=xmr
;  rarray[i,*]=r
;  xstructarray[i,*]=xstruct
;  ystructarray[i,*]=ystruct
;  c12structarray[i,*]=c12struct
;  o16structarray[i,*]=o16struct  
  ZE_EVOL_COMPUTE_CHEMICAL_ABUNDANCE_LAYER_BOUNDARIES,xmr,r,xstruct,ystruct,c12struct,o16struct,ne20struct,si28struct,fe52struct,xrbound1,xxmrbound1,xindexbound1,yrbound1,yxmrbound1,yindexbound1
  print,(10^r[0])/(6.955e10),' ', mtot*30, ' ', 0
  print,(10^xrbound1)/(6.955e10),' ', (mtot*30)*(1-xxmrbound1),' ', MEAN(xstruct[0:xindexbound1]) ,' ', xindexbound1
  print,(10^yrbound1)/(6.955e10),' ', (mtot*30)*(1-yxmrbound1),' ', MEAN(ystruct[0:yindexbound1]), ' ', yindexbound1
  ;print,(10^r[findel(1.3,xmr*mtot)]/(6.955e10)), ' ', (mtot*30)*(1-xmr[findel(1.3,xmr*mtot)]), ' ', findel(1.3,xmr*mtot) ;not sure how much this mean (R at the remnant mass coordinate)
endfor





END