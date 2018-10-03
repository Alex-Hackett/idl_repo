pro etacar_map_event,event
	common etacar_map_common,info,list,images,headers

	widget_control,event.id,get_uvalue=uvalue

	case uvalue of
		'EXIT': begin
			widget_control,event.top,/destroy
			return
			end
		'DIR_BUTTON': begin
			dir = dialog_pickfile(title='Select Data Directory',/dir, $
					dialog_parent = event.top)
			if dir ne '' then widget_control,info.dir_base,set_value=dir
			end
		'DATE_SELECT': begin
			info.datetype = event.value
			if event.value eq 2 then sens=1 else sens=0
			widget_control,info.year1_base,sens=sens
			widget_control,info.year2_base,sens=sens
			end
		'CENWAVE': widget_control, info.wlist, set_value=[' ']

		'SEARCH': begin
			widget_control, info.cenwave_base, get_value=cenwave
			widget_control, info.year1_base, get_value=year1
			widget_control, info.year2_base, get_value=year2
			if info.datetype eq 0 then minimum=1
			if info.datetype eq 1 then maximum=1
			files = etacar_find(cenwave,list,minimum=minimum, $
					maximum=maximum,year1,year2)
			if files(0) eq '' then begin
				list=[' ']
				info.nlist = 0
				istat = dialog_message('No Files found for given CENWAVE/Date Range', $
						/error,dialog_parent=event.top)
			end else info.nlist = n_elements(list)
			widget_control,info.wlist,set_value=list
			end
		'FILE_LIST': return

		'ADD': begin
			widget_control,info.dir_base,get_value=dir
			files = dialog_pickfile(title='Select File(s) to add to list',dialog_parent=event.top, $
				filter = ['*.fits','*.*'],path=dir,/must_exist,/multiple)
			if files(0) eq '' then return

			for i=0,n_elements(files)-1 do begin
				fits_read,files[i],d,h,/header_only
				fdecomp,files[i],disk,dir,name
        print,dir
				files[i] = strmid(name+'          ',0,12)+ $  ;ERROR IS HERE -- FILENAME SIZE MAY CHANGE FROM 11 characters to 12
					string(sxpar(h,'cenwave'),'(I6)')+ $
					string(sxpar(h,'pa_aper'),'(F8.2)')+'  '+ $
					strtrim(sxpar(h,'aperture'))+ $
					string(sxpar(h,'exptime'),'(F7.1)')
			end

			if info.nlist eq 0 then list = files else list = [list,files]
			info.nlist = n_elements(list)
			widget_control,info.wlist,set_value=list
			end
		'DELETE': begin
			isel = widget_info(info.wlist,/list_select)
			if isel lt 0 then begin
				istat=dialog_message('You must first select a file on the '+ $
					'list to delete',/error,dialog_parent=event.top)
				return
			end
			if isel ge info.nlist then return
			mask = replicate(1,info.nlist)
			mask(isel) = 0
			good = where(mask)
			list = list(good)
			info.nlist = info.nlist-1
			widget_control,info.wlist,set_value = list
			widget_control,info.wlist,set_list_select = isel>0<(info.nlist-1)
			end
		'DELETE_ALL': begin
			info.nlist = 0
			list = [' ']
			widget_control,info.wlist,set_v=list
			end
		'NORM_TYPE': info.normtype = event.value
		'EXTRACT': begin
			n = info.nlist
			if n eq 0 then begin
				istat = dialog_message('You must first select input files',/error, $
						dialog_parent=event.top)
				return
			end
			if info.normtype eq 1 then median_filter = 1
			if info.normtype eq 2 then subtract = 1
			if info.normtype eq 3 then profile = 1
			widget_control,info.wave_base,get_value=wavelength
			widget_control,info.median_base,get_value=nmedian
			widget_control,info.wmin_base,get_value=w1
			widget_control,info.wmax_base,get_value=w2
			widget_control,info.vmin_base,get_value=v1
			widget_control,info.vmax_base,get_value=v2
			widget_control,info.smin_base,get_value=s1
			widget_control,info.smax_base,get_value=s2
			widget_control,info.dir_base,get_value=dir
			etacar_cleanup
			images = ptrarr(n)
			headers = ptrarr(n)
			widget_control,/hourglass
			for i=0,n-1 do begin
				file = dir[0]+gettok(list[i],' ')+'.fits'
				print,file
				etacar_map_extract_line,file,wavelength,image,h, $
					subtract=subtract,median_filter=median_filter,profile=profile, $
					wcont=[w1,w2],vrange=[v1,v2],srange=[s1,s2],nmedian=nmedian, $
					error_msg = error_msg
				if error_msg ne '' then begin
					istat = dialog_message(error_msg,/error,dialog_parent=event.top)
					etacar_cleanup
					widget_control,info.display_base,sens=0
					widget_control,info.display_map_button,sens=0
					return
				end
				images[i] = ptr_new(image)
				headers[i] = ptr_new(h)
				widget_control,info.display_label, $
					set_v='Completed '+strtrim(i+1,2)+' of '+strtrim(n,2)
			end
			widget_control,info.display_base,sens=1
			widget_control,info.display_map_button,sens=1
			widget_control,info.print_base,sensitive=1
			widget_control,info.print_sel_base,sensitive=1
			widget_control,info.display_sel_base,sens=1
			widget_control,info.ps_mosaic_base,sens=1
			return
			end

		'DISPLAY': begin
			loadct,3
			etacar_map_display,info,list,images,headers
			return
			end
		'DISPLAY_SEL': begin
			isel = widget_info(info.wlist,/list_select)
			if (isel lt 0) or (isel ge info.nlist) then begin
				istat=dialog_message('You must first select an observation on the '+ $
					'list to display',/error,dialog_parent=event.top)
				return
			end
			h = *headers[isel]
			widget_control,info.title_base,get_value=title1
			widget_control,info.wave_base,get_value=w
			title1 = title1[0]+string(w,'(F9.2)')+' Ang.
			title = gettok(list[isel],' ')+' PA = '+ $
				strtrim(string(sxpar(h,'pa_aper'),'(F7.2)'),2)+ $
				'  '+title1
			v0 = sxpar(h,'crval1')
			vc = sxpar(h,'crpix1')
			dv = sxpar(h,'cd1_1')
			nv = sxpar(h,'naxis1')
			vel = v0 + (findgen(nv)+1-vc)*dv
			s0 = sxpar(h,"CRVAL2")
			sc = sxpar(h,"CRPIX2")
			ds = sxpar(h,"CD2_2")
			dm = sxpar(h,"NAXIS2")
			position = (s0 + ((findgen(dm)+1-sc))*ds) * 3600.	;deg to arcsec.

			eta_car_tv,*images[isel],xmin=min(vel),xscale=dv,ymin=min(position), $
				yscale=ds*3600.,xtitle='Velocity (km/sec)',ytitle='Arcsec',title=title
			return

			end
		'PRINT_SEL': begin
			isel = widget_info(info.wlist,/list_select)
			if (isel lt 0) or (isel ge info.nlist) then begin
				istat=dialog_message('You must first select an observation on the '+ $
					'list to display',/error,dialog_parent=event.top)
				return
			end
			h = *headers[isel]
			widget_control,info.title_base,get_value=user_title
			widget_control,info.wave_base,get_value=w
			title1 = user_title[0]+string(w,'(F9.2)')+' Ang.
			title = gettok(list[isel],' ')+' PA = '+ $
				strtrim(string(sxpar(h,'pa_aper'),'(F7.2)'),2)+ $
				'  '+title1
			image = *images[isel]
			dmax = max(image)
			etacar_print_options,contrast,dmin,dmax,file,colortab,xsize,ysize,include_title, $
				group=event.top
			if include_title eq 0 then title=''

		    filename = gettok(list[isel],' ')
			filename = strtrim(file)+' '+filename+' '+strtrim(string(w,'(F9.2)'),2)+' '+ $
					strtrim(string(sxpar(h,'pa_aper'),'(F7.2)'),2)
			filename = strjoin(strsplit(filename,' ',/extract),'_')
			filename = strjoin(strsplit(filename,'.',/extract),'p')

			etacar_print_it,h,image,info,list,contrast,dmin,dmax,filename+'.ps',colortab,$
				xsize,ysize,title
			return
			end
		'PRINT': begin
			dmin = 0.0
			dmax = 0.0
		    for i=0,n_elements(images)-1 do dmax = dmax>max(*images[i])
			widget_control,info.title_base,get_value=title1
			widget_control,info.wave_base,get_value=w
			title1 = title1[0]+string(w,'(F9.2)')+' Ang.
			etacar_print_options,contrast,dmin,dmax,file,colortab,xsize,ysize,include_title, $
				group=event.top

			for isel=0,n_elements(images)-1 do begin
				h = *headers[isel]
				title = gettok(list[isel],' ')+' PA = '+ $
					strtrim(string(sxpar(h,'pa_aper'),'(F7.2)'),2)+ $
					'  '+title1
				image = *images[isel]
				if include_title eq 0 then title=''

		    		filename = gettok(list[isel],' ')
					filename = strtrim(file)+' '+filename+' '+strtrim(string(w,'(F9.2)'),2)+' '+ $
							strtrim(string(sxpar(h,'pa_aper'),'(F7.2)'),2)
					filename = strjoin(strsplit(filename,' ',/extract),'_')
					filename = strjoin(strsplit(filename,'.',/extract),'p')

					etacar_print_it,h,image,info,list,contrast,dmin,dmax, $
						filename+'.ps',colortab,$
					xsize,ysize,title
			end
			return
			end
		'VEL_SELECT': begin
			info.vel_select = event.value
			return
			end
		'DISPLAY_MAP': begin
			k = info.vel_select
			widget_control,info.size_base,get_v=imsize
			widget_control,info.pixel_size_base,get_v=delta
			widget_control,info.title_base,get_value=title
			widget_control,info.wave_base,get_value=w
			title = title[0]+string(w,'(F9.2)')+' Ang.
			if k lt 4 then begin
				widget_control,info.velmin_base[k],get_v=vel1
				widget_control,info.velmax_base[k],get_v=vel2
				etacar_map_map_display,images,headers,delta=delta,imsize=imsize,image_out,ncoadds, $
					vmin=vel1,vmax=vel2,title=title, error_msg=error_msg
				bad = where(ncoadds eq 0,nbad)
				if nbad gt 0 then image_out(bad) = max(image_out)
				if error_msg ne '' then begin
					istat = dialog_message(error_msg,/error,dialog_parent=event.top)
					return
				end
				title = title + '   '+strtrim(string(vel1,'(F8.1)'),2) + ' to '+ $
				    			strtrim(string(vel2,'(F8.1)'),2)+' km/sec'
				s = size(image_out) & ns = s(1)

				eta_car_tv,image_out,title=title,xmin=-ns/2*delta,xscale=delta, $
				    		ymin=-ns/2*delta,yscale=delta,xtitle='Arcsec.',ytitle='Arcsec.', $
				    		mask = ncoadds gt 0
			   end else begin
				vel1 = fltarr(4)
				vel2 = fltarr(4)
				for i=0,3 do begin
					widget_control,info.velmin_base[i],get_v=v
					vel1[i]=v
					widget_control,info.velmax_base[i],get_v=v
					vel2[i]=v
				end
				good = where((vel1 ne 0) or (vel2 ne 0),ngood)>0
				vel1 = vel1[good]
				vel2 = vel2[good]

				etacar_map_map_display,images,headers,delta=delta,imsize=imsize,image_out,ncoadds, $
						vmin=vel1,vmax=vel2,title=title, error_msg=error_msg
				bad = where(ncoadds eq 0,nbad)
				if nbad gt 0 then image_out(bad) = max(image_out)
				if error_msg ne '' then begin
					istat = dialog_message(error_msg,/error,dialog_parent=event.top)
					return
				end
				s = size(image_out) & ns = s(1) & nl = s(2)

				case ngood of
					1: big = fltarr(ns,nl)
					2: big = fltarr(ns*2+2,nl)
					else: big = fltarr(ns*2+2,nl*2+2)
				end
				mask = byte(big)
				s = size(big) & nlout = s(2)
				for i=0,ngood-1 do begin
					ix = i mod 2
					iy = i/2
					big[ix*(ns+2),nlout-iy*(nl+2)-nl] = image_out[*,*,i]
					mask[ix*(ns+2),nlout-iy*(nl+2)-nl] = ncoadds[*,*,i] gt 0
				end
				eta_car_tv,big,title=title,mask=mask
			end
			return
			end
		'SCALE_SELECT': begin
			info.scale_type = event.value
			return
			end
		'PS_MAP': begin
			widget_control,info.min_base,get_value=dmin
			widget_control,info.max_base,get_value=dmax
			vel1 = fltarr(4)
			vel2 = fltarr(4)
			for i=0,3 do begin
				widget_control,info.velmin_base[i],get_v=v
				vel1[i]=v
				widget_control,info.velmax_base[i],get_v=v
				vel2[i]=v
			end
			good = where((vel1 ne 0) or (vel2 ne 0))>0
			vel1 = vel1[good]
			vel2 = vel2[good]
			widget_control,info.size_base,get_v=imsize
			widget_control,info.pixel_size_base,get_v=delta
			widget_control,info.title_base,get_value=title
			widget_control,info.wave_base,get_value=w
			title = title[0]+string(w,'(F9.2)')+' Ang.
			psfile = dialog_pickfile(title='Enter PS filename',filter='*.ps',/write, $
					dialog_parent=event.top)
			if psfile eq '' then return
			etacar_map_map_display,images,headers,delta=delta,imsize=imsize,image_out,ncoadds, $
				vmin=vel1,vmax=vel2,title=title, error_msg=error_msg, psfile=psfile, $
				scale_type = info.scale_type, dmin=dmin, dmax=dmax
			if error_msg ne '' then begin
				istat = dialog_message(error_msg,/error,dialog_parent=event.top)
				return
			end
			return
			end
		else:
	endcase
	widget_control,info.display_base,sensitive=0
	widget_control,info.display_map_button,sensitive=0
	widget_control,info.display_sel_base,sensitive=0
	widget_control,info.ps_mosaic_base,sensitive=0
	widget_control,info.print_base,sensitive=0
	widget_control,info.print_sel_base,sensitive=0
