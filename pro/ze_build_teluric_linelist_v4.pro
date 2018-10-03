PRO ZE_BUILD_TELURIC_LINELIST_V4,guess_lambda,fluxtel,lkpno,fkpno,grat_angle,det
;using mouse clicks to determine the number of lines to be included

gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
temp_file='/Users/jgroh/espectros/bldtellist_temp_'+gratdet+'.txt'
wlt=0. & wrt=0. & xct=0. & wct=0.
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,20,xsize=1000,ysize=500 
  PLOT,lkpno,10.*(fkpno/max(fkpno)),xstyle=1,ystyle=1,yrange=[10.*min(fkpno),10.*max(fkpno)+1],/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='ZE_BUILD_TELURIC_LINELIST_V4'
  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
  OPLOT,lkpno,10.*(fkpno/max(fkpno))

   print,'Left-click to select lines which should be included for wavelength calibration; click as close as possible to line center '
    nlines=0.
    !MOUSE.BUTTON = 1
    wset,20
    wshow,20
    OPENW,2,temp_file
    
        WHILE !MOUSE.BUTTON NE 4 DO BEGIN 
          CURSOR, xa, ya, /DATA, /DOWN
          PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("BLUE", !D.TABLE_SIZE-0)
          nlines=nlines+ 1
          PRINTF,2,xa,ya
        ENDWHILE
         IF !MOUSE.BUTTON EQ 4 THEN GOTO,ENDLINE

ENDLINE:  
nlines=nlines-1
CLOSE,2
index_lkpno=1.*indgen(n_elements(lkpno))
ZE_READ_SPECTRA_COL_VEC,temp_file,centerx_vec,ya_vec
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;window,xsize=1000,ysize=500 
  PLOT,index_lkpno,10.*(fkpno/max(fkpno)),xstyle=1,ystyle=1,yrange=[10.*min(fkpno),10.*max(fkpno)+1],/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='ZE_BUILD_TELURIC_LINELIST_V4'
;  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
;  OPLOT,lkpno,10.*(fkpno/max(fkpno))

   print,'Left-click to select lines which should be included for wavelength calibration; click as close as possible to line center '
    !MOUSE.BUTTON = 1


wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl & minx_vec=wl & centerx_vec=wl & maxx_vec=wl
    for i=0, nlines -1 DO BEGIN
        ;  CURSOR, xa, ya, /DATA, /DOWN
          PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("DARK GREEN", !D.TABLE_SIZE-0)
          centerx_vec[i]=xa
          minx_vec[i]=xa-40
          maxx_vec[i]=xa+40         
    endfor  
    
window,20,xsize=1000,ysize=500 
FOR i=0, nlines -1 DO BEGIN
  ZE_zcentroid_v2,lkpno,fkpno,0,minx_vec[i],maxx_vec[i],wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR


linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'

ZE_WRITE_COL,linelist_file,wc


END