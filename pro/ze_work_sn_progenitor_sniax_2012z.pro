;PRO ZE_WORK_SN_PROGENITOR_SNIAX_2012Z
;determining the de-reddened photomerty for the progenitor of 2012Z from McCully+ 2014, Nature
;the idea is to determine the initial mass based on the relationships we find for the non-rotating and rotating models

;WILL LOOK AT THIS LATER, HAS TO EDIT THE PROGRAM


;restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_mag_bcs_all.sav'
restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_mag_bcs_onlycmfgen.sav'
restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_rsgs_mag_bcs_all.sav'
model_array_rot=[model_array_rot_rsgl,model_array_rot]
mstar_array_rot=[cmreplicate(evolmass_array_rot_rsg,n_elements(bands)),mstar_array_rot]
Mv_array_rot=[absmag_array_rot_rsg_scl_to_evol,Mv_array_rot]
sntype_array_rot=[sntype_array_rot_rsg,sntype_array_rot]
uminusb_rot=[uminusb_rot_rsg,uminusb_rot]
bminusv_rot=[bminusv_rot_rsg,bminusv_rot]
vminusi_rot=[vminusi_rot_rsg,vminusi_rot]
BC_array_rot=[BC_array_rot_rsg,BC_array_rot]
lstar_array_rot=[cmreplicate(evollstar_array_rot_rsg,n_elements(bands)),lstar_array_rot]
tstar_array_rot=[cmreplicate(evoltstar_array_rot_rsg,n_elements(bands)),tstar_array_rot]
teff_array_rot=[cmreplicate(evolteff_array_rot_rsg,n_elements(bands)),teff_array_rot]

model_array_norot=[model_array_norot_rsgl,model_array_norot]
mstar_array_norot=[cmreplicate(evolmass_array_norot_rsg,n_elements(bands)),mstar_array_norot]
Mv_array_norot=[absmag_array_norot_rsg_scl_to_evol,Mv_array_norot]
sntype_array_norot=[sntype_array_norot_rsg,sntype_array_norot]
uminusb_norot=[uminusb_norot_rsg,uminusb_norot]
bminusv_norot=[bminusv_norot_rsg,bminusv_norot]
vminusi_norot=[vminusi_norot_rsg,vminusi_norot]
BC_array_norot=[BC_array_norot_rsg,BC_array_norot]
lstar_array_norot=[cmreplicate(evollstar_array_norot_rsg,n_elements(bands)),lstar_array_norot]
tstar_array_norot=[cmreplicate(evoltstar_array_norot_rsg,n_elements(bands)),tstar_array_norot]
teff_array_norot=[cmreplicate(evolteff_array_norot_rsg,n_elements(bands)),teff_array_norot]


extinction_bands=[1.532,1.324,1.0,0.748,0.50,1.0,1.025,0.875,0.575,0.282,0.190,0.114] ;U,B,V,R,I,F300w,f555w,f606W,f814W, J, H, K; assuming WFPC extinctions from Girardi, and UBVRI from Fitzpatrick 
;1) 1999br
mf606w99br=24.91   ;from Maund & Smartt 2005 ; van Dyk et al. 2003a finds 25.4
d99br=14.1 *1e3 ;in kpc
sigmad99br=2.6
ebv99br=0.024
a606wbr=ebv99br*3.1*extinction_bands[7]
a606wbr=0.06*extinction_bands[7]
absmagf606w99br=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf606w99br,d99br,a606wbr,/a_band)

;only for RSGs with fit Mini x absmag
j=7 ;F606W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot99br=massfitrot[0]+massfitrot[1]*absmagf606w99br
print,'99br abs mag 606',absmagf606w99br
print,'99br rot mass', massrot99br
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot99br=massfitnorot[0]+massfitnorot[1]*absmagf606w99br
print,'99br norot ', massnorot99br

;2) 1999em
mi99em=23.0   ;
d99em=11.7 *1e3 ;in kpc
sigmad99em=1.0
ebv99em=0.1
ai99em=ebv99em*3.1*extinction_bands[4]
absmagi99em=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mi99em,d99em,ai99em,/A_band)

;only for RSGs with fit Mini x absmag
j=4 ;I band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot99em=massfitrot[0]+massfitrot[1]*absmagi99em
print,'99em abs mag I',absmagi99em
print,'99em rot mass', massrot99em
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot99em=massfitnorot[0]+massfitnorot[1]*absmagi99em
print,'99em norot ', massnorot99em

;4) 1999gi
mf606w99gi=24.9   ; Smartt et al. 2001
d99gi=10.0 *1e3 ;in kpc
sigmad99gi=0.8
ebv99gi=0.21
a606w99gi=ebv99gi*3.1*extinction_bands[7]
absmagf606w99gi=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf606w99gi,d99gi,a606w99gi,/a_band)

