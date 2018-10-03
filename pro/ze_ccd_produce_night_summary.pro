PRO ZE_CCD_PRODUCE_NIGHT_SUMMARY, dir,night,dir_out,starname,exptime,ut,airmass_val,rdnoise,time,ra,dec,nightarray,write=write,xwidget=xwidget,print_screen=print_screen,IRAFNAME=IRAFNAME
;routine to produce a night summary of a given night dir containing exposure name,EXPTIME, UT, airmass_val,rdnoise
;rdnoise is used to determine whether slow or fast readout was used: IF RDNOISE=4.8 fast readout, else RDNOISE=2.4 then slow readout WORKING !
;lists only .fits files
;default is to sort by increasing UT date/time of obsservations
;can get star name either from file name (default) or from keyword IRAFNAME in fits file -- the latter may yield some troubles 
;if files were e.g. renamed during the night because of typos or other mistakes.
SPAWN,'ls '+ dir+'*.fits',list
nfiles=n_elements(list)
starname=strarr(nfiles) & exptime=dblarr(nfiles)  & ut=strarr(nfiles)   & airmass_val=dblarr(nfiles) &  rdnoise=dblarr(nfiles) & starnamet=starname  
timestr=strarr(nfiles) & time=dblarr(nfiles) & ra=strarr(nfiles) & dec=strarr(nfiles) & nightarray=strarr(nfiles)

;could read all headers and put them in a string array, and later find what we want -- but If ain't broke don't fix it
FOR i=0, nfiles -1 DO BEGIN
  headertemp=headfits(list[i])
  IF KEYWORD_SeT(IRAFNAME) THEN BEGIN
    starnamet[i]=sxpar(headertemp,'IRAFNAME')
    starname[i]=strsplit(starnamet[i],'.imh',/extract,/regex)
  ENDIF ELSE starname[i]=strsplit(strsplit(list[i],'.fits',/extract,/regex),dir,/extract,/regex)
  exptime[i]=sxpar(headertemp,'EXPTIME')
  ut[i]=sxpar(headertemp,'UT')
  timestr[i]=sxpar(headertemp,'DATE-OBS')+ut[i]
  time[i]=date_conv(timestr[i])
  airmass_val[i]=sxpar(headertemp,'AIRMASS')
  rdnoise[i]=sxpar(headertemp,'RDNOISE')
  ra[i]=sxpar(headertemp,'RA')
  dec[i]=sxpar(headertemp,'DEC')
ENDFOR

;sort arrays according to ascending time of observations
starname=starname(sort(time))
exptime=exptime(sort(time))
ut=ut(sort(time))
airmass_val=airmass_val(sort(time))
rdnoise=rdnoise(sort(time))
ra=ra(sort(time))
dec=dec(sort(time))
time=time(sort(time))

FOR i=0, nfiles -1 DO BEGIN
   IF KEYWORD_SET(print_screen) THEN print,FORMAT='(A20,2x,F5.1,2x,A12,2x,F6.3,2x,F5.1,2x,A12,2x,A12)',starname[i], exptime[i], UT[i], airmass_val[i],rdnoise[i]
   nightarray[i]=starname[i]+'  '+number_formatter(exptime[i],decimals=1)+'  '+ UT[i]+'  '+ number_formatter(airmass_val[i],decimals=3)+'  '+ number_formatter(rdnoise[i],decimals=1)+'  ' + ra[i] + '  '+ dec[i]
ENDFOR

IF KEYWORD_SET(write) THEN WRT_ASCII,nightarray,dir_out+'log_'+night+'.txt'
IF KEYWORD_SET(xwidget) THEN XDISPLAYFILE,'',text=nightarray,title='Night log '+night,/grow_to_screen

END