end


;============================================================================== ETACAR_MAP_EXTRACT_LINE
;
; Routine to subtract continuum and extract spectral lines.
;
pro etacar_map_extract_line,file,wavelength,image,h, $
	subtract=subtract,median_filter=median_filter,profile=profile, $
	wcont=wcont,vrange=vrange,srange=srange,nmedian=nmedian, $
	error_msg = error_msg

	if n_elements(wnorm) eq 0 then wnorm = [0,11000.]
	if n_elements(vrange) eq 0 then vrange = [-600,600]
	if n_elements(srange) eq 0 then srange = [-1.5,1.5]
	if n_elements(nmedian) eq 0 then nmedian = 75
	error_msg = ''
;
; read image
;
	fdecomp,file,disk,dir,fname
	name = fname+'_'+strtrim(round(wavelength),2)+'.fits'
	list = findfile(file,count=count)
	if count eq 0 then begin
		error_msg = 'File '+file+' not found'
		return
	end
	image = mrdfits(file,1,h,/silent)
	w0 = sxpar(h,"CRVAL1")
	wc = sxpar(h,"CRPIX1")
	dw = sxpar(h,"CD1_1")
	dm = sxpar(h,"NAXIS1")
	wave = w0 + ((findgen(dm)+1-wc))*dw
	print,min(wave),max(wave)
	wait,0.01
	nx = n_elements(wave)
	s0 = sxpar(h,"CRVAL2")
	sc = sxpar(h,"CRPIX2")
	ds = sxpar(h,"CD2_2")
	dm = sxpar(h,"NAXIS2")
	position = (s0 + ((findgen(dm)+1-sc))*ds) * 60*60	;deg to arcsec.
	ny = n_elements(position)