;only for RSGs with fit Mini x absmag
j=7 ;F606W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot99gi=massfitrot[0]+massfitrot[1]*absmagf606w99gi
print,'99gi abs mag 606',absmagf606w99gi
print,'99gi rot mass', massrot99gi
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot99gi=massfitnorot[0]+massfitnorot[1]*absmagf606w99gi
print,'99gi norot ', massnorot99gi

;5) 2001du
mf814w01du=24.25   ;van Dik et al. 2003c (Smartt et al. 2009 gives I=24, which they claim similar, but it's not)
d01du=18.28 *1e3 ;in kpc (mu=31.31), PAturel+ 2002
sigmad01du=2.4 ;guess
ebv01du=0.17
a814w01du=ebv01du*3.1*extinction_bands[8]
absmagf814w01du=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w01du,d01du,a814w01du,/A_band)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot01du=massfitrot[0]+massfitrot[1]*absmagf814w01du
print,'01du abs mag 814',absmagf814w01du
print,'01du rot mass', massrot01du
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot01du=massfitnorot[0]+massfitnorot[1]*absmagf814w01du
print,'01du norot ', massnorot01du

;6) 2002hh DO LATER 
mi02hh=22.8   ;from Smartt+ 2009 using i_ccd=22.8, and calibration from INT-WFC to I frmo Irwin & Lewis 2001. FOUND IT SAFARI BOOKMARK BUT HAS TO USE V-R Landolt. RIGHT NOW ASSUMING iccd=I
d02hh=5.9 *1e3 ;in kpc
sigmad02hh=0.4
ai02hh=2.1
absmagi02hh=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mi02hh,d02hh,ai02hh,/a_band)

;only for RSGs with fit Mini x absmag
j=4 ;I band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot02hh=massfitrot[0]+massfitrot[1]*absmagi02hh
print,'02hh abs mag I',absmagi02hh
print,'02hh rot mass', massrot02hh
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot02hh=massfitnorot[0]+massfitnorot[1]*absmagi02hh
print,'02hh norot ', massnorot02hh

;7) 2003gd  DETECTION
mv03gd=25.72  ;from Smartt+ 2004 V=25.8 +-0.15, R=25.2 +- 0.5 (have to add 0.2 to 25.0)  , I=23.33 +- 0.13 (have to add 0.2 to 23.13), E(B-V)=0.14, Av=0.43
error_mv03gd=0.09
mr03gd=25.20
error_mr03gd=0.50
mi03gd=23.14
error_mi03gd=0.08 ; Maund & Smartt 2009 ;from late time imaging
d03gd=9.3 *1e3 ;in kpc
sigmad03gd=1.8 *1e3
ebv03gd=0.14
error_ebv03gd=0.13
av03gd=ebv03gd*3.1*extinction_bands[2]
error_av03gd=3.1*error_ebv03gd*extinction_bands[2]
ar03gd=ebv03gd*3.1*extinction_bands[3]
error_ar03gd=3.1*error_ebv03gd*extinction_bands[3]
ai03gd=ebv03gd*3.1*extinction_bands[4]
error_ai03gd=3.1*error_ebv03gd*extinction_bands[4]

;from late time imaging Maund+13
mf60603gd=25.06
error_m606w03gd=0.06
a60603gd=3.1*ebv03gd*extinction_bands[7]
error_a60603gd=3.1*0.04*extinction_bands[7]
absmagf606w03gd=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf60603gd,d03gd,a60603gd,/a_band,/errcalc,error_absmag=error_absmagf606w03gd,error_apparent_mag=error_m606w03gd,error_d=sigmad03gd,error_aband=error_a60603gd)

absmagv03gd=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mv03gd,d03gd,av03gd,/a_band,/errcalc,error_absmag=error_absmagv03gd,error_apparent_mag=error_mv03gd,error_d=sigmad03gd,error_aband=error_av03gd)
absmagr03gd=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mr03gd,d03gd,ar03gd,/a_band,/errcalc,error_absmag=error_absmagr03gd,error_apparent_mag=error_mr03gd,error_d=sigmad03gd,error_aband=error_ar03gd)
absmagi03gd=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mi03gd,d03gd,ai03gd,/a_band,/errcalc,error_absmag=error_absmagi03gd,error_apparent_mag=error_mi03gd,error_d=sigmad03gd,error_aband=error_ai03gd)

