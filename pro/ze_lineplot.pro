;+
;       ze_lineplot
; Widget line plot tool.  If widget is already active, the routine will over
; plot the new x,y on the existing plot.
;
; CALLING SEQUENCE:
; ze_lineplot,x,y
;   or
; ze_lineplot,y
;
; INPUTS
; x - input x vector
; y - input y vector
; OPTIONAL INPUT PARAMETERS
; ptitle - main plot title
; title - title of the plot or overplot vectors
; xtitle - title for the xaxis
; ytitle - title for the yaxis
; xrange - initial xrange for the plot
; yrange - initial yrange for the plot
; group - group id of calling widget
;
; INTERACTIVE INPUTS:
; In addition to the widget parameters controlled by buttons and
; text field inputs:
; 1) Use the left mouse button to measure a feature location in the
;    plot.
; 2) Push the center mouse button and hold it down to define
;    two corners of a region to be zoomed.
;
; The large text box containing the history may be edited before writing
; to a file
;
; HISTORY:
; version 1  D. Lindler  Aug 1999
; Aug, 2001, D. Lindler, Added Equivalent Width computation and
;   button.
; Aug, 2003, D. Lindler, Added YSCALE button and NSMOOTH field.
; Nov 2005, D. Lindler, Added XOFFSET and YOFFSET buttons.  Added Velocity
;   plotting.  Added output of all spectra to FITS binary table file.
;-
;----------------------------------------------------------------------------

