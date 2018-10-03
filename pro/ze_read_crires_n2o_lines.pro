PRO ZE_READ_CRIRES_N2O_LINES,lmin,lmax,wn2o,fn2o
filename='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/GEN_CALIB/gen/CR_GCAT_061130A_lines_n2o.fits'
ftab_help,filename
ftab_ext,filename,[1,2],wn2o,fn2o
wn2o=wn2o*10. ; converting to Angstroms
print,'Extraction of N2O lines is finished."
nearmin = Min(Abs(wn2o - lmin), indexmin)
nearmax = Min(Abs(wn2o - lmax), indexmax)
print,lmin,lmax,indexmin,indexmax
wn2o=wn2o[indexmin:indexmax]
fn2o=fn2o[indexmin:indexmax]
;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/espectros/n2o_lines_crires_vac.txt',wn2o,fn2o
END