;
; Normalize image
;
	if keyword_set(subtract) then begin
		good = where((wave ge wcont[0]) and (wave le wcont[1]),ngood)
		if ngood lt 0 then begin
			error_msg = 'Continue wavelengths invalid for '+file
			return
		end
		index1 = good[0]
		index2 = good[ngood-1]
		image = image -  rebin(transpose(total(image[index1:index2,*],1)) $
					/ngood,nx,ny)
		sxaddhist,'Average from '+strtrim(wcont[0],2)+' to '+ $
					strtrim(wcont[1],2)+' subtracted',h
	end

	if keyword_set(median_filter) then begin
		for j=0,ny-1 do image[0,j] = image[*,j]-median(image[*,j],nmedian)
		sxaddhist,strtrim(nmedian,2)+' point median filtered (in X) image'+ $
				' subtracted',h
	end
	if keyword_set(profile) then begin
		cont = median(total(image,2),nmedian)
		yprofile = fltarr(ny)
		for j=0,ny-1 do yprofile[j] = median(image[*,j])
		yprofile = yprofile/total(yprofile)
		image = image - cont#yprofile
		sxaddhist,'X-disperion profile subtracted with nmedian = '+ $
			strtrim(nmedian,2),h
	end
;
; extract subsection around line
;
	vel = (wave-wavelength)/wavelength * 2.997925E5
	good = where((vel ge vrange[0]) and (vel le vrange[1]),ngood)
	if ngood eq 0 then begin
		error_msg = 'ERROR: Invalid line wavelength or velocity range specified'
		return
	end
	ix1 = min(good)
	ix2 = max(good)
	good = where((position ge srange[0]) and (position le srange[1]),ngood)
	if ngood le 0 then begin
		error_msg = 'ERROR: Invalid spatial range specified'
		return
	end
	iy1 = min(good)
	iy2 = max(good)
	image = image[ix1:ix2,iy1:iy2]
	vel = vel[ix1:ix2]
	position = position[iy1:iy2]