;====================================================== ze_lineplot_EVENT
;
; Main event driver for ze_lineplot
;
pro ze_lineplot_event,event
  common ze_lineplot_common,info,xarray,yarray,r,g,b,rsave,gsave,bsave
  tvlct,r,g,b
  set_xy
  set_viewport
  widget_control,event.id,get_uvalue=uvalue
  case uvalue of
    'EXIT': begin
      xarray = 0
      yarray = 0
      wdelete,info.pixid
      tvlct,rsave,gsave,bsave
      widget_control,event.top,/destroy
    end
    'PLOT': begin
      ze_lineplot8_plot,info,xarray,yarray,plotwindow
    end
    'SAVEPDF': begin
      ze_lineplot8_plot,info,xarray,yarray,plotwindow,buffer=1
     
      plotwindow.Save, "/Users/jgroh/temp/temp.pdf",HEIGHT=8.0*450/950., WIDTH=8.0, PAGE_SIZE=[8,8*450/950.]
      
    end
    'WRITE': begin
      case event.value of
        'Write.Postscript File': begin
          orig_device = !d.name
          set_plot,'ps'

          aa=800
          bb=600
          ps_ysize=6.
          ps_xsize=ps_ysize*aa/bb
          psfilename='/Users/jgroh/temp/plot1.eps'
          device,filename=psfilename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches,cmyk=0

          !p.font = 0
          set_viewport,0.08,0.98,0.08,0.98

          ze_lineplot_plot,info,xarray,yarray,/ps
          ze_lineplot_annotate,info,/ps
          device,/close
          set_plot,orig_device
          !p.font = -1

        end
        'Write.ASCII Table': begin
          ze_lineplot_select,info,'Select Which Plot to Write', $
            isel,group=event.top
          file = dialog_pickfile(file='idl.txt',filter='*.txt', $
            /write)
          if file eq '' then return ;no file selected
          openw,unit,file,/get_lun
          printf,unit,';'+info.ptitle
          printf,unit,';'+info.title(isel)
          printf,unit,';'+info.ytitle
          printf,unit,';'+info.xtitle
          if isel ne 0 then i1 = round(total(info.ns(0:isel-1))) $
          else i1 = 0L
          i2 = i1 + info.ns(isel)-1
          for i=i1,i2 do printf,unit,xarray(i),yarray(i)
          free_lun,unit
        end
        'Write.FITS Table': begin
          ze_lineplot_select,info,'Select Which Plot to Write', $
            isel,group=event.top
          file = dialog_pickfile(file='idl.fits', $
            filter='*.fits',/write)
          if file eq '' then return ;no file selected
          sxaddpar,h,'PTITLE',info.ptitle
          sxaddpar,h,'XTITLE',info.xtitle
          sxaddpar,h,'YTITLE',info.ytitle
          sxaddpar,h,'TITLE',info.title(isel)
          if isel ne 0 then i1 = round(total(info.ns(0:isel-1))) $
          else i1 = 0L
          i2 = i1 + info.ns(isel)-1
          a = {x:xarray(i1:i2),y:yarray(i1:i2), $
            xoffset:info.xoffset(isel), $
            yscale:info.yscale(isel), $
            yoffset:info.yoffset(isel), $
            title:info.title(isel)}
          mwrfits,a,file,h,/create
        end
        'Write.All data to FITS Table': begin
          file = dialog_pickfile(file='idl.fits', $
            filter='*.fits',/write)
          if file eq '' then return ;no file selected
          sxaddpar,h,'PTITLE',info.ptitle
          sxaddpar,h,'XTITLE',info.xtitle
          sxaddpar,h,'YTITLE',info.ytitle
          sxaddpar,h,'NSPECTRA',info.n
          for i=0,info.n-1 do begin
            if i ne 0 then i1 = round(total(info.ns(0:i-1))) $
            else i1 = 0L
            i2 = i1 + info.ns(i)-1
            a = {x:xarray(i1:i2),y:yarray(i1:i2), $
              xoffset:info.xoffset(i), $
              yscale:info.yscale(i), $
              yoffset:info.yoffset(i), $
              title:info.title(i)}
            mwrfits,a,file,h,create=(i eq 0)
          end
        end
        'Write.Log File': begin
          file = dialog_pickfile(file='idl.log', $
            filter='*.log',/write)
          if file eq '' then return ;no file selected
          widget_control,info.log,get_value=v
          openw,unit,file,/get_lun
          for i=0L,n_elements(v)-1 do printf,unit,v(i)
          free_lun,unit
        end
      endcase
    end
    'MAIN':
    'ZOOM': begin
      wset,info.plot2_id
      erase
      xyouts,10,150,/dev,'Place Cursor on first corner',$
        charsize=1.4,charthick=2,color=fsc_color('black')
      xyouts,10,110,/dev,'and push left mouse button', $
        charsize=1.4,charthick=2,color=fsc_color('black')
      info.state = 'ZOOM1'
    end
    'UNZOOM_ALL': begin
      yscaled = yarray*0
      i1 = 0
      widget_control,info.yoff_base,get_value=yoffval
      good = bytarr(n_elements(yarray))
      for i=0,info.n-1 do begin
        i2 = i1+info.ns(i)-1
        good(i1:i2) = (yarray(i1:i2) gt info.min_val(i)) and $
          (yarray(i1:i2) lt info.max_val(i))
        yscaled(i1:i2) = i*float(yoffval) + info.yoffset(i) + $
          yarray(i1:i2)*info.yscale(i)
        i1 = i2+1
      end
      minx = min(xarray)
      maxx = max(xarray)
      widget_control,info.rest_base,get_value=wrest
      if wrest(0) ne 0 then begin
        minx = (minx-wrest(0)) * 2.997925e5/wrest(0)
        maxx = (maxx-wrest(0)) * 2.997925e5/wrest(0)
      end
      widget_control,info.xmin_base,set_value = minx
      widget_control,info.xmax_base,set_value = maxx
      good = where(good)
      ygood = yscaled(good)
      widget_control,info.ymin_base,set_value = min(ygood)
      widget_control,info.ymax_base,set_value = max(ygood)
      ze_lineplot_plot,info,xarray,yarray
      ze_lineplot_annotate,info
    end
    'UNZOOM': begin
      yscaled = yarray*0
      i1 = 0
      widget_control,info.yoff_base,get_value=yoffval
      good = bytarr(n_elements(yarray))
      for i=0,info.n-1 do begin
        i2 = i1+info.ns(i)-1
        good(i1:i2) = (yarray(i1:i2) gt info.min_val(i)) and $
          (yarray(i1:i2) lt info.max_val(i))
        yscaled(i1:i2) = i*float(yoffval) + info.yoffset(i) + $
          yarray(i1:i2)*info.yscale(i)
        i1 = i2+1
      end
      minx = min(xarray)
      maxx = max(xarray)
      widget_control,info.rest_base,get_value=wrest
      if wrest(0) ne 0 then begin
        minx = (minx-wrest(0)) * 2.997925e5/wrest(0)
        maxx = (maxx-wrest(0)) * 2.997925e5/wrest(0)
      end

      good = where(good)
      ygood = yarray(good)

      widget_control,info.xmin_base,get_value = xmin
      widget_control,info.xmax_base,get_value = xmax
      widget_control,info.ymin_base,get_value = ymin
      widget_control,info.ymax_base,get_value = ymax
      xrange = (xmax-xmin)
      yrange = (ymax-ymin)
      xmin = (xmin - xrange*0.25) > minx < xmin
      xmax = (xmax + xrange*0.25) < maxx > xmax
      ymin = (ymin - yrange*0.25) > min(ygood) < ymin
      ymax = (ymax + yrange*0.25) < max(ygood) > ymax
      widget_control,info.xmin_base,set_value = xmin
      widget_control,info.xmax_base,set_value = xmax
      widget_control,info.ymin_base,set_value = ymin
      widget_control,info.ymax_base,set_value = ymax
      ze_lineplot_plot,info,xarray,yarray
      ze_lineplot_annotate,info
    end
    'RESTWAVE': begin
      old = info.restwave
      widget_control,info.rest_base,get_value=new
      widget_control,info.xmin_base,get_value=xmin
      widget_control,info.xmax_base,get_value=xmax
      c = 2.997925e5
      if (new eq 0) and (old ne 0) then begin
        xmin = xmin/c*old+old
        xmax = xmax/c*old+old
      end
      if (new ne 0) and (old eq 0) then begin
        xmin = (xmin-new)/new*c
        xmax = (xmax-new)/new*c
      end
      widget_control,info.xmin_base,set_value=xmin
      widget_control,info.xmax_base,set_value=xmax
      ze_lineplot_plot,info,xarray,yarray
    end

    'YSCALE': begin
      ze_lineplot_select,info,'Select Which Plot to Scale', $
        isel,group=event.top
      info.isel = isel
      wset,info.plot2_id
      erase
      xyouts,10,150,/dev,'Place Cursor at current Y-level',$
        charsize=1.4,charthick=2,color=fsc_color('black')
      xyouts,10,110,/dev,'and push left mouse button', $
        charsize=1.4,charthick=2,color=fsc_color('black')
      info.state = 'YSCALE1'
    end
    'YOFFSET': begin
      ze_lineplot_select,info,'Select Which Plot to Offset', $
        isel,group=event.top
      info.isel = isel
      wset,info.plot2_id
      erase
      xyouts,10,150,/dev,'Place Cursor at current Y-level',$
        charsize=1.4,charthick=2,color=fsc_color('black')
      xyouts,10,110,/dev,'and push left mouse button', $
        charsize=1.4,charthick=2,color=fsc_color('black')
      info.state = 'YOFFSET1'
    end
    'XOFFSET': begin
      ze_lineplot_select,info,'Select Which Plot to Offset', $
        isel,group=event.top
      info.isel = isel
      wset,info.plot2_id
      erase
      xyouts,10,150,/dev,'Place Cursor at current X position',$
        charsize=1.4,charthick=2,color=1
      xyouts,10,110,/dev,'and push left mouse button', $
        charsize=1.4,charthick=2,color=1
      info.state = 'XOFFSET1'
    end
    'RANGE': ze_lineplot_plot,info,xarray,yarray
    'LINESTYLES': ze_lineplot_plotpar,group=event.top
    'XLOG': begin
      info.xlog = 1 - info.xlog
      if info.xlog eq 1 then v='X Linear' else v='X Log'
      widget_control,info.xbutton,set_value=v
      ze_lineplot_plot,info,xarray,yarray
    end
    'YLOG': begin
      info.ylog = 1 - info.ylog
      if info.ylog eq 1 then v='Y Linear' else v='Y Log'
      widget_control,info.ybutton,set_value=v
      ze_lineplot_plot,info,xarray,yarray
    end
    'NSMOOTH': ze_lineplot_plot,info,xarray,yarray
    'GAUSSFIT': ze_lineplot_gfit,info,xarray,yarray,event.value,group=event.top

    'EQWIDTH': ze_lineplot_eqwidth,info,xarray,yarray,group=event.top
    'PLOT1': begin
      xd = event.x  ;device coordinates
      yd = event.y
      wset,info.plot1_id
      device,copy=[0,0,950,450,0,0,info.pixid]
      if (info.state eq 'X/Y') then begin
        plots,[xd,xd],[0,450],color=1,/dev
        plots,[0,950],[yd,yd],color=1,/dev
        if event.press eq 1 then begin
          !x = info.xsave
          !y = info.ysave
          v = convert_coord(xd,yd,/dev,/to_data)
          widget_control,info.log,/append,set_value= $
            'X = '+strtrim(v(0),2)+ $
            '    Y = '+strtrim(v(1),2)
        endif
        if event.press eq 2 then begin
          info.x1 = xd
          info.y1 = yd
          info.state = 'ZOOM2'
          return
        endif
      end

      if info.state eq 'ZOOM1' and (event.press eq 1) then begin
        plots,[xd,xd],[0,450],color=1,/dev
        plots,[0,950],[yd,yd],color=1,/dev
        info.x1 = xd
        info.y1 = yd
        wset,info.plot2_id
        erase
        xyouts,10,150,/dev,'Position at second corner and', $
          charsize=1.4,charthick=2,color=1
        xyouts,10,110,/dev,'push left mouse button', $
          charsize=1.4,charthick=2,color=1
        info.state = 'ZOOM2'
        return
      endif

      if info.state eq 'YSCALE1' then begin
        plots,[0,950],[yd,yd],color=1,/dev
        if (event.press eq 1) then begin
          info.y1 = yd
          info.x1 = xd
          wset,info.plot2_id
          erase
          xyouts,10,150,/dev,'Position at New Y-level and', $
            charsize=1.4,charthick=2,color=1
          xyouts,10,110,/dev,'push left mouse button', $
            charsize=1.4,charthick=2,color=1
          info.state = 'YSCALE2'
        end
        return
      endif

      if info.state eq 'YSCALE2' then begin
        x = [info.x1,xd]
        y = [info.y1,yd]
        plots,[0,950],[y(0),y(0)],/dev,color=1,line=1
        plots,[0,950],[y(1),y(1)],/dev,color=1
        if (event.press eq 1) then begin
          !x = info.xsave
          !y = info.ysave
          v = convert_coord(x,y,/dev,/to_data)
          y = v(1,*)
          info.yscale(info.isel) = info.yscale(info.isel) * $
            (y(1)/y(0))
          info.yoffset(info.isel) = info.yoffset(info.isel) * $
            (y(1)/y(0))
          widget_control,info.log,/append,set_value= $
            info.title(info.isel)+': Yscale =  '+ $
            strtrim(info.yscale(info.isel),2)
          if info.yoffset(info.isel) ne 0 then $
            widget_control,info.log,/append,set_value= $
            info.title(info.isel)+': Yoffset =  '+ $
            strtrim(info.yoffset(info.isel),2)
          ze_lineplot_plot,info,xarray,yarray
          ze_lineplot_annotate,info
        end
      end

      if info.state eq 'YOFFSET1' then begin
        plots,[0,950],[yd,yd],color=1,/dev
        if (event.press eq 1) then begin
          info.y1 = yd
          info.x1 = xd
          wset,info.plot2_id
          erase
          xyouts,10,150,/dev,'Position at New Y-level and', $
            charsize=1.4,charthick=2,color=1
          xyouts,10,110,/dev,'push left mouse button', $
            charsize=1.4,charthick=2,color=1
          info.state = 'YOFFSET2'
        end
        return
      endif

      if info.state eq 'YOFFSET2' then begin
        x = [info.x1,xd]
        y = [info.y1,yd]
        plots,[0,950],[y(0),y(0)],/dev,color=1,line=1
        plots,[0,950],[y(1),y(1)],/dev,color=1
        if (event.press eq 1) then begin
          !x = info.xsave
          !y = info.ysave
          v = convert_coord(x,y,/dev,/to_data)
          y = v(1,*)
          info.yoffset(info.isel) = info.yoffset(info.isel) + $
            (y(1)-y(0))

          widget_control,info.log,/append,set_value= $
            info.title(info.isel)+': Yoffset =  '+ $
            strtrim(info.yoffset(info.isel),2)
          ze_lineplot_plot,info,xarray,yarray
          ze_lineplot_annotate,info
        end
      end

      if info.state eq 'XOFFSET1' then begin
        plots,[xd,xd],[0,450],color=1,/dev
        if (event.press eq 1) then begin
          info.y1 = yd
          info.x1 = xd
          wset,info.plot2_id
          erase
          xyouts,10,150,/dev,'Position at new X and', $
            charsize=1.4,charthick=2,color=1
          xyouts,10,110,/dev,'push left mouse button', $
            charsize=1.4,charthick=2,color=1
          info.state = 'XOFFSET2'
        end
        return
      endif

      if info.state eq 'XOFFSET2' then begin
        x = [info.x1,xd]
        y = [info.y1,yd]
        plots,[x(0),x(0)],[0,450],/dev,color=1,line=1
        plots,[x(1),x(1)],[0,450],/dev,color=1
        if (event.press eq 1) then begin
          !x = info.xsave
          !y = info.ysave
          v = convert_coord(x,y,/dev,/to_data)
          x = v(0,*)
          deltax = x(1)-x(0)
          widget_control,info.rest_base,get_value=wrest
          if wrest(0) ne 0 then $
            deltax = deltax * wrest(0)/2.997925E5

          info.xoffset(info.isel) = info.xoffset(info.isel) + $
            deltax

          widget_control,info.log,/append,set_value= $
            info.title(info.isel)+': Xoffset =  '+ $
            strtrim(info.xoffset(info.isel),2)
          if wrest(0) ne 0 then begin
            deltav = info.yoffset(info.isel)*2.997925E5/wrest(0)
            widget_control,info.log,/append,set_value= $
              '        Velocity Offset =  '+ $
              strtrim(deltav,2)
          end
          ze_lineplot_plot,info,xarray,yarray
          ze_lineplot_annotate,info
        end
      end

      if (info.state eq 'ZOOM2') then begin
        x = [info.x1,xd]
        y = [info.y1,yd]
        plots,[x(0),x(1),x(1),x(0),x(0)], $
          [y(0),y(0),y(1),y(1),y(0)],/dev,color=1

        if (event.release eq 2) or (event.press eq 1) then begin
          !x = info.xsave
          !y = info.ysave
          v = convert_coord(x,y,/dev,/to_data)
          x = v(0,*)
          y = v(1,*)
          widget_control,info.xmin_base,set_value = min(x)
          widget_control,info.xmax_base,set_value = max(x)
          widget_control,info.ymin_base,set_value = min(y)
          widget_control,info.ymax_base,set_value = max(y)
          ze_lineplot_plot,info,xarray,yarray
          ze_lineplot_annotate,info
          return
        end
      end

    end
    'PLOT2':
    'YOFF': ze_lineplot_plot,info,xarray,yarray
    else:
  endcase
  return
