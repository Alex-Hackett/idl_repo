;+
;          WFC3_TV
;
; IDL Viewer for WFC3
;
; CALLING SEQUENCE:
;
;   wfc3_tv
;   wfc3_tv,entry_number
;   wfc3_tv,image
;      or
;   wfc3_tv,image,header
;
; HISTORY:
;   version 1, D. Lindler, Jan 2002 (from big_tv)
;   Mar 3007, added write jpeg.
;-
; =========================================================== WFC3_TV_EVENT
;
; wfc3_tv Event Handler
;
pro wfc3_tv_event,event

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field

    widget_control,event.id,get_uvalue=uvalue
    case uvalue of

    'QUIT': begin
       orig = 0
       widget_control,event.top,/destroy
       return
       end

    'COLORS': xloadct

    'CONTRAST': begin
       scale_type = strmid(event.value,9,strlen(event.value)-9)
       if scale_type eq 'Auto Linear' then begin
                  hist = histogram(orig,min=0,max=65535)
                  for i=1L,65535 do hist(i) = hist(i)+hist(i-1)
                  n = n_elements(orig)
                  tabinv,hist,n*[0.06,0.97],range
         widget_control,min_field,set_value=range(0)
         widget_control,max_field,set_value=range(1)
       endif
       wfc3_tv_display
       end
    'HEADER': if n_elements(header) gt 1 then $
          xdisplayfile, "", group=event.top, $
          font='6X13', $
          title='FITS Header', text=header

    'MIN_FIELD': wfc3_tv_display

    'MAX_FIELD': wfc3_tv_display

    'RESET': begin
       widget_control,min_field,set_value=float(omin)
       widget_control,max_field,set_value=float(omax)
       wfc3_tv_display
       end

    'ZOOM': begin
       x = xoffzoom + 128/zoom_factor
       y = yoffzoom + 128/zoom_factor
       zoom_factor = fix(strmid(event.value,5,2))
       xoffzoom = (x - 128/zoom_factor)>0
       yoffzoom = (y - 128/zoom_factor)>0
       wfc3_tv_zoom,orig,zoom_factor,xoffzoom,yoffzoom,zoom
       wfc3_tv_scale,zoom_id,zoom
       end

    'BIG_WINDOW': begin
       x = event.x
       y = event.y
       wfc3_tv_xyval,orig,x,y,1,0,0
       if (state(0) eq 1) or (state(0) eq 2) then  $
          wfc3_tv_defroi,event,big_id
       if (state (0)ge 3) and (state(0) le 6) then $
          wfc3_tv_lineplot,event,'BIG'
       if (event.press gt 1) or ((state(0) eq 0) and $
          (event.press eq 1)) then begin
             xoffzoom = round(x - 128/zoom_factor + 1)>0
             yoffzoom = round(y - 128/zoom_factor + 1)>0
             wfc3_tv_zoom,orig,zoom_factor,xoffzoom,yoffzoom,zoom
             wfc3_tv_scale,zoom_id,zoom
       end
       end

    'LITTLE_WINDOW': begin
       x = event.x
       y = event.y
       factor = 256.0/(ns>nl)
       wfc3_tv_xyval,orig,x,y,factor,0,0
       if (state(0) eq 1) or (state(0) eq 2) then  $
          wfc3_tv_defroi,event,little_id
       if (state(0) ge 3) and (state(0) le 6) then $
          wfc3_tv_lineplot,event,'LITTLE'
       if (state(0) eq 0) then begin
         if event.press ge 1 then little_down=1
         if event.release ge 1 then little_down=0
         if little_down then begin
          factor = (ns>nl)/256.0
          x1 = ((x*factor)-350)>0
          y1 = ((y*factor)-350)>0
          widget_control,big_window,set_draw_view=[x1,y1]
         end
       end
       end

    'ZOOM_WINDOW': begin
       x = event.x
       y = event.y
       wfc3_tv_xyval,orig,x,y,zoom_factor,xoffzoom,yoffzoom
       if (state(0) eq 1) or (state(0) eq 2) then  $
          wfc3_tv_defroi,event,zoom_id
       if (state(0) ge 3) and (state(0) le 6) then $
          wfc3_tv_lineplot,event,'ZOOM'
       end

    'X_FIELD': begin
       widget_control,x_field,get_value=x
       widget_control,y_field,get_value=y
       wfc3_tv_xyval,orig,x,y,1,0,0
       end

    'Y_FIELD': begin
       widget_control,x_field,get_value=x
       widget_control,y_field,get_value=y
       wfc3_tv_xyval,orig,x,y,1,0,0
       end

    'HISTOGRAM' : wfc3_tv_histogram,event.top

    'DOGMAN': begin

       x1 = xoffzoom + 128/zoom_factor-256
       y1 = yoffzoom + 128/zoom_factor-256
       x2 = (x1 + 511)<(ns-1)
       y2 = (y1 + 511)<(nl-1)
       x1 = (x2 - 511)>0
       y1 = (y2 - 511)>0
       dogman,orig(x1:x2,y1:y2),group=event.top
       end

    'SURFACE': begin
       if (xoffzoom ge 0) and (yoffzoom ge 0) and $
          (xoffzoom le ns-1) and (yoffzoom le nl-1) then begin
          xend = (xoffzoom + 256/zoom_factor + 1)<(ns-1)
          yend = (yoffzoom + 256/zoom_factor + 1)<(nl-1)
          data = orig(xoffzoom:xend,yoffzoom:yend)
          x = findgen(xend-xoffzoom+1)+xoffzoom
          y = findgen(yend-yoffzoom+1)+yoffzoom
          widget_control,min_field,get_value=imin
          widget_control,max_field,get_value=imax
          case scale_type of
         'Linear': data = data>imin<imax
         'Log':   begin
          tmin=imax/1e4
          data = alog10((data-imin)>tmin<(imax-tmin))
          end
         'Sqrt': data = sqrt(data>0>imin<imax)
         'Hist. Eq.': data = hist_equal(data)
         'Auto Linear': data = data>imin<imax
          endcase
          xsurface,data
       end
       end

    'CONTOUR': begin
       if (xoffzoom ge 0) and (yoffzoom ge 0) and $
          (xoffzoom le ns-1) and (yoffzoom le nl-1) then begin
          xend = (xoffzoom + 256/zoom_factor + 1)<(ns-1)
          yend = (yoffzoom + 256/zoom_factor + 1)<(nl-1)
          data = orig(xoffzoom:xend,yoffzoom:yend)
          x = findgen(xend-xoffzoom+1)+xoffzoom
          y = findgen(yend-yoffzoom+1)+yoffzoom
          live_contour,data,xindep=x,yindep=y
       end
       end

    'WFC3': begin
