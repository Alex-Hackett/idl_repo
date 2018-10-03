;read V passband from Maiz-Appelaniz
dir='/Users/jgroh/espectros/'
vpassfile='v_passband_johnson_appelaniz.txt'
;vpassfile='agcar/johnson_v_filter_response.txt'
kpassfile='2mass_k_response_inclatm.txt'
readcol,dir+vpassfile,lambdav,vpass,/SILENT
readcol,dir+kpassfile,lambdak,kpass,/SILENT
lambdak=lambdak*10000. ; for 2MASS input data
vpassband=int_tabulated(lambdav,vpass) ; for V band from Appelaniz
kpassband=int_tabulated(lambdak,kpass) ; for V band from Appelaniz
;computing V magnitudes
;V=-2.5 * log [Integral(Flambda*Rlambda*dlambda)/Integral(Rlambda*dlambda)]-21.1  from Bessel et al. 1998 MNRAS
model='17'
;readcol,dir+'/agcar/'+model+'_car6_ebv65r35.txt',lambdamod,fluxmod,/SILENT
;readcol,'/Users/jgroh/espectros/irc10420/irc10420'+model+'_all5_vac_ebv258r31.txt',lambdamod,fluxmod,/SILENT
;readcol,dir+'/etacar/etacar_john_mod111_full_flam.txt',lambdamod,fluxmod,/SILENT
model='mod14_groh'
dirobs='/Users/jgroh/ze_models/etacar/'
ZE_CMFGEN_READ_OBS,dirobs+model+'/obs/obs_fin',lambdamod,fluxmod,num_rec2,/flam

;l16=lambdamod
;f16=fluxmod

;scaling fluxmod to 2.3 kpc
fluxmod=fluxmod/(2.3*2.3)
linterp,lambdamod,fluxmod,lambdav,fluxmod_interpv
fluxmod_interpv_times_passband=fluxmod_interpv*vpass
fluxmod_total_v=int_tabulated(lambdav,fluxmod_interpv_times_passband)

;linterp,lambdamod,fluxmod,lambdav,fluxmod_interpv
;fluxmod_interpv_times_passband=fluxmod_interpv*vpass
;fluxmod_total_v=int_tabulated(lambdav,fluxmod_interpv_times_passband)

fluxmodjy=fluxmod
lambdadif=lambdamod
FOR i=0., (size(lambdamod))[1]-1 do fluxmodjy[i]=(lambdamod[i]^2 * fluxmod[i]) *1E5/ 3.
;FOR i=0., (size(lambdamod))[1]-2 do lambdadif[i]=lambdamod[i+1]-lambdamod[i] 

zeropointjy=1594
lambdaeffang=12350
zeropointflam=3.134e-10 ; for j
zeropointflam=4.29e-11 ; for K

V=-2.5*alog10(fluxmod_total_v/vpassband) -21.1
K=-2.5*alog10(fluxmod_total_v/vpassband) + 2.5*alog10(zeropointflam)
;include redenning?
ebv=1.00 ;in mag
r=5.0    ;reddening parameter
grey=2.0
av=r*ebv+grey
V=v+av
print,'model=',model
print,'mv=',V
;print,'mk=',K

;computing mabsv for a given distance and redenning parametesr
d=2.3 ;in kpc
ebv=1.00 ;in mag
r=5.0    ;reddening parameter
grey=2.0
av=r*ebv+grey
;av=0
;if V INCLUDES reddening (like observed values)
mabsv=V-5.*alog10(d/0.01)-av

;if V DOES NOT INCLUDE reddening then
;mabsv=V-5.*alog10(d/0.01)
print,'Mv=',mabsv

;computing mbol for a given L
lstar=5.0E6 ;in Lsun
mbol=4.75 -2.5*alog10(lstar)
print,'Mbol=',mbol

;computing bc for a given mv and mbol, in V band
bc=mbol-mabsv
print,'Lbol=',lstar
print,'BC=',bc
!P.Background = fsc_color('white')
END