;+
;			dogman
;
; CALLING SEQUENCE:
;
; 	dogman,image,results,index
;
; INPUTS:
;	image - postage stamp galaxy image (up to 512 x 512)
;
; OUTPUTS:
;	results - final ellipse parameters
;		results.xc - x center
;		results.yc - y center
;		results.a - length of semi-major axis
;		results.e - ellipticity  (1 - B/A)
;		results.angle - position angle
;	index - index of the pixels in the input image within the final ellipse
; KEYWORD INPUTS:
;	xc - fixed x-center
;	yc - fixed y-center
;	a - fixed semi-major axis
;	posangle - fixed position angle
;	e - fixed ellipticity (1-B/A)
;
; NOTES:
;	Center of ellipse can be set by positioning cursor and hitting left
;		mouse button
;	Centroid buttons can be used to set center of ellipse
;	MOMENTS button can be used to set ellipticity and position angle
;		using the moments within the current ellipse.  It may be
;		necessary to repeat it a couple of times.
;	The MIN and MAX field refers to the image min and max after subtracting
;		the sky value.  If LOG and min is less then or equal to 0,
;		the max/10,000 is used for the minimum.  If SQRT and min is
;		less than 0, 0 is used.
;	The sky can be changed by manually entering a value in the sky box or
;		by hitting the sky button.  The sky is then computed using
;		an annulus of the specified size (Region between galaxy
;		ellipse and an ellipse with a semi-major axis equal to the
;		galaxy ellipse + ANNULUS).  The medain value in this region
;		is selected. 
;	The right mouse button can be used to edit out bad pixels.  The
;		center button can be used to restore edited pixels to the
;		original values.
;	Once the draw ellipse button is pressed, draw the approximate ellipse
;		while holding down a mouse button.
; HISTORY:
;	version 1  D. Lindler   Aug. 3, 1998
;-
pro dogman_event,ev
;+
;  Dogman event handler
;
;
common dogman_common,h,ellipse,orig,subimage,pic,window_id,omin,omax, $
                        vmin,vmax,transtype,min_field,max_field, $
                        a_slider,e_slider,angle_slider,record_base, $
			xval_base,yval_base,val_base,median_base, $
                        name_field,e_field,angle_field,a_field,center_base, $
			xoffset,yoffset,zoom,skyval,sky_annulus, $
			sky_field,annulus_field,fname,base,path,total_base, $
			record,nrecord,edit,draw_ellipse