;
;   WFC3 write postscript file
;
       if scale_type eq 'Linear' then linear=1 else linear=0
       if scale_type eq 'Log' then log=1 else log=0
       if scale_type eq 'Sqrt' then sqroot=1 else sqroot=0
       if scale_type eq 'Hist. Eq.' then histeq=1 else histeq=0
       widget_control,min_field,get_value=imin
       widget_control,max_field,get_value=imax
;
;   Zoom PS file
;
            if event.value eq 4 then begin
           if strtrim(sxpar(header,'instrume')) eq 'WFC3' then begin
           if (xoffzoom ge 0) and (yoffzoom ge 0) and $
             (xoffzoom le ns-1) and (yoffzoom le nl-1) then begin
             xend = (xoffzoom + 256/zoom_factor + 1)<(ns-1)
            yend = (yoffzoom + 256/zoom_factor + 1)<(nl-1)
             data = orig(xoffzoom:xend,yoffzoom:yend)
                      widget_control,/hourglass
         title = 'Region('+strtrim(xoffzoom,2)+':' + $
          strtrim(xend,2)+','+strtrim(yoffzoom,2)+':'+ $
          strtrim(yend,2)+')'
         wfc3_ps,0,imin=imin,imax=imax,header=header, $
          d=data,log=log, $
          linear=linear,sqroot=sqroot,histeq=histeq, $
          color=0,title=title
         widget_control,/hourglass
           end
           end
       end
;
;   PS file
;
       if event.value eq 3 then begin
           if strtrim(sxpar(header,'instrume')) eq 'WFC3' then begin
                      widget_control,/hourglass

         wfc3_ps,0,imin=imin,imax=imax,header=header, $
          d=orig,log=log, $
          linear=linear,sqroot=sqroot,histeq=histeq, $
          color=0,hudl=['END      ']
         widget_control,/hourglass
           end
       end

;
;       WFC3 Read by entry number
;
       if event.value eq 1 then begin
         wfc3_tv_wfc3read,entry,group=event.top
         widget_control,/hourglass
         wfc3_read,entry,header,orig
         widget_control,/hourglass
         wfc3_tv_display,orig
       end
;
;      WFC3 Read by filename
;
       if event.value eq 2 then begin
         filename = dialog_pickfile()
         if filename ne '' then begin
          widget_control,/hourglass
          wfc3_read,filename,header,orig
          widget_control,/hourglass
          wfc3_tv_display,orig
         endif
       endif
;
; write JPEG
;
       if event.value eq 5 then begin
       	  filename = dialog_pickfile(/write,dialog_parent=event.top,title='Enter name for JPEG file')
       	  print,filename
       	  if filename ne '' then begin

    		case scale_type of
    		   'Linear': pic = bytscl(orig,min=imin,max=imax,top=!d.n_colors)
    		   'Log':    begin
    		     tmin=imax/1e4
    		     pic = bytscl(alog10((orig-imin)>tmin),min=alog10(tmin), $
    		          max=alog10(imax-imin),top=!d.n_colors)
    		       end
       		    'Sqrt': pic = bytscl(sqrt((orig-imin)>0),min=0, $
              			max=sqrt(imax-imin),top=!d.n_colors)
       		     'Hist. Eq.': pic = hist_equal(orig,minv=imin,maxv=imax, $
              			top=!d.n_colors)
       		     'Auto Linear': pic = bytscl(orig,min=imin,max=imax, $
         			top=!d.n_colors)
    		endcase
       	  	tvlct,r,g,b,/get
       	  	write_jpeg,filename,[[[r(pic)]],[[g(pic)]],[[b(pic)]]],true=3
       	  end
       endif
       end

    'GAUSSFIT': begin
       if (xoffzoom ge 0) and (yoffzoom ge 0) and $
          (xoffzoom le ns-1) and (yoffzoom le nl-1) then begin
          xend = (xoffzoom + 256/zoom_factor + 1)<(ns-1)
          yend = (yoffzoom + 256/zoom_factor + 1)<(nl-1)
          data = orig(xoffzoom:xend,yoffzoom:yend)
          x = findgen(xend-xoffzoom+1)+xoffzoom
          y = findgen(yend-yoffzoom+1)+yoffzoom
          wfc3_tv_gfit,data,x,y
       end
       end

    'STATS': begin
        val = event.value
        case val of