;
; update header coordinates
;
	sxaddpar,h,'crval1',vel[0]
	sxaddpar,h,'crpix1',1
	sxaddpar,h,'CD1_1',vel[1]-vel[0]
	sxaddpar,h,'crval2',(position[0])/3600.0
	sxaddpar,h,'crpix2',1
	sxaddpar,h,'CD2_2',(position[1]-position[0])/3600.0
	sxaddpar,h,'CTYPE1','VELOCITY','(km/sec)'
	sxaddpar,h,'naxis1',ix2-ix1+1
	sxaddpar,h,'naxis2',iy2-iy1+1
end

pro etacar_cleanup,event
	common etacar_map_common,info,list,images,headers

	if n_elements(images) gt 1 then begin
		ptr_free,images
		ptr_free,headers
	end
end
;========================================================================== ETACAR_MAP_DISPLAY
;
; Routine to display extracted spectral lines
;

pro etacar_map_display,info,list,images,headers
;
; determine grid size
;
	n = n_elements(images)
	ns = 0L
	nl = 0L
	immax = 0.0
	immin = 1e20
	for i=0,n-1 do begin
		s = size(*images[i])
		ns = ns>s[1]
		nl = nl>s[2]
		immax = immax > max(*images[i],/nan)
		immin = immin < min(*images[i],/nan)
	end
	for nx = n-1,1,-1 do begin
		ny = ceil(float(n)/nx)
		if nx*float(ns) lt (ny+0.6)*float(nl) then goto,next_step
	end
next_step:

;
; create mosaic
;
	xoff = 20
	yoff = 25
	if (xoff+ns) lt 150 then ns = 140-xoff
	nxbig = ns*nx + xoff*(nx-1)
	nybig = nl*ny + yoff*ny

	window,12,xs=nxbig,ys=nybig,/pixmap
	big = replicate(immin,nxbig,nybig)
	for i=0,n-1 do begin
		ix = i mod nx
		iy = (ny-1)-i/nx
		ixpos = ix*(ns+xoff)
		iypos = iy*(nl+yoff)
		title = gettok(list(i),' ') + string(sxpar(*headers[i],'pa_aper'),'(F8.2)')
		xyouts,ixpos+ns/2,iypos+nl+3,title,align=0.5,/dev
		big(ixpos,iypos) = *images[i]
	end
	pic = tvrd()
	wdelete,12
	big = big + (pic gt 0)*(immax-immin)

	wfc3_tv,big