widget_control,ev.id,get_uvalue=uvalue
redisplay = 1
case uvalue of
	'EXIT': begin
		orig=0
		subimage=0
		pic=0
		widget_control,ev.top,/destroy
		return
		end
	'FILE': begin
                name = dialog_pickfile(/read,/must_exist,dialog_parent=base, $
                                filter='*.fit*',path=path,get_path=get_path)
		if name eq '' then return
                path = get_path
		dogman_read,name
		widget_control,name_field,set_value=fname
		dogman_rescale
		nrecord = 0
		widget_control,record_base,set_value=strtrim(nrecord,2)
		end
	'TIME' : begin
		!fancy = 1
		tv,bytarr(512,150),0,352
		xyouts,50,450,'At the tone the time will be',/dev,charsize=2, $
				charthick=2
		xyouts,50,410,!stime,charsize=2,/dev,charthick=2
		wait,0.5
		print,string(7B)
		return
		end
	'WRITE_EDIT': begin
		widget_control,name_field,get_value=fname
		fname = fname(0)+'_e'
		widget_control,name_field,set_value=fname
		sxaddhist,'Bad Pixels editted by DOGMAN',h
		fits_write,fname+'.fits',orig,h
		!fancy = 1
		tv,bytarr(512,61),0,450
		xyouts,50,470,'!5Image File: '+fname+'.fits'+' Written',/dev, $
				charsize=2
		return
		end
	'WRITE': begin
		widget_control,name_field,get_value=fname
		fname = fname(0)
		if nrecord gt 0 then mwrfits,record,fname+'.ellipse',/create $
				else mwrfits,ellipse,fname+'.ellipse',/create
		!fancy = 1
		tv,bytarr(512,61),0,450
		xyouts,50,470,'!5Results File: '+fname+'.ellipse'+' Written', $
				/dev,charsize=2
		return
		end
	'SNAP' : begin
		snap,dummy
		widget_control,name_field,get_value=fname
		fname = fname(0)
		spawn,'xwd -icmap -out junk.xwd'
	        WIDGET_CONTROL, /HOURGLASS
		xim=read_xwd('junk.xwd',rr,gg,bb)
		help,rr,gg,bb
	        set_plot,'ps'
	        device,/landscape,/in,xoff=.75,yoff=9.75,file=fname+'.ps', $
			/color,bits=8
		tvlct,rr,gg,bb
	        tv,xim
	        device,/close
		set_plot,'x'
	        WIDGET_CONTROL, /HOURGLASS
		redisplay = 0
		end
	'E_SLIDER': Begin
		ellipse.e = ev.value
		if ev.drag eq 1 then redisplay = 0
		widget_control,e_field,set_value = strtrim(ellipse.e,2)
		end
	'A_SLIDER': Begin
		ellipse.a = ev.value
		if ev.drag eq 1 then redisplay = 0
		widget_control,a_field,set_value = strtrim(ellipse.a,2)
		end
	'ANGLE_SLIDER': Begin
		ellipse.angle = ev.value
		if ev.drag eq 1 then redisplay = 0
		widget_control,angle_field,set_value = strtrim(ellipse.angle,2)
		end
	'DRAW_WINDOW': Begin
	      if draw_ellipse.flag then begin
			dogman_draw_ellipse,ev,return_flag
			if return_flag then return
	      end else begin
		x = ev.x/zoom + xoffset
		y = ev.y/zoom + yoffset
		s = size(orig) & ns = s(1) & nl = s(2)
		if (x gt 0) and (y gt 0) and (x lt ns) and (y lt nl) then begin
		    if ev.press gt 0 then begin
;
; press left button (new ellipse center)
;
		    	if ev.press eq 1 then begin
		   	    ellipse.xc = x
		   	    ellipse.yc = y
		   	end
;
; press right button (edit pixel)
;
		    	if ev.press eq 4 then begin
			    x1 = (x-2)>0
			    x2 = (x+2)<(ns-1)
			    y1 = (y-2)>0
			    y2 = (y+2)<(ns-1)
			    newval = median(orig(x1:x2,y1:y2))
			    edit.val(edit.n) = orig(x,y)
			    orig(x,y) = newval
			    edit.x(edit.n) = x
			    edit.y(edit.n) = y
			    edit.n = edit.n+1
			    omin = min(orig)
			    omax = max(orig)
			    dogman_rescale
			endif
;
; press middle button (undo last edit)
;
			if ev.press eq 2 then begin
			    if edit.n gt 0 then begin 
				n = edit.n - 1
			    	orig(edit.x(n),edit.y(n)) = edit.val(n)
			    	omin = min(orig)
			    	omax = max(orig)
				edit.n = n
				dogman_rescale
			    end else return
			end
		  end else begin
