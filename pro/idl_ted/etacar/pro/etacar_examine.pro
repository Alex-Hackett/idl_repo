pro etacar_examine_event,event

common etacar_examine,info,image,wave,position,h

	widget_control,event.id,get_uvalue=uvalue
	if n_elements(uvalue) eq 0 then return

	case uvalue of

	    'EXIT': begin
	    	image = 0
	    	widget_control,event.top,/destroy
	    	return
	    	end

	    'FILE_SEARCH': begin

	    	value = dialog_pickfile(dialog_parent = event.top, filter='*.fits', $
	    			/must_exist, title='Select Data File',path=info.path, $
	    			get_path=path)
	    	if value ne '' then begin
	    		widget_control,info.file_base,set_v=value
	    		info.path = path
	    	end
	    	end

	     'READ': begin
	     	widget_control,info.file_base,get_value=file
	     	filename = (file_search(file,count=count))[0]
	     	if count eq 0 then begin
	     		istat = dialog_message('Input file does not exist',dialog_parent=event.top, $
	     				/error)
	     		return
	     	end
	     	fits_read,filename,image,h
		w0 = sxpar(h,"CRVAL1")
		wc = sxpar(h,"CRPIX1")
		dw = sxpar(h,"CD1_1")
		dm = sxpar(h,"NAXIS1")
		wave = w0 + ((findgen(dm)+1-wc))*dw

		s0 = sxpar(h,"CRVAL2")
		sc = sxpar(h,"CRPIX2")
		ds = sxpar(h,"CD2_2")
		dm = sxpar(h,"NAXIS2")
		position = (s0 + ((findgen(dm)+1-sc))*ds) * 60*60	;deg to arcsec.

		fdecomp,filename,disk,dir,name
		wmin = min(wave) & wmax = max(wave)
		date = strtrim(sxpar(h,'date-obs'),2)
		text = name+'  '+string(wmin,'(F7.1)') +' to '+string(wmax,'(F7.1)')+' Ang.     '+ $
			date
		info.name = name + '    PA = '+strtrim(string(sxpar(h,'pa_aper'),'(F6.1)'),2)
		widget_control,info.text_base,set_v=text
		end

	    'NORM_SELECT': info.norm_select = event.value

	    'FULL_DISPLAY': begin
	        if n_elements(image) le 1 then begin
	        	istat = dialog_message('You must read a spectral image first',/error, $
	        			dialog_parent = event.top)
	        	return
	        end
	    	etacar_examine_normalize,image,wave,position,info,norm_image
	    	xmin = min(wave)
	    	xscale = (max(wave)-xmin)/(n_elements(wave)-1.0)
	    	ymin = min(position)
	    	yscale = (max(position)-ymin)/(n_elements(position)-1.0)
	    	s = size(norm_image) & nx = s(1) & ny=s(2)

		eta_car_tv,norm_image,xmin=xmin,xscale=xscale,ymin=ymin, $
				yscale=yscale,xtitle='Wavelength',ytitle='Arcsec', $
				title = info.name
		end
	    'REGION_DISPLAY': begin
	        if n_elements(image) le 1 then begin
	        	istat = dialog_message('You must read a spectral image first',/error, $
	        			dialog_parent = event.top)
	        	return
	        end
	        widget_control,info.wave_base,get_v=wrest
	        if wrest eq 0 then begin
	        	istat = dialog_message('You must first set the Rest Wavelength',/error, $
	        			dialog_parent = event.top)
	        	return
	        end
	        vel = (wave-wrest)/wrest*2.997925E5
		widget_control,info.vmin_base,get_v=vmin
		widget_control,info.vmax_base,get_v=vmax
		good = where((vel ge vmin) and (vel le vmax),ngood)
		if ngood lt 2 then begin
			istat = dialog_message('Invalid Rest Wavelength or Velocity Range',/error, $
					dialog_parent = event.top)
			return
		end
		ix1 = min(good)
		ix2 = max(good)
	        widget_control,info.spatial_base,get_v=srange
	        good = where((position ge (-srange/2.0)) and (position le (srange/2.0)),ngood)
		if ngood lt 2 then begin
			istat = dialog_message('Invalid Spatial Range',/error, $
					dialog_parent = event.top)
			return
		end
		iy1 = min(good)
		iy2 = max(good)
	    	etacar_examine_normalize,image,wave,position,info,norm_image
		norm_image = norm_image(ix1:ix2,iy1:iy2)
		v = vel(ix1:ix2)
		p = position(iy1:iy2)
		nx = n_elements(v)
		ny = n_elements(p)
	    	xmin = min(v)
	    	xscale = (max(v)-xmin)/(nx-1.0)
	    	ymin = min(p)
	    	yscale = (max(p)-ymin)/(ny-1.0)

		eta_car_tv,norm_image,xmin=xmin,xscale=xscale,ymin=ymin, $
				yscale=yscale,xtitle='Velocity',ytitle='Arcsec', $
				title = info.name+'  '+string(wrest,'(F8.2)')+' Ang.'
		end

	    else:
	endcase
end
;