end
;=========================================================== ze_lineplot_SELECT
;
; Select which vector to use
;
pro ze_lineplot_select,info,title,isel,group=group

  n = info.n
  if info.n eq 1 then begin
    isel = 0
    return
  end

  main = widget_base(/col,title=title,xsize=400,/modal,group=group)
  buttons = lonarr(n)
  for i=0,n-1 do buttons(i) = $
    widget_button(main,value = 'PLOT '+strtrim(i+1,2)+': '+ $
    info.title(i))

  widget_control,main,/realize
  ptr = ptr_new({buttons:buttons,isel:0})
  widget_control,main,set_uvalue=ptr
  xmanager,'ze_lineplot_select',main
  isel = (*ptr).isel
  ptr_free,ptr
  return
end
pro ze_lineplot_select_event,event
  widget_control,event.top,get_uvalue=ptr
  good = where((*ptr).buttons eq event.id)
  (*ptr).isel = good(0)
  widget_control,event.top,/destroy
  return
end
;============================================================ ze_lineplot_PLOT
;
; Routine to generate the plot
;
pro ze_lineplot_plot,info,xarray,yarray,ps=ps

  if not keyword_set(ps) then begin
    wset,info.plot1_id
    set_viewport,0.1,0.9,0.1,0.9
  end
  widget_control,info.xmin_base,get_value=xmin
  widget_control,info.xmax_base,get_value=xmax
  widget_control,info.ymin_base,get_value=ymin
  widget_control,info.ymax_base,get_value=ymax
  widget_control,info.yoff_base,get_value=yoff
  widget_control,info.nsmooth_base,get_value=nsmooth
  widget_control,info.rest_base,get_value=wrest
  info.restwave = wrest
  if wrest ne 0 then xtitle='Velocity (km/sec)  Rest Wavelength = ' + $
    strtrim(string(wrest(0),'(F10.3)'),2) $
  else xtitle=info.xtitle
  if keyword_set(ps) then xthick=4 else xthick=1
  if keyword_set(ps) then ythick=4 else ythick=1
  if keyword_set(ps) then thick=2.5 else thick=1

  cgplot,[xmin,xmax],[ymin,ymax],/nodata,ytitle=info.ytitle, $
    xtitle=xtitle,title=info.ptitle,xstyle=1,ystyle=1, $
    xlog=info.xlog,ylog=info.ylog,color=1,xrange=[xmin,xmax], $
    yrange =[ymin,ymax],xthick=xthick,ythick=ythick,thick=thick
  i1 = 0
  colors=['black','red','cyan','green','blue','orange','brown','magenta','dark green','purple']
  for i=0,info.n-1 do begin
    i2 = i1+info.ns(i)-1
    yy = yarray(i1:i2)*info.yscale(i) + info.yoffset(i)
    xx = xarray(i1:i2) + info.xoffset(i)
    if wrest ne 0 then xx = (xx-wrest(0))/wrest(0)*2.997925e5
    if nsmooth gt 1 then yy = smooth(yy,nsmooth)
    oplot,xx,yy+yoff*i, $
      color=fsc_color(colors[i]),psym=info.psym(i), $
      line=info.linestyle(i),thick=thick, $
      symsize=info.symsize(i),nsum=info.nsum(i), $
      min_val = info.min_val(i)+yoff*i, $
      max_val = info.max_val(i)+yoff*i
    i1  = i2+1
  end
  if info.ylog ne 1 then oplot,!x.crange,[0,0],line=2,color=1
  info.xsave = !x
  info.ysave = !y
  xrange = !x.crange
  if info.xlog then xrange = 10^xrange
  yrange = !y.crange
  if info.ylog then yrange = 10^yrange
  widget_control,info.xmin_base,set_value=xrange(0)
  widget_control,info.xmax_base,set_value=xrange(1)
  widget_control,info.ymin_base,set_value=yrange(0)
  widget_control,info.ymax_base,set_value=yrange(1)
  if not keyword_set(ps) then begin
    wset,info.pixid
    device,copy=[0,0,950,450,0,0,info.plot1_id]
  end
  info.state = 'X/Y'
  return
