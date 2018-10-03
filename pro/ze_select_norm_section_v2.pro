PRO ZE_SELECT_NORM_SECTION_V2,index,spec,norm_sect=norm_sect
;works with 1D spectrum
XVECT=FLTARR(4)
YVECT=FLTARR(4)
norm_sect=FLTARR(2)
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!P.MULTI=0
    window
    PLOT,index,spec,xstyle=1, $
    psym=0,xtitle='Wavelength(A)', $
  title='First choose LEFT limit for continuum fitting, and then choose RIGHT limit; right click ABORT'

    CURSOR,A,B,/data,/down
    IF !ERR EQ 4 THEN retall

    XVECT(0:1)=A
    YVECT(0:1)=B
    OPLOT,XVECT(0:1),!y.crange,linestyle=1
    CURSOR,A,B,/data,/down
    IF !ERR EQ 4 THEN retall

    XVECT(2:3)=A
    YVECT(2:3)=B
    OPLOT,XVECT(2:3),!y.crange,linestyle=1
    norm_sect=[xvect(0),xvect(2)]

END