;
;   Whole image
;
        3:  begin
            widget_control,/hourglass
            widget_control,min_field,get_value=minv
            wfc3_tv_stats,orig,minv,title='Image Statistics', $
                 group=event.top
            widget_control,/hourglass
            end
;
;   Zoom Image
;
       4:  begin
          if (xoffzoom ge 0) and (yoffzoom ge 0) and $
             (xoffzoom le ns-1) and (yoffzoom le nl-1) then begin
             xend = (xoffzoom + 256/zoom_factor + 1)<(ns-1)
            yend = (yoffzoom + 256/zoom_factor + 1)<(nl-1)
             data = orig(xoffzoom:xend,yoffzoom:yend)
             widget_control,/hourglass
             widget_control,min_field,get_value=minv
         title='Region ['+strtrim(xoffzoom,2)+':'+ $
               strtrim(xend,2)+', '+strtrim(yoffzoom,2)+':'+ $
               strtrim(yend,2)
             wfc3_tv_stats,data,minv,title=title,group=event.top
             widget_control,/hourglass
          end
          end
;
;   Sub Array
;
        else: begin
            state = [val,0,0]
            if state(0) eq 1 then mess = $
         'Place cursor on first corner and push right button' $
         else mess = $
         'Push mouse button, hold down, trace region,'+ $
         ' then release'
            widget_control,message,set_value=mess
            end
        endcase
        end
    'PLOT' : wfc3_tv_lineplot,event
    else:
    endcase
return
end
;
; ============================================================ WFC3_TV_WFC3READ
;
; Routine to read WFC3 observation using entry number
;

pro wfc3_tv_wfc3read,entry,group=group
;
; create widget
;
    base = widget_base(/col,group=group)
    button = widget_button(base,uvalue='DONE',value='Done')
    dbopen,'wfc3_log'
    n = db_info('entries')
    val_field = cw_field(base,/row,uvalue='VAL_FIELD', $
       value=n(0),title='Entry Number:', $
                xsize=13,/return_events,/long)
    widget_control,base,/realize
    junk = {entry:0L,val_field:val_field}
    pointer = widget_base()
    widget_control,pointer,set_uvalue=junk
    widget_control,base,set_uvalue=pointer

    xmanager,'wfc3_tv_wfc3read',base
    widget_control,pointer,get_uvalue=junk
    entry = junk.entry
    widget_control,pointer,/destroy
    return
end
pro wfc3_tv_wfc3read_event,event
    common wfc3_read,entry,val_field
    widget_control,event.top,get_uvalue=pointer,/no_copy
    widget_control,pointer,get_uvalue=junk,/no_copy
    widget_control,junk.val_field,get_value=entry
    junk.entry = entry
    widget_control,pointer,set_uvalue=junk,/no_copy
    widget_control,event.top,/destroy
    return
end
;
;
;================================================================ WFC3_TV_DISPLAY
;
; Routine to set up and display image all three windows
;
pro wfc3_tv_display, image

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field

    widget_control,/hourglass
;
; process new image?
;
    if n_params(0) gt 0 then begin     ;new image?
       if n_elements(orig) le 1 then orig = fltarr(750,750)
       omin = min(orig)
       omax = max(orig)
       if n_elements(header) gt 2 then $
         widget_control,topbase,tlb_set_title = $
          strtrim(sxpar(header,'entry'),2)+ '  '+ $
          sxpar(header,'filename')
       if scale_type eq 'Auto Linear' then begin
                  hist = histogram(orig,min=0,max=65535)
                  for i=1L,65535 do hist(i) = hist(i)+hist(i-1)
                  n = n_elements(orig)
                  tabinv,hist,n*[0.06,0.97],range
         widget_control,min_field,set_value=range(0)
         widget_control,max_field,set_value=range(1)
           end else begin
         widget_control,min_field,set_value=float(omin)
         widget_control,max_field,set_value=float(omax)
       end
       s = size(orig) & ns = s(1) & nl = s(2)
       nsout = 256
       nlout = 256
       if nl lt ns then nlout = round(256*float(nl)/ns)
       if ns lt nl then nsout = round(256*float(ns)/nl)
       little_image = frebin(orig,nsout,nlout)
       widget_control,big_window,draw_xsize=ns,draw_ysize=nl, $
          scr_xsize=730<(ns+50),scr_ysize=730<(nl+50)
    end
    widget_control,message,set_value=scale_type+' Display'
;
; display big image
;
    wfc3_tv_scale,big_id,orig
;
; display little image
;
    wfc3_tv_scale,little_id,little_image
;
; display zoom image
;
    wfc3_tv_zoom,orig,zoom_factor,xoffzoom,yoffzoom,zoom
    wfc3_tv_scale,zoom_id,zoom
;
; update histogram
;
    if xregistered('wfc3_tv_histogram') then begin
       wfc3_tv_histogram_comp
       wfc3_tv_histogram_plot
    end


    wset,big_id
    widget_control,/hourglass
    return