end

;=============================================================================== ETACAR_MAP_MAP_DISPLAY
;
; Routine to create and display maps
;
pro etacar_map_map_display,image_in,h_in,delta=delta,imsize=imsize,images,ncoadds,vmin=vmin,vmax=vmax, $
	psfile=psfile,ctab=ctab,title=title, error_msg=error_msg, scale_type=scale_type, $
	dmin=dmin,dmax=dmax
;
	if n_elements(delta) eq 0 then delta = 0.1	;arsec/pixel
	if n_elements(imsize) eq 0 then imsize = 4
	if n_elements(vmin) eq 0 then vmin=-500
	if n_elements(vmax) eq 0 then vmax=500
	nvrange = n_elements(vmin)
	if n_elements(title) eq 0 then title=''
	if n_elements(ctab) eq 0 then ctab=3
	if n_elements(scale_type) eq 0 then scale_type = 0
	if n_elements(dmin) eq 0 then dmin = 0.0
	if n_elements(dmax) eq 0 then dmax = 0.0
	error_msg = ''


	ncenter = round(imsize/delta/2)+1
	ns = ncenter*2+1
	ra_center = 161.2650833333d0
	dec_center = -59.68447222222d0
	images = fltarr(ns,ns,nvrange)
	ncoadds = fltarr(ns,ns,nvrange)
	for k=0,nvrange-1 do begin
 	    for i=0,n_elements(image_in)-1 do begin
		d = *image_in[i]
		h = *h_in[i]
		v0 = sxpar(h,'crval1')
		vc = sxpar(h,'crpix1')
		dv = sxpar(h,'cd1_1')
		nv = sxpar(h,'naxis1')
		vel = v0 + (findgen(nv)+1-vc)*dv
		s0 = sxpar(h,"CRVAL2")
		sc = sxpar(h,"CRPIX2")
		ds = sxpar(h,"CD2_2")
		dm = sxpar(h,"NAXIS2")
		position = (s0 + ((findgen(dm)+1-sc))*ds) * 3600.	;deg to arcsec.


		good = where((vel ge vmin[k]) and (vel le vmax[k]),ngood)
		if ngood lt 1 then begin
			error_msg = 'ERROR: Invalid VRANGE'
			return
		end
		index1 = good[0]
		index2 = good[ngood-1]
		flux = total(d[index1:index2,*],1)


		angle = sxpar(h,'pa_aper')/!radeg
		xpos = -position*sin(angle)
		ypos = position*cos(angle)
		ra = sxpar(h,'ra_aper')
		dec = sxpar(h,'dec_aper')
		ypos = ypos + (dec-dec_center)*3600.0
		xpos = xpos + (ra_center-ra)*3600.0*cos(dec_center/!radeg)
		xpixel = round(xpos/delta) + ncenter
		ypixel = round(ypos/delta) + ncenter


		for j=0,n_elements(xpixel)-1 do begin
			if (xpixel[j] ge 0) and (xpixel[j] lt ns) and $
			   (ypixel[j] ge 0) and (ypixel[j] lt ns) then begin
			     images(xpixel[j],ypixel[j],k) = $
			     			images(xpixel[j],ypixel[j],k) + flux[j]
			     ncoadds(xpixel[j],ypixel[j],k) = $
			     			ncoadds(xpixel[j],ypixel[j],k) + 1
			end
		end

	    end
	    images[*,*,k] = images[*,*,k]/(vmax[k]-vmin[k])
	end
	images = images/(ncoadds>1)

	if n_elements(psfile) eq 1 then begin
		dname = !d.name
		set_plot,'ps'
		device,/port,xsize=7.5,ysize=10,xoff=0.5,yoff=0.5,/inches,bits=8, $
			/color,file=psfile
		!p.font=0
		loadct,ctab,/silent
		tvlct,r,g,b,/get
		r(1) = 80 & b(1) = 255 & g(1) = 80
		r(2) = 50 & b(2)=50 & g(2) = 255
		tvlct,r,g,b
		xpos = [0,4,0,4]
		ypos = [5.0,5.0,1.0,1.0]
		if title ne '' then xyouts,0.5,9.5/10.0,title,/norm,charsize=2,align=0.5
		mask = ncoadds gt 0
		if dmax le dmin then begin
			good = where(mask)
			im = images(good)
			sub = sort(im)
			if scale_type eq 2 then maxim = max(images) else maxim  = im[sub[n_elements(im)*0.99]]
			minim = im[sub[n_elements(im)*0.10]]
		   end else begin
		   	maxim = dmax
		   	minim = dmin
		end
		case scale_type of
			0: begin
				pic = images>minim<maxim
				bmin = minim
				bmax = maxim
			   end
			1: begin
				pic = sqrt((images>minim<maxim)-minim)
				bmin = 0.0
				bmax = sqrt(maxim+minim)
			   end
			2: begin
				pic = alog10(((images<maxim)-minim)>(maxim*1e-4))
				bmin = alog10(maxim*1e-4)
				bmax = alog10(maxim-minim)
			   end
			3: begin
				pic = hist_equal(images,min=minim,max=maxim)
				bmin = 0
				bmax = 255
			   end
		end
		pic = (bytscl(pic,top=252,min=bmin,max=bmax) + 2b)
		for i=0,nvrange-1 do begin
			ipos = i mod 4
			if (ipos eq 0) and (i ne 0) then erase
			pic1 = pic[*,*,i]*mask[*,*,i] + 1b
			pic1(ncenter,ncenter) = 2

			tv,pic1,xpos[ipos],ypos[ipos],xsize=3.5,ysize=3.5,/inches
			xyouts,(xpos[ipos]+1.75)/7.5,(ypos[ipos]+3.6)/10,/norm,align=0.5, $
					strtrim(string(vmin[i],'(F10.1)'),2) + ' to '+ $
					strtrim(string(vmax[i],'(F10.1)'),2) + ' km/sec'

		end
		b = bindgen(252)+2b
		tv,b, 7.5/2-2, 0.4, xsize=4,ysize=0.3,/inches
		xyouts,(7.5/2-2.1)/7.5,0.05,strtrim(minim,2),/norm,align=1.0
		xyouts,(7.5/2+2.1)/7.5,0.05,strtrim(maxim,2),/norm,align=0.0
		case scale_type of
			0: title='Linear Scaling'
			1: title='Square Root Scaling'
			2: title='Logarithmic Scaling'
			3: title='Histogram Equalized Scaling'
		end
		xyouts,0.5,0.01,title,align=0.5,/norm
		device,/close
		set_plot,dname
	end