;only for RSGs with fit Mini x absmag
j=2 ;V band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot03gdv=massfitrot[0]+massfitrot[1]*absmagv03gd
print,'03gd abs mag v',absmagv03gd
print,'03gd rot mass v', massrot03gdv
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot03gdv=massfitnorot[0]+massfitnorot[1]*absmagv03gd
print,'03gd norot v', massnorot03gdv

j=3 ;R band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot03gdr=massfitrot[0]+massfitrot[1]*absmagr03gd
print,'03gd abs mag r',absmagr03gd
print,'03gd rot mass r', massrot03gdr
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot03gdr=massfitnorot[0]+massfitnorot[1]*absmagr03gd
print,'03gd norot r', massnorot03gdr

;in the paper include only I band and F606W, which are the ones where late imaging is available
j=4 ;I band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot03gdi=massfitrot[0]+massfitrot[1]*absmagi03gd
sigma_massrot03gdi=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagi03gd)^2+(massfitrot[1]*error_absmagi03gd)^2)
print,'03gd abs mag I',absmagi03gd
print,'03gd rot mass', massrot03gdi, ' +- ',sigma_massrot03gdi
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot03gdi=massfitnorot[0]+massfitnorot[1]*absmagi03gd
sigma_massnorot03gdi=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagi03gd)^2+(massfitnorot[1]*error_absmagi03gd)^2)
print,'03gd norot mass', massnorot03gdi, ' +- ',sigma_massnorot03gdi


j=7 ;F606W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot03gd606=massfitrot[0]+massfitrot[1]*absmagf606w03gd
sigma_massrot03gd606=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf606w03gd)^2+(massfitrot[1]*error_absmagf606w03gd)^2)
print,'06bc abs mag 606',absmagf606w03gd
print,'03gd rot mass', massrot03gd606, ' +- ',sigma_massrot03gd606
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot03gd606=massfitnorot[0]+massfitnorot[1]*absmagf606w03gd
sigma_massnorot03gd606=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf606w03gd)^2+(massfitnorot[1]*error_absmagf606w03gd)^2)
print,'03gd norot mass', massnorot03gd606, ' +- ',sigma_massnorot03gd606

meanerr,[massrot03gdi,massrot03gd606],[sigma_massrot03gdi,sigma_massrot03gd606],massrot03gd_ave,sigma_massrot03gd_ave,sigma_massrot03gd_ave_data
meanerr,[massnorot03gdi,massnorot03gd606],[sigma_massnorot03gdi,sigma_massnorot03gd606],massnorot03gd_ave,sigma_massnorot03gd_ave,sigma_massnorot03gd_ave_data

print,'Average 03gd rot mass: ', massrot03gd_ave, ' +- ', sigma_massrot03gd_ave
print,'Average 03gd norot mass: ', massnorot03gd_ave, ' +- ', sigma_massnorot03gd_ave


;8) 2003ie  
mr03ie=22.65   ;from Smartt+ 2009
d03ie=15.5 *1e3 ;in kpc
sigmad03ie=1.2
ebv03ie=0.013
ar03gd=ebv03ie*3.1*extinction_bands[3]
absmagr03ie=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mr03ie,d03ie,ar03gd,/a_band)

;only for RSGs with fit Mini x absmag
j=3 ;R band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot03ie=massfitrot[0]+massfitrot[1]*absmagr03ie
print,'03ie abs mag r',absmagr03ie
print,'03ie rot mass', massrot03ie
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot03ie=massfitnorot[0]+massfitnorot[1]*absmagr03ie
print,'03ie norot ', massnorot03ie

;9) 2004dg OK CORRECTED EXTINCTION OK!
mf814w04dg=25.0   ;Smartt+ 09
d04dg=20.0 *1e3 ;in kpc (mu=31.31), PAturel+ 2002
sigmad04dg=2.6 
ebv04dg=0.24
ai04dg=0.36
a814w04dg=ebv04dg*3.1*extinction_bands[8]
absmagf814w04dg=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w04dg,d04dg,a814w04dg,/a_band)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot04dg=massfitrot[0]+massfitrot[1]*absmagf814w04dg
print,'04dg abs mag 814',absmagf814w04dg
print,'04dg rot mass', massrot04dg
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot04dg=massfitnorot[0]+massfitnorot[1]*absmagf814w04dg
print,'04dg norot ', massnorot04dg

;10) 2005cs DETECTION
mf814w05cs=23.26   ;from Maund, Smartt & Danziger 2005
error_m814w05cs=0.03
av05cs=0.34 ;Pastorello + 06, quoted in Eldridge+07; Maund uses E(B-V)=0.14 => Av=0.43