end
; ================================================================ WFC3_TV_SCALE
;
; Routine to scale and display an image
;
pro wfc3_tv_scale, window_id, image

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field


    widget_control,min_field,get_value=imin
    widget_control,max_field,get_value=imax
    case scale_type of
       'Linear': pic = bytscl(image,min=imin,max=imax,top=!d.n_colors)
       'Log':    begin
         tmin=imax/1e4
         pic = bytscl(alog10((image-imin)>tmin),min=alog10(tmin), $
              max=alog10(imax-imin),top=!d.n_colors)
         end
       'Sqrt': pic = bytscl(sqrt((image-imin)>0),min=0, $
              max=sqrt(imax-imin),top=!d.n_colors)
       'Hist. Eq.': pic = hist_equal(image,minv=imin,maxv=imax, $
              top=!d.n_colors)
       'Auto Linear': pic = bytscl(image,min=imin,max=imax, $
         top=!d.n_colors)
    endcase

    wset,window_id
    erase
    tv,pic
    return
end
;
;================================================================ WFC3_TV_ZOOM
;
; ROUTINE TO CREATE ZOOMED IMAGE -
;
pro wfc3_tv_zoom,image,zoom_factor,xoff,yoff,zoom
    s = size(image) & ns = s(1) & nl = s(2)
    if (xoff lt 0) or (yoff lt 0) or $
       (xoff ge ns-1) or (yoff ge nl-1) then begin
           zoom = fltarr(256,256)
       return
    end
    xend = (xoff + 256/zoom_factor + 1)<(ns-1)
    yend = (yoff + 256/zoom_factor + 1)<(nl-1)
    zoom = rebin(image(xoff:xend,yoff:yend),(xend-xoff+1)*zoom_factor, $
                 (yend-yoff+1)*zoom_factor,/samp)
    return
end
;
; ================================================================= WFC3_TV_XVAL
;
; ROUTINE TO UPDATE X/Y/Value fields
;
pro wfc3_tv_xyval,image,x,y,zoomfact,xoff,yoff

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field


    s = size(image) & ns = s(1) & nl = s(2)
    xx = xoff + fix(x/zoomfact)
    yy = yoff + fix(y/zoomfact)
    if (xx gt 0) and (xx lt ns-1) and (yy gt 0) and (yy lt nl-1) then begin
       widget_control,x_field,set_value=xx
       widget_control,y_field,set_value=yy
       widget_control,val_field,set_value=image(xx,yy)
    endif
    return
end
; ====================================================  WFC3_TV_HISTOGRAM_EVENT
;
; Histogram event handler
;
pro wfc3_tv_histogram_event,event

common wfc3_tv_histogram_common,hist_id,loghist, $
    hxrange,hyrange,xhist,yhist, $
    hmin_field,hmax_field,hslider

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field


    widget_control,event.id,get_uvalue=uvalue
    case uvalue of
        'EXIT' : begin
         widget_control,event.top,/destroy
         return
         end
        'LINEAR':  loghist = 0
        'LOG' :    loghist = 1
        'RESET' : begin
         widget_control,min_field,get_value=minv
         widget_control,max_field,get_value=maxv
         widget_control,hmin_field,set_value=minv
         widget_control,hmax_field,set_value=maxv
            end

         else:
    endcase
    wfc3_tv_histogram_plot
    return
end
;
; ========================================================  WFC3_TV_HISTOGRAM_COMP
;
; Routine to compute the histogram
;
pro wfc3_tv_histogram_comp
common wfc3_tv_histogram_common,hist_id,loghist, $
    hxrange,hyrange,xhist,yhist, $
    hmin_field,hmax_field,hslider

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field


    widget_control,min_field,get_value=minv
    widget_control,max_field,get_value=maxv
    range = maxv-minv
    if (range gt 200) and (maxv le 65536) and (minv ge -32768) then begin
       minv = long(minv)-0.5
       maxv = long(maxv)+1.5
       binsize=1
       end else begin
           binsize = (maxv-minv)/50000
    end
    yhist = histogram(orig,min=minv,max=maxv,binsize=binsize)
    xhist = lindgen(n_elements(yhist))*binsize+(minv+binsize/2)
    widget_control,hmin_field,set_value=minv
    widget_control,hmax_field,set_value=maxv

return
end
; ======================================================== WFC3_TV_HISTOGRAM_PLOT
;
; Routine to plot the histgram
;
pro wfc3_tv_histogram_plot
common wfc3_tv_histogram_common,hist_id,loghist, $
    hxrange,hyrange,xhist,yhist, $
    hmin_field,hmax_field,hslider

    widget_control,hmin_field,get_value=xmin
    widget_control,hmax_field,get_value=xmax
    widget_control,hslider,get_value=factor
    wset,hist_id
;
; determine binning for the histogram
;
    good = where((xhist ge xmin) and (xhist le xmax),ngood)
    if ngood eq 0 then begin
       ngood = n_elements(xhist)
       good = lindgen(xhist)
    end
    nsum = 1
    while ngood/nsum gt 500 do nsum = nsum + 1
;
; determine yrange
;
    ymin = 0.0
    if loghist then ymin = 0.1
    ymax = max(yhist(good))*factor
    plot,xhist,yhist>0.1,nsum=nsum,ylog=loghist,xrange=[xmin,xmax], $
         yrange = [ymin,ymax],xstyle=1,ystyle=1, $
         ytitle='',xtitle='',title='',psym=10

    return
end
;
; =========================================================== WFC3_TV_HISTOGRAM
;
; Main Widget Driver for Histograms
;
pro wfc3_tv_histogram,group

