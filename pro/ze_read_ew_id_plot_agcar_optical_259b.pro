close,/all
;defines ewdata for reading, as generated by CMF_FLUX (including header)
ewdata='/home/groh/espectros/agcar/ewdata_fin_256ed'  
openu,1,ewdata     ; open file without writing

;defines observed FUSE file
obsfuse='/home/groh/espectros/agcar/agcar_uves_03jan11nsys.txt'  
openu,2,obsfuse     ; open file without writing

;defines model continuum file
modelc='/home/groh/espectros/agcar/252_narv2.txt'  
openu,4,modelc    ; open file without writing

;defines model file
model='/home/groh/espectros/agcar/256_narv2.txt'  
openu,3,model    ; open file without writing

;finds the z number of depth points in model file
z=0.
while not eof(3) do begin
readf,3,linha
if linha eq '' then begin
goto,skip3
endif
z=z+1.0
skip3:
endwhile
close,3

;finds the w number of depth points in model continuum file
w=0.
while not eof(4) do begin
readf,4,linha
if linha eq '' then begin
goto,skip4
endif
w=w+1.0
skip4:
endwhile
close,4

;finds the u number of depth points in input IUE files
u=0.
while not eof(2) do begin
readf,2,linha
if linha eq '' then begin
goto,skip2
endif
u=u+1.
skip2:
endwhile
close,2

;declare arrays
lambdamod=dblarr(z) & fluxmod=lambdamod & b=lambdamod 
lambdafuse=dblarr(u) & fluxfuse=lambdafuse & c=lambdafuse
lambdacont=dblarr(w) & fluxcont=lambdacont
red1=dblarr(10000) & red2=red1 & red3=red1

;reads model
openu,3,model
r=0.
for k=0.,z-1 do begin
readf,3,lambdamod1,fluxmod1
if (lambdamod1 gt 3190.0) then begin 
lambdamod[k]=lambdamod1 & fluxmod[k]=fluxmod1
r=r+1.0
endif
endfor
close,3

;reads model continuum
openu,4,modelc
s=0.
for k=0.,w-1 do begin
readf,4,lambdacont1,fluxcont1
if (lambdacont1 lt 3390.0) then begin 
lambdacont[k]=lambdacont1 & fluxcont[k]=fluxcont1
s=s+1.0
endif
endfor
close,4


;reads IUE data
openu,2,obsfuse
for j=0.,u-1 do begin
readf,2,lambdafuse1,fluxfuse1
lambdafuse[j]=lambdafuse1 & fluxfuse[j]=fluxfuse1
endfor
close,2

;scales the model flux to 1.8 kpc (WR136)
fluxmodesc=fluxmod/(1.8*1.8)
fluxcontesc=fluxcont/(1.8*1.8)

linha=''

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

;print ew for a range of lambdas
for l=0, i-1 do begin
if (lambdac[l] gt 3470) and (lambdac[l] lt 11280) and (abs(ew[l]) gt 1.00) then begin
print,l,lambdac[l],ew[l],sob[l]
endif
endfor


;final redenning in model and continuum
;minusebv=-0.47
;a=4.0
;fm_unred, lambdamod, fluxmodesc, minusebv, fluxmodescd, R_V = a
;fm_unred, lambdacont, fluxcontesc, minusebv, fluxcontescd, R_V = a

;set plot range
x1l=4500. & x1u=4800.
x2l=4840. & x2u=5180.
x3l=5640. & x3u=6040.
x4l=1080. & x4u=1180.

