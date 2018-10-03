close,/all
;defines arcturus spectrum for reading
spectrum='/home/groh/espectros/arcturus_ir_atlas/ab9250'  
openu,1,spectrum     ; open file without writing

;le fits
flux=mrdfits('/home/groh/espectros/camiv/w26_204spdmn.fits',0,header)
crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
s=size(flux)
lambda=dblarr(s[1]) & fluxd=lambda & lambda2=lambda
for k=0., s[1]-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

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
obs1=dblarr(i) & tel1=obs1 & ratio1=obs1 & obs2=dblarr(i) & tel2=obs1 & ratio2=obs1 & wavenumber=obs1

obs1c=0. & tel1c=0. & ratio1c=0. & obs2c=0. & tel2c=0. & ratio2c=0. & wavenumberc=0.



lambdaair=lambda
vactoair,lambdaair

;defines file output
output='/home/groh/data/gemini/gnirs_nsmith_2005A/reduced/etc108mdair.txt'
openw,6,rvsig     ; open file to write

for k=0, i-1 do begin
printf,6,lambdaair,flux
end
