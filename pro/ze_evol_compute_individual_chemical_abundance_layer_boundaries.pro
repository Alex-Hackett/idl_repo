PRO ZE_EVOL_COMPUTE_INDIVIDUAL_CHEMICAL_ABUNDANCE_LAYER_BOUNDARIES,xmr,r,elemstruct,rbound1,xmrbound1,indexbound1
;compute chemical abundace boundaries for one single element
;returns mass and r coordinate(s) when Z_elem < 1e-5 ; returns one value if only lower boundary is fuond, and 2 if a shell is found
  indexbound1=findel(1e-5,elemstruct)
  rbound1=r(indexbound1)
  xmrbound1=xmr(indexbound1)
 
END