end
;
;=============================================================================== ETACAR_PRINT_IT
;
pro etacar_print_it,h,image,info,list,scale,dmin,dmax,file, $
	colortab,xsize,ysize,title

;
; open ps file
;
	tvlct,r,g,b,/get
	dev_save = !d.name
	set_plot,'ps'
	device,/port,xsize=xsize,ysize=ysize,/inches,/color,bits=8,file=file,xoff=0.5,yoff=0.5
	loadct,colortab,/silent
	contrast = (['LINEAR','SQRT','LOG','HIST_EQ'])[scale]
	case contrast of
	   'LINEAR': pic = bytscl(image,min=dmin,max=dmax)
	   'SQRT': begin
	   			im = sqrt((image + dmin)>0)
	   			sqmax = sqrt(dmin+dmax)
	   			pic = bytscl(im,min=0,max=sqmax)
	   		   end
	   'LOG': begin
	   			im = alog10((image+dmin)>(dmax*1e-5))
	   			lmax = alog10((dmin+dmax))
	   			lmin = alog10(dmax*1e-5)
	   			pic = bytscl(im,min=lmin,max=lmax)
	   			end
	   'HIST_EQ': pic = hist_equal(image,minv=dmin,maxv=dmax)
	endcase
	tv,pic,xsize*0.15,ysize*0.12,xsize=xsize*0.8,ysize=ysize*0.8,/inches

	v0 = sxpar(h,'crval1')
	vc = sxpar(h,'crpix1')
	dv = sxpar(h,'cd1_1')
	nv = sxpar(h,'naxis1')
	vel = v0 + (findgen(nv+1)+0.5-vc)*dv
	s0 = sxpar(h,"CRVAL2")
	sc = sxpar(h,"CRPIX2")
	ds = sxpar(h,"CD2_2")
	dm = sxpar(h,"NAXIS2")
	position = (s0 + ((findgen(dm+1)+0.5-sc))*ds) * 3600.	;deg to arcsec.
	if xsize lt 2.5 then ptitle='' else ptitle=title
	plot,vel,position,position=[0.15,0.12,0.95,0.92],/nodata,xstyle=1,ystyle=1, $
		ticklen=-0.02,/noerase,font=0,xthick=3,ythick=3,title=ptitle, $
			charsize = (xsize/4.5)>0.6<1.2,xrange=[min(vel),max(vel)], $
			yrange=[min(position),max(position)]
	device,/close
	set_plot,dev_save
	tvlct,r,g,b
	print,'File '+file+' written'
end

;
;==============================================================================ETACAR_PRINT_OPTIONS
pro etacar_print_options_event,event

common etacar_print,val,val_save
	if datatype(event) ne 'STC' then return
	widget_control,val.dmin_base,get_value=dmin
	widget_control,val.dmax_base,get_value=dmax
	widget_control,val.file_base,get_value=file
	widget_control,val.xsize_base,get_value=xsize
	widget_control,val.ysize_base,get_value=ysize
	widget_control,val.color_base,get_value=colortab
	widget_control,val.scale_select_base,get_value=scale

	widget_control,val.title_base,get_value=include_title
	v = {dmin:dmin,dmax:dmax,file:file,xsize:xsize,ysize:ysize,colortab:colortab, $
			scale:scale,include_title:include_title}

	if (event.id eq event.top) or (event.id eq val.exit_base) then begin
	    val = v
		widget_control,event.top,/destroy
	end