common wfc3_tv_histogram_common,hist_id,loghist, $
    hxrange,hyrange,xhist,yhist, $
    hmin_field,hmax_field,hslider
common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field

;
; initialization
;
    hxrange = [0.0, 0.0]
    hyrange = [0.0, 0.0]
    loghist = 0

    base = widget_base(/col,group=group)
    basebar = widget_base(base,/row)
    button = widget_button(basebar,uvalue='EXIT',value='EXIT')
    button = widget_button(basebar,uvalue='LINEAR',value='LINEAR')
    button = widget_button(basebar,uvalue='LOG',value='LOG')
    widget_control,min_field,get_value=minv
    widget_control,max_field,get_value=maxv
        hmin_field = cw_field(basebar,/row,uvalue='MIN_FIELD',value=minv, $
                title='Xmin: ',xsize=13,/return_events,/float)
        hmax_field = cw_field(basebar,/row,uvalue='MAX_FIELD',value=maxv, $
                title='Xmax: ',xsize=13,/return_events,/float)
    button = widget_button(basebar,uvalue='RESET',value='RESET')

    base1 = widget_base(base,/row)
    hist_window = widget_draw(base1,uvalue='HIST_WINDOW',retain=2, $
         xsize=600,ysize=350,/button_events)
    hslider = cw_fslider(base1,/drag,min=0.01,max=1.0,uvalue='SLIDER', $
       /vertical,/suppress_value,value=1.0,ysize=350)
    widget_control,base,/realize
    widget_control,hist_window,get_value=hist_id
    wfc3_tv_histogram_comp
    wfc3_tv_histogram_plot
    xmanager,'wfc3_tv_histogram',base,/no_block,group=group
    return
    end
;
; ================================================================ WFC3_TV_GFIT
;
;  Integrated Gaussian Fit event driver
;
pro wfc3_tv_gfit_event,event
widget_control,event.top,/destroy
return
end
;
; Integrated Gaussian Fit Widget
;
pro wfc3_tv_gfit,image,x,y,group=group
;
; compute fits
;
    profile1 = total(image,2)
    profile2 = total(image,1)
    fit1 = gaussint_fit(x,profile1,coef1,nterms=5)
    fit2 = gaussint_fit(y,profile2,coef2,nterms=5)
;
; create widget layout
;
    base = widget_base(/col,group=group)
    button = widget_button(base,uvalue='DONE',VALUE='DONE')
    basex = widget_base(base,/row)
    base1 = widget_base(basex,/col)
    base2 = widget_base(basex,/col)

    lab = widget_label(base1,value='Horizontal Profile')
    lab = widget_label(base2,value='Verticle Profile')

    draw1 = widget_draw(base1,xsize=450,ysize=300)
    draw2 = widget_draw(base2,xsize=450,ysize=300)

    lab = widget_label(base1,value='X-center =' + $
         string(coef1(1),'(F8.2)'))
    lab = widget_label(base2,value='Y-center =' + $
         string(coef2(1),'(F8.2)'))

    lab = widget_label(base1,value='X FWHM =' + $
         string(coef1(2)*2.3548,'(F8.2)'))
    lab = widget_label(base2,value='Y FWHM =' + $
         string(coef2(2)*2.3548,'(F8.2)'))
;
; create widget
;
    widget_control,base,/realize
    widget_control,draw1,get_value=window1
    widget_control,draw2,get_value=window2
;
; Plot Profiles
;
    back1 = coef1(3) + coef1(4)*x
    xx = congrid(x,500,/interp)
        arg=(abs((xx-coef1(1))/coef1(2))<9.)   ; set values 9 sigma to 0
        yy=exp(-arg*arg/2)*(arg lt 9.0)*coef1(0)
    yy = yy + coef1(3) + coef1(4)*xx
    wset,window1

    plot,x,profile1,psym=10,xstyle=1, $
       yrange= [ min(yy)<min(profile1) , max(yy)>max(profile1) ]
    oplot,x,fit1,psym=10,line=2
    oplot,xx,yy,thick=2
    oplot,x,back1,line=1

    back2 = coef2(3) + coef2(4)*y

    xx = congrid(y,500,/interp)
        arg=(abs((xx-coef2(1))/coef2(2))<9.)   ; set values 9 sigma to 0
        yy=exp(-arg*arg/2)*(arg lt 9.0)*coef2(0)
    yy = yy + coef2(3) + coef2(4)*xx

    wset,window2

    plot,y,profile2,psym=10,xstyle=1, $
       yrange = [ min(yy)<min(profile2) , max(yy)>max(profile2) ]
    oplot,y,fit2,psym=10,line=2
    oplot,xx,yy,thick=2
    oplot,y,back2,line=1
    xmanager,'wfc3_tv_gfit',base,/no_block
    return
end
;
; ================================================================= WFC3_TV_STATS
;
; Routine to compute statitics and print statistics
;
pro wfc3_tv_stats,region,background,group=group,title=title
;
; compute statistics
;
    if n_elements(title) eq 0 then title='Statistics'
    if n_elements(background) eq 0 then background=0.0
    n = n_elements(region)
    minv = min(region,max=maxv)
    med = median(region)
    sig = stdev(region,mean)
    tot = mean*n
    medback = med-background
    totback = tot - background*n
    meanback= mean-background
    minvb = minv - background
    maxvb = maxv - background
