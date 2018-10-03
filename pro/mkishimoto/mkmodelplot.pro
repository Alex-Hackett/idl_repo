pro mkmodelplot, imgorg, maxbaseline=maxbaseline, visrange=visrange, $
  nplot=nplot, baseline=baseline, legend=legend

; nplot:
;  0: all of the three below
;  1: model image
;  2: visibility image
;  3: 1D visibility curve (only for this case, imgorg can be an array, 
;       where multiple visibility curves will be overplotted)
;
  
; maxbaseline in meter
if not keyword_set(maxbaseline) then maxbaseline = 150.

if not keyword_set(visrange) then visrange=[0,1]
if not keyword_set(nplot) then nplot = 0

if nplot ne 3 then begin
  if n_elements(imgorg) ne 1 then begin
    print, 'only one structure, please.'
    return
  endif
endif

if nplot eq 3 then begin
  xmargin=[10,3] 
  ymargin=[4,4] 
endif else begin
  xmargin=[10,3]
  ymargin=[4,2]
endelse

img = imgorg[0]

set_plot, 'ps'
charset_ps
!p.charsize=1.6; 2.4
if nplot eq 0 then prepwin, r=7, xsize=10
if nplot ne 0 then prepwin, r=1, ymargin=ymargin, xmargin=xmargin
device, xoff=0, yoff=2

str_rdust   = string(img.rdeff,  form='(F4.2)')
str_nucfrac = string(img.nucfrac,form='(F4.2)')

;device, filename='plots/' +'rdust'+str_rdust+'nucfrac'+str_nucfrac+'.eps'

;device, /encapsul
xtickl = -0.02 & ytickl = -0.02


; model image
cenradius = 3.
cenimg = sqregion({pix:img.pix, imh:img.imh}, 0.,0.,radius=cenradius)
cenimg.imh.xname=img.imh.xname
cenimg.imh.yname=img.imh.yname

; u,v visibility image
cenvis = sqregion({pix:img.vis, imh:img.imhvis}, 0,0, radius=1.0); 2.)
;cenvis.imh.xname=img.imhvis.xname
cenvis.imh.yname=img.imhvis.yname

; visibility vs baseline
maxsfreq=maxbaseline /img.sfreq_to_bline
;nbase = 101
;baselinearr = findgen(nbase)/(nbase-1) *maxbaseline
n_sfreq = 201
sfreqarr = findgen(n_sfreq)/(n_sfreq-1) *maxsfreq
blinearr = findgen(n_sfreq)/(n_sfreq-1) *maxbaseline

vis1darr = fltarr(n_sfreq, n_elements(imgorg))

for i=0, n_elements(imgorg)-1 do begin
  used = where(finite(imgorg[i].sfreq))

  vis1d_real = imgorg[i].vis1d[used] *cos(imgorg[i].phs1d[used])
  vis1d_imag = imgorg[i].vis1d[used] *sin(imgorg[i].phs1d[used])

  if keyword_set(baseline) then begin
    vr = interpol(vis1d_real, imgorg[i].baseline[used], blinearr, /spline)
    vi = interpol(vis1d_imag, imgorg[i].baseline[used], blinearr, /spline)
  endif else begin
    vr = interpol(vis1d_real, imgorg[i].sfreq[used], sfreqarr, /spline)
    vi = interpol(vis1d_imag, imgorg[i].sfreq[used], sfreqarr, /spline)
  endelse
  vis1darr[*,i] = sqrt(vi^2 + vr^2)
endfor

;-- make labels
nimg = n_elements(imgorg)
label = strarr(nimg)

psymarr=((indgen(nimg)+3) mod 7)+1

