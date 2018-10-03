;+
;MK_LCOOL_CHIANTI.PRO
;	IDL program to call WRT_LN_CHIANTI repeatedly for various pressures
;	and densities to generate a database of line intensities for all
;	available CHIANTI ions
;
;vinay kashyap (Dec96)
;-

if not keyword_set(wmn) then wmn=0.
if not keyword_set(wmx) then wmx=3000.
if not keyword_set(chidir) then chidir='/data/fubar/SCAR/CHIANTI/dbase/'
if not keyword_set(outdir) then outdir='/data/fubar/SCAR/emissivity/chianti'
if not keyword_set(ne_min) then ne_min=8.0
if not keyword_set(ne_max) then ne_max=15.0
if not keyword_set(d_ne) then d_ne=1.0
if not keyword_set(p_min) then p_min=13.0
if not keyword_set(p_max) then p_max=20.0
if not keyword_set(d_p) then d_p=1.0

for logD=ne_min,ne_max,d_ne do begin
  n_e = 10.^(logD)
  print,n_e
  wrt_ln_chianti,logP,outdir=outdir,chidir=chidir,wmn=wmn,wmx=wmx,n_e=n_e
endfor

for logP=p_min,p_max,d_p do begin
  print,logP
  wrt_ln_chianti,logP,outdir=outdir,chidir=chidir,wmn=wmn,wmx=wmx
endfor

end