;
; display result in a widget
;
    base = widget_base(group=group,/col,title=title)
    button = widget_button(base,value = 'DONE')
    lab = widget_label(base,/align_left,value='  NPoints = '+strtrim(n,2))
    lab = widget_label(base,/align_left, $
          value='  Minimum = '+strtrim(minv,2))
    lab = widget_label(base,/align_left, $
         value='  Maximum = '+strtrim(maxv,2))
    lab = widget_label(base,/align_left,value='  Total = '+strtrim(tot,2))
    lab = widget_label(base,/align_left,value='  Median = '+strtrim(med,2))
    lab = widget_label(base,/align_left,value='  Mean = '+strtrim(mean,2))
    lab = widget_label(base,/align_left,value='  StDev = '+strtrim(sig,2))
    lab = widget_label(base,/align_left,value=' ')
    lab = widget_label(base,value='Results after background subtraction')
    lab = widget_label(base,/align_l, $
         value='  Background = '+strtrim(background,2))
    lab = widget_label(base,/align_l,value='  Minimum = '+strtrim(minvb,2))
    lab = widget_label(base,/align_l,value='  Maximum = '+strtrim(maxvb,2))
    lab = widget_label(base,/align_l,value='  Total = '+strtrim(totback,2))
    lab = widget_label(base,/align_l,value='  Median = '+strtrim(medback,2))
    lab = widget_label(base,/align_l,value='  Mean = '+strtrim(meanback,2))
    widget_control,base,/realize
    xmanager,'wfc3_tv_stats',base,/no_block
    return
end
pro wfc3_tv_stats_event,event
widget_control,event.top,/destroy
return
end
;
; ===============================================================  WFC3_TV_DEFROI
;
; Routine to define region of interest
;
pro wfc3_tv_defroi,event,window_id

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field

;
; State Vector
;   State(0) = 0 not processing stats
;        1 Processing Box
;        2 Processing Defroi
;   State(1) = 0 Ready to begin processing
;      = 1 Button Pressed for first position of box or button
;      Pressed for defroi
;      = 2 Button pressed for second position of box or button
;      released for defroi
;   State(2) = window id of window being processed
;
;
; convert x and y to data coordinates
;
    x = event.x
    y = event.y
    case window_id of
       big_id: begin
         xdata = x
         ydata = y
         end
       little_id: begin
         factor = 256.0/(ns>nl)
         xdata = long(x/factor)
         ydata = long(y/factor)
         end
       zoom_id: begin
         xdata = long(x/zoom_factor) + xoffzoom
         ydata = long(y/zoom_factor) + yoffzoom
         end
    endcase
;
; BOX Processing
;
    if state(0) eq 1 then begin
        if event.press ne 1 then return
        case state(1) of
           0: begin       ;processing not started
          state(1) = 1
          xregion(0) = xdata
          yregion(0) = ydata
          nregion = 1
          widget_control,message,set_value = 'Place cursor on ' + $
               'opposite corner and press right button'
          return
          end
       1: begin       ;waiting for second corner
          state(1) = 2
          xregion(1) = xdata
          yregion(1) = ydata
          xregion(0) = [xregion(0),xregion(1),xregion(1), $
              xregion(0),xregion(0)]
          yregion(0) = [yregion(0),yregion(0),yregion(1), $
              yregion(1),yregion(0)]
          nregion = 5
          end
        endcase
     end else begin
;
; Draw Processing
;
        case state(1) of
           0: begin       ;not yet started
          if event.press eq 1 then begin
             state(1) = 1
         xregion(0) = xdata
         yregion(0) = ydata
         nregion = 1
          end
          return
          end
       1: begin
          xregion(nregion) = xdata
          yregion(nregion) = ydata
          nregion = nregion + 1
          if event.release gt 0 then state(1) = 2
          end
        endcase
    end
;
; Draw region in all three windows
;
    i1 = nregion-2
    i2 = nregion-1
    if state(0) eq 1 then i1 = 0   ;draw entire box
    xx = xregion(i1:i2)
    yy = yregion(i1:i2)
    if (state(0) eq 2) and (state(1) eq 2) then begin  ;back to first point
       xx = [xx,xregion(0)]
       yy = [yy,yregion(0)]
    end
;
; convert to window coordinates for all three windows and plot
;
    wset,big_id
    plots,xx,yy,/dev

    wset,little_id
    factor = 256.0/(ns>nl)
    plots,long(xx*factor),long(yy*factor),/dev

    wset,zoom_id
    plots,(xx-xoffzoom)*zoom_factor + zoom_factor/2, $
          (yy-yoffzoom)*zoom_factor + zoom_factor/2, /dev
;
; process statistics
;
    if state(1) lt 2 then return
    widget_control,message,set_value = ' '
    index = polyfillv(xregion(0:nregion-1),yregion(0:nregion-1),ns,nl)
    n = n_elements(index)
    widget_control,min_field,get_value=minv
    if state(0) eq 1 then title='Statistics in Box' $
          else title='Statistics in Drawn Region'
    if n gt 1 then begin
       widget_control,/hourglass
       wfc3_tv_stats,orig(index),minv,group = event.top
       widget_control,/hourglass
    end
    nregion = 0
    state = intarr(3)
