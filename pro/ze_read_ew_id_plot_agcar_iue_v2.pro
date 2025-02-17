;v2 for AG Car Paper I
;CHANGES:
;1) added Si 2 line in the UV 1265
;2) added line IDs requested by the referee

close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'

;defines ewdata for reading, as generated by CMF_FLUX (including header)
;ewdata='/aux/pc20117a/jgroh/cmfgen_models/agcar/397_red_maxr/obscont/EWDATA' 
ewdata='/Users/jgroh/ze_models/takion/ze_models/agcar/223/obs/ewdata_fin_ed'
;defines observed IUE file
obsiue='/Users/jgroh/espectros/agcar/agc89dec23_swp37882_merge.txt' 
obslwp='/Users/jgroh/espectros/agcar/agc89dec23_lwp16985_merge.txt' 

;defines model file
model='/Users/jgroh/espectros/agcar/agc_mod223_89dec23_red.txt'   ;best fit
;model='/Users/jgroh/espectros/agcar/408_uv.txt'                  ; with Si Ii lines
modelsi2='/Users/jgroh/espectros/agcar/408_si2_der.txt'                  ; only Si Ii line 1265

ZE_READ_SPECTRA_COL_VEC,obsiue,lambdafuse,fluxfuse,nrec
ZE_READ_SPECTRA_COL_VEC,obslwp,llwp,flwp,nrec3
ZE_READ_SPECTRA_COL_VEC,model,l1,f1,nrec2
ZE_READ_SPECTRA_COL_VEC,modelsi2,lsi2,fsi2,nrec4

;scales the model flux to 6.0 kpc (AG Car)? check input file
;f1=f1/(6.0*6.0)/1.0
linha=''

openu,1,ewdata
;finds the i number of points in ewdata
i=0
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1
skip1:
endwhile
close,1


;declare arrays
lambdac=dblarr(i) & cont=lambdac & ew=lambdac & sob=strarr(i) & sobc=strarr(i)
lambdac1=0. & cont1=0. & ew1=0. & sob1='A2' 

;read lambda central, continuum intensity, EW and transition ID
ewdata_header=''
openu,1,ewdata
readf,1,ewdata_header
for k=0, i-2 do begin
readf,1,lambdac1,cont1,ew1,sob1
sob1=strsub(sob1,4,50)
lambdac[k]=lambdac1 & cont[k]=cont1 & ew[k]=ew1 & sob[k]=sob1
endfor
close,1


;;print ew for a range of lambdas
;set_plot,'x'
;window,5
;plot,lambdac,abs(ew),xrange=[900,1180],/nodata
;FOR l=0, i-1 do begin
; IF (lambdac[l] gt 900) and (lambdac[l] lt 1180) and (abs(ew[l]) gt 0.2) then begin
; ;print,l,lambdac[l],ew[l],sob[l]
; pos=strpos(strtrim(sob[l],1),'(')
; sobc[l]=strmid(sob[l],2,pos+2)
;  IF (sobc[l] eq '  SIII') then begin
;  print,lambdac[l],ew[l],sobc[l]
;  xyouts,lambdac[l],abs(ew[l]),'!3'+string(45B),alignment=0.5,orientation=90
;  ENDIF
; ENDIF
;ENDFOR


;final redenning in model
minusebv=-0.65
a=3.5
;fm_unred, l1, f1, minusebv, f1, R_V = a
;fm_unred, lambdanoabs, fluxnoabsesc, minusebv, fluxnoabsescd, R_V = a

;set plot range
;x1l=925. & x1u=1055.
x1l=1260. & x1u=1390.
x2l=1385. & x2u=1500.
x3l=1500. & x3u=1752.
x4l=1750. & x4u=1952.
x5l=2500. & x5u=2820.
x6l=2850. & x6u=3120.

;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/output_iue_tes.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!X.thick=3.7
!Y.thick=3.7
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 6, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
coloro=fsc_color('black')
colorm=fsc_color('red')

s=1.0e-12
plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0,1.9e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata;,POSITION=[0.11,0.72,0.99,0.99]
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=a
plots,l1,f1/s,color=colorm,linestyle=lm,noclip=0,clip=[1270.0,0,x1u,1.9e-11/s],thick=b+1.5
plots,lsi2,fsi2/s,color=colorm,linestyle=lm,noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=b+1.5
for l=0, i-1 do begin
if (lambdac[l] gt x1l) and (lambdac[l] lt x1u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'FeIV') && (sobc[l] ne 'NiIV')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+0.1,14e-12/s,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charthick=3.5
endif
if (sobc[l] eq 'NiIV') then begin
;xyouts,lambdac[l],9e-12/s,'!3'+string(45B),alignment=0.5,orientation=90
;plots,lambdac[l]-0.1,9e-12/s,psym=1,symsize=0.7        ;using psym=1 (cross) for Ni IV, has to be consistent)
endif
if(sobc[l] eq '  FeIII') then begin
;xyouts,lambdac[l],5e-12/s,'!3'+string(45B),alignment=0.5,orientation=90
endif
endif
endfor

