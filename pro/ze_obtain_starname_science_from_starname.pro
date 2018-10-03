PRO ZE_OBTAIN_STARNAME_SCIENCE_FROM_STARNAME,dir,night,dir_out,star,sufix,angle,starname,exptime,ut,airmass_val,rdnoise,time,ra,dec,nightarray,starname_science,index_science_starname,write=write,xwidget=xwidget,print_screen=print_screen

index_science_starname=WHERE(strmatch(starname,'*tho*') EQ 0 AND strmatch(starname,'*bias*') EQ 0 AND strmatch(starname,'*fla*') EQ 0 AND $
         strmatch(starname,'*lixo*') EQ 0 AND strmatch(starname,'*tes*') EQ 0 AND strmatch(starname,'*foco*') EQ 0)

starname_science=starname(index_science_starname)
sufix_starname_science=sufix(index_science_starname)
angle_starname_science=angle(index_science_starname)
time_starname_science=time(index_science_starname)
exptime_starname_science=exptime(index_science_starname)
airmass_val_starname_science=airmass_val(index_science_starname)
ut_starname_science=ut(index_science_starname)
nightarray_starname_science=nightarray(index_science_starname)
rdnoise_starname_science=rdnoise(index_science_starname)

nscience=n_elements(index_science_starname)

FOR i=0, nscience -1 DO BEGIN
   IF KEYWORD_SET(print_screen) THEN print,FORMAT='(A20,2x,F5.1,2x,A12,2x,F6.3,2x,F5.1)',starname_science[i], exptime_starname_science[i], UT_starname_science[i], airmass_val_starname_science[i],rdnoise_starname_science[i]
ENDFOR

IF KEYWORD_SET(write) THEN WRT_ASCII,nightarray_starname_science,dir_out+'science_log_'+night+'.txt'
IF KEYWORD_SET(xwidget) THEN XDISPLAYFILE,'',text=nightarray_starname_science,title='Science log '+night,/grow_to_screen

END