;
; no button pressed
;
		      val = orig(x,y)
		      st = string(x,'(I3)')+' ,'
		      widget_control,xval_base,set_value=st
		      st = string(y,'(I3)')
		      widget_control,yval_base,set_value=st
		      st = 'F = '+strtrim(val,2)
		      widget_control,val_base,set_value=st
		      x1 = (x-5)>0 & y1 = (y-5)>0
		      x2 = (x+5)<(ns-1) & y2 = (y+5)<(nl-1)
		      st = 'Median = '+strtrim(median(orig(x1:x2,y1:y2)))
		      widget_control,median_base,set_value=st
		      return
		   end
		end else return
	      end
	      end
	'CENT3': Begin
		x1 = round(ellipse.xc)-1
		y1 = round(ellipse.yc)-1
		f = orig(x1:x1+2,y1:y1+2)
		f = (f-min(f))>0
		x = lindgen(3,3) mod 3
		y = lindgen(3,3)/3
		ellipse.xc = x1 + total(x*f)/total(f)
		ellipse.yc = y1 + total(y*f)/total(f)
		end
	'CENT5': Begin
		x1 = round(ellipse.xc)-2
		y1 = round(ellipse.yc)-2
		f = orig(x1:x1+4,y1:y1+4)
		f = (f-min(f))>0
		x = lindgen(5,5) mod 5
		y = lindgen(5,5)/5
		ellipse.xc = x1 + total(x*f)/total(f)
		ellipse.yc = y1 + total(y*f)/total(f)
		end
	'CENT7': Begin
		x1 = round(ellipse.xc)-3
		y1 = round(ellipse.yc)-3
		f = orig(x1:x1+6,y1:y1+6)
		f = (f-min(f))>0
		x = lindgen(7,7) mod 7
		y = lindgen(7,7)/7
		ellipse.xc = x1 + total(x*f)/total(f)
		ellipse.yc = y1 + total(y*f)/total(f)
		end
	'CENT15': Begin
		x1 = round(ellipse.xc)-7
		y1 = round(ellipse.yc)-7
		f = orig(x1:x1+14,y1:y1+14)
		f = (f-min(f))>0.0
		x = lindgen(15,15) mod 15
		y = lindgen(15,15)/15
		ellipse.xc = x1 + total(x*f)/total(f)
		ellipse.yc = y1 + total(y*f)/total(f)
		end
	'CENTROID': begin
		widget_control,/hourglass
		index = ellipse_defroi(orig,ellipse.xc, $
					ellipse.yc,ellipse.a, $
					ellipse.e,ellipse.angle)
		s = size(orig) & ns = s(1) & nl = s(2)
		x = index mod ns
		y = index/ns
		f = orig(index)-ellipse.sky
		totf = total(f)
		if totf gt 0 then begin
			ellipse.xc = total(x*f)/totf
			ellipse.yc = total(y*f)/totf
		end
		widget_control,/hourglass
		end
	'MOMENTS': Begin
		index = ellipse_defroi(orig,ellipse.xc, $
					ellipse.yc,ellipse.a, $
					ellipse.e,ellipse.angle)
		s = size(orig) & ns = s(1) & nl = s(2)
		dogman_moments,orig-ellipse.sky,index,ellipse.xc,ellipse.yc, $
				a,e,angle
		ellipse.angle = angle
		ellipse.e = e
		widget_control,e_slider,set_value=e
		widget_control,e_field,set_value = strtrim(ellipse.e,2)
		widget_control,angle_slider,set_value=angle
		widget_control,angle_field,set_value = strtrim(ellipse.angle,2)
		end
	'TRANSTYPE': Begin
		types = ['LINEAR','SQRT','LOG','HISTEQ']
		transtype = types(ev.value)
		dogman_rescale
		end
	'COLORS': begin
		xloadct
		redisplay = 0
		end
	'MIN_FIELD': Begin
		vmin = ev.value
		dogman_rescale
		end
	'MAX_FIELD': Begin
		vmax = ev.value
		dogman_rescale
		end
	'RESET': Begin
		vmin = omin-skyval
		vmax = omax-skyval
		dogman_rescale
		end
	'ZOOM' : begin
		zooms = [1,2,3,4,6,8,16]
		zoom = zooms(ev.value)
		dogman_rescale
		end
	'ANNULUS' : begin
		sky_annulus = ev.value
		end
	'SKY_FIELD' : begin
		oldsky = skyval
		skyval = ev.value
		ellipse.sky = skyval
		vmin = vmin+oldsky-skyval
		vmax = vmax+oldsky-skyval
		dogman_rescale
		end
	'SKY': begin
		if sky_annulus eq 0 then sky_annulus = 20
		widget_control,annulus_field,set_value = sky_annulus
		index = ellipse_defroi(orig,ellipse,annulus=sky_annulus)
		if index(0) ne -1 then begin
			oldsky = skyval
			values = orig(index)
			values = values(sort(values))
			n = n_elements(index)
			skyval = avg(values(n/10:n-n/10-1))
			ellipse.sky = skyval
			widget_control,sky_field,set_value=skyval
			dogman_rescale
			vmin = vmin+oldsky-skyval
			vmax = vmax+oldsky-skyval
		end
		end
	'DRAW_ELLIPSE': begin
		draw_ellipse.flag = 1
		!fancy = 1
		erase & tv,pic
		xyouts,256,480,'Draw Ellipse',charsize=2,align=0.5,/dev
		return
		end
	'NAME_FIELD': begin
		fname = ev.value
		redisplay = 0
		end
	'RECORD': begin
		if nrecord eq 0 then record = ellipse $
				else record = [record,ellipse]
		nrecord = nrecord + 1
		widget_control,record_base,set_value=strtrim(nrecord,2)
		redisplay = 0
		end
	'REVIEW': begin
		if nrecord gt 0 then begin
		    print,' '
		    print,'  XC    YC           A            E          ' +$
			 'ANGLE        SKY         TOTFLUX'
		    for i=0,nrecord-1 do begin
			draw_ellipse,(record(i).xc-xoffset)*zoom +  $
							(zoom-1)/2.0 , $
			     (record(i).yc-yoffset)*zoom + (zoom-1)/2.0 , $
			     record(i).a*zoom,record(i).e,record(i).angle
			print,string(record(i).xc,'(F6.1)'), $
			     string(record(i).yc,'(F6.1)'),record(i).a, $
			     record(i).e,record(i).angle,record(i).sky, $
			     record(i).totflux
		    end
		end
		redisplay = 0
		end		
			
	else: print,'UNDEFINED UVALUE'
	endcase
	if redisplay then begin
		widget_control,/hourglass
		index = ellipse_defroi(orig,ellipse)
		totflux = total(double(orig(index))) - $
				double(skyval)*n_elements(index)
		ellipse.totflux = totflux
		widget_control,total_base,set_value = strtrim(float(totflux))
		erase
		tv,pic
		widget_control,/hourglass
	endif
	widget_control,center_base,set_value = $
		string(ellipse.xc,'(F6.1)')+string(ellipse.yc,'(F8.1)')
	draw_ellipse,(ellipse.xc-xoffset)*zoom + (zoom-1)/2.0 , $
		     (ellipse.yc-yoffset)*zoom + (zoom-1)/2.0 , $
		     ellipse.a*zoom,ellipse.e,ellipse.angle
	if sky_annulus ne 0 then begin
		!linetype=1
		draw_ellipse,(ellipse.xc-xoffset)*zoom + (zoom-1)/2.0 , $
			     (ellipse.yc-yoffset)*zoom + (zoom-1)/2.0 , $
			     (ellipse.a+sky_annulus)*zoom,ellipse.e, $
			     ellipse.angle
		!linetype=0
	end

