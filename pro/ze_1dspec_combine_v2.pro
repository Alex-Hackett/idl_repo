PRO ZE_1DSPEC_COMBINE_V2, l1_1dspc,f1_1dspc,l2_1dspc,f2_1dspc,lambdacomb_1dspc=lambdacomb_1dspc,fluxcomb_1dspc=fluxcomb_1dspc

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

;scale spec 2 to macht spec 1 
f2_1dspcscl=f2_1dspc*norm_line_val1_1dspc/norm_line_val2_1dspc

lmerge=dblarr(sizelam2,2)
fmerge=dblarr(sizelam2,2)


;arrays have to have the same number of pixels, thus cropping
IF sizelam1 lt sizelam2 THEN BEGIN 
lmerge=dblarr(sizelam1,2)
fmerge=dblarr(sizelam1,2)
l2_1dspc=l2_1dspc[0:sizelam1-1]
f2_1dspcscl=f2_1dspcscl[0:sizelam1-1]
ENDIF

IF sizelam1 gt sizelam2 THEN BEGIN 
lmerge=dblarr(sizelam2,2)
fmerge=dblarr(sizelam2,2)
l1_1dspc=l1_1dspc[0:sizelam2-1]
f1_1dspc=f1_1dspc[0:sizelam2-1]
ENDIF

lmerge[*,0]=l1_1dspc
lmerge[*,1]=l2_1dspc

fmerge[*,0]=f1_1dspc
fmerge[*,1]=f2_1dspcscl

hrs_merge,lmerge,fmerge,0,0,lambdacomb_1dspc,fluxcomb_1dspc

END