mf814w05cs=23.62   ; from Maund et al. 2013 with late imaging 
error_m814w05cs=0.07
d05cs=8.4 *1e3 ;in kpc (mu=31.31), PAturel+ 2002
sigmad05cs=1.0*1e3 
ebv05cs=0.22 ;+- 0.05 Maund et al 2013
av05cs=ebv05cs*3.1 ;assuming galactic reddening law
a814w05cs=av05cs*extinction_bands[8]
error_a814w05cs=av05cs*extinction_bands[8]*0.05
absmagf814w05cs=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w05cs,d05cs,a814w05cs,/a_band,/errcalc,error_absmag=error_absmag814w05cs,error_apparent_mag=error_m814w05cs,error_d=sigmad05cs,error_aband=error_a814w05cs)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot05cs814=massfitrot[0]+massfitrot[1]*absmagf814w05cs
print,'05cs abs mag 814',absmagf814w05cs
sigma_massrot05cs814=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w05cs)^2+(massfitrot[1]*error_absmag814w05cs)^2)
print,'05cs rot mass', massrot05cs814, ' +- ',sigma_massrot05cs814

massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot05cs814=massfitnorot[0]+massfitnorot[1]*absmagf814w05cs
sigma_massnorot05cs814=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w05cs)^2+(massfitnorot[1]*error_absmag814w05cs)^2)
print,'05cs norot mass', massnorot05cs814, ' +- ',sigma_massnorot05cs814


;11) 2006bc
mf814w06bc=24.45   ;Smartt et al. 2009
d06bc=14.7 *1e3 ;in kpc
sigmad06bc=2.6
ebv06bc=0.205
a814w06bc=ebv06bc*3.1*extinction_bands[8]
absmagf814w06bc=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w06bc,d06bc,a814w06bc,/a_band)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot06bc=massfitrot[0]+massfitrot[1]*absmagf814w06bc
print,'06bc abs mag 814',absmagf814w06bc
print,'06bc rot mass', massrot06bc
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot06bc=massfitnorot[0]+massfitnorot[1]*absmagf814w06bc
print,'06bc norot ', massnorot06bc

;12) 2006my
mf814w06my=24.8   ;Smartt et al. 2009
d06my=22.3 *1e3 ;in kpc
sigmad06my=2.6
ebv06my=0.027

mf814w06my=24.86; ± 0.13. ;Maund et al. 2013 DETECTION
error_m814w06my=0.13
d06my=22.3 *1e3 ;in kpc
sigmad06my=2.6
ebv06my=0.49
error_ebv06my=0.25
a814w06my=ebv06my*3.1*extinction_bands[8]
error_a814w06my=ebv06my*3.1*extinction_bands[8]*0.25
absmagf814w06my=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w06my,d06my,a814w06my,/a_band,/errcalc,error_absmag=error_absmag814w06my,error_apparent_mag=error_m814w06my,error_d=sigmad06my,error_aband=error_a814w06my)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot06my=massfitrot[0]+massfitrot[1]*absmagf814w06my
sigma_massrot06my=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w06my)^2+(massfitrot[1]*error_absmag814w06my)^2)
print,'06my abs mag 814',absmagf814w06my
print,'06my rot mass', massrot06my, ' +- ',sigma_massrot06my
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot06my=massfitnorot[0]+massfitnorot[1]*absmagf814w06my
sigma_massnorot06my=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w06my)^2+(massfitnorot[1]*error_absmag814w06my)^2)
print,'06my norot mass', massnorot06my, ' +- ',sigma_massnorot06my


;13) 2006ov
mf814w06ov=24.2   ;Smartt et al. 2009
d06ov=12.6 *1e3 ;in kpc
sigmad06ov=2.4
ebv06ov=0.022
a814w06ov=ebv06ov*3.1*extinction_bands[8]
absmagf814w06ov=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w06ov,d06ov,a814w06ov,/a_band)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot06ov=massfitrot[0]+massfitrot[1]*absmagf814w06ov
print,'06ov absmag 814 ', absmagf814w06ov
print,'06ov rot mass', massrot06ov
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot06ov=massfitnorot[0]+massfitnorot[1]*absmagf814w06ov
print,'06ov norot ', massnorot06ov


