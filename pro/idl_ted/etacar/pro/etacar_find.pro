function etacar_find,cenwave,summary,minimum=minimum,maximum=maximum,year1,year2
;
; find files
;
	dbopen,'etacar_log'
	list = dbfind('cenwave='+strtrim(fix(cenwave),2),/silent)
	if list(0) eq -1 then begin
		summary=''
		return,''
	end
	if keyword_set(minimum) then begin
		list1 = dbfind('year<1998.5',list,/silent)
		list2 = dbfind('2003.5<year<2004',list,/silent)
		list = [list1,list2]
	end else begin
	    if keyword_set(maximum) then begin
	    	list1 = dbfind('1998.51<year<2003.49',list,/silent)
	    	list2 = dbfind('2004<year<2005',list,/silent)
	    	list = [list1,list2]
	    end else list = dbfind(strtrim(year1,2)+'<year<'+strtrim(year2,2),list,/silent)
	end
	list = dbsort(list,'pa_aper')
;
; get filenames and info
;
	if list(0) eq -1 then begin
		sumary = ''
		return,''
	   end else begin
	   	dbext,list,'filename,cenwave,aperture,pa_aper,texptime', $
	   			filename,cenwave,aperture,pa_aper,exptime
	   	summary = strmid(filename+'          ',0,11)+ $
	   			string(cenwave,'(I6)')+string(pa_aper,'(F8.2)')+ $
	   			'  '+aperture+string(exptime,'(F7.1)')
	   	return,filename
	 end

end