return
end
pro dogman_draw_ellipse,ev,return_flag
;
; Subroutine to handle draw_window events when draw ellipse is active
;
common dogman_common,h,ellipse,orig,subimage,pic,window_id,omin,omax, $
                        vmin,vmax,transtype,min_field,max_field, $
                        a_slider,e_slider,angle_slider,record_base, $
                        xval_base,yval_base,val_base,median_base, $
                        name_field,e_field,angle_field,a_field,center_base, $
                        xoffset,yoffset,zoom,skyval,sky_annulus, $
                        sky_field,annulus_field,fname,base,path,total_base, $
                        record,nrecord,edit,draw_ellipse

	return_flag = 1	;return from event handler after we are done
;
; case 1 (ellipse not yet started, no button pressed)
;
	if (draw_ellipse.start eq 0) and (ev.press eq 0) then return
;
; case 2 (button is pressed to start ellipse)
;
	if (ev.press gt 0) then begin
		draw_ellipse.start = 1
		draw_ellipse.x(0) = ev.x
		draw_ellipse.y(0) = ev.y
		draw_ellipse.n = 1
		return
	end
;
; case 3 (mouse is moved while button is pressed)
;
	if (ev.release eq 0) then begin
		n = draw_ellipse.n
		draw_ellipse.x(n) = ev.x
		draw_ellipse.y(n) = ev.y
		plots,draw_ellipse.x(n-1:n),draw_ellipse.y(n-1:n),/dev
		draw_ellipse.n = n+1
		return
	end