return
end
;
; =============================================================  WFC3_TV_LINEPLOT
;
; Routine to plot row/column sums
;
pro wfc3_tv_lineplot,event,window
;

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field
;
; State Vector
;
;   State(0) = 3 Row
;                  4 Column
;        5 Row Sum
;        6 Column Sum
;   State(1) = Number of points measured
;
;
; If window not supplied, initialize state vector, and print instructions
;
;
    if n_params(0) lt 2 then begin
       State = [event.value+2,0,0]
       case state(0) of
         3: mess = 'Select row and click left mouse button'
         4: mess = 'Select column and click left mouse button'
         5: mess = 'Select first row and click left button'
         6: mess = 'Select first column and click left button'
       endcase
       widget_control,message,set_value=mess
       return
    end
;
; If right button not pressed then return
;
    if event.press ne 1 then return
;
; convert x and y to data coordinates
;
    wfc3_tv_convert,event.x,event.y,window,x,y
    xregion(state(1)) = x
    yregion(state(1)) = y
    state(1) = state(1) + 1
;
; Row Plot
;
    if state(0) eq 3 then begin
       if window eq 'ZOOM' then $
          xrange = [xoffzoom,xoffzoom+256/zoom_factor]
       lineplot,orig(*,y),title='Row '+strtrim(y,2),xrange=xrange
    end
;
; Column Plot
;
    if state(0) eq 4 then begin         ;column plot
       if window eq 'ZOOM' then $
          xrange = [yoffzoom,yoffzoom+256/zoom_factor]
       lineplot,reform(orig(x,*)),title='Column '+strtrim(x,2), $
          xrange=xrange
    end
;
; Row Sum
;
    if (state(0) eq 5) and (state(1) eq 2) then begin  ;Row Sum
       if window eq 'ZOOM' then $
          xrange = [xoffzoom,xoffzoom+256/zoom_factor]
       y1 = yregion(0)<yregion(1)
       y2 = yregion(0)>yregion(1)
       if y1 eq y2 then data = orig(*,y1) $
             else data = total(orig(*,y1:y2),2)
       title = 'Rows '+strtrim(y1,2)+' to '+ strtrim(y2,2)
       lineplot,data,title=title,xrange=xrange
    end
;
; Column Sum
;
    if (state(0) eq 6) and (state(1) eq 2) then begin  ;Row Sum
       if window eq 'ZOOM' then $
          xrange = [yoffzoom,yoffzoom+256/zoom_factor]
       x1 = xregion(0)<xregion(1)
       x2 = xregion(0)>xregion(1)
       if x1 eq x2 then data = reform(orig(x1,*)) $
             else data = total(orig(x1:x2,*),1)
       title = 'Columns '+strtrim(x1,2)+' to '+ strtrim(x2,2)
       lineplot,data,title=title,xrange=xrange
    endif
;
; Do we need second point?
;
    if (state(0) gt 4) and (state(1) eq 1) then begin
       if state(0) eq 5 then mess = $
          'Select last row and click left button' $
         else mess = 'Select last column and click left button'
           widget_control,message,set_value = mess
        end else begin
           widget_control,message,set_value = scale_type + ' Display'
       state = [0,0,0]
    end
    return
end
;
; =================================================================  WFC3_TV_PLOT
; Widget to control live_plot
;
pro wfc3_tv_plot,data,title,group=group,xrange=xrange

    common wfc3_tv_plot_common,window_id

    if n_elements(title) eq 0 then title='Data'
;
; Overplot?
;
    if xregistered('wfc3_tv_plot') then begin
       live_oplot,data,window='wfc3_tv Plot', $
          name={data:title}
       return
    end
;
; New Plot
;
;   live_destroy,'wfc3_tv Plot',/error    ;clean up just in case
    base = widget_base(group=group,/col)
    button = widget_button(base,value='DONE')
    live_plot,data,independent=findgen(n_elements(data)), $
       parent=base,draw_dim = [600,450], $
       reference_out=ref_out,title='wfc3_tv Plot', $
       name={data:title,i:'Pixel'},xrange=xrange
    window_id = ref_out.win
    widget_control,/realize
    xmanager,'wfc3_tv_plot',base,/no_block
    return
end
;
; Event Driver
;
pro wfc3_tv_plot_event,event
    live_destroy,window='wfc3_tv Plot'
    widget_control,event.top,/destroy
    return
end

;
;=============================================================== WFC3_TV_CONVERT
;
; Routine to convert x,y coordinates from screen to data and vice versa
;
pro wfc3_tv_convert,xin,yin,window,xout,yout,to_screen=to_screen
;
; Inputs: xin, yin, window
;   window = 'big','little', or 'zoom'
; Outputs: xout, yout
; Keyword: /to_screen - if supplied coordinates are converted from
;      data to screen coord, otherwise conversion is
;      for screen to data.
;
common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field
;
; conversion from screen to data
;
    if keyword_set(to_screen) then begin

       case window of
         'BIG': begin
          xout = xin
          yout = yin
          end
         'LITTLE': begin
          factor = (ns>nl)/256.
          xout = fix(xin/factor)
          yout = fix(yin/factor)
          end
         'ZOOM': begin
          xout = (xin - xoffzoom)*zoom_factor + $
                   zoom_factor/2
          yout = (yin - yoffzoom)*zoom_factor + $
                   zoom_factor/2
          end
       end
        end else begin
;
; conversion for screen to data
;
       case window of
         'BIG': begin
          xout = xin
          yout = yin
          end
         'LITTLE': begin
          factor = (ns>nl)/256.0
          xout = fix(xin*factor+factor/2)
          yout = fix(yin*factor+factor/2)
          end
         'ZOOM': begin
          xout = long(xin/zoom_factor) + xoffzoom
          yout = long(yin/zoom_factor) + yoffzoom
          end
       end
       xout = xout>0<(ns-1)
       yout = yout>0<(nl-1)
    end
    return