end

;============================================================ ze_lineplot8_PLOT
;
; Routine to generate the plot
;
pro ze_lineplot8_plot,info,xarray,yarray,plotwindow,ps=ps,buffer_val=buffer_val

  if  keyword_set(buffer_val) then buffer=1 else buffer=0  
  ;info.plot1_id.Select
  set_viewport,0.1,0.9,0.1,0.9
  widget_control,info.xmin_base,get_value=xmin
  widget_control,info.xmax_base,get_value=xmax
  widget_control,info.ymin_base,get_value=ymin
  widget_control,info.ymax_base,get_value=ymax
  widget_control,info.yoff_base,get_value=yoff
  widget_control,info.nsmooth_base,get_value=nsmooth
  widget_control,info.rest_base,get_value=wrest
  info.restwave = wrest
  if wrest ne 0 then xtitle='Velocity (km/sec)  Rest Wavelength = ' + $
    strtrim(string(wrest(0),'(F10.3)'),2) $
  else xtitle=info.xtitle

  plotwindow=plot(xarray,yarray,xrange=[xmin,xmax],yrange=[ymin,ymax],ytitle=info.ytitle, $
    xtitle=xtitle,title=info.ptitle,thick=thick,/NODATA,DIM=[950,450],POSITION=[0.12,0.14,0.95,0.96],buffer=buffer)
  i1 = 0
  colors=['black','red','deep sky blue','green','blue','orange','brown','magenta','dark green','purple']
  for i=0,info.n-1 do begin
    i2 = i1+info.ns(i)-1
    yy = yarray(i1:i2)*info.yscale(i) + info.yoffset(i)
    xx = xarray(i1:i2) + info.xoffset(i)
    if wrest ne 0 then xx = (xx-wrest(0))/wrest(0)*2.997925e5
    if nsmooth gt 1 then yy = smooth(yy,nsmooth)
    p2=plot(xx,yy+yoff*i, $
      color=colors[i],symbol=info.psym(i), $
      linestyle=info.linestyle(i),thick=thick, $
      sym_size=info.symsize(i),/OVERPLOT,buffer=buffer)
    i1  = i2+1
  end
  if info.ylog ne 1 then begin
    ;p3=plot(!x.crange,[0,0],line=2,color=1)
  endif
  info.xsave = !x
  info.ysave = !y
  xrange = plotwindow.xrange
  if info.xlog then xrange = 10^xrange
  yrange = plotwindow.yrange
  if info.ylog then yrange = 10^yrange
  widget_control,info.xmin_base,set_value=xrange(0)
  widget_control,info.xmax_base,set_value=xrange(1)
  widget_control,info.ymin_base,set_value=yrange(0)
  widget_control,info.ymax_base,set_value=yrange(1)


  ;info.pixid.Select
  ;  device,copy=[0,0,950,450,0,0,info.plot1_id]

  info.state = 'X/Y'
  return