;
; case 4 (mouse button is released to complete the ellipse)
;
	if (ev.release gt 0) then begin
		widget_control,/hourglass
		n = draw_ellipse.n
		if n gt 2 then begin
			x = round((draw_ellipse.x(0:n-1)) $
				/float(zoom) + xoffset)
			y = round((draw_ellipse.y(0:n-1)) $
				/float(zoom) + yoffset)
			s = size(orig) & ns = s(1) & nl=s(2)
			index = polyfillv(x,y,ns,nl)
			ellipse.xc = avg(index mod ns)
			ellipse.yc = avg(index/ns)
			dogman_moments,replicate(1.0,ns,nl),index, $
				ellipse.xc,ellipse.yc,a,e,angle
			ellipse.a = a*2
			ellipse.e = e
			ellipse.angle = angle
		endif
        	widget_control,center_base,set_value = $
        	        string(ellipse.xc,'(F6.1)')+string(ellipse.yc,'(F8.1)')
        	draw_ellipse,(ellipse.xc-xoffset)*zoom + (zoom-1)/2.0 , $
        	             (ellipse.yc-yoffset)*zoom + (zoom-1)/2.0 , $
        	             ellipse.a*zoom,ellipse.e,ellipse.angle
                widget_control,e_slider,set_value=ellipse.e
                widget_control,e_field,set_value = strtrim(ellipse.e,2)
                widget_control,a_slider,set_value=ellipse.a
                widget_control,a_field,set_value = strtrim(ellipse.a,2)
                widget_control,angle_slider,set_value=ellipse.angle
                widget_control,angle_field,set_value = strtrim(ellipse.angle,2)

		draw_ellipse.n = 0
		draw_ellipse.start = 0
		draw_ellipse.flag = 0
		return_flag = 0
		wait,1
		widget_control,/hourglass
		return
	endif
return
end

pro draw_ellipse,xc,yc,a,e,angle
;
; subroutine to draw an ellipse
;
	b = (1-e)*a
	phi = findgen(120)*2*!pi/119
	x = a*cos(phi)
	y = b*sin(phi)	
	ang = angle/!radeg
	cosang = cos(ang)
	sinang = sin(ang)
	xrot = xc + x*cosang - y*sinang
	yrot = yc + x*sinang + y*cosang
	plots,xrot,yrot,/dev
;
; plot center
;
	x = round(xc) & y = round(yc)
	x = [xc,xc] & y = [yc,yc]
	off = [7,13]
	plots,x+off,y,/dev,thick=2
	plots,x-off,y,/dev,thick=2
	plots,x,y+off,/dev,thick=2
	plots,x,y-off,/dev
	off = [2,7]
	plots,x+off,y,/dev,color=0,thick=2
	plots,x-off,y,/dev,color=0,thick=2
	plots,x,y+off,/dev,color=0,thick=2
	plots,x,y-off,/dev,color=0,thick=2
return
end
pro dogman_moments,image,index,xc,yc,a,e,angle
;
; routine to compute angle and ellipticity from the moments
;
	s = size(image) & ns = s(1) & nl = s(2)
	x = (index mod ns) - xc
   	y = (index/ns) - yc
	x2 = x*x
	y2 = y*y
	G = image(index)
	Itot = total(G)
	Mxx = total(G*x2)/Itot
	Myy = total(G*y2)/Itot
	Mxy = total(G*x*y)/Itot
	A = sqrt( (Mxx+Myy)/2 + sqrt(((Mxx-Myy)/2)^2+Mxy^2) )
	B = sqrt( (Mxx+Myy)/2 - sqrt(((Mxx-Myy)/2)^2+Mxy^2) )
	e = 1-b/a
	angle = atan(2*mxy,mxx-myy)/2 * !radeg
return
end
pro dogman_rescale
;
; subroutine to rescale the displayed image
;
        common dogman_common,h,ellipse,orig,subimage,pic,window_id,omin,omax, $
                        vmin,vmax,transtype,min_field,max_field, $
                        a_slider,e_slider,angle_slider,record_base, $
			xval_base,yval_base,val_base,median_base, $
                        name_field,e_field,angle_field,a_field,center_base, $
			xoffset,yoffset,zoom,skyval,sky_annulus, $
			sky_field,annulus_field,fname,base,path,total_base, $
			record,nrecord,edit,draw_ellipse

