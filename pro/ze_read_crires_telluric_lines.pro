PRO ZE_READ_CRIRES_N2O_LINES,wn2o,fn2o
filename='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/GEN_CALIB/gen/CR_GCAT_061130A_lines_n2o.fits'
ftab_help,filename
ftab_ext,filename,[1,2],wn2o,fn2o
w2no=w2no*10. ; converting to Angstroms
print,'Extraction of N2O lines is finished."
ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/espectros/n2o_lines_crires_vac.txt',wn2o,fn2o
END