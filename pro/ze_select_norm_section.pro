PRO ZE_SELECT_NORM_SECTION,index,dataa2,row,norm_sect=norm_sect

XVECT=FLTARR(4)
YVECT=FLTARR(4)
norm_sect=FLTARR(2)
    window
    PLOT,index,dataa2[*,row],xstyle=1, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='First choose LEFT limit for continuum fitting, and then choose RIGHT limit; right click ABORT'
     print,!MOUSE
    CURSOR,A,B,/data,/down
     print,!MOUSE.BUTTON
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