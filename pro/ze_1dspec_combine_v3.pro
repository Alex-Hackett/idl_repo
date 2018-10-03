PRO ZE_1DSPEC_COMBINE_V3, l1_1dspc,f1_1dspc,l2_1dspc,f2_1dspc,lambdacomb_1dsp,fluxcomb_1dspc

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


norm_line_val1_1dspc=(MOMENT(f1_1dspc))[0]

norm_line_val2_1dspc=(MOMENT(f2_1dspc))[0]

print,norm_line_val1_1dspc,norm_line_val2_1dspc

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