; plot spectrum to window
set_plot,'x'
window,0,xsize=900,ysize=400,retain=2
;hline, 5.1e-11, /DATA ; put a horizontal line for Fe V transitions
plot,lambdafuse,fluxfuse,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,5],xtitle='wavelength (Angstrom)',$
ytitle='Normalized Flux',/nodata
plots,lambdafuse,fluxfuse,color=fsc_color('grey'),noclip=0,clip=[x1l,0,x1u,12]
plots,lambdamod,fluxmod,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,12]
;plots,lambdacont,(0.55*fluxcontescd+0.0e-11),color=255, noclip=0,clip=[x1l,0,x1u,12],linestyle=2
for l=0, i-1 do begin
if (lambdac[l] gt x1l) and (lambdac[l] lt x1u) and (abs(ew[l]) gt 0.3) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],2,pos+2)
if ((sobc[l] ne '  FeV') && (sobc[l] ne '  FeVI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l],4,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if (sobc[l] eq '  FeV') then begin
xyouts,lambdac[l],6,'!3'+string(45B),alignment=0.5,orientation=90
endif
if(sobc[l] eq '  FeVI') then begin
xyouts,lambdac[l],8,'!3'+string(45B),alignment=0.5,orientation=90
endif
endif
endfor


window,1,xsize=900,ysize=400,retain=2
plot,lambdafuse,fluxfuse,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,7],xtitle='wavelength (Angstrom)', ytitle='Normalized Flux',/nodata
plots,lambdafuse,fluxfuse,color=fsc_color('grey'), noclip=0,clip=[x2l,0,x2u,7]
plots,lambdamod,fluxmod,color=fsc_color('red'), noclip=0,clip=[x2l,0,x2u,7]
for l=0, i-1 do begin
if (lambdac[l] gt x2l) and (lambdac[l] lt x2u) and (abs(ew[l]) gt 2.00) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],2,pos+2)
if ((sobc[l] ne '  FeV') && (sobc[l] ne '  FeVI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l],6e,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if (sobc[l] eq '  FeV') then begin
xyouts,lambdac[l],4e,'!3'+string(45B),alignment=0.5,orientation=90
endif
if(sobc[l] eq '  FeVI') then begin
xyouts,lambdac[l],5,'!3'+string(45B),alignment=0.5,orientation=90
endif
endif
endfor

;making psplots
set_plot,'ps'
device,filename='/home/groh/espectros/agcar/output_opt.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=8.48,/inches
!p.multi=[0, 1, 3, 0, 0]

;1st panel, 925--1160 Angstrom
max1=1.71
plot,lambdafuse,fluxfuse,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.5,max1],xtitle='wavelength (Angstrom)',$
ytitle='Normalized Flux',/nodata,charsize=2
plots,lambdafuse,fluxfuse,color=fsc_color('black'),noclip=0,clip=[x1l,0.5,x1u,max1]
plots,lambdamod,fluxmod,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x1l,0.5,x1u,max1],linestyle=1,thick=3.5
;plots,lambdacont,(0.55*fluxcontescd+0.0e-11),color=255, noclip=0,clip=[x1l,0.3,x1u,13],linestyle=2
for l=0, i-1 do begin
if (lambdac[l] gt x1l) and (lambdac[l] lt x1u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HeI') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+4,max1-0.15,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if (sobc[l] eq 'HeI') then begin
xyouts,lambdac[l]+12,max1-0.2,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=45
endif
if(sobc[l] eq '  FeVI') then begin
xyouts,lambdac[l],8,'!3'+string(45B),alignment=0.5,orientation=90
endif
endif
endfor


;2nd panel
max2=1.2
plot,lambdafuse,alog10(fluxfuse),xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[-1,max2],xtitle='wavelength (Angstrom)', ytitle='Log Normalized Flux',/nodata,charsize=2
plots,lambdafuse,alog10(fluxfuse),color=fsc_color('black'),noclip=0,clip=[x2l,-1,x2u,max2]
plots,lambdamod,alog10(fluxmod),color=fsc_color('red'), noclip=0,clip=[x2l,-1,x2u,max2],linestyle=1,thick=3.5
for l=0, i-1 do begin
if (lambdac[l] gt x2l) and (lambdac[l] lt x2u) and (abs(ew[l]) gt 0.10) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'NII') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+4,max2-0.5,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if (sobc[l] eq 'NII') then begin
xyouts,lambdac[l]+4,max2-0.93,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if(sobc[l] eq 'HI') then begin
xyouts,lambdac[l]+13,max2-0.4,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=45
endif
endif
endfor

;3rd panel
max3=0.8
plot,lambdafuse,alog10(fluxfuse),xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[-0.3,max3],xtitle='wavelength (Angstrom)', ytitle='Log Normalized Flux',/nodata,charsize=2
plots,lambdafuse,alog10(fluxfuse),color=fsc_color('black'), noclip=0,clip=[x3l,-0.3,x3u,max3]
plots,lambdamod,alog10(fluxmod),color=fsc_color('red'), noclip=0,clip=[x3l,-0.3,x3u,max3],linestyle=1,thick=3.5
for l=0, i-1 do begin
if (lambdac[l] gt x3l) and (lambdac[l] lt x3u) and (abs(ew[l]) gt 0.1) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'NII') && (sobc[l] ne 'FeVI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+4,max3-0.15,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if (sobc[l] eq 'NII') then begin
xyouts,lambdac[l]+4,max3-0.5,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
endif
if(sobc[l] eq 'FeVI') then begin
xyouts,lambdac[l],5,'!3'+string(45B),alignment=0.5,orientation=90
endif
endif
endfor

!p.multi=[0, 0, 0, 0, 0]
device,/close


set_plot,'x'

end
