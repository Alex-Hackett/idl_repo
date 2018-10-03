;PRO ZE_WORK_FLASH_SPECTRA_COMPARISON_13CU_98S_FOR_EWASS_TALK

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/98s_shivvers/sn1998s-both.absfluxnorm.flm',lobs98s,fobs98s ;not corrected for redenning
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_groh/2014_Groh_sn_csm_13cu/13ast_20130503_Keck2_v1.ascii.txt',lobs,fobs

z = 0.00286
lambda_factor=1+z
lobs98s=lobs98s/lambda_Factor

fobs98scnvl=ZE_SPEC_CNVL_VEL(lobs98s,fobs98s,175.0)


z = 0.025734 ;original 
z = 0.025534
lambda_factor=1+z
lobs=lobs/lambda_Factor



END