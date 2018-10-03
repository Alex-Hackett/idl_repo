PRO ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,header,keyword,keyword_val

pos_key_head_vec=strpos(header,keyword)
lineoff=WHERE(pos_key_head_vec ne -1)
cut1=strmid(header[lineoff],pos_key_head_vec[lineoff])
pos_eqsign=strpos(cut1,'=')
cut2=strmid(cut1,pos_eqsign+1)
cut3=strtrim(cut2,2)
pos_space=strpos(cut3,' ')
cut4=strmid(cut3,0,pos_space)
keyword_val=float(cut4)

END