mf814w06ov=23.19; ± 0.13. ;Li et al. 2007 detection
error_m814w06ov=0.18
d06ov=12.6 *1e3 ;in kpc
sigmad06ov=2.4e3
ebv06ov=0.022
error_ebv06ov=0.0
a814w06ov=ebv06ov*3.1*extinction_bands[8]
error_a814w06ov=0.0
absmagf814w06ov=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w06ov,d06ov,a814w06ov,/a_band,/errcalc,error_absmag=error_absmag814w06ov,error_apparent_mag=error_m814w06ov,error_d=sigmad06ov,error_aband=error_a814w06ov)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot06ov=massfitrot[0]+massfitrot[1]*absmagf814w06ov
sigma_massrot06ov=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w06ov)^2+(massfitrot[1]*error_absmag814w06ov)^2)
print,'06ov abs mag 814',absmagf814w06ov
print,'06ov rot mass', massrot06ov, ' +- ',sigma_massrot06ov
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot06ov=massfitnorot[0]+massfitnorot[1]*absmagf814w06ov
sigma_massnorot06ov=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w06ov)^2+(massfitnorot[1]*error_absmag814w06ov)^2)
print,'06ov norot mass', massnorot06ov, ' +- ',sigma_massnorot06ov



;14) 2007aa
mf814w07aa=24.44   ;Smartt et al. 2009
d07aa=20.5 *1e3 ;in kpc
sigmad07aa=2.6*1e3
ebv07aa=0.026
a814w07aa=ebv07aa*3.1*extinction_bands[8]
absmagf814w07aa=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w07aa,d07aa,a814w07aa,/a_band)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot07aa=massfitrot[0]+massfitrot[1]*absmagf814w07aa
print,'07aa rot mass', massrot07aa
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot07aa=massfitnorot[0]+massfitnorot[1]*absmagf814w07aa
print,'07aa norot ', massnorot07aa

;15) 2009md
mf606w09md=26.736;   ;Fraser et al. 2011 mF606W = 26.736 ± 0.15 mag and mF606W = 24.895 ± 0.08 in the HST flight system, corresponding to a Johnson–Cousins magnitude of mV = 27.32 ± 0.15 mag and mI = 24.89 ± 0.08 mag
error_m606w09md=0.15
d09md=21.28 *1e3 ;in kpc
sigmad09md=2.6*1e3
ebv09md=0.1
error_ebv09md=0.1 ; +0.1 - 0.05
a606w09md=ebv09md*3.1*extinction_bands[7]
error_a606w09md=error_ebv09md*3.1*extinction_bands[7]
absmagf606w09md=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf606w09md,d09md,a606w09md,/a_band,/errcalc,error_absmag=error_absmag606w09md,error_apparent_mag=error_m606w09md,error_d=sigmad09md,error_aband=error_a606w09md)

;only for RSGs with fit Mini x absmag
j=7 ;F606W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot09md606=massfitrot[0]+massfitrot[1]*absmagf606w09md
sigma_massrot09md606=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf606w09md)^2+(massfitrot[1]*error_absmag606w09md)^2)
print,'09md abs mag 606',absmagf606w09md
print,'09md rot mass', massrot09md606, ' +- ',sigma_massrot09md606
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot09md606=massfitnorot[0]+massfitnorot[1]*absmagf606w09md
sigma_massnorot09md606=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf606w09md)^2+(massfitnorot[1]*error_absmag606w09md)^2)
print,'09md norot mass', massnorot09md606, ' +- ',sigma_massnorot09md606

mf814w09md=24.895;   ;Fraser et al. 2011 mF606W = 26.736 ± 0.15 mag and mF814W = 24.895 ± 0.08 in the HST flight system, corresponding to a Johnson–Cousins magnitude of mV = 27.32 ± 0.15 mag and mI = 24.89 ± 0.08 mag
error_m814w09md=0.08
d09md=21.28 *1e3 ;in kpc
sigmad09md=2.6*1e3
ebv09md=0.1
error_ebv09md=0.1 ; +0.1 - 0.05
a814w09md=ebv09md*3.1*extinction_bands[8]
error_a814w09md=error_ebv09md*3.1*extinction_bands[8]
absmagf814w09md=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w09md,d09md,a814w09md,/a_band,/errcalc,error_absmag=error_absmag814w09md,error_apparent_mag=error_m814w09md,error_d=sigmad09md,error_aband=error_a814w09md)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot09md814=massfitrot[0]+massfitrot[1]*absmagf814w09md
sigma_massrot09md814=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w09md)^2+(massfitrot[1]*error_absmag814w09md)^2)
print,'09md abs mag 814',absmagf814w09md
print,'09md rot mass', massrot09md814, ' +- ',sigma_massrot09md814
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot09md814=massfitnorot[0]+massfitnorot[1]*absmagf814w09md
sigma_massnorot09md814=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w09md)^2+(massfitnorot[1]*error_absmag814w09md)^2)
print,'09md norot mass', massnorot09md814, ' +- ',sigma_massnorot09md814