;
; extract subimage from orig
;
	widget_control,/hourglass
	s = size(orig) & ns = s(1) & nl = s(2)
	ns_sub = 512/zoom
	nl_sub = 512/zoom
	xoffset = round((ellipse.xc - ns_sub/2)>0)
	yoffset = round((ellipse.yc - nl_sub/2)>0)
	xlast = (xoffset + ns_sub - 1)<(ns-1)
	ylast = (yoffset + nl_sub - 1)<(nl-1)
	subimage = orig(xoffset:xlast,yoffset:ylast)-skyval
	
	case transtype of
	'LINEAR' : pic = bytscl(subimage,min=vmin,max=vmax,top=!d.n_colors)
	'LOG': begin
		if vmin le 0 then tmin = vmax/1e4 else tmin = vmin
		pic = bytscl(alog10(subimage>tmin),min=alog10(tmin), $
			max=alog10(vmax),top=!d.n_colors)
		end
	'SQRT': begin
		tmin = vmin>0 
		pic = bytscl(sqrt(subimage>0),min=sqrt(tmin),max=sqrt(vmax), $
				top=!d.n_colors)
		end
	'HISTEQ': pic = bytscl(hist_equal(subimage),top=!d.n_colors)
	endcase
	if zoom gt 1 then pic = rebin(pic,(xlast-xoffset+1)*zoom, $
					  (ylast-yoffset+1)*zoom,/sample)
	widget_control,min_field,set_value=vmin
	widget_control,max_field,set_value=vmax
	widget_control,sky_field,set_value=skyval
	widget_control,/hourglass
return
end
pro dogman_read,image
;
; Routine to read image and create an initial sky estimate
;
        common dogman_common,h,ellipse,orig,subimage,pic,window_id,omin,omax, $
                        vmin,vmax,transtype,min_field,max_field, $
                        a_slider,e_slider,angle_slider,record_base, $
			xval_base,yval_base,val_base,median_base, $
                        name_field,e_field,angle_field,a_field,center_base, $
			xoffset,yoffset,zoom,skyval,sky_annulus, $
			sky_field,annulus_field,fname,base,path,total_base, $
			record,nrecord,edit,draw_ellipse

	name = ''
	fname = 'dogman'
	h = ['END     ']

	if n_elements(image) lt 2 then begin
	    name = ''
	    if datatype(image) eq 'STR' then begin
		    name = image
		    if name ne '' then begin
			widget_control,/hourglass
		    	fits_open,name,fcb,/no_abort,message=message
		    	if !err ge 0 then fits_read,fcb,orig,h,/no_abort, $
				message=message
			if !err ge 0 then fits_close,fcb
			widget_control,/hourglass
			if !err lt 0 then begin
			    result = dialog_message(Message,dialog_parent=base)
			    name = ''
		    	end else fdecomp,name,disk,dir,fname
	             end
	        end else begin
		     orig = fltarr(512,512)
		     orig(256,256) = 100
	    end
	  end else begin
		orig = image
	end

	s = size(orig) & ns = s(1) & nl = s(2)
	skyval = sxpar(h,'SKY')
	if !err lt 0 then begin		;no sky keyword
;
; compute crude sky value
;
		widget_control,/hourglass
		rowmedian = fltarr(nl)
		for i=0,nl-1 do rowmedian(i) = median(orig(*,i))
		colmedian = fltarr(ns)
		for i=0,ns-1 do colmedian(i) = median(orig(i,*))
		rowmedian = rowmedian(sort(rowmedian))
		colmedian = rowmedian(sort(colmedian))
		skyval = rowmedian(3)<colmedian(3)
		widget_control,/hourglass
	end
	if name eq '' then name='dogman'
	ellipse = {filename:name,xc:ns/2.0,yc:nl/2.0,a:(ns<nl<500)/2.0,e:0.0, $
		angle:0.0,sky:0.0,totflux:0.0}
	ellipse.sky = skyval
	omin = min(orig)
	omax = max(orig)
	vmin = omin-skyval
	vmax = omax-skyval