end
;============================================================= ze_lineplot_ANNOTATE
;
; Routine to fill annotation box
;
pro ze_lineplot_annotate,info,ps=ps
  colors=['black','red','cyan','green','blue','orange','brown','magenta','dark green','purple']
  if keyword_set(ps) then begin
    set_viewport,0,1.0,0,1.0
    y1 = 0.92
    dy = 0.027
    x = [0.2,0.3,0.33]
    charsize = 1.0
  end else begin
    y1 = 0.93
    dy = 0.09
    x = [0.05,0.14,0.18]
    charsize = 1.25
    wset,info.plot2_id
    erase
  end
  for i=0,info.n-1 do begin
    psym = info.psym(i)
    if psym eq 10 then psym=0
    cgplots,x(0:1),[y1,y1]-i*dy,psym=psym,color=colors[i], $
      line=info.linestyle(i),thick=info.thick(i), $
      symsize=info.symsize(i),/norm
    xyouts,x(2),y1-dy*0.25-i*dy,info.title(i),/norm,color=fsc_color('white'), $
      charsize=charsize

  end
  return
end

;=========================================================== ze_lineplot_PLOTPAR
;
; Routine to adjust the plotting parameters
;
pro ze_lineplot_plotpar,group=group
  common ze_lineplot_common,info,xarray,yarray,r,g,b,rsave,gsave,bsave

  ;
  ; if already active, return
  ;
  if xregistered('ze_lineplot_plotpar') then return
  ;
  ; set up widget layout
  ;

  mainbase = widget_base(/col,title='Plot Parameter Adjustment', $
    group=group)
  button = widget_button(mainbase,uvalue='DONE',value='Done')
  basex = widget_base(mainbase,/row)
  plot_select = cw_bgroup(basex,info.title+' ', $
    /col,set_value=0,uvalue='PLOT_SELECT', $
    /exclusive)
  base = widget_base(basex,/col,/frame)
  window = widget_draw(base,xsize=300,ysize=50)
  ;
  ; color sliders
  ;
  red_slider = widget_slider(base,min=0,max=255,/drag,uvalue='RED', $
    title='Red',value=0,xsize=280)
  green_slider = widget_slider(base,min=0,max=255,/drag,uvalue='GREEN', $
    title='Green',value=0,xsize=280)
  blue_slider = widget_slider(base,min=0,max=255,/drag,uvalue='BLUE', $
    title='Blue',value=0,xsize=280)
  ;
  ; linestype
  ;
  base1 = widget_base(base,/row)
  label = widget_label(base1,value='Linestyle',xsize=80,/align_left)
  linestyle = widget_droplist(base1,uvalue='LINESTYLE', $
    value=['Solid','Dotted','Short Dash','Dash Dot Dash', $
    'Dash Dot Dot Dot Dash','Long Dash'])
  widget_control,linestyle,set_droplist_select=0
  ;
  ; Psym
  ;
  base2 = widget_base(base,/row)
  label = widget_label(base2,value='Psym',xsize=80,/align_left)
  psym = widget_droplist(base2,uvalue='PSYM', $
    value =["Connected X's","Connected Squares", $
    "Connected Triangles","Connected Diamonds", $
    "Connected Asterisks","Connected Plus Signs", $
    "No Symbol","Plus Signs","Asterisks","Dots", $
    "Diamonds","Triangles","Sqaures","X's","Histogram"])
  psyms = [-7,-6,-5,-4,-2,-1,0,1,2,3,4,5,6,7,10]
  ;
  ; Psymsize, pthick
  ;
  size_field = cw_field(base,uvalue='SIZE_FIELD',xsize=8, $
    value=0, $
    /float,title='Symsize       ',/return_events)

  thick_field = cw_field(base,uvalue='THICK_FIELD',xsize=8, $
    value=0, $
    /float,title='Line Thickness',/return_events)
  nsum_field = cw_field(base,uvalue='NSUM',value=1,/long, $
    xsize=5,title='NSUM',/return_events)
  button = widget_button(base,uvalue='APPLY',value='APPLY')
  ;
  ; create and run the widget
  ;

  widget_control,mainbase,/realize
  widget_control,window,get_value=window_id
  base = {window_id:window_id, red_slider:red_slider, $
    green_slider:green_slider,blue_slider:blue_slider, $
    linestyle:linestyle,psym:psym,size_field:size_field, $
    thick_field:thick_field, $
    plot_select:plot_select,nsum_field:nsum_field}
  point = ptr_new({base:base})
  widget_control,mainbase,set_uvalue=point
  ze_lineplot_plotpar_set,base,info,r,g,b
  xmanager,'ze_lineplot_plotpar',mainbase,/no_block

  return
end

