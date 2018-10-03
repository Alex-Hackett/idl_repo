pro etacar_log,create=create

	!priv = 2
	if keyword_set(create) then dbcreate,'etacar_log',1,1,/ext

	dir = dialog_pickfile(/directory,title='Select directory to catalog')
	if dir eq '' then return
	list = findfile(dir+'c*.fits',count=count)
	if count eq 0 then begin
		print,'No FITS files found in '+dir
		retall
	end

	dbopen,'etacar_log',1
	dbrd,0,e

	keyword = ['opt_elem','cenwave','minwave','maxwave','aperture','ra_aper','dec_aper', $
		   'pa_aper','tdateobs','targname','rootname','texptime']


	for i=0,n_elements(list)-1 do begin
		fdecomp,list[i],disk,dir,name
		dbput,'filename',name,e
		fits_read,list(i),d,h,/header_only
		for j=0,n_elements(keyword)-1 do dbput,keyword[j],sxpar(h,keyword[j]),e
		dbput,'mjd',sxpar(h,'expstart'),e
		date = sxpar(h,'tdateobs')
		year = fix(gettok(date,'-'))
		month = fix(gettok(date,'-'))
		day = fix(date)
		jd = julday(month,day,year)
		jd1 = julday(1,1,year)
		jd2 = julday(1,1,year+1)
		year = year + (double(jd)-jd1)/(jd2-jd1)
		dbput,'year',year,e
		ra = sxpar(h,'ra_aper')
		dec = sxpar(h,'dec_aper')
		dbput,'delta_ra',(ra-1.612650833333d2)*60*60/cos(dec/!radeg),e
		dbput,'delta_dec',(dec+5.968447222222D+01)*60*60,e
		dbwrt,e,0,1
	end
	dbclose
end