meanerr,[massrot09md814,massrot09md606],[sigma_massrot09md814,sigma_massrot09md606],massrot09md_ave,sigma_massrot09md_ave,sigma_massrot09md_ave_data
meanerr,[massnorot09md814,massnorot09md606],[sigma_massnorot09md814,sigma_massnorot09md606],massnorot09md_ave,sigma_massnorot09md_ave,sigma_massnorot09md_ave_data

print,'Average 09md rot mass: ', massrot09md_ave, ' +- ', sigma_massrot09md_ave
print,'Average 09md norot mass: ', massnorot09md_ave, ' +- ', sigma_massnorot09md_ave

;16)SN 2009hd
mf814w09hd=23.50   ;using upper limit from Elias-rosa+ 2011; they foun an object with mF814W = 23.54 ± 0.14 mag ;We find that >26.1 mag in F555W and >23.5 mag in F814W. Note that the limit in F814W is very similar to the measure brightness of the progenitor candidate 
error_m814w09hd=0.14
d09hd=9.37 *1e3 ;in kpc  (μ = 29.86 ± 0.08 mag; )
sigmad09hd=0.34 *1e3
ebv09hd=1.23
av09hd=3.80
error_av09hd=0.14
a814w09hd=av09hd*extinction_bands[8]
error_a814w09hd=error_av09hd*extinction_bands[8]
absmagf814w09hd=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w09hd,d09hd,a814w09hd,/a_band,/errcalc,error_absmag=error_absmag814w09hd,error_apparent_mag=error_m814w09hd,error_d=sigmad09hd,error_aband=error_a814w09hd)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot09hd814=massfitrot[0]+massfitrot[1]*absmagf814w09hd
sigma_massrot09hd814=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w09hd)^2+(massfitrot[1]*error_absmag814w09hd)^2)
print,'09hd abs mag 814',absmagf814w09hd
print,'09hd rot mass', massrot09hd814, ' +- ',sigma_massrot09hd814
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot09hd814=massfitnorot[0]+massfitnorot[1]*absmagf814w09hd
sigma_massnorot09hd814=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w09hd)^2+(massfitnorot[1]*error_absmag814w09hd)^2)
print,'09hd norot mass', massnorot09hd814, ' +- ',sigma_massnorot09hd814

;17) 2012aw 
mf555w12aw=26.49 ;van dyk+ 2012
error_m555w12aw=0.07   ;van Dyk+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
a555w12aw=av12aw*extinction_bands[6]
error_a555w12aw=error_av12aw*extinction_bands[6]
absmagf555w12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf555w12aw,d12aw,a555w12aw,/a_band,/errcalc,error_absmag=error_absmag555w12aw,error_apparent_mag=error_m555w12aw,error_d=sigmad12aw,error_aband=error_a555w12aw)

;only for RSGs with fit Mini x absmag
j=10 ;F555W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12aw555=massfitrot[0]+massfitrot[1]*absmagf555w12aw
sigma_massrot12aw555=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf555w12aw)^2+(massfitrot[1]*error_absmag555w12aw)^2)
print,'12aw abs mag 555',absmagf555w12aw
print,'12aw rot mass', massrot12aw555, ' +- ',sigma_massrot12aw555
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12aw555=massfitnorot[0]+massfitnorot[1]*absmagf555w12aw
sigma_massnorot12aw555=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf555w12aw)^2+(massfitnorot[1]*error_absmag555w12aw)^2)
print,'12aw norot mass', massnorot12aw555, ' +- ',sigma_massnorot12aw555

mf814w12aw=23.39
error_m814w12aw=0.02   ;van Dyk+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
a814w12aw=av12aw*extinction_bands[8]
error_a814w12aw=error_av12aw*extinction_bands[8]
absmagf814w12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w12aw,d12aw,a814w12aw,/a_band,/errcalc,error_absmag=error_absmag814w12aw,error_apparent_mag=error_m814w12aw,error_d=sigmad12aw,error_aband=error_a814w12aw)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12aw814=massfitrot[0]+massfitrot[1]*absmagf814w12aw
sigma_massrot12aw814=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w12aw)^2+(massfitrot[1]*error_absmag814w12aw)^2)
print,'12aw abs mag 814',absmagf814w12aw
print,'12aw rot mass', massrot12aw814, ' +- ',sigma_massrot12aw814
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12aw814=massfitnorot[0]+massfitnorot[1]*absmagf814w12aw
sigma_massnorot12aw814=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w12aw)^2+(massfitnorot[1]*error_absmag814w12aw)^2)
print,'12aw norot mass', massnorot12aw814, ' +- ',sigma_massnorot12aw814

