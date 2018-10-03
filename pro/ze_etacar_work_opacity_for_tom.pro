;PRO ZE_ETACAR_WORK_OPACITY_FOR_TOM
fileclump='/Users/jgroh/etc_john_mod111_clump_r.txt'
fileden='/Users/jgroh/etc_john_mod111_yden_r.txt'
fileop='/Users/jgroh/etc_john_mod111_chi_cmminus1_r.txt'
fileop_all='/Users/jgroh/etacar_john_mod111_chi_op_au_43_54_64_80_125_164_216_354.txt'
fileeta_all='/Users/jgroh/etacar_john_mod111_eta_emiss_au_43_54_64_80_125_164_216_354.txt'
file_jc_4340='/Users/jgroh/etacar_mod111_john_Jc_4340_r_au.txt'
file_op_4340='/Users/jgroh/op_4340.txt' ;in cm-1, au
file_eta_4340='/Users/jgroh/eta_4340.txt' ;in erg/s/cm^3/Hz, au
file_op_21400='/Users/jgroh/op_21400.txt' ;in cm-1, au
file_eta_21400='/Users/jgroh/eta_21400.txt' ;in erg/s/cm^3/Hz, au

;values of wavelengths
wavelength=[4319,5494]

ZE_READ_SPECTRA_COL_VEC,fileden,dist,yden,nrec
ZE_READ_SPECTRA_COL_VEC,fileclump,dist3,clump,nrec
chi_op=read_ascii(fileop_all)
eta_emiss=read_Ascii(fileeta_all)
ZE_READ_SPECTRA_COL_VEC,fileop,dist2,op,nrec
ZE_READ_SPECTRA_COL_VEC,file_jc_4340,dist4,jc4340,nrec
opcm2=op-yden
k_op_cm2_g=chi_op
FOR I=0,14,2 DO BEGIN
k_op_cm2_g.field01[i+1,*]=10^(chi_op.field01[i+1,*])/(10^(yden)*clump)
ENDFOR

file='/Users/jgroh/temp/etacar_mod11_john_op_cm2_g_bvrijhkl_to_tom.asc'
close,1
openw,1,file     ; open file to write

for k=0, 65-1 do begin
printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',k_op_cm2_g.field01[0,k],k_op_cm2_g.field01[1,k],k_op_cm2_g.field01[3,k],k_op_cm2_g.field01[5,k],k_op_cm2_g.field01[7,k],k_op_cm2_g.field01[9,k],$
                                    k_op_cm2_g.field01[11,k],k_op_cm2_g.field01[13,k],k_op_cm2_g.field01[15,k]
endfor
close,1

beta2=2.5e-4*500./(1e-6*3000.)
beta=(25/6.)
D=1.5
sep_apex_prim=beta^(0.5)*D/(1.+SQRT(beta))
!P.Background = fsc_color('white')

r_val=k_op_cm2_g.field01[0,20:64]
op_b=k_op_cm2_g.field01[1,20:64]

r_val_r1=REVERSE(r_val[20:24])
r_val_r2=REVERSE(r_val[16:20])
r_val_r3=REVERSE(r_val[0:16])

op_b_r1=REVERSE(op_b[20:24])
op_b_r2=REVERSE(op_b[16:20])
op_b_r3=REVERSE(op_b[0:16])

fit_r1=linfit(r_val_r1, op_b_r1, chisq = chisq_r1, prob = prob_r1, yfit=yfit_r1, sigma=sigma_r1)
fit_r2=linfit(r_val_r2, op_b_r2, chisq = chisq_r2, prob = prob_r2, yfit=yfit_r2, sigma=sigma_r2)
fit_r3=linfit(r_val_r3, op_b_r3, chisq = chisq_r3, prob = prob_r3, yfit=yfit_r3, sigma=sigma_r3)

ZE_READ_SPECTRA_COL_VEC,file_op_4340,dist4,op4340,nrec
ZE_READ_SPECTRA_COL_VEC,file_eta_4340,dist4,eta4340,nrec

ZE_READ_SPECTRA_COL_VEC,file_op_21400,dist4,op21400,nrec
ZE_READ_SPECTRA_COL_VEC,file_eta_21400,dist4,eta21400,nrec

s4340=eta4340-op4340
s21400=eta21400-op21400

a=19
b=50
print,dist4
fit_s4340=linfit(alog10(dist4[a:b]), s4340[a:b], chisq = chisq_s4340, prob = prob_s4340 ,yfit=yfit_s4340, sigma=sigma_jc)
;lineplot,alog10(dist4[a:b]), s4340[a:b]
;lineplot,alog10(dist4[a:b]),yfit_s4340
fit_s21400=linfit(alog10(dist4[a:b]), s21400[a:b], chisq = chisq_s21400, prob = prob_s21400 ,yfit=yfit_s21400, sigma=sigma_jc)
lineplot,alog10(dist4[a:b]), s21400[a:b]
lineplot,alog10(dist4[a:b]),yfit_s21400

jc4340=jc4340-23
print,dist4
dist4=dist4*1.496e+13
dist4au=dist4/1.496e+13
fit_jc4340=linfit(alog10(dist4[a:b]), jc4340[a:b], chisq = chisq_jc, prob = prob_jc ,yfit=yfit_jc, sigma=sigma_jc)
fit_jc4340lin=poly_fit(dist4,jc4340,5,yfit=yfit_jc4340lin)




;lineplot,r_val_r1,yfit_r1
;lineplot,r_val_r2,yfit_r2
;lineplot,r_val_r3,yfit_r3
;lineplot,r_val_r1,op_b_r1
;lineplot,r_val_r2,op_b_r2
;lineplot,r_val_r3,op_b_r3

;lineplot,dist4,jc4340

;result2 = linfit(alog10(mass), alog10(gammavel2), sdev=errgv2/(2.3*gammavel2), chisq = chisq2, prob = prob2, yfit=yfit3, sigma=sigma2)
END