end

pro etacar_print_options,contrast,dmin,dmax,file,colortab,xsize,ysize,include_title,group=group
common etacar_print,val,val_save

	if n_elements(val_save) eq 0 then $
		val_save = {dmin:0,dmax:dmax,file:'',colortab:3,xsize:4,ysize:4,contrast:2, $
					include_title:0}
	dmin = val_save.dmin
	dmax = val_save.dmax
	file = val_save.file
	colortab = val_save.colortab
	xsize = val_save.xsize
	ysize = val_save.ysize
	contrast = val_save.contrast
	include_title = val_save.include_title

	if n_elements(group) gt 0 then modal=1 else modal=0


	base = widget_base(/col,group=group,modal=modal)
	scale_select_base = cw_bgroup(base,['Linear','Sqrt','Log','Hist Eq'],uvalue='SCALE_SELECT', $
		set_value=contrast,/exclusive)
	label_base = widget_label(base,value='Include Title?',/align_left)
	title_base = cw_bgroup(base,['NO','YES'],/row,uvalue='TITLE', $
		set_value=include_title,/exclusive)
	file_base = cw_field(base,xsize=35,title='Filename:',value=file,uvalue='file')
	dmin_base = cw_field(base,xsize=20,title='Dmin:',value=dmin,/float,uvalue='dmin')
	dmax_base = cw_field(base,xsize=20,title='Dmax:',value=dmax,/float,uvalue='dmax')
	color_base = cw_field(base,xsize=10,title='Color Table:',value=colortab,/integer,uvalue='color')
	xsize_base = cw_field(base,xsize=20,title='Xsize (inches):',value=xsize,/float,uvalue='xsize')
	ysize_base = cw_field(base,xsize=20,title='Ysize (inches):',value=ysize,/float,uvalue='ysize')
	exit_base = widget_button(base,value='Done')

	widget_control,base,/realize
	val = {scale_select_base:scale_select_base, file_base:file_base, dmin_base:dmin_base, $
		color_base:color_base, xsize_base:xsize_base, ysize_base:ysize_base, $
		dmax_base:dmax_base, exit_base:exit_base, title_base:title_base}

	xmanager,'etacar_print_options',base	,cleanup='etacar_print_options_event'
	dmin = val.dmin
	dmax = val.dmax
	file = val.file
	colortab = val.colortab
	xsize = val.xsize
	ysize = val.ysize
	contrast = val.scale
	include_title = val.include_title
    val_save = {dmin:dmin,dmax:dmax,file:file,colortab:colortab,xsize:xsize,ysize:ysize, $
    	contrast:contrast,include_title:include_title}
end
;=========================================================================== ETACAR_MAP
;
; Main routine
;
pro etacar_map

	common etacar_map_common,info,list,images,headers

	if xregistered('etacar_map') then return
;
; create widget layout
;
	topbase = widget_base(/row)
;
; Exit
;
	base1 = widget_base(topbase,/col)
	exit_button = widget_button(base1,value='     Exit     ',uvalue='EXIT')
;
; File Specification
;
	base1 = widget_base(base1,/col,/frame)
	label = widget_label(base1,value='Input File Specification')
	row_base = widget_base(base1,/row)
	directory_button = widget_button(row_base,value='Directory',uvalue='DIR_BUTTON')
	dir_base = cw_field(row_base,title='',uvalue='DIRECTORY',xsize=30)
	cenwave_base = cw_field(base1,/all_events,/integer,title='CENWAVE:  ',xsize=10, $
			value=0,uvalue='CENWAVE',/row)
	date_base = cw_bgroup(base1,/col,['Minimum','Maximum','Year Range'], $
			uvalue='DATE_SELECT',/exclusive,set_value=2)
	row_base = widget_base(base1,/row)
	year1_base = cw_field(row_base,title='     Min:',value=1990.0,/float,/row, $
		uvalue='FIELD_CHANGE',xsize=10,/all_events)
	year2_base = cw_field(row_base,title='     Max:',value=2007.0,/float,/row, $
		uvalue='FIELD_CHANGE',xsize=10,/all_events)
	label = widget_label(base1,value='File List')
	menu = widget_base(base1,/row)
	search_base = widget_button(menu,uvalue='SEARCH',value='Search')
	add_base = widget_button(menu,uvalue='ADD',value='Add')
	delete_base = widget_button(menu,uvalue='DELETE',value='Delete')
	delete_all_base = widget_button(menu,uvalue='DELETE_ALL',value='Delete All')
	wlist = widget_list(base1,uvalue='FILE_LIST',xsize=35,ysize=250,scr_ysize=300, $
		value=[' '],font='6X13')