end

; ===================================================================== WFC3_TV
;
; Main Routine
;
pro wfc3_tv,image,h

common wfc3_tv_common,topbase,message,orig,header,ns,nl,omin,omax, $
    big_window,big_id, state,xregion,yregion,nregion, $
    zoom_id,zoom,zoom_factor,xoffzoom,yoffzoom, $
    little_image, little_id, little_down, little_ns, little_nl, $
    draw_x, draw_y, ndraw, draw_window, $
    scale_type, min_field,max_field, x_field, y_field, val_field

    if n_elements(h) gt 0 then header=h else header=['END      ']
    if n_elements(image) eq 1 then wfc3_read,image,header,orig
    if n_elements(image) gt 1 then orig = image
    if xregistered('wfc3_tv') then begin
       wfc3_tv_display,image
       return
    end

;
; initialization
;
    s = size(image) & ns = s(1) & nl = s(2)
    zoom_factor = 5
    xoffzoom = ns/2 - 128/zoom_factor
    yoffzoom = ns/2 - 128/zoom_factor
    little_down = 0
    scale_type = 'Linear'
    state = intarr(3)
    xregion = intarr(20000)
    yregion = intarr(20000)
    nregion = 0
;   widget_control,default_font  = $
;      '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
;
; create widget layout
;
    base = widget_base(/col,group=0)
    topbase = base
    widget_control,base,/managed
;
; Button Bar
;
    basebar = widget_base(base,/row)
    button = widget_button(basebar,uvalue='QUIT',value='QUIT')
    desc = ['1\WFC3','0\Read by Entry','0\Read by Filename', $
       '0\Write ps File','0\Write zoom ps file','2\Write JPEG']
    button = cw_pdmenu(basebar,desc,uvalue='WFC3')
    button = widget_button(basebar,uvalue='COLORS',value='Colors')
    desc = ['1\Contrast','0\Linear','0\Sqrt','0\Log','0\Hist. Eq.', $
       '2\Auto Linear']
    button = cw_pdmenu(basebar,desc,uvalue='CONTRAST',/Return_full_name)
    button = widget_button(basebar,uvalue='HISTOGRAM',value='Histogram')
    desc = ['1\Stats','0\Box','0\Draw Region','0\Whole Image', $
       '2\Zoomed Image']
    button = cw_pdmenu(basebar,desc,uvalue='STATS')
    desc = ['1\Plot','0\Row','0\Column','0\Row Sum','2\Column Sum']
    button = cw_pdmenu(basebar,desc,uvalue='PLOT')
    button = widget_button(basebar,uvalue='HEADER',value='Header')
    button = widget_button(basebar,uvalue='DOGMAN',value='Dogman')
    button = widget_button(basebar,uvalue='SURFACE',value='Surface')
    button = widget_button(basebar,uvalue='CONTOUR',value='Contour')
    button = widget_button(basebar,uvalue='GAUSSFIT',value='GaussFit')
    desc = ['1\Zoom','0\ 1','0\ 2','0\ 3','0\ 4','0\ 5','0\ 6','0\ 7', $
       '0\ 8','0\ 9','0\10','0\16','2\32']
    button = cw_pdmenu(basebar,desc,uvalue='ZOOM',/return_full_name)

    basewindows = widget_base(base,/row)
    basebig = widget_base(basewindows,/col)
    message = widget_label(basebig,value='   ',xsize=700)
    big_window = widget_draw(basebig,uvalue='BIG_WINDOW', $
         xsize=1024,ysize=1024,x_scroll_size=700, $
         y_scroll_size=700,/button_events,/motion)
    base2 = widget_base(basewindows,/col)
    zoom_window = widget_draw(base2,uvalue='ZOOM_WINDOW',retain=2, $
         xsize=256,ysize=256,/motion,/button_events)

    base2a = widget_base(base2,/col,/frame)

        min_field = cw_field(base2a,/row,uvalue='MIN_FIELD',value=omin, $
                title='Min: ',xsize=13,/return_events,/float)
        max_field = cw_field(base2a,/row,uvalue='MAX_FIELD',value=omax, $
                title='Max: ',xsize=13,/return_events,/float)
    button = widget_button(base2a,uvalue='RESET',value='Reset Min/Max')

    base2b = widget_base(base2,/col,/frame)
    x_field = cw_field(base2b,/row,uvalue='X_FIELD',value=-1, $
                title='X:   ',xsize=13,/return_events,/long)
    y_field = cw_field(base2b,/row,uvalue='Y_FIELD',value=-1, $
                title='Y:   ',xsize=13,/return_events,/long)
    val_field = cw_field(base2b,/row,uvalue='VAL_FIELD',value=-1, $
                title='Val: ',xsize=13,/return_events,/float)



    little_window = widget_draw(base2,uvalue='LITTLE_WINDOW',retain=2, $
         xsize=256,ysize=256,/button_events,/motion)

;
; create widget
;
    widget_control,base,/realize
        widget_control,big_window,get_value=big_id
        widget_control,little_window,get_value=little_id
        widget_control,zoom_window,get_value=zoom_id
    wfc3_tv_display,image

    xmanager,'wfc3_tv',base,/no_block
    return
end
