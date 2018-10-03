PRO ZE_1DSPEC_COMBINE, l1_1dspc,f1_1dspc,l2_1dspc,f2_1dspc,lambdacomb_1dspc=lambdacomb_1dspc,fluxcomb_1dspc=fluxcomb_1dspc

Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!P.MULTI=0

sizelam1=n_elements(l1_1dspc)
sizelam2=n_elements(l2_1dspc)
index1=1.*indgen(n_elements(l1_1dspc))
index2=1.*indgen(n_elements(l2_1dspc))

ZE_SELECT_NORM_SECTION_V2,index1,f1_1dspc,norm_sect=norm_sect1
norm_line_val1_1dspc=(MOMENT(f1_1dspc[norm_sect1[0]:norm_sect1[1]]))[0]

ZE_SELECT_NORM_SECTION_V2,index2,f2_1dspc,norm_sect=norm_sect2
norm_line_val2_1dspc=(MOMENT(f2_1dspc[norm_sect2[0]:norm_sect2[1]]))[0]

l1_1dspc_sel=l1_1dspc[norm_sect1[0]:norm_sect1[1]]
f1_1dspc_sel=f1_1dspc[norm_sect1[0]:norm_sect1[1]]

l2_1dspc_sel=l2_1dspc[norm_sect2[0]:norm_sect2[1]]
f2_1dspc_sel=f2_1dspc[norm_sect2[0]:norm_sect2[1]]

minl1_1dspc_sel=min(l1_1dspc_sel)
maxl1_1dspc_sel=max(l1_1dspc_sel)
minl2_1dspc_sel=min(l2_1dspc_sel)
maxl2_1dspc_sel=max(l2_1dspc_sel)
print,minl1_1dspc_sel,maxl1_1dspc_sel,minl2_1dspc_sel,maxl2_1dspc_sel

near_min_l2_1dspc_sel = Min(Abs(l2_1dspc_sel - minl1_1dspc_sel), index_min_l2_1dspc_sel)
near_max_l2_1dspc_sel = Min(Abs(l2_1dspc_sel - maxl1_1dspc_sel), index_max_l2_1dspc_sel)

near_min_l1_1dspc_sel = Min(Abs(l1_1dspc_sel - minl2_1dspc_sel), index_min_l1_1dspc_sel)
near_max_l1_1dspc_sel = Min(Abs(l1_1dspc_sel - maxl2_1dspc_sel), index_max_l1_1dspc_sel)


l1_1dspc_sel_intsct=l1_1dspc_sel[(index_min_l1_1dspc_sel+1):(index_max_l1_1dspc_sel-1)]
f1_1dspc_sel_intsct=f1_1dspc_sel[(index_min_l1_1dspc_sel+1):(index_max_l1_1dspc_sel-1)]

l2_1dspc_sel_intsct=l2_1dspc_sel[(index_min_l2_1dspc_sel+1):(index_max_l2_1dspc_sel-1)]
f2_1dspc_sel_intsct=f2_1dspc_sel[(index_min_l2_1dspc_sel+1):(index_max_l2_1dspc_sel-1)]

;print,index_min_l1_1dspc_sel,index_max_l1_1dspc_sel,index_min_l2_1dspc_sel,index_max_l2_1dspc_sel
;print,l1_1dspc_sel_intsct
;print,l2_1dspc_sel_intsct

norm_line_val1_1dspc_a=(MOMENT(f1_1dspc_sel_intsct))[0]
norm_line_val2_1dspc_a=(MOMENT(f2_1dspc_sel_intsct))[0]

;print,norm_line_val1_1dspc,norm_line_val1_1dspc_a,norm_line_val2_1dspc,norm_line_val2_1dspc_a

;scale spec 2 to macht spec 1 
f2_1dspcscl=f2_1dspc*norm_line_val1_1dspc_a/norm_line_val2_1dspc_a

lmerge=dblarr(sizelam2,2)
fmerge=dblarr(sizelam2,2)

print,sizelam1,sizelam2

;arrays have to have the same number of pixels, thus cropping
IF sizelam1 lt sizelam2 THEN BEGIN 
lmerge=dblarr(sizelam1,2)
fmerge=dblarr(sizelam1,2)
l2_1dspc=l2_1dspc[0:sizelam1-1]
f2_1dspcscl=f2_1dspcscl[0:sizelam1-1]
print,'Cropped f2_1dspcscl'
ENDIF

IF sizelam1 gt sizelam2 THEN BEGIN 
lmerge=dblarr(sizelam2,2)
fmerge=dblarr(sizelam2,2)
l1_1dspc=l1_1dspc[0:sizelam2-1]
f1_1dspc=f1_1dspc[0:sizelam2-1]
print,'Cropped f1_1dspc'
ENDIF

lmerge[*,0]=l1_1dspc
lmerge[*,1]=l2_1dspc

fmerge[*,0]=f1_1dspc
fmerge[*,1]=f2_1dspcscl

hrs_merge,lmerge,fmerge,0,0,lambdacomb_1dspc,fluxcomb_1dspc

END