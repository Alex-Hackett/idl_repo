PRO ZE_BUILD_TELURIC_LINELIST, lkpno,fkpno,grat_angle,det

nlines=16

wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl
wlt=0. & wrt=0. & xct=0. & wct=0.
window,20,xsize=1000,ysize=500 
  PLOT,lkpno,10.*(fkpno/max(fkpno)),xstyle=1,/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='FP_MERGE ( using CENTROID option)'
  
FOR i=0, nlines -1 DO BEGIN
  ZE_zcentroid,lkpno,fkpno,0,wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR

linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'
;save,'/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(2070, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'template.sav'
ZE_WRITE_COL,linelist_file,wc

END