;
; Normalization
;
	base1 = widget_base(topbase,/col)
	title_base = cw_field(base1,xsize=25,title='Title: ',uvalue='TITLE')
	base2 = widget_base(base1,/col,/frame)
	label = widget_label(base2,value='Spectral Line Extraction and Continuum Removal')
	wave_base = cw_field(base2,/all_events,/float,/row,title='Wavelength', $
		uvalue='FIELD_CHANGE',value=0.0)
	normtype_base = cw_bgroup(base2,/col,['None','Median Filter','Subtract	Cont.','X-Disp. Profile'], $
		uvalue='NORM_TYPE',/exclusive,set_value=0)
	median_base = cw_field(base2,title='Median Filter Size: ',value=75,/integer, $
		uvalue='FIELD_CHANGE',/all_events,xsize=5)
	wmin_base = cw_field(base2,title='Cont. Wmin: ',value=0.0,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	wmax_base = cw_field(base2,title='Cont. Wmax: ',value=0.0,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	col_base = widget_base(base2,/col,/frame)
	label = widget_label(col_base,value = 'Spatial Range (arcsec)')
	smin_base = cw_field(col_base,title='Min: ',value=-1.5,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	smax_base = cw_field(col_base,title='Max: ',value=1.5,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	label = widget_label(col_base,value = 'Velocity Range (km/sec)')
	vmin_base = cw_field(col_base,title='Min: ',value=-600.0,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	vmax_base = cw_field(col_base,title='Max: ',value=600.0,/float, $
		uvalue='FIELD_CHANGE',/all_events,xsize=10)
	extract_base = widget_button(base2,value='Extract Lines',uvalue='EXTRACT')
	display_label = widget_label(base2,value='                           ',xsize=200)
	display_base = widget_button(base2,value='Display Images',uvalue='DISPLAY')
	display_sel_base = widget_button(base2,value='Display Selected Image',uvalue='DISPLAY_SEL')
	print_base = widget_button(base2,value='Print Images',uvalue='PRINT')
	print_sel_base = widget_button(base2,value='Print Selected Image',uvalue='PRINT_SEL')
;
; Map control
;
	base2 = widget_base(topbase,/col,/frame)
	label = widget_label(base2,value='Spatial Map',/align_center)
	label = widget_label(base2,value='Velocity Range (km/sec)')
	velmin_base = lonarr(4)
	velmax_base = lonarr(4)
	minvals = [-100,50,-500,0]
	maxvals = [50,500,-100,0]
	for i=0,3 do begin
		row_base = widget_base(base2,/row)
		velmin_base[i] = cw_field(row_base,title='  '+strtrim(i+1,2)+'   Min: ', $
				value=minvals[i],/float,xsize=10)
		velmax_base[i] = cw_field(row_base,title='   Max: ',value=maxvals[i],/float,xsize=10)
	end
	vel_select_base = cw_bgroup(base2,['1','2','3','4','All'],/exclusive,uvalue='VEL_SELECT', $
		set_value=0,/row)
	size_base = cw_field(base2,title='Image Size (arcsec): ',/float,xsize=10,value=3.0)
	pixel_size_base =  cw_field(base2,title='pixel Size (arcsec): ',/float,xsize=10,value=0.1)
	display_map_button = widget_button(base2,value = '   Display Map   ',/align_center, $
		uvalue='DISPLAY_MAP')
	base = widget_base(base2,/col,frame=2)
	ps_mosaic_base = widget_button(base,value='Postscript of all maps',uvalue='PS_MAP')
	scale_select_base = cw_bgroup(base,['Linear','Sqrt','Log','Hist Eq'],uvalue='SCALE_SELECT', $
		set_value=2,/exclusive)
	min_base = cw_field(base,/row,title='Min: ',/float,xsize=15,value=0.0)
	max_base = cw_field(base,/row,title='Max: ',/float,xsize=15,value=0.0)

;
; save info in structure
;
	info = {dir_base:dir_base, cenwave_base:cenwave_base, datetype:2, $
		year1_base:year1_base, wlist:wlist, title_base:title_base, $
		wave_base:wave_base, normtype:0, median_base:median_base, $
		wmin_base:wmin_base, wmax_base:wmax_base, smin_base:smin_base, $
		smax_base:smax_base, vmin_base:vmin_base, velmin_base:velmin_base, $
		velmax_base:velmax_base, size_base:size_base, nlist:0, vel_select:0, $
		pixel_size_base:pixel_size_base, topbase:topbase, year2_base:year2_base, $
		display_map_button:display_map_button, vmax_base:vmax_base, $
		display_base:display_base, display_label:display_label, $
		display_sel_base:display_sel_base,ps_mosaic_base:ps_mosaic_base, $
		scale_type:2,min_base:min_base,max_base:max_base, $
		print_base:print_base, print_sel_base:print_sel_base}


	widget_control,topbase,/realize
	widget_control,display_base,sensitive=0
	widget_control,display_map_button,sensitive=0
	widget_control,display_sel_base,sensitive=0
	widget_control,print_base,sensitive=0
	widget_control,print_sel_base,sensitive=0
	widget_control,ps_mosaic_base,sensitive=0
	xmanager,'etacar_map',topbase,/no_block,cleanup='etacar_cleanup'
end