pro ze_lineplot_plotpar_event,event
  common ze_lineplot_common,info,xarray,yarray,r,g,b,rsave,gsave,bsave

  widget_control,event.id,get_uvalue=uvalue
  widget_control,event.top,get_uvalue=point
  base = (*point).base
  widget_control,base.plot_select,get_value=i ;current selection
  apply = 0

  case uvalue of
    'DONE': begin
      ze_lineplot_plot,info,xarray,yarray
      ze_lineplot_annotate,info
      if ptr_valid(point) then ptr_free,point
      widget_control,event.top,/destroy
      return
    end
    'PLOT_SELECT': begin
      if event.select eq 1 then begin
        ze_lineplot_plotpar_set,base,info,r,g,b
        return
      end
    end
    'RED': r(i+2) = event.value
    'BLUE': b(i+2) = event.value
    'GREEN': g(i+2) = event.value
    'LINESTYLE': info.linestyle(i) = event.index
    'PSYM': begin
      psyms = [-7,-6,-5,-4,-2,-1,0,1,2,3,4,5,6,7,10]
      info.psym(i) = psyms(event.index)
    end
    'APPLY': apply = 1

    else:
  endcase

  widget_control,base.thick_field,get_value=v
  info.thick(i) = v
  widget_control,base.size_field,get_value=v
  info.symsize(i) = v
  widget_control,base.nsum_field,get_value=v
  info.nsum(i) = v

  ze_lineplot_plotpar_set,base,info,r,g,b
  if apply then begin
    ze_lineplot_plot,info,xarray,yarray
    ze_lineplot_annotate,info
  endif

  return
end
;======================================================== ze_lineplot_PLOTPAR_SET
;
; Routine to set plot paramters for the selected plot
;
pro ze_lineplot_plotpar_set,base,info,red,green,blue

  widget_control,base.plot_select,get_value=isel
  widget_control,base.red_slider,set_value=red(isel+2)
  widget_control,base.green_slider,set_value=green(isel+2)
  widget_control,base.blue_slider,set_value=blue(isel+2)
  widget_control,base.linestyle,set_droplist_select=info.linestyle(isel)
  psyms = [-7,-6,-5,-4,-2,-1,0,1,2,3,4,5,6,7,10]
  good = where(psyms eq info.psym(isel))
  widget_control,base.psym,set_droplist_select=good(0)
  widget_control,base.size_field,set_value=info.symsize(isel)
  widget_control,base.thick_field,set_value=info.thick(isel)
  widget_control,base.nsum_field,set_value=info.nsum(isel)
  ;
  ; update plot
  ;
  wset,base.window_id
  erase
  tvlct,red,green,blue
  ps = info.psym(isel)
  if ps eq 10 then ps=0
  plots,indgen(11)*30,replicate(25,11),/dev,psym=ps, $
    color=isel+2,line=info.linestyle(isel),thick=info.thick(isel), $
    symsize = info.symsize(isel)

  return
end
;=============================================================== ze_lineplot_GFIT
;
; Gaussian Fit Routine for line plot
;
pro ze_lineplot_gfit,info,xarray,yarray,type,group=group
  ;
  ; Extract data region to fit
  ;
  ze_lineplot_select,info,'Select Which Plot to FIT',isel,group=group
  ze_lineplot_plot,info,xarray,yarray
  if isel ne 0 then i1 = round(total(info.ns(0:isel-1))) $
  else i1 = 0
  i2 = i1 + info.ns(isel)-1
  x = xarray(i1:i2) + info.xoffset(isel)
  y = yarray(i1:i2)*info.yscale(isel) + info.yoffset(isel)
  xrange = info.xsave.crange
  widget_control,info.rest_base,get_value=wrest
  if wrest ne 0 then x = (x-wrest)/wrest*2.997925e5
  good = where((x ge xrange(0)) and (x le xrange(1)),n)
  good = where((x ge xrange(0)) and (x le xrange(1)),n)
  if n eq 0 then begin
    widget_control,info.log,set_v='No Points found in Xrange'
    return
  end
  x = double(x(good))
  y = double(y(good))
  widget_control,info.yoff_base,get_v=yoffset
  yoffset = yoffset*isel
  ;
  ; emission or absorption
  ;
  widget_control,info.log,/append,set_v=' '
  widget_control,info.log,/append,set_v='-----  Gaussian Fit'
  widget_control,info.log,/append,set_v=info.title(isel)
  widget_control,info.log,/append,set_v='Xrange = '+strtrim(min(x),'2')+ $
    ' to '+strtrim(max(x),2)
  if type le 3 then begin
    ymax = max(y)
    yy = y/ymax
    fit = gaussfit(x,yy,a,nterms=2+type)  ;peak,center,sigma
    fit = fit*ymax
    a(0) = a(0)*ymax
    a = [a,fltarr(3)]
    gcoef = a(0:2)
    bcoef = a(3:5)*ymax

    baseline = a(3) + a(4)*a(1) + a(5)*a(1)*a(1) ;baseline at peak
    wset,info.plot1_id
    oplot,x,fit+yoffset,thick=2,color=1
  endif

  if type eq 4 then begin
    title = info.title(isel)
    if wrest gt 0 then title=title+'  Wrest = '+strtrim(wrest,2)
    xgaussfit,x,y,bcoef,gcoef,fit,title=title
    bcoef = [bcoef,fltarr(2)]
  endif

  n = n_elements(gcoef)/3
  if n gt 0 then begin
    for i=0,n-1 do begin
      center = gcoef(1,i)
      peak = gcoef(0,i)
      fwhm = gcoef(2,i)*2.3548
      baseline = bcoef(0) + bcoef(1)*center + bcoef(2)*center*center
      eqwidth = -peak/baseline*gcoef(2,i)*sqrt(2.0*!pi)
      widget_control,info.log,/append,set_v='  '
      widget_control,info.log,/append,set_v='  Center = '+ $
        strtrim(center,2)
      widget_control,info.log,/append,set_v='  Peak  = '+ $
        strtrim(peak,2)
      widget_control,info.log,/append,set_v='  FWHM = '+ $
        strtrim(fwhm,2)
      widget_control,info.log,/append,set_v='  EqWidth = '+ $
        strtrim(eqwidth,2)
    end
  end

  wset,info.pixid
  device,copy=[0,0,950,450,0,0,info.plot1_id]
  return
end

