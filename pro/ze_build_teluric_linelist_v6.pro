PRO ZE_BUILD_TELURIC_LINELIST_V6,guess_lambda,fluxtel,lkpno,fkpno,gratdet
;using mouse clicks to determine the number of lines to be included
;v6 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.

temp_file='/Users/jgroh/espectros/bldtellist_temp_'+gratdet+'.txt'
wlt=0. & wrt=0. & xct=0. & wct=0.
index_lkpno=1.*indgen(n_elements(lkpno))
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,20,xsize=1000,ysize=500 
  PLOT,lkpno,10.*(fkpno/max(fkpno)),xstyle=1,ystyle=1,yrange=[10.*min(fkpno),10.*max(fkpno)+1],/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='ZE_BUILD_TELURIC_LINELIST_V5'
  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
  OPLOT,lkpno,10.*(fkpno/max(fkpno))
  AXIS,XAXIS=1,xstyle=1,XRANGE=[min(index_lkpno),max(index_lkpno)],/SAVE
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
wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl & minx_vec=wl & centerx_vec=wl & maxx_vec=wl

ZE_READ_SPECTRA_COL_VEC,temp_file,centerx_vec,ya_vec
print,centerx_Vec
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;window,xsize=1000,ysize=500 
;  PLOT,index_lkpno,10.*(fkpno/max(fkpno)),xstyle=1,ystyle=1,yrange=[10.*min(fkpno),10.*max(fkpno)+1],/NOERASE, $
;    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
;  title='ZE_BUILD_TELURIC_LINELIST_V4'
;  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
;  OPLOT,lkpno,10.*(fkpno/max(fkpno))

;   print,'Left-click to select lines which should be included for wavelength calibration; click as close as possible to line center '
    !MOUSE.BUTTON = 1

    for i=0, nlines -1 DO BEGIN
          minx_vec[i]=centerx_vec[i]-40
          maxx_vec[i]=centerx_vec[i]+40         
    endfor  


minx_index=WHERE(minx_vec lt min(index_lkpno),countmin)
maxx_index=WHERE(maxx_vec gt max(index_lkpno),countmax)

IF countmin NE 0 THEN minx_vec(minx_index)=0
IF countmax NE 0 THEN maxx_vec(maxx_index)=max(index_lkpno)

window,20,xsize=1000,ysize=500 
FOR i=0, nlines -1 DO BEGIN
  ZE_zcentroid_v2,lkpno,fkpno,0,minx_vec[i],maxx_vec[i],wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR

linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+gratdet+'_sel.txt'

ZE_WRITE_COL,linelist_file,wc


END