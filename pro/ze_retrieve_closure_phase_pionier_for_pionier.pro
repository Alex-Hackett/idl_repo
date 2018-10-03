;--------------------------------------------------------------------------------------------------------------------------
 
PRO ZE_RETRIEVE_CLOSURE_PHASE_PIONIER_FOR_PIONIER,baseline_x1_obs,baseline_y1_obs,baseline_x2_obs,baseline_y2_obs,baseline_x3_obs,baseline_y3_obs,baseline_xloc_all,baseline_yloc_all,phase,cp_triplet
;finding location of 3 given baseline coordinate in the model image, and retrieving the closure phase corresponding to that triangle
;difference from routine above (TRIPLET) is that only one baseline is queried at a time, so there is no closure phase returned
;reqriteen using  interpolation to return correct values interpolated (and not the closest values)

;build array based on input baseline coords
base_rect_coord=dblarr(2,3)
base_rect_coord[0,0]=baseline_x1_obs
base_rect_coord[0,1]=baseline_x2_obs
base_rect_coord[0,2]=baseline_x3_obs
base_rect_coord[1,0]=baseline_y1_obs
base_rect_coord[1,1]=baseline_y2_obs
base_rect_coord[1,2]=baseline_y3_obs

nearx=dblarr(3) & neary=nearx & indexx = nearx & indexy=indexx & vis_triplet=indexx & phase_triplet=nearx
for i=0, 2 DO BEGIN
nearx1 = Min(Abs(baseline_xloc_all - base_rect_coord[0,i]), indexx1)
neary1 = Min(Abs(baseline_yloc_all - base_rect_coord[1,i]), indexy1)
nearx[i]=nearx1 & neary[i]=neary1 & indexx[i]=indexx1 & indexy[i]=indexy1
phase_triplet[i]=phase[indexx[i],indexy[i]]
ENDFOR

cp_triplet=TOTAL(phase_triplet)
;cp_triplet=phase_triplet[0]+phase_triplet[1]+phase_triplet[2]
if cp_triplet ge 180 then cp_triplet=cp_triplet-360
if cp_triplet le (-180) then cp_triplet=cp_triplet+360

;TESTING
;if cp_triplet le (-178) then cp_triplet=0
;if cp_triplet ge 178 then cp_triplet=0

END