;========================================================== ze_lineplot_EQWIDTH
;
; Gaussian Fit Routine for line plot
;
pro ze_lineplot_eqwidth,info,xarray,yarray,group=group
  ;
  ; Extract data region to fit
  ;
  ze_lineplot_select,info,'Select Which Plot to FIT',isel,group=group
  ze_lineplot_plot,info,xarray,yarray
  if isel ne 0 then i1 = round(total(info.ns(0:isel-1))) $
  else i1 = 0
  i2 = i1 + info.ns(isel)-1
  x = xarray(i1:i2) + info.xoffset(isel)
  y = yarray(i1:i2)*info.yscale(isel) + info.yoffset(isel)
  xrange = info.xsave.crange
  widget_control,info.rest_base,get_value=wrest
  if wrest ne 0 then xrange = xrange/2.997925e5*wrest+wrest
  good = where((x ge xrange(0)) and (x le xrange(1)),n)
  if n eq 0 then begin
    widget_control,info.log,set_v='No Points found in Xrange'
    return
  end
  x = double(x(good))
  y = double(y(good))
  ;
  ; call Eqwidth widget
  ;

  if wrest eq 0 then wrest = avg(x)
  line_eqwidth,x,y,wrest=wrest,res, group=group,/modal
  if res(12) eq 0.0 then return
  widget_control,info.log,/append,set_v='  '
  widget_control,info.log,/append,set_v='  Wtot = '+ strtrim(res(14),2)
  widget_control,info.log,/append,set_v='  Fcont = '+ strtrim(res(10),2)
  widget_control,info.log,/append,set_v='  EqWidth = '+ strtrim(res(12),2)
  return
end

;==================================================================== ze_lineplot
;
; Plot widget main routine

