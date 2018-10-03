PRO ZE_CCD_OBTAIN_SUFIX_FROM_STARNAME,starname,endsufix,sufix
;obtain sufix from starname file: removes all chracters after the first ocurrence of ENDSUFIX (and including EDNSUFIX) is found in the filename -- has to do it to take into account that e.g. flat157 and flat157b are different
;for a science target, will have toruble if star contains endsufix, e.g. star=80077 and endsufix=00

sufix=strarr(n_elements(starname))
for i=0, n_elements(starname)-1 do sufix[i]=strmid(starname[i],0,strpos(starname[i],'00'))


END