mfjw12aw=21.02
error_mjw12aw=0.03   ;van Dyk+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
ajw12aw=av12aw*extinction_bands[9]
error_ajw12aw=error_av12aw*extinction_bands[9]
absmagfjw12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mfjw12aw,d12aw,ajw12aw,/a_band,/errcalc,error_absmag=error_absmagjw12aw,error_apparent_mag=error_mjw12aw,error_d=sigmad12aw,error_aband=error_ajw12aw)

;only for RSGs with fit Mini x absmag
j=11 ;FjW
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12awj=massfitrot[0]+massfitrot[1]*absmagfjw12aw
sigma_massrot12awj=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagfjw12aw)^2+(massfitrot[1]*error_absmagjw12aw)^2)
print,'12aw abs mag j',absmagfjw12aw
print,'12aw rot mass', massrot12awj, ' +- ',sigma_massrot12awj
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12awj=massfitnorot[0]+massfitnorot[1]*absmagfjw12aw
sigma_massnorot12awj=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagfjw12aw)^2+(massfitnorot[1]*error_absmagjw12aw)^2)
print,'12aw norot mass', massnorot12awj, ' +- ',sigma_massnorot12awj

mfkw12aw=19.47
error_mkw12aw=0.19   ;van Dyk+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
akw12aw=av12aw*extinction_bands[11]
error_akw12aw=error_av12aw*extinction_bands[11]
absmagfkw12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mfkw12aw,d12aw,akw12aw,/a_band,/errcalc,error_absmag=error_absmagkw12aw,error_apparent_mag=error_mkw12aw,error_d=sigmad12aw,error_aband=error_akw12aw)

;only for RSGs with fit Mini x absmag
j=13 ;FkW
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12awk=massfitrot[0]+massfitrot[1]*absmagfkw12aw
sigma_massrot12awk=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagfkw12aw)^2+(massfitrot[1]*error_absmagkw12aw)^2)
print,'12aw abs mag k',absmagfkw12aw
print,'12aw rot mass', massrot12awk, ' +- ',sigma_massrot12awk
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12awk=massfitnorot[0]+massfitnorot[1]*absmagfkw12aw
sigma_massnorot12awk=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagfkw12aw)^2+(massfitnorot[1]*error_absmagkw12aw)^2)
print,'12aw norot mass', massnorot12awk, ' +- ',sigma_massnorot12awk


meanerr,[massrot12aw814,massrot12aw555],[sigma_massrot12aw814,sigma_massrot12aw555],massrot12aw_ave,sigma_massrot12aw_ave,sigma_massrot12aw_ave_data
meanerr,[massnorot12aw814,massnorot12aw555],[sigma_massnorot12aw814,sigma_massnorot12aw555],massnorot12aw_ave,sigma_massnorot12aw_ave,sigma_massnorot12aw_ave_data

print,'Average 12aw rot mass vD12: ', massrot12aw_ave, ' +- ', sigma_massrot12aw_ave
print,'Average 12aw norot mass vD12: ', massnorot12aw_ave, ' +- ', sigma_massnorot12aw_ave


;17b) 2012aw 
mf555w12aw=26.70 ;Fraser+ 2012
error_m555w12aw=0.06   ;Fraser+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
a555w12aw=av12aw*extinction_bands[6]
error_a555w12aw=error_av12aw*extinction_bands[6]
absmagf555w12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf555w12aw,d12aw,a555w12aw,/a_band,/errcalc,error_absmag=error_absmag555w12aw,error_apparent_mag=error_m555w12aw,error_d=sigmad12aw,error_aband=error_a555w12aw)

;only for RSGs with fit Mini x absmag
j=10 ;F555W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12aw555=massfitrot[0]+massfitrot[1]*absmagf555w12aw
sigma_massrot12aw555=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf555w12aw)^2+(massfitrot[1]*error_absmag555w12aw)^2)
print,'12aw abs mag 555',absmagf555w12aw
print,'12aw rot mass', massrot12aw555, ' +- ',sigma_massrot12aw555
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12aw555=massfitnorot[0]+massfitnorot[1]*absmagf555w12aw
sigma_massnorot12aw555=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf555w12aw)^2+(massfitnorot[1]*error_absmag555w12aw)^2)
print,'12aw norot mass', massnorot12aw555, ' +- ',sigma_massnorot12aw555

mf814w12aw=23.39
error_m814w12aw=0.02   ;Fraser+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
a814w12aw=av12aw*extinction_bands[8]
error_a814w12aw=error_av12aw*extinction_bands[8]
absmagf814w12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814w12aw,d12aw,a814w12aw,/a_band,/errcalc,error_absmag=error_absmag814w12aw,error_apparent_mag=error_m814w12aw,error_d=sigmad12aw,error_aband=error_a814w12aw)

