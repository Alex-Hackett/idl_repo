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
model='model23950_T224855_L483178_logg6d211_2'
model='P120z14S4_model064569_T252831_L0856258_logg6.349'
dirobs='/Users/jgroh/ze_models/SN_progenitor_grid/'
ZE_CMFGEN_READ_OBS,dirobs+model+'/obs/obs_fin',lambdamod,fluxmod,num_rec2,/flam

;scaling fluxmod to 2.3 kpc
;fluxmod=fluxmod/(6.0*6.0)
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
av=0
print,'model=',model
print,'mv=',V
;print,'mk=',K

;computing mabsv for a given distance and redenning parametesr
d=1.0 ;in kpc
ebv=0 ;in mag
r=3.1    ;reddening parameter
av=r*ebv
;av=0
;if V INCLUDES reddening (like observed values)
;V=[7.98,8.00,7.71,7.63,7.60,7.20,7.03] ;screwing up just to comput bc for the paper
mabsv=V-5.*alog10(d/0.01)-av

;if V DOES NOT INCLUDE reddening then
;mabsv=V-5.*alog10(d/0.01)
print,'Mv=',mabsv

;computing mbol for a given L
lstar= 856258.0;in Lsun
mbol=4.75 -2.5*alog10(lstar)
print,'Mbol=',mbol

;computing bc for a given mv and mbol, in V band
bc=mbol-mabsv
print,'Lbol=',lstar
print,'BC=',bc
!P.Background = fsc_color('white')
END