;putting labels on the first panel
;plots, [930,934],[5.3e-13,5.3e-13],color=fsc_color('grey')
;xyouts,935,5.1e-13,'AG Car FUSE obs. 2001 May',alignment=0,orientation=0
;plots, [930,934],[4.5e-13,4.5e-13],color=coloro,linestyle=1
;xyouts,935,4.3e-13,'CMFGEN model no IS abs.',alignment=0,orientation=0
;plots, [930,934],[3.7e-13,3.7e-13],color=fsc_color('purple')
;xyouts,935,3.5e-13,'CMFGEN model + IS abs. (N!IH!N=10!E21!N cm!E-2!N, N!IH2!N=10!E21!N cm!E-2!N)',alignment=0,orientation=0


plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x2l-1,x2u+1],yrange=[0,1.5e-11/s],ytickinterval=5.,xcharsize=2.0,ycharsize=2.0,$
thick=3.5,xthick=3.5,ythick=3.5,/nodata;,POSITION=[0.126,0.40,0.99,0.67]
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=a
plots,l1,f1/s,color=colorm,linestyle=lm, noclip=0,clip=[x2l,0,x2u,1.0e-11/s],thick=b+1.5
for l=0, i-1 do begin
if (lambdac[l] gt x2l) and (lambdac[l] lt x2u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'FeV') && (sobc[l] ne 'NiIV') && (sobc[l] ne 'FeIII') ) then begin
xyouts,lambdac[l],1.0e-11/s,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charthick=3.5
endif
if (sobc[l] eq 'NiIV') then begin
;plots,lambdac[l]-0.1,9e-12/s,psym=1,symsize=0.7        ;using psym=1 (cross) for Ni IV, has to be consistent)
endif
plotsym,0,/FILL
if (sobc[l] eq 'FeIII') then begin
;plots,lambdac[l]-0.1,12e-12/s,psym=8,symsize=0.4,thick=2        ;usingfilles circle for Fe III, has to be consistent)
endif
endif
endfor


plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x3l-1,x3u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=a
plots,l1,f1/s,color=colorm,linestyle=lm, noclip=0,clip=[x3l,0,x3u,1.0e-11/s],thick=b

for l=0, i-1 do begin
if (lambdac[l] gt x3l) and (lambdac[l] lt x3u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
;xyouts,lambdac[l],4.0e-12,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
;if (sobc[l] eq 'NiIV') then begin
;plots,lambdac[l]-0.1,9e-12/s,psym=1,symsize=0.7        ;using psym=1 (cross) for Ni IV, has to be consistent)
;endif
;plotsym,5
;if (sobc[l] eq 'FeIV') then begin
;plots,lambdac[l]-0.1,10.5e-12/s,psym=8,symsize=0.3,thick=2        ;usingfilles circle for Fe III, has to be consistent)
;endif
;plotsym,1
;if (sobc[l] eq 'FeIII') then begin
;xyouts,lambdac[l]-0.1,12e-12/s,'x',charsize=0.5,charthick=3.5        ;usingfilles circle for Fe III, has to be consistent)
;endif

endif
endfor

plot,lambdafuse,fluxfuse/s,xstyle=1,ystyle=1,xrange=[x4l-1,x4u+1],yrange=[0,1.3e-11/s],ytickinterval=5.,$
thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
plots,lambdafuse,fluxfuse/s,color=coloro,noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=a
plots,l1,f1*1.3/s,color=colorm,linestyle=lm, noclip=0,clip=[x4l,0,x4u,1.3e-11/s],thick=b

for l=0, i-1 do begin
if (lambdac[l] gt x3l) and (lambdac[l] lt x3u) and (abs(ew[l]) gt 0.2) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
;xyouts,lambdac[l],4.0e-12/s,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charthick=3.5
endif
endfor

plot,llwp,flwp/s,xstyle=1,ystyle=1,xrange=[x5l-1,x5u+1],yrange=[0.0e-11/s,1.4e-11/s],ytickinterval=5.,$
thick=3.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
plots,llwp,flwp/s,color=coloro,noclip=0,clip=[x5l,0.0e-11/s,x5u,0.6e-11/s],thick=a
plots,l1,f1*0.83/s,color=colorm,linestyle=lm, noclip=0,clip=[x5l,0,x5u,0.6e-11/s],thick=b+1.5
for l=0, i-1 do begin
if (lambdac[l] gt x5l) and (lambdac[l] lt x5u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
xyouts,lambdac[l]+2,10.0e-12/s,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charthick=3.5
endif
endfor


plot,llwp,flwp/s,xstyle=1,ystyle=1,xrange=[x6l-1,x6u+1],yrange=[0.25e-11/s,0.78e-11/s],ytickinterval=2.,$
xtitle=TEXTOIDL('Wavelength [ '+Angstrom+' ]'),$
thick=10.5,xthick=3.5,ythick=3.5,xcharsize=2.0,ycharsize=2.0,/nodata;,POSITION=[0.11,0.08,0.99,0.35],/nodata
plots,llwp,flwp/s,color=coloro,noclip=0,clip=[x6l,0.25e-11/s,x6u,0.5e-11/s],thick=a
plots,l1,f1*0.83/s,color=colorm,linestyle=lm, noclip=0,clip=[x6l,0.25e-11/s,x6u,0.6e-11/s],thick=b+1.5
for l=0, i-1 do begin
if (lambdac[l] gt x6l) and (lambdac[l] lt x6u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
xyouts,lambdac[l]+2.4,6.4e-12/s,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charthick=3.5
endif
endfor

xyouts,400,6500,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

set_plot,'x'

end