;============================================================= ETACAR_EXAMINE_NORMALIZE
;
; Routine to normalize the image
;
pro etacar_examine_normalize,image,wave,position,info,norm_image

	if info.norm_select eq 0 then begin		;No normalization
		norm_image = image
		return
	end

	if info.norm_select eq 3 then begin
		widget_control,/hourglass
		widget_control,info.median_base,get_v=med
		norm_image = image
		s = size(norm_image) & nl = s(2)
		for i=0,nl-1 do norm_image(0,i) = image(*,i)- median(image(*,i),med)
		return
	end

	if info.norm_select eq 4 then begin
		widget_control,/hourglass
		widget_control,info.median_base,get_v=med
		s = size(image) & nl = s(2)
		cont = median(total(image,2),med)
		profile = fltarr(nl)
		for i=0,nl-1 do profile(i) = median(image(*,i))
		profile = profile/total(profile)
		norm_image = image - cont#profile
		return
	end
	widget_control,info.min_base,get_v=wmin
	widget_control,info.max_base,get_v=wmax

	if wmin eq 0 then begin
		wmin = min(wave)
		widget_control,info.min_base,set_v=wmin
	end

	if wmax eq 0 then begin
		wmax = max(wave)
		widget_control,info.max_base,set_v=wmax
	end
	good = where((wave ge wmin) and (wave le wmax),ngood)
	if ngood lt 1 then begin
		istat = dialog_message('Invalid normalization wavelength range',/error, $
				dialog_parent = info.topbase)
		norm_image = 0
		return
	end
	index1 = min(good)
	index2 = max(good)
	normvalue = total(image(index1:index2,*),1)/ngood
	s = size(image) & ns = s(1) & nl = s(2)
	norm_image = image
	print,info.norm_select
	if info.norm_select eq 2 then begin
		for i=0,nl-1 do norm_image(*,i) = image(*,i) - normvalue(i)
	    end else begin
	    	threshold = 0.0001*max(normvalue)
	    	for i=0,nl-1 do $
	    		if normvalue(i) ge threshold then norm_image(*,i) = image(*,i)/normvalue(i)
	end
end

pro etacar_examine

common etacar_examine,info,image,wave,position,h

;
; initialization
;

	if xregistered('etacar_examine') then return
	image = 0

	topbase = widget_base(/col,group=0)
	button = widget_button(topbase,uvalue='EXIT',value='EXIT')
	base = widget_base(topbase,/col,/frame)

;
; file
;
	row_base = widget_base(base,/row)
	file_base = cw_field(row_base,/row,title='File',uvalue='FILE',value=' ',xsize=70,/return_events)
	search_base = widget_button(row_base,uvalue='FILE_SEARCH',value='Search')
	text_base = widget_label(base,value=' ',xsize=400)
	button = widget_button(base,value='Read File',uvalue='READ')

;
; normalization
;
	base = widget_base(topbase,/col,/frame)
	label = widget_label(base,value='Normalization')
	norm_select = cw_bgroup(base,['None','Ratio','Subtract','Subtract Median Filter', $
			'Subtract Median Profile'], $
			set_value=0,uvalue='NORM_SELECT',/row,/exclusive)
	row_base = widget_base(base,/row)
	label = widget_label(row_base,value='Normalization Range       ')
	min_base = cw_field(row_base,value=0.0,/float,uvalue='MIN_BASE',title='Min:', $
			/return_events,xsize=20)
	max_base = cw_field(row_base,value=0.0,/float,uvalue='MAX_BASE',title='Max:', $
			/return_events,xsize=20)
	label = widget_label(row_base,value=' Angstroms')
	median_base = cw_field(base,value=75,uvalue='MEDIAN',/long,title='Median Filter Width', $
				xsize=10,/return_events)
	button = widget_button(base,value='Display Full Image',uvalue='FULL_DISPLAY')
;
; Region
;
	base = widget_base(topbase,/col,/frame)
	label = widget_label(base,value='Region Selection')
	wave_base = cw_field(base,/row,title='Rest Wavelength:',xsize=20,/float, $
			/return_events,value=0.0)
	row_base = widget_base(base,/row)
	label = widget_label(row_base,value='Velocity Range    ')
	vmin_base = cw_field(row_base,value=-600.0,/float,uvalue='VMIN_BASE',title='Min:', $
			/return_events,xsize=20)
	vmax_base = cw_field(row_base,value=600.0,/float,uvalue='VMAX_BASE',title='Max:', $
			/return_events,xsize=20)
	label = widget_label(row_base,value=' km/sec')
	spatial_base = 	cw_field(base,/row,title='Spatial Range (arcsec):',xsize=20,/float, $
			/return_events,value=3.5)
	button = widget_button(base,value='Display',uvalue='REGION_DISPLAY')
;
; create structure to hold widget information
;
	info = {file_base:file_base, norm_select:0, min_base:min_base, max_base:max_base, $
		text_base:text_base, vmin_base: vmin_base, vmax_base:vmax_base, $
		wave_base:wave_base, spatial_base:spatial_base,  $
		path:'',name:'',topbase:topbase, median_base:median_base}
	widget_control,topbase,/realize
	xmanager,'etacar_examine',topbase,/no_block

end