return
end

pro dogman,image,results,index,xc=xc,yc=yc,a=a,e=e,posangle=posangle, $
	group = group
;--------------------------------------------------------------------------
;
; print calling sequence
;
	if n_params(0) lt 1 then begin
		print,'CALLING SEQUENCE: dogman,image,results,indices'
		print,'OPTIONAL KEYWORD INPUTS: xc, yc, a, e, posangle
		return
	endif
;
; initialization
;
        common dogman_common,h,ellipse,orig,subimage,pic,window_id,omin,omax, $
                        vmin,vmax,transtype,min_field,max_field, $
                        a_slider,e_slider,angle_slider,record_base, $
			xval_base,yval_base,val_base,median_base, $
                        name_field,e_field,angle_field,a_field,center_base, $
			xoffset,yoffset,zoom,skyval,sky_annulus, $
			sky_field,annulus_field,fname,base,path,total_base, $
			record,nrecord,edit,draw_ellipse

	base = 0
	dogman_read,image
	s = size(orig) & ns = s(1) & nl = s(2)
	zoom = 1
	if n_elements(xc) gt 0 then ellipse.xc = xc
	if n_elements(yc) gt 0 then ellipse.yc = yc
	if n_elements(e) gt 0 then ellipse.e = e
	if n_elements(a) gt  0 then ellipse.a = a
	if n_elements(posangle) gt 0 then ellipse.angle = posangle
	if n_elements(group) eq 0 then group = 0
	transtype = 'LOG'
	sky_annulus = 0
	nrecord = 0
	edit = {x:intarr(1000),y:intarr(1000),val:fltarr(1000),n:0}
	draw_ellipse = {flag:0,start:0,x:intarr(2000),y:intarr(2000),n:0}
	path = '/stis0/data16/uvmorph/'
;
; define widget layout
;
	base = widget_base(/col,title='DOGMAN Galaxy Region Definition', $
		group=group)