;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12aw814=massfitrot[0]+massfitrot[1]*absmagf814w12aw
sigma_massrot12aw814=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagf814w12aw)^2+(massfitrot[1]*error_absmag814w12aw)^2)
print,'12aw abs mag 814',absmagf814w12aw
print,'12aw rot mass', massrot12aw814, ' +- ',sigma_massrot12aw814
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12aw814=massfitnorot[0]+massfitnorot[1]*absmagf814w12aw
sigma_massnorot12aw814=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagf814w12aw)^2+(massfitnorot[1]*error_absmag814w12aw)^2)
print,'12aw norot mass', massnorot12aw814, ' +- ',sigma_massnorot12aw814

mfjw12aw=21.1
error_mjw12aw=0.2   ;Fraser+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
ajw12aw=av12aw*extinction_bands[9]
error_ajw12aw=error_av12aw*extinction_bands[9]
absmagfjw12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mfjw12aw,d12aw,ajw12aw,/a_band,/errcalc,error_absmag=error_absmagjw12aw,error_apparent_mag=error_mjw12aw,error_d=sigmad12aw,error_aband=error_ajw12aw)

;only for RSGs with fit Mini x absmag
j=11 ;FjW
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12awj=massfitrot[0]+massfitrot[1]*absmagfjw12aw
sigma_massrot12awj=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagfjw12aw)^2+(massfitrot[1]*error_absmagjw12aw)^2)
print,'12aw abs mag j',absmagfjw12aw
print,'12aw rot mass', massrot12awj, ' +- ',sigma_massrot12awj
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12awj=massfitnorot[0]+massfitnorot[1]*absmagfjw12aw
sigma_massnorot12awj=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagfjw12aw)^2+(massfitnorot[1]*error_absmagjw12aw)^2)
print,'12aw norot mass', massnorot12awj, ' +- ',sigma_massnorot12awj

mfkw12aw=19.1
error_mkw12aw=0.4   ;Fraser+ 12
d12aw=10.0 *1e3 ;in kpc μ0 = 30.00 ± 0.09 m
sigmad12aw=0.41 *1e3
av12aw=3.1
error_av12aw=0.1
rv12aw=4.45
ebv12aw=av12aw/rv12aw
akw12aw=av12aw*extinction_bands[11]
error_akw12aw=error_av12aw*extinction_bands[11]
absmagfkw12aw=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mfkw12aw,d12aw,akw12aw,/a_band,/errcalc,error_absmag=error_absmagkw12aw,error_apparent_mag=error_mkw12aw,error_d=sigmad12aw,error_aband=error_akw12aw)

;only for RSGs with fit Mini x absmag
j=13 ;FkW
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
massrot12awk=massfitrot[0]+massfitrot[1]*absmagfkw12aw
sigma_massrot12awk=SQRT(sigmarot[0]^2+(sigmarot[1]*absmagfkw12aw)^2+(massfitrot[1]*error_absmagkw12aw)^2)
print,'12aw abs mag k',absmagfkw12aw
print,'12aw rot mass', massrot12awk, ' +- ',sigma_massrot12awk
massfitnorot = linfit(Mv_array_norot[0:4,j],mstar_array_norot[0:4,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
massnorot12awk=massfitnorot[0]+massfitnorot[1]*absmagfkw12aw
sigma_massnorot12awk=SQRT(sigmanorot[0]^2+(sigmanorot[1]*absmagfkw12aw)^2+(massfitnorot[1]*error_absmagkw12aw)^2)
print,'12aw norot mass', massnorot12awk, ' +- ',sigma_massnorot12awk


meanerr,[massrot12aw814,massrot12aw555],[sigma_massrot12aw814,sigma_massrot12aw555],massrot12aw_ave,sigma_massrot12aw_ave,sigma_massrot12aw_ave_data
meanerr,[massnorot12aw814,massnorot12aw555],[sigma_massnorot12aw814,sigma_massnorot12aw555],massnorot12aw_ave,sigma_massnorot12aw_ave,sigma_massnorot12aw_ave_data

print,'Average 12aw rot mass F12: ', massrot12aw_ave, ' +- ', sigma_massrot12aw_ave
print,'Average 12aw norot mass F12: ', massnorot12aw_ave, ' +- ', sigma_massnorot12aw_ave



;SN Ibc Progenitors listed in Eldridge+13
;1) 2010br upper limit
mf606w10br=25.7 ;eldridge
d10br=12.5 *1e3 ;in kpc 
sigmad10br=0.3 ;
av10br=0.04
rv10br=3.1
ebv10br=av10br/rv10br
a606w10br=av10br*extinction_bands[7]
absmagf606w10br=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf606w10br,d10br,a606w10br,/a_band)
print,absmagf606w10br



END