pro ze_lineplot,xin,yin,title=title,xtitle=xtitle,ytitle=ytitle, $
  ptitle=ptitle,group=group,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val,xoffset=xoffset, yscale=yscale, $
  yoffset = yoffset,wrest=wrest,$
  linestyle1=linestyle1,linestyle2=linestyle2,linestyle3=linestyle3,linestyle4=linestyle4,linestyle5=linestyle5,$
  linestyle6=linestyle6,linestyle7=linestyle7,linestyle8=linestyle8,linestyle9=linestyle9,linestyle_10=linestyle_10,$
  psym1=psym1,psym2=psym2,psym3=psym3,psym4=psym4,psym5=psym5,$
  psym6=psym6,psym7=psym7,psym8=psym8,psym9=psym9,psym_10=psym_10

  common ze_lineplot_common,info,xarray,yarray,r,g,b,rsave,gsave,bsave
  ;
  ; calling sequence
  ;
  if n_params(0) lt 1 then begin
    print,'CALLING SEQUENCE:  ze_lineplot,x,y
    print,'Keyword INPUTS: title,xtitle,ytitle,ptitle,xrange,yrange,linestyle1,linestyle2,...linestyle_10, psym1,psym2,...,psym_10
    return
  end


  if n_elements(title) eq 0 then title=''
  if n_elements(xtitle) eq 0 then xtitle=''
  if n_elements(ytitle) eq 0 then ytitle=''
  if n_elements(ptitle) eq 0 then ptitle=''
  if n_elements(xoffset) eq 0 then xoffset = 0.0
  if n_elements(yoffset) eq 0 then yoffset = 0.0
  if n_elements(yscale) eq 0 then yscale = 1.0
  if n_elements(wrest) eq 0 then wrest = 0.0
  if n_elements(linestyle1) gt 0 then linestyle=intarr(10)
  if n_elements(linestyle1) gt 0 then linestyle[0]=linestyle1 &   if n_elements(linestyle2) gt 0 then linestyle[1]=linestyle2 &  if n_elements(linestyle3) gt 0 then linestyle[2]=linestyle3
  if n_elements(linestyle4) gt 0 then linestyle[3]=linestyle4 &   if n_elements(linestyle5) gt 0 then linestyle[4]=linestyle5 &  if n_elements(linestyle6) gt 0 then linestyle[5]=linestyle6
  if n_elements(linestyle7) gt 0 then linestyle[6]=linestyle7 &   if n_elements(linestyle8) gt 0 then linestyle[7]=linestyle8 &  if n_elements(linestyle9) gt 0 then linestyle[8]=linestyle9  & if n_elements(linestyle_10) gt 0 then linestyle[9]=linestyle_10
  if n_elements(linestyle) eq 0 then linestyle=intarr(10)
  if n_elements(psym1) gt 0 then psym=intarr(10)
  if n_elements(psym1) gt 0 then psym[0]=psym1 &   if n_elements(psym2) gt 0 then psym[1]=psym2 &  if n_elements(psym3) gt 0 then psym[2]=psym3
  if n_elements(psym4) gt 0 then psym[3]=psym4 &   if n_elements(psym5) gt 0 then psym[4]=psym5 &  if n_elements(psym6) gt 0 then psym[5]=psym6
  if n_elements(psym7) gt 0 then psym[6]=psym7 &   if n_elements(psym8) gt 0 then psym[7]=psym8 &  if n_elements(psym9) gt 0 then psym[8]=psym9  & if n_elements(psym_10) gt 0 then psym[9]=psym_10
  if n_elements(psym) eq 0 then psym=intarr(10)



  if n_params(0) eq 1 then begin
    y = xin
    x = findgen(n_elements(xin))
  end else begin
    x = xin
    y = yin
  end
  ;
  ; add new x and y to common block
  ;
  ns = n_elements(x)
  if xregistered('ze_lineplot') then begin
    if info.n eq 10 then return
    if n_elements(xrange) gt 0 then begin
      widget_control,info.xmin_base,set_v=xrange(0)
      widget_control,info.xmax_base,set_v=xrange(1)
    end
    if n_elements(yrange) gt 0 then begin
      widget_control,info.ymin_base,set_v=yrange(0)
      widget_control,info.ymax_base,set_v=yrange(1)
    end
    xarray = [xarray,x]
    yarray = [yarray,y(0:ns-1)]
    info.ns(info.n) = ns
    info.title(info.n) = title
    if n_elements(min_val) gt 0 then info.min_val(info.n) = min_val
    if n_elements(max_val) gt 0 then info.max_val(info.n) = max_val
    info.xoffset(info.n) = xoffset
    info.yscale(info.n) = yscale
    info.yoffset(info.n) = yoffset
    widget_control,info.log,/append,set_v=title
    info.n = info.n + 1
    if xtitle ne '' then info.xtitle=xtitle
    if ytitle ne '' then info.ytitle=ytitle
    if ptitle ne '' then begin
      info.ptitle=ptitle
      widget_control,info.log,/append,set_v=ptitle
    end
    ze_lineplot_plot,info,xarray,yarray
    ze_lineplot_annotate,info

    return
  endif
  ;
  ; initilization
  ;
  xarray = x
  yarray = y
  tvlct,r,g,b,/get
  rsave = r
  gsave = g
  bsave = b
  r(0) = [255,0,0,255,255,  0,  0,180,240, 75,110,150]
  g(0) = [255,0,0,  0,  0,220,  0, 80,140,180,110,120]
  b(0) = [255,0,0,255,  0,  0,255,180,100, 40,185,150]
  tvlct,r,g,b

  main = widget_base(/col,group=group,/tracking,uvalue='MAIN')
  menu = widget_base(main,/row,/frame)
  exit = widget_button(menu,value='EXIT',uvalue='EXIT')
  plot = widget_button(menu,value='PLOT',uvalue='PLOT')
  savepdf = widget_button(menu,value='SAVEPDF',uvalue='SAVEPDF')
  desc = ['1\Write','0\Postscript File','0\ASCII Table','0\FITS Table', $
    '0\All data to FITS Table','2\Log File']
  button = cw_pdmenu(menu,desc,uvalue='WRITE',/return_full_name)
  button = widget_button(menu,uvalue='UNZOOM_ALL',value='UnZoom All')
  unzoom = widget_button(menu,uvalue='UNZOOM',value='UnZoom')
  zoom = widget_button(menu,uvalue='ZOOM',value='Zoom')
  button = widget_button(menu,uvalue='LINESTYLES',value='Linestyles')
  xbutton = widget_button(menu,uvalue='XLOG',value='X Log     ')
  ybutton = widget_button(menu,uvalue='YLOG',value='Y Log     ')
  desc = ['1\GAUSSFIT','0\No Baseline','0\Constant Baseline', $
    '0\Linear Baseline','2\Interactive/Multiple']
  button = cw_pdmenu(menu,desc,uvalue='GAUSSFIT')
  button = widget_button(menu,uvalue='EQWIDTH',value='EqWidth')
  rest_base = cw_field(menu,/row,uvalue='RESTWAVE',value=wrest, $
    title='Rest Wave: ',xsize=15,/return_events,/float)

  menu = widget_base(main,/row,/frame)
  button = widget_button(menu,uvalue='XOFFSET',value='Xoffset')
  button = widget_button(menu,uvalue='YSCALE',value='Yscale')
  button = widget_button(menu,uvalue='YOFFSET',value='Yoffset')
  ;
  ; draw window 1
  ;
  base1 = widget_base(main,/row)
  plot1 = widget_draw(base1,uvalue='PLOT1',retain=2, $
    xsize=950,ysize=450,/button_events,/motion)
  ;
  ; draw window 2
  ;
  base = widget_base(main,/row)
  !P.Background=fsc_color('white')
  plot2 = widget_draw(base,xsize=400,ysize=200,/button_events, $
    uvalue='PLOT2',/motion)
  log = widget_text(base,xsize=35,ysize=8,/scroll,uvalue='MESSAGE',/edit)
  basex = widget_base(base,/col)
  xmin_base = cw_field(basex,/row,uvalue='RANGE',value=min(x), $
    title='X Min: ',xsize=13,/return_events,/float)
  xmax_base = cw_field(basex,/row,uvalue='RANGE',value=max(x), $
    title='X Max: ',xsize=13,/return_events,/float)
  ymin_base = cw_field(basex,/row,uvalue='RANGE',value=min(y), $
    title='Y Min: ',xsize=13,/return_events,/float)
  ymax_base = cw_field(basex,/row,uvalue='RANGE',value=max(y), $
    title='Y Max: ',xsize=13,/return_events,/float)
  yoff_base = cw_field(basex,/row,uvalue='YOFF',value=0.0, $
    title='Y Offsets:',xsize=11,/return_events,/float)
  nsmooth_base = cw_field(basex,/row,uvalue='NSMOOTH',value=1, $
    title='N Smooth:',xsize=11,/return_events,/integer)
  ;
  ; create pixmap
  ;

  window,xs=950,ys=450,/pixmap,/free
  pixid = !d.window
  ;
  ; save widget info in structure
  ;
  widget_control,main,/realize
  widget_control,plot1,get_value=plot1_id
  widget_control,plot2,get_value=plot2_id
  ns = lonarr(10)
  ns(0) = n_elements(x)

  info = {n:1,ns:ns,psym:psym,thick:intarr(10), $
    symsize:replicate(1.0,10),linestyle:linestyle, $
    pixid:pixid,title:strarr(10),xtitle:xtitle, $
    ytitle:ytitle,ptitle:ptitle,plot1:plot1,yoff_base:yoff_base, $
    main:main,log:log,plot2:plot2,xmin:min(x),ymin:min(y), $
    xmax:max(x),ymax:max(y),xlog:0,ylog:0,xmin_base:xmin_base, $
    ymin_base:ymin_base,xmax_base:xmax_base,ymax_base:ymax_base, $
    xsave:!x,ysave:!y,state:'X/Y',xbutton:xbutton,ybutton:ybutton, $
    x1:0, y1:0, plot1_id:plot1_id,plot2_id:plot2_id, $
    nsum:intarr(10),min_val:replicate(-1e37,10), $
    max_val:replicate(1e37,10),nsmooth_base:nsmooth_base, $
    yscale:replicate(1.0,10),xoffset:fltarr(10),yoffset:fltarr(10), $
    isel:0, rest_base:rest_base, restwave:0.0d0}
  if n_elements(min_val) gt 0 then info.min_val(0) = min_val
  if n_elements(max_val) gt 0 then info.max_val(0) = max_val
  info.xoffset(0) = xoffset
  info.yoffset(0) = yoffset
  info.yscale(0) = yscale
  info.title(0) = title
  ;
  ; set initial range
  ;
  if wrest ne 0 then begin
    minx = (min(x)-wrest) * 2.997925e5/wrest
    maxx = (max(x)-wrest) * 2.997925e5/wrest
    widget_control,info.xmin_base,set_value = minx
    widget_control,info.xmax_base,set_value = maxx
  end
  if n_elements(xrange) gt 0 then begin
    widget_control,info.xmin_base,set_v=xrange(0)
    widget_control,info.xmax_base,set_v=xrange(1)
  end
  if n_elements(yrange) gt 0 then begin
    widget_control,info.ymin_base,set_v=yrange(0)
    widget_control,info.ymax_base,set_v=yrange(1)
  end

  widget_control,info.log,/append,set_v=ptitle
  widget_control,info.log,/append,set_v=info.title(0)
  ze_lineplot_plot,info,xarray,yarray
  ze_lineplot_annotate,info
  xmanager,'ze_lineplot',main,/no_block
  return
end