;;;	widget_control, default_font='6x13'
	basea = widget_base(base,/row)
	base1 = widget_base(basea,/col)
	base1x = widget_base(base1,/col,frame=2)
	button = widget_button(base1x,uvalue='CENT3',value='3 Pixel Centroid')
	button = widget_button(base1x,uvalue='CENT5',value='5 Pixel Centroid')
	button = widget_button(base1x,uvalue='CENT7',value='7 Pixel Centroid')
	button = widget_button(base1x,uvalue='CENT15',value='15 Pixel Centroid')
	button = widget_button(base1x,uvalue='CENTROID',value='Full Centroid')
	center_base = widget_label(base1x,scr_xsize=200,/align_left, $
		value = string(ellipse.xc,'(F6.1)')+string(ellipse.yc,'(F8.1)'))
	button = widget_button(base1x,uvalue='MOMENTS',value='Moments')
	base1y = widget_base(base1,/col,frame=3)
	button = widget_button(base1y,uvalue='COLORS',value='COLORS')
        button = cw_bgroup(base1y, $
			['Linear','Sqrt.','Log.','Hist. Eq.'], $
			/col,/exclusive,uvalue='TRANSTYPE', $
                       set_value=2,/no_release)

        min_field = cw_field(base1y,/row,uvalue='MIN_FIELD',value=omin, $
                title='Min: ',xsize=13,/return_events,/float)
        max_field = cw_field(base1y,/row,uvalue='MAX_FIELD',value=omax, $
                title='Max: ',xsize=13,/return_events,/float)
	button = widget_button(base1y,uvalue='RESET',value='Reset Min/Max')

	base_sky = widget_base(base1y,/frame,/col)
        annulus_field = cw_field(base_sky,/row,uvalue='ANNULUS',value=0, $
                title='Annulus ',xsize=8,/return_events)
	base_sky1 = widget_base(base_sky,/row)
	sky_button = widget_button(base_sky1,uvalue='SKY',value='SKY')
	sky_field = cw_field(base_sky1,/row,uvalue='SKY_FIELD',value=skyval, $
                xsize=13,/return_events,/float,title=' ')
	button = widget_button(base1,uvalue='DRAW_ELLIPSE', $
			value='Draw Ellipse')

	base1a = widget_base(basea,/col)
	base1ar = widget_base(base1a,/row,/frame)
	xval_base = widget_label(base1ar,value='   ',xsize=45,/align_left)
	yval_base = widget_label(base1ar,value='   ',xsize=50,/align_left)
	val_base = widget_label(base1ar,value='F =   ',xsize=160, $
			/align_left)
	median_base = widget_label(base1ar,value='Median =     ', $
			xsize=240,/align_left)
	draw_window = widget_draw(base1a,uvalue='DRAW_WINDOW',retain=2, $
			xsize=512,ysize=512,/button_events,/motion)

	basea2 = widget_base(basea,/col)
	button = widget_button(basea2,uvalue='EXIT',value='EXIT')
	button = widget_button(basea2,uvalue='SNAP',value='SNAP')
	button = widget_button(basea2,uvalue='FILE',value='Read New Image')
	button = widget_button(basea2,uvalue='WRITE_EDIT', $
				value='Write Editted Image')
	button = widget_button(basea2,uvalue='WRITE',value='Write Results')
        name_field = cw_field(basea2,/row,uvalue='NAME_FIELD',value=fname, $
                title=' ',xsize=20,/return_events)
        image_zoom_button = cw_bgroup(basea2,['1','2','3','4','6','8','16'], $
			/col,/exclusive,uvalue='ZOOM', $
                        LABEL_TOP = 'Zoom Factor', $
                        set_value=0,/no_release)
	button = widget_button(basea2,uvalue='TIME',value='TIME')
	basea2frame = widget_base(basea2,/col,/frame)
	label_base = widget_label(basea2frame,value='Total')
	label_base = widget_label(basea2frame,value='Galaxy Flux')
	total_base = widget_label(basea2frame,value='   ',xsize=160, $
			/align_left)
	button = widget_button(basea2,uvalue='RECORD',value='Record Ellipse')
	record_base = widget_label(basea2,value='0')
	button = widget_button(basea2,uvalue='REVIEW',value='Review Ellipses')



	base2 = widget_base(base,/col)
	base2a = widget_base(base2,/row)
	base2b = widget_base(base2,/row)
	base2c = widget_base(base2,/row)
	label_base = widget_label(base2a,value='Ellipticity',xsize=150, $
			/align_left)
	label_base = widget_label(base2b,value='Position Angle',xsize=150, $
			/align_left)
	label_base = widget_label(base2c,value='Semi-Major Axis',xsize=150, $
			/align_left)
	
	e_slider = cw_fslider(base2a,min=0,max=1.0, $
			uvalue='E_SLIDER',xsize=600,/drag,/scroll, $
			value=ellipse.e,/suppress_value)
	angle_slider = cw_fslider(base2b,min=-90,max=90, $
			uvalue='ANGLE_SLIDER',xsize=600,/drag,/scroll, $
			value=ellipse.angle,/suppress_value)
	a_slider = cw_fslider(base2c,min=1.0,max=(ns>nl)*1.3, $
			uvalue='A_SLIDER',xsize=600,/drag,/scroll, $
			value=ellipse.a,/suppress_value)

        e_field = widget_label(base2a,value=strtrim(ellipse.e,2),/align_left, $
			xsize=120)
        angle_field = widget_label(base2b,value=strtrim(ellipse.angle,2), $
		/align_left,xsize=120)
        a_field = widget_label(base2c,value=strtrim(ellipse.a,2),/align_left, $
			xsize=120)
	
;
; turn control over to xmanger
;
        widget_control,base,/realize	
        widget_control,draw_window,get_value=window_id
	dogman_rescale
	wset,window_id
	tv,pic
	draw_ellipse,(ellipse.xc-xoffset)*zoom + (zoom-1)/2.0 , $
		     (ellipse.yc-yoffset)*zoom + (zoom-1)/2.0 , $
		     ellipse.a*zoom,ellipse.e,ellipse.angle
	xmanager,'dogman',base	
;
; return results
;
	if nrecord gt 0 then results = record else results = ellipse
	index = ellipse_defroi(orig,ellipse)
return
end
