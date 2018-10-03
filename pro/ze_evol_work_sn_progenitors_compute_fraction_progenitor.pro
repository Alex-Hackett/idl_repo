;PRO ZE_EVOL_WORK_SN_PROGENITORS_COMPUTE_FRACTION_PROGENITOR
;computes fraction of SN progenitors of a given SN type assuming salpeter IMF
;computes, within a given SN type, the fraction of different progenitors

;data from eldridge+13 
eldtypeii=0.74
eldtypeiib=0.121
eldtypeiip=0.555
eldtypeiil=0.03
eldtypeinl=0.02
eldtypeibc=0.26
eldtypeib=0.09
eldtypeic=0.17
;print,eldtypeibc/eldtypeii

;total number of stars between 8.0 and 120.0 Msun, i.e., total number of CCSN progenitors
snproglow=8.0
snprogup=120.0
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,snproglow,snprogup,total_nstars_snprog,total_mstars_snprog

;type Ib
sniblowrot_wn=23.0
snibuprot_wn=30.1
sniblowrot_wo=82.0
snibuprot_wo=87.0
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniblowrot_wn,snibuprot_wn,nstars_snibrotwn,mstars_snibrotwn
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniblowrot_wo,snibuprot_wo,nstars_snibrotwo,mstars_snibrotwo
nstar_snibrot_total=nstars_snibrotwn+nstars_snibrotwo
print,'Fraction SN Ib rot from WN ',nstars_snibrotwn/nstar_snibrot_total
print,'Fraction SN Ib rot from WO ',nstars_snibrotwo/nstar_snibrot_total

print,'Fraction SN Ib rot total ',nstar_snibrot_total/total_nstars_snprog


;type Ic
snIclowrot_woa=30.1
snIcuprot_woa=82.0
snIclowrot_wob=87.0
snIcuprot_wob=120.0
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,snIclowrot_woa,snIcuprot_woa,nstars_snIcrotwoa,mstars_snIcrotwoa
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,snIclowrot_wob,snIcuprot_wob,nstars_snIcrotwob,mstars_snIcrotwob
nstar_snIcrot_total=nstars_snIcrotwoa+nstars_snIcrotwob
print,'Fraction SN Ic rot total ',nstar_snIcrot_total/total_nstars_snprog

;type II
sniiplowrot=8.0
sniipuprot=16.8
sniilnlowrot=16.8
sniilnuprot=23.0

ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniiplowrot,sniipuprot,nstars_sniiprot,mstars_sniiprot
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniilnlowrot,sniilnuprot,nstars_sniilrot,mstars_snIIlrot
nstar_snIIrot_total=nstars_sniiprot+nstars_sniilrot

print,'Fraction SN IIP rot ',nstars_sniiprot/total_nstars_snprog
print,'Fraction SN IIL/b rot ',nstars_sniilrot/total_nstars_snprog
print,'Fraction SN II rot',nstar_snIIrot_total/total_nstars_snprog

print,''
;non rotating
;type Ib
sniblownorot_wn=32.0
snibupnorot_wn=45.0
sniblownorot_wo1=45.0
snibupnorot_wo1=52.2
sniblownorot_wo2=106.4
snibupnorot_wo2=120.0
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniblownorot_wn,snibupnorot_wn,nstars_snibnorotwn,mstars_snibnorotwn
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniblownorot_wo1,snibupnorot_wo1,nstars_snibnorotwo1,mstars_snibnorotwo1
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniblownorot_wo2,snibupnorot_wo2,nstars_snibnorotwo2,mstars_snibnorotwo2
nstars_snibnorotwo=nstars_snibnorotwo1+nstars_snibnorotwo2
nstar_snibnorot_total=nstars_snibnorotwn+nstars_snibnorotwo
print,'Fraction SN Ib norot from WN ',nstars_snibnorotwn/nstar_snibnorot_total
print,'Fraction SN Ib norot from WO ',nstars_snibnorotwo/nstar_snibnorot_total
print,'Fraction SN Ib norot total ',nstar_snibnorot_total/total_nstars_snprog


;type Ic
snIclownorot_wo=52.2
snIcupnorot_wo=106.4
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,snIclownorot_wo,snIcupnorot_wo,nstars_snIcnorotwo,mstars_snIcnorotwo
nstar_snIcnorot_total=nstars_snIcnorotwo
print,'Fraction SN Ic norot total ',nstar_snIcnorot_total/total_nstars_snprog

;type II
sniiplownorot=8.0
sniipupnorot=19.0
sniilnlownorot=19.0
sniilnuporot=25.0

sniillownorot_rsg=19.0
sniilupnorot_rsg=24.0
sniillownorot_wnl=24.0
sniilupnorot_wnl=32.0
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniillownorot_rsg,sniilupnorot_rsg,nstars_ssniilnorot_rsg,mstars_ssniilnorot_rsg
ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniillownorot_wnl,sniilupnorot_wnl,nstars_ssniilnorot_wnl,mstars_ssniilnorot_wnl
nstar_sniilnorot_total=nstars_ssniilnorot_rsg+nstars_ssniilnorot_wnl
print,'Fraction SN IIL/b norot from RSG ',nstars_ssniilnorot_rsg/nstar_sniilnorot_total
print,'Fraction SN IIL/b norot from WN11 ',nstars_ssniilnorot_wnl/nstar_sniilnorot_total

ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,sniiplownorot,sniipupnorot,nstars_sniipnorot,mstars_sniipnorot
print,'Fraction SN IIL/b norot total ',nstar_sniilnorot_total/total_nstars_snprog
print,'Fraction SN IIP norot ',nstars_sniipnorot/total_nstars_snprog
nstar_snIInorot_total=nstars_sniipnorot+nstar_sniilnorot_total
print,'Fraction SN II norot',nstar_snIInorot_total/total_nstars_snprog

END