for i=0, nimg -1 do begin

  label[i] = imgorg[i].model

  case label[i] of
    'torus': label[i] = '' $
      + label[i] $
      + ' r!Din!N' + string(imgorg[i].rdin,   form='(F3.1)') + 'mas' $
      ;+ ' r!U-'    + string(imgorg[i].beta,   form='(F3.1)') + '!N' $
      + ' '        + string(imgorg[i].lam_um, form='(F4.1)') + '!4l!Xm' $
      + ' f!DAD!N='+ string(imgorg[i].nucfrac,form='(F3.1)') $
      + ''

    'gaussian': label[i] = '' $
      + label[i] $
      + ' HWHM=' + string(imgorg[i].rdeff, form='(F3.1)') + 'mas'

    'ring': label[i] = '' $
      ;+ label[i] $
      ;+ ' r='       + string(imgorg[i].rdeff,  form='(F4.2)') + 'mas' $
      + ' f!DAD!N=' + string(imgorg[i].nucfrac,form='(F3.1)') $
      ;+ 'width' + string(imgorg[i].wdust, form='(F4.2)') + 'mas' $
      + ''

    else:
  endcase

endfor

;-- plotting

if nplot eq 0 then !p.multi=[0,1,3]

if nplot eq 0 or nplot eq 1 then begin

  drawaxis, cenimg.imh, xticklen=xtickl, yticklen=ytickl
  ;psdisp, cenimg.pix, /rev
  psdisp, cenimg.pix, /rev, 0, max(cenimg.pix)/5.
  ;psdisp, alog10(cenimg.pix),-2, 0, /rev 

  ;xyouts, /data, -cenradius*0.8, cenradius*0.8, $
  ;  'nuc frac = '+ string(img.nucfrac,form='(F4.2)'), $
  ;  charsize=!p.charsize/2

  xyouts, /data, -cenradius*0.8, cenradius*0.8, label[0], $
    charsize=!p.charsize

endif

if nplot eq 0 then !p.multi[0]=2

if nplot eq 0 or nplot eq 2 then begin
  drawaxis, cenvis.imh, xticklen=xtickl, yticklen=ytickl
  psdisp, cenvis.pix, 0, 1, /rev
endif

if nplot eq 0 then !p.multi[0]=1

if nplot eq 0 or nplot eq 3 then begin

  lamstring = string(img.lam_um,form='(F4.1)')+'!4l!Xm'

  if not keyword_set(baseline) then begin
    xarr  = sfreqarr 
    xmax1 = maxsfreq
    xmax2 = maxbaseline
    xtit1 = img.imhvis.xname
    xtit2 = 'baseline (m) at !4k!X!Dobs!N=' + lamstring 
  endif else begin
    xarr  = blinearr
    xmax1 = maxbaseline
    xmax2 = maxsfreq
    xtit1 = 'baseline (m)'
    xtit2 = 'spatial frequency (mas!U-1!N) at !4k!X!Dobs!N=' + lamstring
  endelse
      
  plot,  /nodata, xarr, vis1darr[*,0]^2, yr=visrange, /ys, $
    xr=[0,xmax1], /xs, xtit=xtit1, ytitle='visibility^2', $
    ymargin=ymargin, xmargin=xmargin

  axis, xaxis=1, xr=[0,xmax2], /xs, xticklen=-0.02, xtit=xtit2

  for i=0, nimg -1 do begin
    if not keyword_set(baseline) then $
      x = imgorg[i].sfreq else x = imgorg[i].baseline

    plots,  xarr, vis1darr[*,i]^2

    ; choose psym between 1-7
    plots, x, imgorg[i].vis1d^2, psym=psymarr[i], noclip=0

    poslabel = fix(n_sfreq *0.7)

    if not keyword_set(legend) then begin
      xyouts, xarr[poslabel], vis1darr[poslabel, i]^2, label[i]
    endif else begin
      plots,  xarr[poslabel],      0.60-0.07 *i, psym=psymarr[i]
      xyouts, xarr[poslabel]*1.05, 0.59-0.07 *i, label[i]
    endelse
  endfor

endif

device,/close
set_plot, 'x'
charset_x
!p.charsize=1.2
!p.multi=0

return
end

