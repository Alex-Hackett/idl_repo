;derreden (or redden) ascii spectra
model='17'
;readcol,'/Users/jgroh/espectros/agcar/'+model+'_all.txt',lambda,flux
readcol,'/Users/jgroh/espectros/irc10420/irc10420_mod'+model+'_all_vac.txt',lambda,flux
;readcol,'/Users/jgroh/espectros/agcar/'+model+'c',lambda,flux
;readcol,'/Users/jgroh/espectros/agcar/var_191_regrid_223_mdot8_car.txt',lambda,flux
nlines= (size(lambda))[1]

;scales the flux to 5 kpc
flux6=flux/25.0

;final redenning
minusebv=-2.58
a=3.1
fm_unred, lambda, flux6, minusebv, flux6dfin, R_V = a

;defines file for writing ;
;vmfile='/Users/jgroh/espectros/agcar/'+model+'_all6_ebv65r35.txt'
vmfile='/Users/jgroh/espectros/irc10420/irc10420'+model+'_all5_vac_ebv258r31.txt'
;vmfile='/Users/jgroh/espectros/agcar/var_191_regrid_223_mdot8_car_ebv65r35.txt'
openw,1,vmfile     ; open file to write

for k=0., nlines-1 do begin
printf,1,FORMAT='(E12.6,2x,E12.6)',lambda[k],flux6dfin[k]
endfor
close,1

end
