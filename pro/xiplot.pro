;PRO xiplot, infile, data, outfile, WMIN=wmin_0, WMAX=wmax_0,$
;                                   FMIN=fmin_0, FMAX=fmax_0,$
;                                   ASCII=ascii, $
;                                   New_Continuum=new_continuum
;+
; NAME:
;	XIPLOT 2.17
;
; PURPOSE:
;	This procedure plots flux vs wavelength from a FUSE calibrated
;       spectrum or ASCII file.
;       The program allows to use widget to write output into an ascii file.
;       Plots can be done in window, printer and postscript files.
;
; CATEGORY:
;	Widgets
;
; CALLING SEQUENCE:
;	XIPLOT [, Infile, Data, Outfile, WMIN=wmin, WMAX=wmax,$
;                                        FMIN=fmin, FMAX=fmax,$
;                                        ASCII=ascii,$
;                                        /New_Continuum ]
;
; OPTIONAL INPUTS:
;	Infile:	Name of a calibrated FUSE spectrum file.  
;		This is expected to be a binary FITS table with data columns
;	
; KEYWORD PARAMETERS:
;            WMIN:  minimum wavelength for the first plot
;            WMAX:  maximum wavelength for the first plot
;            FMIN:  minimum flux for the first plot
;            FMAX:  maximum flux for the first plot
;           ASCII:  name of an ASCII input file to be read
;   New_Continuum:  Force the new convention of continuum for (owens')Fit Plotting
;    
; OPTIONAL OUTPUTS:
;       Data:  A structure containing the data of the last plot
;	Outfile: Name of an ASCII file 
;                 in which the selected columns are writen
;
; SIDE EFFECTS:
;	infile, data and outfile are updated by the value of the last plot.
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;          idl> xiplot
;       or
;          idl> xiplot,'I80101050011alif4ttagfcal.fit',data
;
; MODIFICATION HISTORY:
;
; 	Procedure iplot written by Bill Oegerle, 27 May 1999.
;	Widget functions by Alain Lecavelier, November 13, 1999
;       Add functions by Alain Lecavelier, December 13, 1999
;       Version 2.0 by Alain Lecavelier, April 6, 2000
;       Version 2.1 (Add Expo) by Alain Lecavelier, Mai 12, 2000
;       Fixed BUG on error estimate, Mai 18, 2000
;       Fixed BUG on AddExpo with pixels with f=0, Mai 30, 2000
;       Color Version 2.2 by Guillaume HŽbrard, Juin 5, 2000
;       Fixed BUG on rebin since Mai 18 version. by Martin Lemoine Juin 6, 2000
;       Version 2.2 (New Add Expo) by Jean-Michel Desert, juin 16 2000
;	Set error to 1 photon when 0 photon detected, juillet 18, 2000
;	Shift, Resample & Add by Jean-Michel Desert, August 7, 2000
;       Version 2.3, Small window size for laptop screens, October 14, 2000
;       Fixed bugs on conversion micron-angstroms October 20, 2000
;       Compatibility with owens new features (Double gauss, Angstrom,
;                                              Continuum) December 22, 2000
;       Output Continuum in Ascii File, January 2, 2001
;	Fixed bug: Add Background level to continuum, January 3, 2001
;       Fixed bug for continuum with 14th degree polynomial, February 19, 2001
;       New buttons for Select Window, February 20, 2001
;       Read LSF table in Plot Fit, Martin Lemoine, March 6, 2001
;       User-defined parameters for Add_Expo_Resample, March 22, 2001
;       Improved speed for Plot Fit, March 27, 2001
;       New output : 'All lines' of Plot Fit, March 27, 2001
;       Procedure to Cross-correlate Plot and Overplot, March 28, 2001
;       Confirmation if ASCII created file overwritte an existing file, June 1
;       Updates for IDL5.4:N_Tag in Scrolling & xtickformat by Martial Andre January 23, 2002
;       Find Lines, February 30, 2002
;       More robust procedure for Add_expo, April 8, 2002
;       Fix few bugs (Equivalent widths), March 15, 2004
;       Improve efficiency of initialization of Plot_fit, March 15, 2004
;       Fix ndata = (size of structure data) for Pipeline 3.0, July 7, 2004
;       Fix n_data in Add_Expo for Pipeline 3.0, April 15, 2005
;       Add HD in Find_Line, May 13, 2005 
;       Color for Linux, May 25, 2005
;       Fixed bug with CalFUSE 3.0 for add_expo per photons, Septembre 7, 2005
;                       (change of the counts column content)
;       Add of CH in element lists. May 10, 2006

PRO MAIN_Event, Event

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax


  COMMON FIELD_DataFile_Comm,  FIELD_DataFile  ; Data file field  : infilename 
  COMMON FIELD_OplotFile_Comm,  FIELD_OplotFile ; Oplot file field  : overname 
  COMMON FIELD_AsciiFile_Comm, FIELD_AsciiFile ; Ascii file field : outfilename
  COMMON FIELD_PlotFile_Comm,  FIELD_PlotFile  ; Plot file field  : plotname
  COMMON FIELD_ShiftFile_Comm,  FIELD_ShiftFile  ; Shift File Field  : shiftfile

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider

  COMMON TEXTID,TEXT_Click,TEXT_INFO
  COMMON LOCK_UNLOCK,BUTTON_LOCK,BUTTON_UNLOCK
  COMMON Fmin_max_info,fmin,fmax
  COMMON Wminmax_Comm,wmin_or_max,Wmin_next  ; flag for click on Wmin or Wmax.
  COMMON Fminmax_Comm,fmin_or_max,Fmin_next  ; flag for click on Fmin or Fmax.

  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

  COMMON DRAW_LARGE_Comm, DRAW_LARGE_Id
  COMMON DRAW_SMALL_Comm, DRAW_SMALL_Id,Vx_4,X0_4,X1_4,button_pressed

  COMMON SLIDE_BUTTON,left,right,left_id,right_id

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
  COMMON BASE_OverPlot_Comm, BASE_OverPlot
  COMMON BASE_Select_Window_Comm, BASE_Select_Window
  COMMON Select_Window_Status_Comm, Select_Window_on
  COMMON BASE_Find_Lines_Comm, BASE_Find_Lines
  COMMON Find_lines_Status_Comm,Find_Lines_on
  COMMON BASE_AddExpo_Comm, BASE_AddExpo
  COMMON ADDEXPO_Comm,addexpo_on
  COMMON ShiftFile_Comm,shiftfile

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'BUTTON_Ascii': BEGIN
      OverWrite=''
      get_lun,unit
      openr,unit,outfilename,error=err
      close,unit
      free_lun,unit
      if (err eq 0) then $
         OverWrite=DIALOG_MESSAGE([ $
              outfilename+': File already exists ', $ 
              'Do you wish to overwrite ?'],QUESTION=1)
      if ((err ne 0) or (OverWrite eq 'Yes' )) then begin
       print, 'Writting Ascii file.'
       WIDGET_CONTROL, /HOURGLASS
       create_ascii,data,infilename,outfilename,content,wmin,wmax
       print,'Done'
      endif
      END

  'BGROUP_Content': BEGIN
      IF Event.Select THEN Sel = 'On' ELSE Sel = 'Off'
      CASE Event.Value OF
       0: Print,'Button Lambda Turned ', Sel
       1: Print,'Button Fit_noPSF Turned ', Sel
       2: Print,'Button Flux Turned ', Sel
       3: Print,'Button Error Turned ', Sel
       4: Print,'Button Quality Turned ', Sel
       5: Print,'Button Fit Turned ', Sel
       6: Print,'Button Header Turned ', Sel
       7: Print,'Button All lines Turned ', Sel
      ELSE: Message,'Unknown button pressed'
      ENDCASE
      content[Event.Value]=event.select
      END

  'BUTTON_Print': BEGIN ; Event for button PRINT
      if (infilename eq '') then print,'No data selected, No plot' $
       else begin 
         output_mode_print=2   
        plot_data,data,infilename,wmin,wmax,output_mode_print,plotname
       endelse
      END

  'BUTTON_PostScript': BEGIN ; Event for button POSTSCRIPT
      if (infilename eq '') then print,'No data selected, No plot' $
       else begin 
         output_mode_print=1
         plot_data,data,infilename,wmin,wmax,output_mode_print,plotname
       endelse
      END

  'BUTTON_Exit': BEGIN ; Event for button EXIT
      done,event
      END

  'BUTTON_Help': BEGIN

;   Find the 'xiplot.help' within the directories in the !path list.
      path_list=expand_path(!path,/array)
      n_path=n_elements(path_list)
      i=0
      repeat begin
        helpfile=(findfile(path_list[i]+'/xiplot.help'))[0]
        i=i+1
      endrep until ((i eq n_path) or (helpfile ne ''))

      get_lun,unit
      openr,unit,helpfile,error=err
      if (err ne 0) then begin 
            z=Dialog_message(['HELP File "xiplot.help" not Found'])
      endif else $
            Xdisplayfile,helpfile,title='HELP',width=75
      close,unit
      free_lun,unit
      END

  'BUTTON_OverPlot': BEGIN
     if (overplot_on) then widget_control, BASE_OverPlot, SHOW=1 else begin
       overplot_on=1
       shift_o=0.
       rebin_o=1
       smooth_o=0
       shift_o_p=0
       scale_o=1.
       OverPlot_Button
     endelse
     END

  'BUTTON_AddExpo': BEGIN
     if (AddExpo_on) then widget_control, BASE_AddExpo, SHOW=1 else begin
      if (overplot_on) then begin
        actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
        shiftfile_nopath='shift_'+ $
        STRMID(overname,RSTRPOS(overname,'/')+12, 5)+'.list'
        shiftfile=actual_path+shiftfile_nopath
      endif else begin
        shiftfile='shift_file_list'
      endelse
      AddExpo_on=1
      AddExpo_Button
     endelse
     END

  'BUTTON_Plot_Fit': BEGIN
     if (Select_Window_on) then widget_control, BASE_Select_Window, SHOW=1 else begin
      get_lun,unit
      openr,unit,'AtomicData.d',error=err
      close,unit
      free_lun,unit
      if (err ne 0) then begin 
            Print,"ERROR: Atomic Data missing. PLOT FIT NOT EXECUTED"
            z=Dialog_message(['ERROR !! ',$
              '"Plot Fit" button overplots a fit to the spectrum',$ 
              ' obtained by Martin Lemoine''s Fit Program.',$
              ' It needs a table of Atomic Data, which is not present',$
              ' in the current directory.',$
              '  ',$
              ' PLOT FIT NOT EXECUTED'])
       endif else begin
         Cite_Lemoine
         moses_button
       endelse
      endelse
      END

  'BUTTON_Find_Lines': BEGIN
     if (Find_lines_on) then widget_control, BASE_Find_Lines, SHOW=1 else begin
      get_lun,unit
      openr,unit,'AtomicData.d',error=err
      close,unit
      free_lun,unit
      if (err ne 0) then begin 
            Print,"ERROR: Atomic Data missing. FIND LINES NOT EXECUTED"
            z=Dialog_message(['ERROR !! ',$
              '"Find Lines" button overplots a list of possible lines',$ 
              ' It needs a table of Atomic Data, which is not present',$
              ' in the current directory.',$
              '  ',$
              ' FIND LINES NOT EXECUTED'])
       endif else begin
         Cite_Roueff
         Find_Lines_button
       endelse
     endelse
     END

  'BUTTON_COG': BEGIN
      get_lun,unit
      openr,unit,'AtomicData.d',error=err
      close,unit
      free_lun,unit
      if (err ne 0) then begin 
            Print,"ERROR: Atomic Data missing. PLOT COG NOT EXECUTED"
            z=Dialog_message(['ERROR !! ',$
              '"Plot COG" button displays the curve of growth',$ 
              ' calculated using the profile fitting results.',$
              ' It needs a table of Atomic Data, which is not present',$
              ' in the current directory.',$
              '  ',$
              ' PLOT COG NOT EXECUTED'])
       endif else  cog_button
      END

  'FIELD_DataFile': BEGIN ; Event for Data filename
      actual_path=STRMID(infilename,0,RSTRPOS(infilename,'/')+1)
      newfilename=(actual_path+Event.Value)[0]
      get_lun,unit
      openr,unit,newfilename,error=err
      close,unit
      free_lun,unit
      if (err ne 0) then begin 
            Print,'ERROR: ',newfilename,' file not found'
            z=Dialog_message(['ERROR !! ',$
              'ERROR: ',newfilename,' file not found'])
      filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
      WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
      endif else begin
       infilename=newfilename
       print,' The Data file is set to : ',infilename
       read_data,infilename,data
       first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
      endelse
      END

  'BUTTON_SearchDataFile': BEGIN ; Event for Get Data Filename
      newfilename=infilename
      getfile,newfilename,'*.d*',/read,field_to_updated=FIELD_DataFile        
      if newfilename ne '' then begin
       get_lun,unit
       openr,unit,newfilename,error=err
       close,unit
       free_lun,unit
       if (err ne 0) then begin 
         Print,'ERROR: ',newfilename,' file not found'
         z=Dialog_message(['ERROR !! ',$
            'ERROR: ',newfilename,' file not found'])
         filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
         WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
       endif else begin
         infilename=newfilename
         print,' The Data file is set to : ',infilename
         read_data,infilename,data
         first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
       endelse
      endif else begin
       filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
       WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
      endelse
      END

  'FIELD_AsciiFile': BEGIN ; Event for Ascii filename
      actual_path=STRMID(outfilename,0,RSTRPOS(outfilename,'/')+1)
      outfilename=(actual_path+Event.Value)[0]
      print,' The Ascii file is set to : ',outfilename
      END

  'BUTTON_SearchAsciiFile': BEGIN ; Event for Get Ascii Filename
       getfile,outfilename,'*.dat',/write,field_to_updated=FIELD_AsciiFile
       print,' The Ascii file is set to : ',outfilename
      END

  'FIELD_PlotFile': BEGIN ; Event for Plot filename
      actual_path=STRMID(plotname,0,RSTRPOS(plotname,'/')+1)
      plotname=(actual_path+Event.Value)[0]
      print,' The Plot file is set to : ',plotname
      END

  'BUTTON_SearchPlotFile': BEGIN ; Event for Get Plot Filename'
      getfile,plotname,'*.ps',/write,field_to_updated=FIELD_PlotFile
      print,' The Plot file is set to : ',plotname
      END

  'wmin_slider': BEGIN ; Event for Wmin
      wmin=Event.Value
      if (output_mode eq 0) then $
       plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
      END

  'wmax_slider': BEGIN ; Event for Wmax
      wmax=Event.Value
      if (output_mode eq 0) then $
       plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
      END

  'fmin_slider': BEGIN ; Event for Fmin
      fmin=Event.Value
      if (output_mode eq 0) then $ 
            plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'fmax_slider': BEGIN ; Event for Fmax
      fmax=Event.Value
      if (output_mode eq 0) then $ 
            plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'REBIN_SLIDER': BEGIN ; Event for Rebin
      rebin=Event.Value
      print,'rebin=',rebin
      data_process,data0,data,rebin,shift
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'SHIFT_SLIDER': BEGIN ; Event for Shift
      shift=Event.Value
      print,'shift=',shift
      data_process,data0,data,rebin,shift
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'BUTTON_YFULL': BEGIN ; Event for  Y full'
       plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
      END

  'BUTTON_REPLOT': BEGIN ; Event for Replot'
        replot,data,infilename,wmin,wmax,plotname
       END

  'BUTTON_XFULL': BEGIN ; Event for X full'
          wavemin = min(data.wave)
          wavemax = max(data.wave)
          set_wmin_wmax,wavemin,wavemax
          if (output_mode eq 0) then $
            plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
      END

  'DRAW_LARGE': BEGIN ; Event in window
      if (Event.type eq 0) then begin   ;  Button pressed down
       if ((Event.press eq 1) $         ;  Left button
          and (output_mode eq 0)) then begin 

;       device to data:  (Rx (raw) to Dx (data))
  
        Rx=event.x
        Vx = 1.*!D.X_VSIZE
        X0=!X.S[0]
        X1=!X.S[1]
        Dx=(Rx/Vx-X0)/X1

;       Select and alternate between click on Wmin and Wmax
	 
        if (wmin_or_max eq 0 ) then begin
          Wmin_next=Dx	
          x_line=[wmin_next,wmin_next]
          y_line=!y.crange
          oplot,x_line,y_line
          wmin_or_max=1
        endif else begin
          x_line=[Dx,Dx]
          y_line=!y.crange
          oplot,x_line,y_line
          set_wmin_wmax,Wmin_next,Dx
          if (output_mode eq 0) then $
            plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
        endelse
       endif

       if (Event.press eq 2) then begin ;  Middle button

;         replot at full scale

          wavemin = min(data.wave)
          wavemax = max(data.wave)
          set_wmin_wmax,wavemin,wavemax
          if (output_mode eq 0) then $
            plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange
       endif

       if ((Event.press eq 4) $         ;  Right button
          and (output_mode eq 0)) then begin 

;       device to data:  (Ry (raw) to Dy (data))
  
        Ry=event.Y
        Vy = 1.*!D.Y_VSIZE
        Y0=!Y.S[0]
        Y1=!Y.S[1]
        Dy=(Ry/Vy-Y0)/Y1

;       Select and alternate between click on Fmin and Fmax
	 
        if (fmin_or_max eq 0 ) then begin
          Fmin_next=Dy
          x_line=!x.crange
          y_line=[fmin_next,fmin_next]
          oplot,x_line,y_line
          fmin_or_max=1
        endif else begin
          x_line=!y.crange
          y_line=[Dy,Dy]
          oplot,x_line,y_line
          set_fmin_fmax,Fmin_next,Dy
          if (output_mode eq 0) then $
            plot_data,data,infilename,wmin,wmax,output_mode,plotname
        endelse
       endif
      endif

      if (Event.type eq 2) then begin;  Motion in window

;       device to data:  (Rx (raw) to Dx (data))
        Rx=event.x
        Vx = 1.*!D.X_VSIZE
        X0=!X.S[0]
        X1=!X.S[1]
        Dx=(Rx/Vx-X0)/X1

        d_min=min(abs(data.wave-dx),i_min)
        if ((where(tag_names(data) eq 'ERROR'))[0] ne -1) then $ 
           error_string=string(format='(e11.3)',(data.error)[i_min]) else $
             error_string=''
        if ((where(tag_names(data) eq 'QUALITY'))[0] ne -1) then $ 
           quality_string=string(format='(i15)',(data.quality)[i_min]) else $
             quality_string=''
        info=[$
         'Lambda  = '+string(format='(g15)', float((data.wave)[i_min]) )+ $
       '  Flux    = '+string(format='(e11.3)',(data.flux)[i_min]), $
         'Quality   = '+quality_string+$
       '      Error   = '+error_string]
        widget_control,text_info,set_value=info
      endif
      if ((Event.type eq 4) and (output_mode eq 0)) then $;  Visibility changed
          replot,data,infilename,wmin,wmax,plotname
      END

  'DRAW_SMALL': BEGIN ; Event in small window
       if (Event.release eq 1) then button_pressed=0 ;  Left button released
       if (Event.press   eq 1) then button_pressed=1 ;  Left button pressed
       if ((Event.type eq 2) and (button_pressed eq 1)) $; motion with pressed button
        or (Event.press eq 1)  $; button newly pressed
        then begin

        Rx_4=event.x
        Dx=(Rx_4/Vx_4-X0_4)/X1_4
        Delta=Wmax-Wmin
        set_wmin_wmax,Dx-delta/2,Dx+delta/2
        if (output_mode eq 0) then $
            plot_data,data,infilename,wmin,wmax,output_mode,plotname
       endif

       if ((Event.type eq 4) and (output_mode eq 0)) then $;  Visibility changed
          replot,data,infilename,wmin,wmax,plotname
      END
  'LEFT':  BEGIN ; Event in left button
        if (output_mode eq 0) then scroll,event,-1.,left,left_id,data,infilename,wmin,wmax,output_mode,plotname
       END    
  'RIGHT': BEGIN ; Event in right button
        if (output_mode eq 0) then scroll,event,+1.,right,right_id,data,infilename,wmin,wmax,output_mode,plotname
       END    
  'LEFT2':  BEGIN ; Event in left2 button
        if (output_mode eq 0) then scroll2,event,-1.,left,left_id,data,infilename,wmin,wmax,output_mode,plotname
       END    
  'RIGHT2': BEGIN ; Event in right2 button
        if (output_mode eq 0) then scroll2,event,+1.,right,right_id,data,infilename,wmin,wmax,output_mode,plotname
       END    
  'FULL_LEFT':  BEGIN ; Event in full_left button
        if (output_mode eq 0) then scroll2,event,-10.,left,left_id,data,infilename,wmin,wmax,output_mode,plotname
       END    
  'FULL_RIGHT': BEGIN ; Event in full_right button
        if (output_mode eq 0) then scroll2,event,+10.,right,right_id,data,infilename,wmin,wmax,output_mode,plotname
       END    

  ENDCASE
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro getfile,filename,filter,read=read,write=write,field_to_updated=field_to_updated

; find actual path

      actual_path=STRMID(filename,0,RSTRPOS(filename,'/'))
   
      if keyword_set(read) then  $
         pickfile=DIALOG_PICKFILE($
           file=filename,filter=filter, path=actual_path,$
           /READ) $
      else $
         pickfile=DIALOG_PICKFILE($
           file=filename,filter=filter, path=actual_path,$
           /WRITE)

      if (pickfile ne '') then filename=pickfile

;     Update the field without the path:
;

      filename_nopath=STRMID(filename,RSTRPOS(filename,'/')+1)
      WIDGET_CONTROL, field_to_updated, SET_VALUE=filename_nopath

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro create_ascii,data,infile,outfile,content,wmin,wmax

COMMON Moses_Result_Comm,ntot,n_compo,ilin_max,$
                     x_cont,y_cont,xfit,yfit,y_nopsf,xfit_line,yfit_line,$
                     lda_line,lbl_elt_line,lbl_elt_tab, $ 
                     fwhm_iw,deg_poly_iw,chi2_w_iw,nu_chi2_iw


get_lun,unit
openw,unit,outfile
;;
;;PRINT HEADER
;;;
if content[6] then begin
  printf,unit,';Filename=',infile
  printf,unit,';Wmin=',wmin,'  Wmax=',wmax
  printf,unit,';',format='(a1,$)'
  if content[0] then printf,unit,'   Wave    ',format='(a11,$)'
  if content[1] then printf,unit,'   FIT_noPSF    ',format='(a11,$)'
  if content[2] then printf,unit,'      Flux      ',format='(a16,$)'
  if content[3] then printf,unit,'      Error     ',format='(a16,$)'
  if content[4] then printf,unit,'    Continuum   ',format='(a16,$)'
  if content[5] then printf,unit,'     Fit        ',format='(a16,$)'
  if content[7] then printf,unit,lbl_elt_tab,format='(100a11)' $
    else   printf,unit,''
endif

; number of lines in the fit
if ((size(xfit_line))[0] eq 2) then k_max=(size(xfit_line))[2]-1 else k_max=-1
;print,'kmax=',k_max

;;
;;PRINT TABLE
;;
;;
ndata = n_elements(data.wave)		;number of lines

; figure out array index near wmin, wmax
        wdum = where(wmin gt data.wave,count)
        imin = count - 1
        if(imin lt 0) then imin = 0
        wdum = where(wmax gt data.wave,count)
        imax = count + 1
        if(imax gt ndata-1) then imax = ndata-1

print,'Write data:',imax-imin+1,' rows in ',outfile

;if ((data.wave)[0] gt 1.) then $
;  format_each=['f11.4,' , 'f11.8,' , 'e16.8,' , 'e16.8,' , 'i9,' , 'e16.8,'] $
;else  format_each=['f11.8,' , 'f11.8,' , 'e16.8,' , 'e16.8,' , 'i9,' , 'e16.8,'] 

if ((data.wave)[0] gt 1.) then $
  format_each=['f11.4,' , 'e16.8,' , 'e16.8,' , 'e16.8,' , 'e16.8,' , 'e16.8,'] $
else  format_each=['f11.8,' , 'e16.8,' , 'e16.8,' , 'e16.8,' , 'e16.8,' , 'e16.8,'] 

ind=where(content(0:5) eq 1,count)  

if (count ne 0) then form_extract=format_each(ind) else form_extract=''
ff=''
for i=0,n_elements(form_extract)-1 do ff=ff+form_extract[i]
if (content[7] eq 1) then for k=0,k_max do ff=ff+'e11.3,' 
ff=strmid(ff,0,strlen(ff)-1) 
formatt='('+ff+')'     

data_tab=fltarr(7+k_max,ndata)

data_tab[0,*]=(data.wave)[*]    

;;;;;;;;;;;;;;;;;;;;;;;; data_tab[1,*]=(data.wave)[*]*1.0e-4    
if (content[1] eq 1) then begin 
  yfit_No_PSF_data=interpol(y_nopsf,xfit,data_tab[0,imin:imax])
  data_tab[1,imin:imax]=yfit_No_PSF_data
  ; WRITE AN ADDITIONAL FILE WITH THE FULL RESOLUTION 
    get_lun,unit_nopsf
    openw,unit_nopsf,(outfile+'_NoPSF')
    wdum = where(wmin gt xfit,count)
    jmin = count - 1
    if (jmin lt 0) then jmin = 0
    wdum = where(wmax gt xfit,count)
    jmax = count - 1   
    printf,unit_nopsf,transpose([[xfit[jmin:jmax]],[y_nopsf[jmin:jmax]]]), $ 
                    format='(f11.4,e16.8)'
   close,unit_nopsf
   free_lun,unit_nopsf
   print,'Write data:',jmax-jmin+1,' rows in ',outfile+'_NoPSF'
endif

data_tab[2,*]=(data.flux)[*]   ;    *1.0e-13  
if ((where(tag_names(data) eq 'ERROR'))[0] ne -1) then data_tab[3,*]=(data.error)[*]    
;; data_tab[4,*]=(data.quality)[*]    

if (content[4] eq 1) then begin 
  ycont_data=interpol(y_cont,x_cont,data_tab[0,imin:imax])
  data_tab[4,imin:imax]=ycont_data
endif

if (content[5] eq 1) then begin 
  yfit_data=interpol(yfit,xfit,data_tab[0,imin:imax])
  data_tab[5,imin:imax]=yfit_data
endif

if (content[7] eq 1) then begin 
 for k=0,k_max do begin
   xi=where(xfit_line(*,k) ne 0.)
   yfit_line_data=interpol(yfit_line(xi,k),xfit_line(xi,k),data_tab[0,imin:imax])
   data_tab[6+k,imin:imax]=yfit_line_data
 endfor
endif

bad_point=where((finite(data_tab[2,*]) eq 0), nb_bad_point)
if (nb_bad_point ne 0) then begin 
  data_tab[2,bad_point]=0.
  data_tab[3,bad_point]=1.e10
endif

bad_point=where((finite(data_tab[3,*]) eq 0), nb_bad_point)
if (nb_bad_point ne 0) then begin 
;  data_tab[2,bad_point]=0.
  data_tab[3,bad_point]=1.e10
endif

if ((content[7] eq 1) and (k_max ge 0)) then ind=[ind,6+indgen(k_max+1)] 

printf,unit,data_tab[ind,imin:imax],format=formatt

close,unit
free_lun,unit
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro set_wmin_wmax,wmin0,wmax0

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  COMMON FSLID_Wmin_Comm, FSLID_Wmin ; wmin slider
  COMMON FSLID_Wmax_Comm, FSLID_Wmax ; wmax slider

  COMMON Wminmax_Comm,wmin_or_max,Wmin_next  ; flag for click on Wmin or Wmax.

          wmin = wmin0
          wmax = wmax0
          wmin_or_max=0
          WIDGET_CONTROL, FSLID_Wmin, SET_VALUE=Wmin
          WIDGET_CONTROL, FSLID_Wmax, SET_VALUE=Wmax
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro set_fmin_fmax,fmin0,fmax0

  COMMON Fmin_max_info,fmin,fmax

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider

  COMMON Fminmax_Comm,fmin_or_max,Fmin_next  ; flag for click on Fmin or Fmax.

          fmin = fmin0
          fmax = fmax0
          fmin_or_max=0
          WIDGET_CONTROL, FSLID_Fmin, SET_VALUE=Fmin
          WIDGET_CONTROL, FSLID_Fmax, SET_VALUE=Fmax
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro set_slider_min_max,slidermin,slidermax,min,max

;
;set min and max slider limits
;

;return  

	stash=WIDGET_INFO(slidermin,/child)
        widget_control,stash,get_uvalue=state;,/nocopy

if ((size(state))[1] eq 10) then  begin
  	(*state).top=max
	(*state).bot=min
	stash=WIDGET_INFO(slidermax,/child)
        widget_control,stash,get_uvalue=state
  	(*state).top=max
	(*state).bot=min
endif else begin

	state.top=max
	state.bot=min
        widget_control,stash,set_uvalue=state;,/nocopy

	stash=WIDGET_INFO(slidermax,/child)
        widget_control,stash,get_uvalue=state

	state.top=max
	state.bot=min
        widget_control,stash,set_uvalue=state

endelse
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro reset_rebin
  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

rebin=1
WIDGET_CONTROL, rebin_slider, SET_VALUE=1

shift=0
WIDGET_CONTROL, shift_slider, SET_VALUE=0

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro first_plot,data,data0,infilename,wmin,wmax,new_fmin,new_fmax

  COMMON FSLID_Wmin_Comm, FSLID_Wmin ; wmin slider
  COMMON FSLID_Wmax_Comm, FSLID_Wmax ; wmax slider

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider
  COMMON Fmin_max_info,fmin,fmax

;
; Set wmin and wmax according to data
;
        wavemin = min(data.wave)
        wavemax = max(data.wave)
        set_wmin_wmax,wavemin,wavemax
        set_slider_min_max,FSLID_Wmin,FSLID_Wmax, $
                   wmin-0.2*(wmax-wmin),wmax+0.2*(wmax-wmin)
;
; First plot on window
;
        output_window=0
        plot_data,data,infilename,wmin,wmax,output_window,plotname,/small,/set_yrange
        plot_data,data,infilename,wmin,wmax,output_window,plotname
;
;set fmin and fmax slider limits
;
	new_fmin=fmin
        new_fmax=fmax
       
        set_slider_min_max,FSLID_Fmin,FSLID_Fmax, $ 
                   fmin-1.*(fmax-fmin),fmax+1.*(fmax-fmin)
	data0=data
        reset_rebin
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro plot_data,data,infilename,wmin,wmax,output_mode,plotname,small=small,set_yrange=set_yrange
  COMMON DRAW_LARGE_Comm, DRAW_LARGE_Id
  COMMON DRAW_SMALL_Comm, DRAW_SMALL_Id,Vx_4,X0_4,X1_4,button_pressed
  COMMON ColorsSetup,color_tab, black,white,red,green,blue,yellow

  COMMON Wminmax_Comm,wmin_or_max,Wmin_next  ; flag for click on Wmin or Wmax.
  COMMON Fminmax_Comm,fmin_or_max,Fmin_next  ; flag for click on Fmin or Fmax.

  COMMON Fmin_max_info,fmin,fmax

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on

  COMMON Moses_Status_Comm,Moses_on
  COMMON Find_lines_Status_Comm,Find_Lines_on

;  help,data,/stru
;  ndata = n_elements(data)  ; bug since pipeline Version 3.0

  ndata = n_elements(data.wave)		;number of lines

  if (wmax lt wmin) then begin ; note: wmin could be greater than wmax
   temp=wmax & wmax=wmin & wmin=temp
   set_wmin_wmax,wmin,wmax
  endif
  wmin_or_max=0
  if (fmax lt fmin) then begin ; note: wmin could be greater than wmax
   temp=fmax & fmax=fmin & fmin=temp
   set_fmin_fmax,fmin,fmax
  endif
  fmin_or_max=0

if keyword_set(set_yrange) then begin

; figure out array index near wmin, wmax

        wdum = where(wmin gt data.wave,count)
        imin = count - 1
        if(imin lt 0) then imin = 0
        wdum = where(wmax gt data.wave,count)
        imax = count + 1
        if(imax gt ndata-1) then imax = ndata-1

; set min and max fluxes to plot

;       fluxmm = minmax(data[imin:imax].flux)  ; bug since pipeline Version 3.0
        fluxmin = min((data.flux)[imin:imax])
        fluxmax = max((data.flux)[imin:imax])
        fmin = min([1.2*fluxmin, -0.1*fluxmax]) ; fmin is always less than zero
        fmax = max([-0.1*fluxmin, 1.2*fluxmax]) ; fmax is always greater than zero

           WIDGET_CONTROL, FSLID_Fmin, SET_VALUE=Fmin
           WIDGET_CONTROL, FSLID_Fmax, SET_VALUE=Fmax
endif 

 ok=1
 CASE output_mode OF
      0: BEGIN
          set_plot,'x'
          if keyword_set(small) then wset,DRAW_SMALL_Id else wset,DRAW_LARGE_Id
	 END
      1: BEGIN
          set_plot,'ps'
          set_color_table,/print
          device, filename=plotname,/landscape,/color,encapsulated=0
	  print,'Plot PostScript in: ',plotname 
         END
      2: BEGIN
          set_plot,'printer'
          set_color_table,/print
          device,/true_color
          ok = DIALOG_PRINTERSETUP()
         END
      ENDCASE

if ok then begin
  xformat='' & if (float(!version.release) le 5.2) then xformat='(g10)'
  if keyword_set(small) then begin
        !x.margin=[3,1]
        !y.margin=[3,1]
	plot,data.wave,data.flux,psym=10,charsize=1.0,$
              xrange=[wmin,wmax],yrange=[fmin,fmax],$
              /xstyle,/ystyle;,xtickformat=xformat
        if Overplot_on then oplot,data_o.wave,data_o.flux,psym=10, $ 
                                  color=color_tab[red];,thick=2
        Vx_4 = 1.*!D.X_VSIZE
        X0_4=!X.S[0]
        X1_4=!X.S[1]
        !x.margin=[12,3]
        !y.margin=[3,3]
   endif else begin
        ang=string("305B)

        title_name = STRMID(infilename,RSTRPOS(infilename,'/')+1)
        get_lun,unit
        openr,unit,'notitle',error=err
        if (err ne 0) then $
          titl = title_name $
        else titl=''
        close,unit
	free_lun,unit
 
        xtitl = '!3wavelength';  ('+ang+')'
        ytitl = '!3flux' ;  / (erg/cm2/s/A)'
	plot,data.wave,data.flux,psym=10, $; color=color_tab[white], $
                charsize=1.35,charthick=1.5, $
                xtitle=xtitl,ytitle=ytitl, title=titl,$
                xrange=[wmin,wmax],yrange=[fmin,fmax],$
              /xstyle,/ystyle;,xtickformat=xformat
   ; xyouts,0.75,0.97,title_name,charsize=1.35,charthick=1.5,/normal

        get_lun,unit
        openr,unit,'title_bottom',error=err
        if (err eq 0) then $
         xyouts,0.02,0.025,title_name,charsize=1.35,charthick=1.5,/normal
        close,unit
	free_lun,unit

        if (Overplot_on and (overname ne '')) then $
             oplot,data_o.wave,data_o.flux,psym=10,color=color_tab[red] 
;;; COLOR BUG          oplot,data_o.wave,data_o.flux,psym=10,color=250
        if Moses_on then Oplot_Moses
        if Find_Lines_on then Oplot_Find_Lines
   endelse
endif

CASE output_mode OF
      0: BEGIN
          wset,DRAW_LARGE_Id
	 END
      1: BEGIN
          device,/close
          set_color_table,print=0
          set_plot,'x'
         END
      2: BEGIN
          ok = DIALOG_PRINTJOB()
          device,/close_document
          set_color_table,print=0
          set_plot,'x'
         END
      ENDCASE

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro replot,data,infilename,wmin,wmax,plotname
  COMMON ColorsSetup,color_tab, black,white,red,green,blue,yellow
  COMMON Fmin_max_info,fmin,fmax
  COMMON Wminmax_Comm,wmin_or_max,Wmin_next  ; flag for click on Wmin or Wmax.
  COMMON Fminmax_Comm,fmin_or_max,Fmin_next  ; flag for click on Fmin or Fmax.
  COMMON SLIDE_BUTTON,left,right,left_id,right_id

           wset,left_Id
           xyouts,25,5,'<<',/device ,alignment=0.5,charsize=2,charthick=2
           wset,right_Id
           xyouts,25,5,'>>',/device ,alignment=0.5,charsize=2,charthick=2

           output_window=0
           keep_wmin_or_max=wmin_or_max
           keep_fmin_or_max=fmin_or_max

;           wavemm = minmax(data.wave)
           wmin_all = min(data.wave)
           wmax_all = max(data.wave)
	   fmin_tmp=fmin
	   fmax_tmp=fmax
             plot_data,data,infilename,wmin_all,wmax_all,output_window,plotname,/small,/set_yrange;
	   fmin=fmin_tmp
	   fmax=fmax_tmp
; always last plot on large window (for oplot vertical line to work)
             plot_data,data,infilename,wmin,wmax,output_window,plotname

         wmin_or_max=keep_wmin_or_max
         if (wmin_or_max eq 1) then begin 
          x_line=[wmin_next,wmin_next]
          y_line=!y.crange
          oplot,x_line,y_line,color=color_tab[white]
         endif
         fmin_or_max=keep_fmin_or_max
         if (fmin_or_max eq 1) then begin 
          x_line=!x.crange
          y_line=[fmin_next,fmin_next]
          oplot,x_line,y_line,color=color_tab[white]
         endif
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function get_display

 spawn,'echo $DISPLAY',display
 poscolon=rstrpos(display[0],':')
 if (poscolon[0] ne -1) then display=STRMID(display[0],0,poscolon)
 uname_command= 'rsh '+display[0]+' uname'
 spawn,uname_command,uname
 return,uname[0]
 end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro set_color_table,print=print
  COMMON ColorsSetup,color_tab, black,white,red,green,blue,yellow

;loadct,12

RED_tab   = [0, 255, 255,   0,   0, 255]     
GREEN_tab = [0, 255,  32, 255, 194, 255]
BLUE_tab  = [0, 255,   0,   0, 255,   0]   

if n_elements(print) eq 0 then print=0

if ((get_display() eq 'Linux') or (get_display() eq 'SunOS') $ 
     and not(print))  then begin
  color_tab=Blue_tab*256L^2+Green_tab*256L+Red_tab
endif else begin
  color_tab=indgen(n_elements(red_tab))
  TVLCT, RED_tab,  GREEN_tab, BLUE_tab
endelse

black=0 & white=1 & red=2
green=3 & blue=4  & yellow=5

;;  ?? ;; !p.color=1

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro scroll,event,side,motion,motion_id,data,infilename,wmin,wmax,output_mode,plotname

      if (n_tags(Event) ge 9) then begin ; Normal event
        if (Event.press   eq 1) then motion=1
        if (Event.release eq 1) then motion=0   
       endif 

       if (motion eq 1) then begin

          WIDGET_CONTROL, event.id, TIMER=0.2;Reset the timer.

          delta=(wmax-wmin)/10.
          Wmin=Wmin+delta*side
          Wmax=Wmax+delta*side
          set_wmin_wmax,wmin,wmax
          if (output_mode eq 0) then $
           wset,MOTION_Id
           if (side eq -1.) then char='<<' else char='>>'
           xyouts,25,5,char,/device ,alignment=0.5,charsize=2,charthick=2
           plot_data,data,infilename,wmin,wmax,output_mode,plotname
          endif
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro scroll2,event,side,motion,motion_id,data,infilename,wmin,wmax,output_mode,plotname

          delta=(wmax-wmin)/10.
          Wmin=Wmin+delta*side
          Wmax=Wmax+delta*side
          set_wmin_wmax,wmin,wmax
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro data_process,data0,data,rebin,shift,shift_pixel,scale,smooth
;;
;; arg_present is miss-used: it is 'false' if a value cannot be returned to the caller
;; for ex., if the procedure is called with shift_pixel as a table "shift[k]", 
;;          then arg_present is 'false'
;;  
;;
;; This should be changed to n_param()
;;

; copy the data structure to 1D variable.
 
     aw=reform(data0.wave)
     af=reform(data0.flux)
     ae=reform(data0.error)
     aq=reform(data0.quality)
;     ac=reform(data0.counts)
;     ace=reform(data0.cntserr)

;  make the shift in pixels on the wavelength scale
       if arg_present(shift_pixel) then begin
         nd=n_elements(aw)
         af=(shift(af,shift_pixel))
         ae=(shift(ae,shift_pixel))
         aq=(shift(aq,shift_pixel))
;       if (shift_pixel gt 0) then begin
;          aw=aw[0:nd-shift_pixel-1]
;          af=af[0:nd-shift_pixel-1]
;          ae=ae[0:nd-shift_pixel-1]
;          aq=aq[0:nd-shift_pixel-1]
;       endif
;       if (shift_pixel lt 0) then begin
;          aw=aw[-shift_pixel:nd-1]
;          af=af[-shift_pixel:nd-1]
;          ae=ae[-shift_pixel:nd-1]
;          aq=aq[-shift_pixel:nd-1]
;       endif
       if (shift_pixel lt 0) then begin
          af[nd+shift_pixel:nd-1]=0.
          ae[nd+shift_pixel:nd-1]=0.
          aq[nd+shift_pixel:nd-1]=0
       endif
       if (shift_pixel gt 0) then begin
          af[0:shift_pixel-1]=0.
          ae[0:shift_pixel-1]=0.
          aq[0:shift_pixel-1]=0
       endif
       endif

; make rebin

         n=n_elements(aw)
         nrebin=n / rebin                
         nlast=n / rebin * rebin

 	 aw=boxave(reform(aw[0:nlast-1]),rebin)
 	 af=boxave(reform(af[0:nlast-1]),rebin)
         ae=sqrt(boxave((ae[0:nlast-1])^2,rebin) / rebin )
         aq=replicate(aq[0]*0,nrebin)
	           	
;	  for i=0L,nrebin do begin
;	    ae[i]=sqrt(total((data0.error)[rebin*i:rebin*(i+1)-1]^2)) / rebin
;	    aq[i]=max((data0.quality)[rebin*i:rebin*(i+1)-1])
;          endfor

; smooth the data

       if arg_present(smooth) then if (smooth gt 0) then begin
         width=2*smooth+1
         af=smooth(af,width,nan=1)
         ae=sqrt(smooth(ae^2/width,width,nan=1))
       endif
    
; scale the flux

       if arg_present(scale) then af=af*scale

; make the structure data

         nd=n_elements(aw)
         data=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B},nd)
         data.wave=reform(aw)+shift
         data.flux=reform(af)  
         data.error=reform(ae)  
         data.quality=reform(aq)  

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro normalize,data,norm

     aw=reform(data.wave)
     af=reform(data.flux)
     ae=reform(data.error)

     nw=reform(norm.wave)
     nf=reform(norm.flux)

     normal=interpol(nf,nw,aw)
     af=af/normal
     ae=ae/normal

         nd=n_elements(aw)
         data=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B},nd)
         data.wave=reform(aw)
         data.flux=reform(af)  
         data.error=reform(ae)  

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro cross_overplot,wmin,wmax,best_shift,shift_range

  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider
  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
          
eps_wave=2e-4

error=0
j_wmin=(where(data0.wave ge wmin,count))[0]
if (count le 0) then error=1
j_wmin_o=(where(data0_o.wave ge wmin,count))[0]
if (count le 0) then error=2
ind=(where(data0.wave le wmax,count))
j_wmax=ind[n_elements(ind)-1]
if (count le 0) then error=3
ind=(where(data0_o.wave le wmax,count))
j_wmax_o=ind[n_elements(ind)-1]
if (count le 0) then error=4

if not(error) then pixels_ok=where(abs((data0.wave)[j_wmin:j_wmax]- $
                    (data0_o.wave)[j_wmin_o:j_wmax_o]) le eps_wave, nb_pixels_ok)
if ((nb_pixels_ok le 1) or (nb_pixels_ok ne (j_wmax-j_wmin+1)) or $
                       (nb_pixels_ok ne (j_wmax_o-j_wmin_o+1))) then error=5

  if error then begin 
             z=Dialog_message(['ERROR::'+strtrim(string(error),2)+'. THE WAVELENGTH SCALES OF ',$
                               ' PLOTTED AND OVER-PLOTTED DATA', $
                               ' DO NOT MATCH WITH THE SELECTED WAVELENGTH RANGE!!',$
                               ' CROSS CANNOT EXECUTE']) 
             best_shift=0
             shift_range=[-100,100]             
  endif else $
cross,data0,data0_o,rebin,wmin,wmax,best_shift,shift_range

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro cross,data0,data0_o,rebin,wmin,wmax,best_shift,shift_range,maxsh=maxsh

; This procedure calculate the best shift to be apply to data0_o
; in order that data0_o matchs data0 within (wmin,wmax) 
;
; rebin parameter is used in the calculation
;

if not(keyword_set(maxsh)) then maxsh=30
sh=indgen(2*maxsh+1)-maxsh

shift_lambda=0.
data_process,data0,data,rebin,shift_lambda

error=0
imin=(where(data.wave ge wmin,count))[0]
if (count le 0) then error=1
ind=(where(data.wave le wmax,count))
imax=ind[n_elements(ind)-1]
if (count le 0) then error=3

i1=max([imin,maxsh])
i2=min([imax,n_elements(data)-1-maxsh])
if ((i1 gt i2) or error) then begin
 print,' Error',error
 print, 'Not enough data to check the whole range of shift in CROSS procedure'
 print, 'maxsh value should be decreased'
 z=Dialog_message(['ERROR::'+strtrim(string(error),2)+'. Not enough data',$
                           ' in overplot to check the whole range of shift', $
                           ' CROSS CANNOT EXECUTE']) 
 best_shift=0
 shift_range=[-9999,+9999]
 return
endif

chi=fltarr(n_elements(sh))

chimin=1e10
for j=0,n_elements(sh)-1 do begin

  shift_pixel=sh[j]
  data_process,data0_o,data_o,rebin,shift_lambda,shift_pixel

imin_o=(where(data_o.wave ge wmin,count))[0]
if (count le 0) then error=1
ind=(where(data_o.wave le wmax,count))
imax_o=ind[n_elements(ind)-1]
if (count le 0) then error=3

i1_o=max([imin_o,maxsh])
i2_o=min([imax_o,n_elements(data_o)-1-maxsh])

;print,imin,imax,'  ',i1,i2
;print,imin_o,imax_o,'  ',i1_o,i2_o

if ((i2-i1) ne (i2_o-i1_o)) then error=10
if ((i1_o gt i2_o) or (error ne 0)) then begin
 print,' Error',error
 print, 'Not enough data in overplot to check the whole range of shift in CROSS procedure'
 print, 'maxsh value should be decreased'
 z=Dialog_message(['ERROR::'+strtrim(string(error),2)+'. Not enough data',$
                           ' in overplot to check the whole range of shift', $
                           ' CROSS CANNOT EXECUTE']) 
 best_shift=0
 shift_range=[-9999,+9999]
 return
endif

 y1=(data.flux)[i1:i2]
 e1=(data.error)[i1:i2]
 y2s=(data_o.flux)[i1_o:i2_o]
 e2s=(data_o.error)[i1_o:i2_o]

 sigma2 = e1^2 + e2s^2

 alpha=total(y1*y2s/sigma2) / total(y2s^2/sigma2)
 chi[j]=total( (y1-alpha*y2s)^2/sigma2 )

; print,sh[j],alpha,chi[j],'/',(i2-i1+1)

 if (chi[j] lt chimin) then begin 
    chimin=chi[j]
    best_shift=sh[j]
    best_alpha=alpha
 endif

endfor

print,'Best Shift=',best_shift,'  Best Scale= ',float(best_alpha), $
      '   Chi2=',chimin,'/',(i2-i1+1),format='(a,i5,a,f,a,g8,a,i5)

shift_2sigma=where(chi lt (chimin+4.))
shift_range_min=min(sh[shift_2sigma])
shift_range_max=max(sh[shift_2sigma])
print,'Shift range at 2 sigmas is [',shift_range_min,',',shift_range_max,']'

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Shift_Optimize,wmin,wmax,file_list
  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

  if keyword_set(addphoton) then photon_mode='Yes' else $
   photon_mode=DIALOG_MESSAGE('Do you wish to add in photon mode ?',QUESTION=1)

  read_shift_file_list,file_list,data_tab_wave,data_tab_flux,data_tab_error, $ 
                    data_tab_counts,data_tab_cntserr,n_data_tab, $
                    list

shift_tab=reform(list.shift)

n_line=(size(data_tab_wave))[1]
n_data=(size(data_tab_wave))[2]

if (n_line le 1) then begin
            z=Dialog_message(['ERROR:: '+file_list+' has less than two lines',$
                               ' SHIFT OPTIMIZE CANNOT EXECUTE']) 
                 endif else begin

if (n_line le 4) then print,' CASE OF LESS THAN 5 FILES NOT IMPLEMENTED'

if ((data_tab_wave)[0,n_data/2] ne (data_tab_wave)[1,n_data/2]) then begin
             z=Dialog_message(['ERROR:: THE WAVELENGTH SCALES OF ',$
                               ' PLOTTED AND OVER-PLOTTED DATA', $
                               ' ARE DIFFERENT!!',$
                               ' SHIFT OPTIMIZE CANNOT EXECUTE']) 
                 endif else begin

print,'EXECUTE Shift_Optimize from',wmin,' to',wmax,' with Rebin=',rebin, $ 
  format='(A,F10.2,A,F10.2,A,I3)'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First execute CROSS for each individual file compared to the first
; To determine a first hint of the best shift without add_expo.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
; Now this part is not executed:
; 

data0=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0, $ 
                                    counts:0.0D,cntserr:0.0D},n_data)
data0.wave =reform(data_tab_wave[0,*])
data0.flux =reform(data_tab_flux[0,*])
data0.error =reform(data_tab_error[0,*])
data0.counts =reform(data_tab_counts[0,*])
data0.cntserr =reform(data_tab_cntserr[0,*])

;;;;;;;;;;;;;;;;;;;;;;;;;
;for k=1,n_line-1 do begin 
;
;data_k=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0, $ 
;                                     counts:0.0D,cntserr:0.0D},n_data)
;  data_k.wave =reform(data_tab_wave[k,*])
;  data_k.flux =reform(data_tab_flux[k,*])
;  data_k.error =reform(data_tab_error[k,*])
;  data_k.counts =reform(data_tab_counts[k,*])
;  data_k.cntserr =reform(data_tab_cntserr[k,*])
;  
;  cross,data0,data_k,rebin,wmin,wmax,best_shift,shift_range
;
;  shift_tab[k]=best_shift
;  
;endfor
;;;;;;;;;;;;;;;;;;;;

new_list=replicate({filename:'',shift:0L},n_line)
new_list.filename=reform((list.filename)[*])
new_list.shift=reform(shift_tab[*])

; help,new_list,/str
print,(new_list.shift)[*]

; Then execute CROSS on two 'shift&added' sub-samples of the file-list
;
; 

ref_size=3*n_line/4-1 				; n_line/2  	; n_line-1 
to_shift_size=n_line-ref_size
ind_1=indgen(ref_size)
ind_2=indgen(to_shift_size)+ref_size

N_noshift=0
Repeat begin

; determine the sub sample to exchange between ind_1 and ind_2
sub_size=min([ref_size/2+1,to_shift_size/2+1])   ; n_line/4	; 1

for j=0,sub_size-1 do begin
  i=fix(randomu(seed)*(ref_size-j))+j  ; select an element in [j;ref_size-1]
  temp=ind_1[i]
  ind_1[i]=ind_1[j]
  ind_1[j]=temp
endfor
 
for j=0,sub_size-1 do begin
  i=fix(randomu(seed)*(to_shift_size-j))+j  ; select an element in [j;lto_shift_size-1]
  temp=ind_2[i]
  ind_2[i]=ind_2[j]
  ind_2[j]=temp
endfor
 
; exchange the content of ind_1 and ind_2 
temp=ind_1[0:sub_size-1]
ind_1[0:sub_size-1]=ind_2[0:sub_size-1]
ind_2[0:sub_size-1]=temp

print,'ind1=',ind_1
print,'ind2=',ind_2

;; reset shift list : 1st element is zero

list_1=replicate({filename:'',shift:0L},n_line)
list_1.filename=reform((list.filename)[*])
list_1.shift=reform(shift_tab[*]-shift_tab[ind_1[0]])

list_2=replicate({filename:'',shift:0L},n_line)
list_2.filename=reform((list.filename)[*])
list_2.shift=reform(shift_tab[*]-shift_tab[ind_2[0]])


;print,'dat_tab_wave=',data_tab_wave[ind_1[0],0],data_tab_wave[ind_2[0],0]
;print,'list_1=',(list_1[ind_1]).shift
;print,'list_2=',(list_2[ind_2]).shift


add_expo_data_tab,data_tab_wave[ind_1,*],data_tab_flux[ind_1,*], $ 
                  data_tab_error[ind_1,*], $ 
                  data_tab_counts[ind_1,*],data_tab_cntserr[ind_1,*],n_data_tab[ind_1,*], $ 
                  list_1[ind_1],data_1,photon_mode

add_expo_data_tab,data_tab_wave[ind_2,*],data_tab_flux[ind_2,*], $ 
                  data_tab_error[ind_2,*], $ 
                  data_tab_counts[ind_2,*],data_tab_cntserr[ind_2,*],n_data_tab[ind_2,*], $ 
                  list_2[ind_2],data_2,photon_mode

if   ( (data_1.wave)[0] ne (data_2.wave)[0])  then begin
  if   ( (data_1.wave)[0] lt (data_2.wave)[0])  then begin
        i0=(where( (data_1.wave) eq (data_2.wave)[0],count))[0]
        if (count eq 1) then data_1=data_1[i0:*]
  endif else begin
        i0=(where( (data_2.wave) eq (data_1.wave)[0],count))[0]
        if (count eq 1) then data_2=data_2[i0:*]
  endelse
  print,'count,i0=',count,i0
  if (count ne 1) then print,'ERROR: Cross impossible'
endif
 
cross,data_1,data_2,rebin,wmin,wmax,best_shift,shift_range,maxsh=30

;print,'shift range =',shift_range
;print,'best,ref1,2=',best_shift, shift_tab[ind_1[0]] , shift_tab[ind_2[0]]

Delta_shift_range=shift_range - shift_tab[ind_2[0]] + shift_tab[ind_1[0]]

print,'Delta_shift range =',Delta_shift_range

if (Delta_shift_range[0]*Delta_shift_range[1] gt 0) then begin 
  Delta_shift=best_shift - shift_tab[ind_2[0]] + shift_tab[ind_1[0]]
  shift_tab[ind_2]=shift_tab[ind_2]+ Delta_shift
;
  N_noshift=0
;
endif else begin
  N_noshift=N_noshift+1
  print,'N_noshift=',N_noshift
endelse

new_list=replicate({filename:'',shift:0L},n_line)
new_list.filename=reform((list.filename)[*])
new_list.shift=reform(shift_tab[*])

;help,new_list.shift
print,(new_list.shift)[*]

endrep until (N_noshift ge n_line)

endelse ; Wavelengths Scale OK
endelse ; nline > 1

new_list=replicate({filename:'',shift:0L},n_line)
new_list.filename=reform((list.filename)[*])
new_list.shift=reform(shift_tab[*])

; help,new_list.shift
print,(new_list.shift)[*]

get_lun,out
file_list_out=file_list+'_Optimized'
openw,out,file_list_out
for k=0,n_line-1 do begin
 print,     (new_list.filename)[k],' ',(new_list.shift)[k],format='(A,A1,I4)'
 printf,out,(new_list.filename)[k],' ',(new_list.shift)[k],format='(A,A1,I4)'
endfor
close,out
free_lun,out

add_expo_data_tab,data_tab_wave,data_tab_flux, $ 
                  data_tab_error, $ 
                  data_tab_counts,data_tab_cntserr,n_data_tab, $ 
                  new_list,data_result,photon_mode
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro add_expo_file_list,file_list,data_sum, $ 
                        addphoton=addphoton,weighted=weighted

 if keyword_set(addphoton) then begin
  photon_mode='Yes' 
  weighted=0
 endif else begin
  if keyword_set(weighted) then begin 
   photon_mode='No' 
   weighted=1
  endif else begin
   if ((n_elements(addphoton) gt 0) and (n_elements(weighted) gt 0)) then begin
    photon_mode='No' 
    weighted=0
   endif else begin
    photon_mode=DIALOG_MESSAGE('Do you wish to add photon counts in spectra ?',QUESTION=1)
    if (photon_mode eq 'Yes') then weighted=0 else begin
     weighted_question=DIALOG_MESSAGE('Do you wish an Error-Weighted Addition ?',QUESTION=1)
     if (weighted_question eq 'Yes') then weighted=1 else weighted=0
    endelse
   endelse
  endelse
 endelse

 read_shift_file_list,file_list,data_tab_wave,data_tab_flux,data_tab_error, $ 
                    data_tab_counts,data_tab_cntserr,n_data_tab, $
                    list
 add_expo_data_tab,data_tab_wave,data_tab_flux,data_tab_error, $ 
                    data_tab_counts,data_tab_cntserr,n_data_tab, $ 
                    list,data_sum,photon_mode,weighted
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro read_shift_file_list,file_list,data_tab_wave,data_tab_flux,data_tab_error,$ 
                    data_tab_counts,data_tab_cntserr,n_data_tab, $
                    list


print,'read',file_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  READ_ASCII DOES NOT WORK WITH IDL 5.5
;;;;;;
;       template={ VERSION:1.0 , DATASTART:0 , DELIMITER:32B, MISSINGVALUE:'' ,$ 
;                   COMMENTSYMBOL : '' , FIELDCOUNT:2 , FIELDTYPES:[7,3] ,$
;                   FIELDNAMES:['filename','shift'],  $
;                   FIELDLOCATIONS:[0,22], $
;                   FIELDGROUPS:[0,1] }
;       list=read_ascii(file_list,template=template)
;       n_line=(size((list.filename),/dimensions))[0]         
; print,'n_line=',n_line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
 ; READ file_list for IDL 5.5
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

line=''
filename_tab=strarr(1000)
shift_tab=intarr(1000)

get_lun,unit
openr,unit,file_list
    k=0
    while (not eof(unit)) do begin
       readf,unit,line
       line_clean=strtrim(strcompress(line),2)
       bline = byte(line_clean)
       ptr = where(bline eq 32, num_spaces)
       filename_tab[k]=strmid(line_clean,0,ptr[0])
        if (filename_tab[k] ne '') then begin
          shift_tab[k]=fix(strmid(line_clean,ptr[0]+1))
          k=k+1
        endif
    endwhile
    n_line=k
filename_tab=filename_tab[0:k-1]
shift_tab=shift_tab[0:k-1]
list={filename:filename_tab, shift:shift_tab} 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read each file into data_tab

Qmax=20000
 data_tab_wave=fltarr(n_line,Qmax)
 data_tab_flux=fltarr(n_line,Qmax)
 data_tab_error=fltarr(n_line,Qmax)
 data_tab_counts=fltarr(n_line,Qmax)
 data_tab_cntserr=fltarr(n_line,Qmax)

 n_data_tab=intarr(n_line)

       for k=0,n_line-1 do begin
           filename= (list.filename)[k]
           shift=(list.shift)[k]
           print,'file=',filename,'  shift=',shift

           read_data,filename,data
           n_data=n_elements(data.wave)

           if (n_data gt Qmax) then begin
             z=Dialog_message(['ERROR:: The data size are larger than ''Qmax'':'+string(Qmax)]) 
             return
           endif

             data_tab_wave[k,0:n_data-1]=reform(data.wave)
             data_tab_flux[k,0:n_data-1]=reform(data.flux)
           if ((where(tag_names(data) eq 'ERROR'))[0] ne -1) then $ 
             data_tab_error[k,0:n_data-1]=reform(data.error)
           if ((where(tag_names(data) eq 'COUNTS'))[0] ne -1) then $ 
             data_tab_counts[k,0:n_data-1]=reform(data.counts)
           if ((where(tag_names(data) eq 'CNTSERR'))[0] ne -1) then $ 
             data_tab_cntserr[k,0:n_data-1]=reform(data.cntserr)
             n_data_tab[k]=n_data
 
       endfor; of k

       n_data_max=max(n_data_tab)
       data_tab_wave=data_tab_wave[*,0:n_data_max-1]
       data_tab_flux=data_tab_flux[*,0:n_data_max-1]
       data_tab_error=data_tab_error[*,0:n_data_max-1]
       data_tab_counts=data_tab_counts[*,0:n_data_max-1]
       data_tab_cntserr=data_tab_cntserr[*,0:n_data_max-1]
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro add_expo_data_tab,data_tab_wave,data_tab_flux,data_tab_error, $ 
                      data_tab_counts,data_tab_cntserr,n_data_tab, $ 
                      list,data_sum,photon_mode,weighted

eps_wave=2e-4

; make the sum for each element of data_tab 

  print,'Add_Expo running'

  n_line=n_elements(data_tab_wave[*,0])
  for k=0,n_line-1 do begin

    if ( (photon_mode eq 'Yes') and $
;       ((where(tag_names(data_tab[k]) eq 'COUNTS'))[0] eq -1)) then begin
         (total(data_tab_counts[k,*]) eq 0)) then begin
         z=Dialog_message(['WARNING:: ',$
                           (list.filename)[k]+' has no COUNTS column',$
                           'It cannot be used in Photon Mode',$
                           ' File skipped'])
    endif else begin ; (photon_mode is 'No'  or  COUNTS is present)

    shift=(list.shift)[k]

; copy record to a table
     aw=reform(data_tab_wave[k,*])
     af=reform(data_tab_flux[k,*])
     ae=reform(data_tab_error[k,*])
  if photon_mode eq 'Yes' then begin
     ac=reform(data_tab_counts[k,*])
     ace=reform(data_tab_cntserr[k,*])
  endif

;  make the shift in pixels on the wavelength scale

       aw=shift(aw,-shift)
       if (shift gt 0) then $
            af[n_elements(af)-shift:n_elements(af)-1]= 0. 
       if (shift lt 0) then $
            af[0:(-shift)-1]= 0. 

; remove the extreme points with (flux eq 0)  

       ind=where(af ne 0.)
       last_ind=ind(n_elements(ind)-1)
       ind=indgen(last_ind-ind[0]+1)+ind[0]
       n_data=n_elements(ind)

; set the wavelentgh reference frame on the first file

         if (k eq 0) then begin 
            wave_sum=aw(ind)
            n_sum=n_elements(wave_sum)
            flux_sum=dblarr(n_sum)
            errr_sum=dblarr(n_sum)
            norm_sum=dblarr(n_sum)
  if photon_mode eq 'Yes' then begin
            cnts_sum=dblarr(n_sum)
            cter_sum=dblarr(n_sum)
  endif else begin
            nbpt_sum=dblarr(n_sum)
  endelse
         endif ; of (k eq 0)

; find the point with the nearest wavelength to the first point of the 
; reference frame.

         i0=0
         temp= min(abs(aw(ind)-wave_sum[0]),j0)
         if (j0 eq 0) then temp= min(abs(aw(ind[0])-wave_sum),i0)
  
         n_new=min([n_data-j0,n_sum-i0])
         if ( n_new ne 0) then begin

;;           print,'i0=',i0,' w[i0]=',wave_sum[i0]
;;           print,'j0=',j0,' w[j0]=',aw(ind[j0]),'  n_new=',n_new

           if ( abs(wave_sum[i0+n_new-1]-aw[ind[j0+n_new-1]]) gt eps_wave) then $
             z=Dialog_message(['WARNING:: THE WAVELENGTH SCALES OF ',$
                                 (list.filename)[0], $
                               ' AND ', $
                                 (list.filename)[k], $
                               ' ARE DIFFERENT!!',$
                               ' YOU SHOULD EXECUTE ',$
			       ' SHIFT, RESAMPLE & ADD '])
      
; remove NaN and undefined numbers
   
            ind_sum=i0+indgen(n_new)
            ind_add=ind[j0:j0+n_new-1]

  if photon_mode eq 'Yes' then $
            good_point=where(finite(af[ind_add]) and finite(ac[ind_add]) $
                                                 and finite(ace[ind_add]) $
                                                 and (af[ind_add] ne 0.)  $
                                                 and (ae[ind_add] ne 0.) )$
  else      good_point=where(finite(af[ind_add]) and finite(ae[ind_add]))
            ind_sum=ind_sum[good_point]
            ind_add=ind_add[good_point]

; add the information from the current exposure

  if photon_mode eq 'Yes' then begin

            flux_sum[ind_sum]=flux_sum[ind_sum]+ ac[ind_add]
            norm_sum[ind_sum]=norm_sum[ind_sum]+ ac[ind_add] / af[ind_add]
;            errr_sum[ind_sum]=errr_sum[ind_sum]+ 2*ace[ind_add]^2-ac[ind_add]
            errr_sum[ind_sum]=errr_sum[ind_sum]+ $ 
                                       (ac[ind_add]/af[ind_add]*ae[ind_add])^2
            cnts_sum[ind_sum]=cnts_sum[ind_sum]+ ac[ind_add]
            cter_sum[ind_sum]=cter_sum[ind_sum]+ ace[ind_add]^2

  endif else begin

           if not(keyword_set(weighted)) then weighted=0
           if (weighted ne 0) then begin
            flux_sum[ind_sum]=flux_sum[ind_sum]+ af[ind_add] / ae[ind_add]^2
            norm_sum[ind_sum]=norm_sum[ind_sum]+ 1. / ae[ind_add]^2
            errr_sum[ind_sum]=errr_sum[ind_sum]+ 1. / ae[ind_add]^2 
            nbpt_sum[ind_sum]=nbpt_sum[ind_sum]+ 1. / ae[ind_add]^2 
           endif else begin
            flux_sum[ind_sum]=flux_sum[ind_sum]+ af[ind_add] 
            norm_sum[ind_sum]=norm_sum[ind_sum]+ 1. 
            errr_sum[ind_sum]=errr_sum[ind_sum]+ (ae[ind_add]^2 ) 
            nbpt_sum[ind_sum]=nbpt_sum[ind_sum]+ 1
           endelse

  endelse; of (photon_mode is yes)


         endif ; of (n_new ne 0)
    endelse; (photon_mode is 'No'  or  COUNTS is present)
  endfor; of k
 
; compute the final result of add_expo

  if photon_mode eq 'Yes' then begin
       flux_sum[0:n_sum-1]=flux_sum[0:n_sum-1]/norm_sum[0:n_sum-1]
     ; by default when no photon in the bin, then error is assumed to be 'one photon' :
         zerophoton=where(errr_sum[0:n_sum-1] lt 1. , count)
         if (count ne 0) then begin ; (errr_sum[0:n_sum-1])[zerophoton]=1 error with IDL 5.5 !!
            errr_temp=errr_sum[0:n_sum-1]
            errr_temp[zerophoton]=1.
            errr_sum[0:n_sum-1]=errr_temp
         endif

       errr_sum[0:n_sum-1]=sqrt(errr_sum[0:n_sum-1])/norm_sum[0:n_sum-1]
       cter_sum[0:n_sum-1]=sqrt(cter_sum[0:n_sum-1])
  endif else begin
       flux_sum[0:n_sum-1]=flux_sum[0:n_sum-1]/norm_sum[0:n_sum-1]
       errr_sum[0:n_sum-1]=sqrt( errr_sum[0:n_sum-1])/nbpt_sum[0:n_sum-1]
  endelse 

       bad_point=where((finite(flux_sum[0:n_sum-1]) eq 0),nb_bad_point)
       if (nb_bad_point ne 0) then begin
        flux_sum[bad_point]=0.
        errr_sum[bad_point]=1.e10
       endif

       bad_point=where((finite(errr_sum[0:n_sum-1]) eq 0),nb_bad_point)
       if (nb_bad_point ne 0) then begin
        errr_sum[bad_point]=1.e10
       endif

  if photon_mode eq 'Yes' then begin
        data_sum=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B,counts:0.0D,cntserr:0.0D},n_sum)
        data_sum.wave =reform(wave_sum[0:n_sum-1])
        data_sum.flux =reform(flux_sum[0:n_sum-1])  
        data_sum.error=reform(errr_sum[0:n_sum-1])  
        data_sum.counts=reform(cnts_sum[0:n_sum-1])  
        data_sum.cntserr=reform(cter_sum[0:n_sum-1])  
  endif else begin
        data_sum=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B},n_sum)
        data_sum.wave =reform(wave_sum[0:n_sum-1])
        data_sum.flux =reform(flux_sum[0:n_sum-1])  
        data_sum.error=reform(errr_sum[0:n_sum-1])  
  endelse 
  end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro add_expo_resample,file_list,data_sum,weighted=weighted,addphoton=addphoton

  COMMON BASE_AddExpo_Comm, BASE_AddExpo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  READ_ASCII DOES NOT WORK WITH IDL 5.5
;;;;;;
;       template={ VERSION:1.0 , DATASTART:0 , DELIMITER:32B, MISSINGVALUE:'' ,$ 
;                   COMMENTSYMBOL : '' , FIELDCOUNT:2 , FIELDTYPES:[7,3] ,$
;                   FIELDNAMES:['filename','shift'],  $
;                   FIELDLOCATIONS:[0,22], $
;                   FIELDGROUPS:[0,1] }
;       list=read_ascii(file_list,template=template)
;       n_line=(size((list.filename),/dimensions))[0]         
; print,'n_line=',n_line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
 ; READ file_list for IDL 5.5
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

line=''
filename_tab=strarr(1000)
shift_tab=intarr(1000)

get_lun,unit
openr,unit,file_list
    k=0
    while (not eof(unit)) do begin
       readf,unit,line
       line_clean=strtrim(strcompress(line),2)
       bline = byte(line_clean)
       ptr = where(bline eq 32, num_spaces)
       filename_tab[k]=strmid(line_clean,0,ptr[0])
        if (filename_tab[k] ne '') then begin
          shift_tab[k]=fix(strmid(line_clean,ptr[0]+1))
          k=k+1
        endif
    endwhile
    n_line=k
filename_tab=filename_tab[0:k-1]
shift_tab=shift_tab[0:k-1]
list={filename:filename_tab, shift:shift_tab} 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       if keyword_set(addphoton) then photon_mode='Yes' else $
       photon_mode=DIALOG_MESSAGE('Do you wish to add in photon mode ?',QUESTION=1)

; make the sum for each file 

    print,'Add_Expo per Photon running'

       for k=0,n_line-1 do begin
           filename= (list.filename)[k]
           shift=(list.shift)[k]
           print,'file=',filename,'  shift=',shift

       read_data,filename,data

    if ( (photon_mode eq 'Yes') and ((where(tag_names(data) eq 'COUNTS'))[0] eq -1)) then begin
             z=Dialog_message(['WARNING:: ',$
                               '(list.filename)[k] has no COUNTS column',$
                               'It cannot be used in Photon Mode',$
                               ' File skipped'])              
    endif else begin ; (photon_mode is 'No'  or  COUNTS is present)
    
; copy record to a table
     aw=reform(data.wave)
     af=reform(data.flux)
     ae=reform(data.error)
  if photon_mode eq 'Yes' then begin
     ac=reform(data.counts)
     ace=reform(data.cntserr)
  endif

;  make the shift in pixels on the wavelength scale

       aw=shift(aw,-shift)
       if (shift gt 0) then begin
            aw[n_elements(data)-shift:n_elements(data)-1]= 1.e100 
            af[n_elements(data)-shift:n_elements(data)-1]= 0.
       endif
       if (shift lt 0) then begin
            aw[0:(-shift)-1]= -1e100 
            af[0:(-shift)-1]= 0.
       endif

; remove the extreme points with (flux eq 0)  

       ind=where(af ne 0.)
       last_ind=ind(n_elements(ind)-1)
       ind=indgen(last_ind-ind[0]+1,/long)+ind[0]
       n_data=n_elements(ind)

; set the spectrum wavelentgh  on the new wavelentgh scale

   if (k eq 0) then begin 
; create the new scale (Default: 900 AA - 1200 AA ; step = 0.02 AA):
      wave_min= 900
      wave_max=1200
      pas=0.02
      Ask_wmin_wmax_step,wave_min,wave_max,pas,BASE_AddExpo
print,'Execute Resample Shift & Add with '
print,'   Wavelength Min = ',wave_min,' Max = ',wave_max,' Step = ',pas

 	step_nb=long((wave_max-wave_min)/pas)
; array definition:
	wave_sum=double(wave_min+pas*indgen(step_nb))

; uncomment the 2 lines below to rescale to the first file wavelengths
; and define  phmin=0 phmax=step_nb-1 about 15 lines below
;
;        wave_sum=aw  
; 	step_nb=n_elements(wave_sum)

   	flux_sum=dblarr(step_nb)
	norm_sum=dblarr(step_nb)
	errr_sum=dblarr(step_nb)
	cnts_sum=dblarr(step_nb)
	cter_sum=dblarr(step_nb)
	nbpt_sum=intarr(step_nb)
  endif ; (k eq 0)
	 
; find the limits of the new scale
 wave_min_k=aw(ind[0])
 wave_max_k=aw(ind[n_data-1])
 phmin=long(max([(wave_min_k-wave_min)/pas+0.5,0]))
 phmax=long(min([(wave_max_k-wave_min)/pas+0.5,step_nb-1]))

;phmin=0
;phmax=step_nb-1

 if (k eq 0) then begin
	pmini=phmin
	pmaxi=phmax
 endif
 if (pmini gt phmin ) then pmini=phmin
 if (pmaxi lt phmax ) then pmaxi=phmax

 lim_inf= (wave_sum+shift(wave_sum, 1))/2.
 lim_sup= (wave_sum+shift(wave_sum,-1))/2.
 lim_inf[0]=-1.e10
 lim_sup[step_nb-1]=1.e10

     ;Find the Pixels between p et p+1 on the spectrum
  for p=phmin, phmax-1 do begin

	indh=where(( aw ge lim_inf[p]) and (aw lt lim_sup[p]))
        if (indh[0] ne -1) then begin ; set of points in the current bin not empty 

; remove NaN and undefined numbers

        if photon_mode eq 'Yes' then $
              good_point=where(finite(af[indh]) and finite(ac[indh])  $
                                                and finite(ace[indh]) $
                                                and af[indh], count)$
        else  good_point=where(finite(af[indh]) and finite(ae[indh]), count)

        if (count ne 0) then begin ; set of good points in the current bin not empty 

          ind_add=indh[good_point]

; add the information from the current exposure and pixel bin (ind_add -> p)

          if photon_mode eq 'Yes' then begin
;             ind_add=ind_add(where(af[ind_add] ne 0))
		flux_sum[p]=flux_sum[p]+total(ac[ind_add])
		norm_sum[p]=norm_sum[p]+total(ac[ind_add]/af[ind_add])
		errr_sum[p]=errr_sum[p]+ $ 
                          total((ac[ind_add]/af[ind_add]*ae[ind_add])^2)
		cnts_sum[p]=cnts_sum[p]+total(ac[ind_add])
		cter_sum[p]=cter_sum[p]+total(ace[ind_add]^2)
          endif else begin
	     if keyword_set(weighted) then begin
		flux_sum[p]=flux_sum[p]+total(af[ind_add]/ae[ind_add]^2)
		norm_sum[p]=norm_sum[p]+total(1./ae[ind_add]^2)
		errr_sum[p]=errr_sum[p]+total(1./ae[ind_add]^2)
		nbpt_sum[p]=nbpt_sum[p]+total(1./ae[ind_add]^2)
             endif else begin
		flux_sum[p]=flux_sum[p]+total(af[ind_add])
		norm_sum[p]=norm_sum[p]+n_elements(ind_add)
		errr_sum[p]=errr_sum[p]+total(ae[ind_add]^2)
		nbpt_sum[p]=nbpt_sum[p]+n_elements(ind_add)
	     endelse ;of keyword_set
	  endelse ;of photon_mode 

        endif ; set of points in the current bin not empty 
        endif ; set of good points in the current bin not empty 

   endfor; for P

  endelse; (photon_mode is 'No'  or  COUNTS is present)

endfor; for k

; compute the final result of add_expo_resample

  if photon_mode eq 'Yes' then begin

       flux_sum[pmini:pmaxi]=flux_sum[pmini:pmaxi]/norm_sum[pmini:pmaxi]

     ; by default when no photon in the bin, then error is assumed to be 'one photon' :
         zerophoton=where(errr_sum[pmini:pmaxi] lt 1. , count)
 ;        help,count
 ;        help,pmini,pmaxi,errr_sum
 ;        help,zerophoton
         print,min(zerophoton),max(zerophoton)

         if (count ne 0) then begin ; (errr_sum[pmini:pmaxi])[zerophoton]=1. error with IDL 5.5 !!
            errr_temp=errr_sum[pmini:pmaxi]
            errr_temp[zerophoton]=1.
            errr_sum[pmini:pmaxi]=errr_temp
         endif

       errr_sum[pmini:pmaxi]=sqrt(errr_sum[pmini:pmaxi])/norm_sum[pmini:pmaxi]
       cter_sum[pmini:pmaxi]=sqrt(cter_sum[pmini:pmaxi])
        
  endif else begin

       flux_sum[pmini:pmaxi]=flux_sum[pmini:pmaxi]/norm_sum[pmini:pmaxi]
       errr_sum[pmini:pmaxi]=sqrt( errr_sum[pmini:pmaxi])/nbpt_sum[pmini:pmaxi]

  endelse 

       bad_point=where((finite(flux_sum) eq 0) or $ 
                       (finite(errr_sum) eq 0),nb_bad_point)
       if (nb_bad_point ne 0) then begin
        flux_sum[bad_point]=0.
        errr_sum[bad_point]=1.e10
       endif

  if photon_mode eq 'Yes' then begin        
        data_sum=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B,counts:0.0D,cntserr:0.0D},(pmaxi-pmini+1))
        data_sum.wave =reform(wave_sum[pmini:pmaxi])
        data_sum.flux =reform(flux_sum[pmini:pmaxi])  
        data_sum.error=reform(errr_sum[pmini:pmaxi])  
        data_sum.counts=reform(cnts_sum[pmini:pmaxi])  
        data_sum.cntserr=reform(cter_sum[pmini:pmaxi])  
;       print,transpose([[wave_sum[pmini:pmaxi]],[flux_sum[pmini:pmaxi]],$
;                        [cnts_sum[pmini:pmaxi]],[cter_sum[pmini:pmaxi]]])
  endif else begin
        data_sum=replicate({wave:0.0D,flux:0.0D,error:0.0D,quality:0B},(pmaxi-pmini+1))
        data_sum.wave =reform(wave_sum[pmini:pmaxi])
        data_sum.flux =reform(flux_sum[pmini:pmaxi])  
        data_sum.error=reform(errr_sum[pmini:pmaxi])  
  endelse 

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro done,event

widget_control,/destroy,event.top
!p.charsize=1.

; reset margin to default

!x.margin=[10,3]   ;; default=[10,3]
!y.margin=[4,2]   ;; default=[4,2]
set_plot,'x'

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro read_data,infilename,data

extension=''
posdot=rstrpos(infilename,'.')
if (posdot ne -1) then extension=strmid(infilename,posdot+1,1)
if (extension eq 'd') then $
  read_asciifile,infilename,data $
else begin
; read the data file
	data = mrdfits(infilename[0],1)
	ndata = n_elements(data.wave)		;number of lines

        if ( (data.wave)[0] gt (data.wave)[1] ) then begin
   	  print,' Reverse the Wave order (w0>w1): '
;	  print,'   w0= ',(data.wave)[0]
;         print,'   w1= ',(data.wave)[1]
          data.wave=reverse(data.wave)
          data.flux=reverse(data.flux)  
          if ((where(tag_names(data) eq 'ERROR'))[0] ne -1)   then data.error=reverse(data.error)
          if ((where(tag_names(data) eq 'QUALITY'))[0] ne -1) then data.quality=reverse(data.quality)
          if ((where(tag_names(data) eq 'COUNTS'))[0] ne -1)  then data.counts=reverse(data.counts)
          if ((where(tag_names(data) eq 'CNTSERR'))[0] ne -1) then data.cntserr=reverse(data.cntserr)
        endif

if ((where(tag_names(data) eq 'WEIGHTS'))[0] ne -1) and $ 
 ((where(tag_names(data) eq 'BKGD'))[0] ne -1) then begin  ; CalFUSE Ver > 3.0 ==> New Count colomn format
           data1=replicate({wave:0.0,flux:0.0, $  
                            error:0.0,quality:0,counts:0.0,cntserr:0.0},ndata)
           data1.wave   =data.wave   
           data1.flux   =data.flux   
           data1.error  =data.error   
           data1.quality=data.quality   
           data1.counts =data.weights-data.bkgd
           data=data1
endif

;   if ((where(tag_names(data) eq 'COUNTS'))[0] ne -1) and $
;      ((where(tag_names(data) eq 'CNTSERR'))[0] ne -1) then begin
;
;;;;	Reset error to 1 photon when 0 photon detected
;        
;        af=reform(data.flux)
;        ae=reform(data.error)
;        ac=reform(data.counts)
;        ace=reform(data.cntserr)
;        ind=where(ace lt 1.) 
;        if (ind[0] ne -1) then answer=DIALOG_MESSAGE($
;                      [' Reading '+STRMID(infilename,RSTRPOS(infilename,'/')+1),$
;                       'Some pixels have "CNTSERR" less than 1. ',$
;                       '  ',$
;                       'Do you wish to reset the ERROR', $
;                       'to Flux/Counts (=1 photon noise)', $
;                       'for these pixels ??'],QUESTION=1)
;        if answer eq 'Yes' then begin
;          ae[ind]=abs(af[ind]/ac[ind])
;          data.error=reform(ae)
;       endif
;   endif

endelse

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro read_asciifile,ascii,data

	 print,'Reading ascii file:', ascii

;READ THE HEADER
;
         get_lun,unit
         openr,unit,ascii
         line=''
         header_length=0
         repeat begin
            readf,unit,line ;$
            header_length=header_length+1
         endrep $
          until (strmid(line,0,1) ne ';') and (strmid(line,0,1) ne '#') 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ THE FILE USING READ_ASCII IDL PROCEDURE (DOES NOT WORK WITH IDL 5.5 !!)
;
;         close,unit
;         free_lun,unit
;         WIDGET_CONTROL, /HOURGLASS
;  	  r=read_ascii(ascii,data_start=header_length-1)
;         n_col=(size((r.field1),/dimensions))[0]         
;         n_row=(size((r.field1),/dimensions))[1]                
;         a=dblarr(n_col,n_row)
;         a=(r.field1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ THE FILE WITHOUT READ_ASCII IDL PROCEDURE (for IDL Version 5.5) 
;
 ; determine n_row & n_col

    readf,unit,line ;$
    bline = byte(strtrim(strcompress(line),2))
    ptr = where(bline eq 32, num_spaces)
    n_col = num_spaces + 1
    n_row = 2L
    while (not eof(unit)) do begin
          readf,unit,line
          n_row=n_row+1
    endwhile

 ; read data into an array

    print,'Ncol=',n_col,' Nrow=',n_row,' Header_Length=',header_length-1
    a=dblarr(n_col,n_row)
    close,unit
    openr,unit,ascii
    for i=1, header_length-1 do readf,unit,line
    readf,unit,a
    close,unit
    free_lun,unit

;;; put the Array 'a' into 'data' structure

	 if (n_col ge 2) then begin
           data=replicate({wave:(a)[0,0],flux:(a)[1,0],$ 
                            error:0.0,quality:0B,counts:0.0,cntserr:0.0},n_row)
           data.wave=reform((a)[0,*])   
           data.flux=reform((a)[1,*])
           if (n_col ge 3) then data.error=reform((a)[2,*])
           if (n_col ge 4) then data.quality=reform((a)[3,*])
           if (n_col ge 5) then data.counts=reform((a)[4,*])
           if (n_col ge 6) then data.cntserr=reform((a)[5,*])

           if ( (data.wave)[0] gt (data.wave)[1] ) then begin
   	    print,' Reverse the Wave order (w0>w1): '
	    print,'   w0= ',(data.wave)[0]
	    print,'   w1= ',(data.wave)[1]
             data.wave=reverse(data.wave)
             data.flux=reverse(data.flux)
             if (n_col ge 3) then data.error=reverse(data.error)
             if (n_col ge 4) then data.quality=reverse(data.quality)
             if (n_col ge 5) then data.counts=reverse(data.counts)
             if (n_col ge 6) then data.cntserr=reverse(data.cntserr)
           endif
	 endif else print,'the ascii file ',ascii,' must have at least 2 columns'

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function ask_value,message,base_leader

COMMON Ask_Value_comm, result

Base_AskValue=WIDGET_BASE(GROUP_LEADER=base_leader, $
      MODAL=1, $
      ROW=2, $
      MAP=1, $
      TITLE='Value Required', $
      UVALUE='Base_AskValue')

Value_Field= CW_FIELD(  BASE_AskValue, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE=message, $
      UVALUE='Value_Field', $
      XSIZE=20, $
      VALUE=3.)

widget_control,BASE_AskValue,/realize
xmanager,'AskValue',BASE_AskValue

return,result
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro AskValue_event,event

COMMON Ask_Value_comm, result

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 
  'Value_Field': BEGIN ; Event for Value_Field 
         result=event.value
         widget_control,/destroy,event.top
      END
  ENDCASE
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Ask_wmin_wmax_step,wmin,wmax,step,base_leader

COMMON Ask_wmin_wmax_step_comm,wmin_ask,wmax_ask,step_ask

wmin_ask=wmin
wmax_ask=wmax
step_ask=step

Base_AskWWS=WIDGET_BASE(GROUP_LEADER=base_leader, $
      MODAL=1, $
      COLUMN=4, $
      MAP=1, $
      TITLE='Wavelength sampling', $
      UVALUE='Base_AskWWS')

Wmin_Field= CW_FIELD(  BASE_AskWWS, $
      ALL_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Wavelength Min', $
      UVALUE='Wmin_Field', $
      XSIZE=7, $
      VALUE=Wmin)

Wmax_Field= CW_FIELD(  BASE_AskWWS, $
      ALL_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Wavelength Max', $
      UVALUE='Wmax_Field', $
      XSIZE=7, $
      VALUE=Wmax)

Step_Field= CW_FIELD(  BASE_AskWWS, $
      ALL_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Step Size', $
      UVALUE='Step_Field', $
      XSIZE=10, $
      VALUE=Step)

BUTTON_End = WIDGET_BUTTON( BASE_AskWWS, $
      UVALUE='BUTTON_OK', $
      VALUE='OK', $
      XSIZE=60, $
      XOFFSET =10, $
      YSIZE=60)

widget_control,BASE_AskWWS,/realize
xmanager,'Ask_Wmin_Wmax_Step',BASE_AskWWS

wmin=wmin_ask
wmax=wmax_ask
step=step_ask

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Ask_Wmin_Wmax_Step_event,event

COMMON Ask_wmin_wmax_step_comm,wmin_ask,wmax_ask,step_ask

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 
  'Wmin_Field': BEGIN ; Event for Wmin_Field 
         wmin_ask=event.value
;	 Print,'Wmin set to',wmin_ask
      END
  'Wmax_Field': BEGIN ; Event for Wmax_Field 
         wmax_ask=event.value
;	 Print,'Wmax set to',wmax_ask
      END
  'Step_Field': BEGIN ; Event for Step_Field 
         step_ask=event.value
;	 Print,'Step set to',step_ask
      END
  'BUTTON_OK': BEGIN ; Event for BUTTON_OK
         widget_control,/destroy,event.top
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro overplot_button

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
  COMMON FIELD_OverplotFile_Comm,  FIELD_OverplotFile ; Oplot file field 
  COMMON SHIFT_Slider_Over_Pixel_Comm,SHIFT_Slider_Over_Pixel
  COMMON SCALE_Slider_Over_Comm,SCALE_Slider_Over
  COMMON BUTTON_Cross_Comm,BUTTON_Cross

  COMMON BASE_OverPlot_Comm, BASE_OverPlot
  COMMON Main_Comm,MAIN

  BASE_OverPlot = WIDGET_BASE(GROUP_LEADER=MAIN, $
      ROW=2, $
      MAP=1, $
      TITLE='OverPlot', $
      UVALUE='MAIN')

  BASE_OverplotFile = WIDGET_BASE(BASE_Overplot, $
      COLUMN=2, $
      FRAME=1, $
      MAP=1, $
      UVALUE='BASE_OverplotFile')

  BASE_Action_Over = WIDGET_BASE(BASE_OverPlot, $
      ROW=2, $
      MAP=1, $
      UVALUE='BASE_Bottom_Line')

  BASE_RebinShift_Over = WIDGET_BASE(BASE_Action_Over, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_RebinShift_Over')

  BASE_Bottom_Line = WIDGET_BASE(BASE_Action_Over, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_RebinShift_Over')


  BASE_Action_Button = WIDGET_BASE(BASE_Bottom_Line, $
      COLUMN=3, $
      MAP=1, $
      UVALUE='BASE_Action_Bottom')

  BASE_End_Button = WIDGET_BASE(BASE_Bottom_Line, $
      COLUMN=2, $
      MAP=1, $
      XPAD=20, $
      UVALUE='BASE_End_Bottom')

  BASE_Rebin_ShiftPix = WIDGET_BASE(BASE_RebinShift_Over, $
      ROW=3, $
      MAP=1, $
      UVALUE='BASE_Rebin_ShiftPix')

  BASE_Shift_Scale = WIDGET_BASE(BASE_RebinShift_Over, $
      ROW=2, $
      MAP=1, $
      UVALUE='BASE_Shift_Scale')

  BASE_Scale = WIDGET_BASE(BASE_Shift_Scale, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_Scale')

 FieldVal_OverplotFile = STRMID(overname,RSTRPOS(overname,'/')+1) 
  FIELD_OverplotFile = CW_FIELD( BASE_OverplotFile, $
      VALUE=FieldVal_OverplotFile, $
      ROW=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='OverPlot File :', $
      UVALUE='FIELD_OverplotFile', $
      XSIZE=25, $
      YSIZE=1)

  BUTTON_SearchOverplotFile = WIDGET_BUTTON( BASE_OverplotFile, $
      UVALUE='BUTTON_SearchOverplotFile', $
      VALUE='Search File', $
      XSIZE=100, $
      YSIZE=30)

  REBIN_SLIDER_OVER = WIDGET_SLIDER( BASE_Rebin_ShiftPix, $
      MAXIMUM=40, $
      MINIMUM=1, $
      TITLE='Rebin', $
      UVALUE='REBIN_SLIDER_OVER', $
      XSIZE=140, $
      SCROLL=1, $
      VALUE=1)

  SMOOTH_SLIDER_OVER = WIDGET_SLIDER( BASE_Rebin_ShiftPix, $
      MAXIMUM=20, $
      MINIMUM=0, $
      TITLE='Smooth', $
      UVALUE='SMOOTH_SLIDER_OVER', $
      SCROLL=1, $
      XSIZE=140, $
      VALUE=0)

  SHIFT_SLIDER_OVER_PIXEL = WIDGET_SLIDER( BASE_Rebin_ShiftPix, $
      MAXIMUM= 40, $
      MINIMUM=-40, $
      TITLE='Shift in Pixel', $
      UVALUE='SHIFT_SLIDER_OVER_PIXEL', $
      XSIZE=140, $
      SCROLL=1, $
      VALUE=0)  

  SHIFT_SLIDER_OVER = CW_FSLIDER( BASE_Shift_Scale, $
      EDIT=1, $
      MAXIMUM= 200., $
      MINIMUM=-200., $
      TITLE='Shift', $
      UVALUE='SHIFT_SLIDER_OVER', $
      XSIZE=240, $
      VALUE=0.)

  SCALE_SLIDER_OVER = CW_FSLIDER( BASE_Scale, $
      EDIT=1, $
      MAXIMUM= 10., $
      MINIMUM=  0., $
      TITLE='Scale', $
      UVALUE='SCALE_SLIDER_OVER', $
      XSIZE=100, $
      VALUE=1.)
  
  SCALE_MAX_OVER= CW_FIELD(  BASE_Scale, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Scale Max', $
      UVALUE='SCALE_MAX_OVER', $
      XSIZE=7, $
      VALUE=10.)

  BUTTON_CONVOL = WIDGET_BUTTON( BASE_Action_Button, $
      UVALUE='BUTTON_CONVOL', $
      VALUE='Gauss Convol', $
      XSIZE=100, $
      YSIZE=50)

  BUTTON_Divide = WIDGET_BUTTON( BASE_Action_Button, $
      UVALUE='BUTTON_Divide', $
      VALUE='Divide', $
      XSIZE=100, $
      YSIZE=50)

  BUTTON_Cross = WIDGET_BUTTON( BASE_Action_Button, $
      UVALUE='BUTTON_Cross', $
      VALUE='Find Shift', $
      XOFFSET =10, $
      XSIZE=100, $
      YSIZE=50)

  BUTTON_End = WIDGET_BUTTON( BASE_End_Button, $
      UVALUE='BUTTON_End', $
      VALUE='End', $
      XSIZE=100, $
      YSIZE=50)

	widget_control,BASE_OverPlot,/realize
	xmanager,'OverPlot',BASE_OverPlot

        if overname ne '' then begin
           read_data,overname,data0_o
           data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
           replot,data,infilename,wmin,wmax,plotname
        endif

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro OverPlot_event,event

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
  COMMON BASE_OverPlot_Comm, BASE_OverPlot
  COMMON FIELD_OverplotFile_Comm,  FIELD_OverplotFile ; Oplot file field 
  COMMON FIELD_ShiftFile_Comm,  FIELD_ShiftFile  ; Shift File Field  : shiftfile

  COMMON SCALE_Slider_Over_Comm,SCALE_Slider_Over
  COMMON SHIFT_Slider_Over_Pixel_Comm,SHIFT_Slider_Over_Pixel

  COMMON ADDEXPO_Comm,addexpo_on
  COMMON ShiftFile_Comm,shiftfile

  COMMON Data_Name_Comm, nam  

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'FIELD_OverplotFile': BEGIN ; Event for Over Filename
      actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
      overname=actual_path+Event.Value
      print,' The OverPlot file is set to : ',overname
;      overplot_on=1
      read_data,overname,data0_o
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      replot,data,infilename,wmin,wmax,plotname
 ; Update the FIELD_ShiftFile: 
        actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
        shiftfile_nopath='shift_'+ $
        STRMID(overname,RSTRPOS(overname,'/')+12, 5)+'.list'
        shiftfile=actual_path+shiftfile_nopath
      if addexpo_on then begin
        WIDGET_CONTROL, FIELD_ShiftFile, SET_VALUE=shiftfile_nopath
      endif
      END

  'BUTTON_SearchOverplotFile': BEGIN ; Event for Search Over Filename
      getfile,overname,'*',/read,field_to_updated=FIELD_OverplotFile
      if overname ne '' then begin
        print,' The OverPlot file is set to : ',overname
        overplot_on=1
        read_data,overname,data0_o
        data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
        replot,data,infilename,wmin,wmax,plotname
 ; Update the FIELD_ShiftFile: 
          actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
          shiftfile_nopath='shift_'+ $
          STRMID(overname,RSTRPOS(overname,'/')+12, 5)+'.list'
          shiftfile=actual_path+shiftfile_nopath
        if addexpo_on EQ 1 then begin
          WIDGET_CONTROL, FIELD_ShiftFile, SET_VALUE=shiftfile_nopath
        endif
      endif
      END

  'REBIN_SLIDER_OVER': BEGIN ; Event for Rebin_Over
      rebin_o=Event.Value
      print,'rebin Over=',rebin_o
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname      
      END

  'SMOOTH_SLIDER_OVER': BEGIN ; Event for Smooth_Over
      smooth_o=Event.Value
      print,'Smooth Over=',smooth_o
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname      
      END

  'SHIFT_SLIDER_OVER': BEGIN ; Event for Shift_Over
      shift_o=Event.Value
      print,'shift Over=',shift_o
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'SHIFT_SLIDER_OVER_PIXEL': BEGIN ; Event for Shift_Over_Pixel
      shift_o_p=Event.Value
      print,'shift Over in Pixel=',shift_o_p
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'SCALE_SLIDER_OVER': BEGIN ; Event for Scale_Over
      scale_o=Event.Value
      print,'scale Over=',scale_o
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'SCALE_MAX_OVER': BEGIN ; Event for Scale_Over
      if Event.Value gt 0. then begin 
       scale_max=Event.Value
       print,'scale Max=',scale_max
       set_slider_min_max,SCALE_Slider_Over,SCALE_Slider_Over,0.,scale_max
      endif
      END

  'BUTTON_CONVOL': BEGIN ; Event for button CONVOL
      print,'Convol the overplotted data with a gaussian'
      psf_width=ask_value( $
         'Enter the Gaussian FWHM to convol the Overplotted Data', $
                        BASE_OverPlot)
      print,'of size =',psf_width

      fwhm=psf_width/1.66511

      nap=2*fix(1+2*fwhm)+1
      ainst=dblarr(nap)
      binst=dblarr(nap)
      for k=0,nap-1 do begin
        ainst(k)=float(k+1  - (nap+1)/2)
        binst(k)=exp(-(ainst(k)^2)/(fwhm^2))
      endfor

      psf=binst(where(binst ne 0.))
      psf=psf/total(psf)
      nf=reform(data_o.flux)
      nf=convol(nf,psf,edge_truncate=1)
      data_o.flux=reform(nf)  

      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'BUTTON_Divide': BEGIN ; Event for button Divide
      print,'Divide the plotted data with the overplotted data'
      normalize,data,data_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'BUTTON_Cross': BEGIN ; Event for button Cross
      print,'Try to find the best shift for overplotted data by cross-correlation'
      WIDGET_CONTROL, /HOURGLASS

        cross_overplot,wmin,wmax,best_shift,shift_range

      shift_o_p=best_shift
      print,'shift Over in Pixel=',shift_o_p
      WIDGET_CONTROL, SHIFT_Slider_Over_Pixel, Set_value=shift_o_p
      data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
      if (output_mode eq 0) then $
          plot_data,data,infilename,wmin,wmax,output_mode,plotname
      END

  'BUTTON_End': BEGIN ; Event for button End
     widget_control,/destroy,event.top
     overplot_on=0
     replot,data,infilename,wmin,wmax,plotname
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro addexpo_button

  COMMON FIELD_ShiftFile_Comm,  FIELD_ShiftFile  ; Shift File Field  : shiftfile
  COMMON ShiftFile_Comm,shiftfile

  COMMON BASE_AddExpo_Comm, BASE_AddExpo
  COMMON Main_Comm,MAIN

  BASE_AddExpo = WIDGET_BASE(GROUP_LEADER=MAIN, $
      ROW=4, $
      MAP=1, $
      TITLE='AddExpo', $
      UVALUE='MAIN')

  BASE_ShiftFile = WIDGET_BASE(BASE_AddExpo, $
      ROW=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_ShiftFile')

  BASE_SelectShiftFile = WIDGET_BASE(BASE_ShiftFile, $
      COLUMN=2, $
;      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_SelectShiftFile')

  BASE_ShowShiftFile = WIDGET_BASE(BASE_ShiftFile, $
      COLUMN=2, $
;      FRAME=2, $
      MAP=1, $
      YPAD=20, $
      UVALUE='BASE_ShowShiftFile')

  BASE_WithOverPlot = WIDGET_BASE(BASE_AddExpo, $
      ROW=2, $
      FRAME=1, $
      MAP=1, $
      YPAD=20, $
      UVALUE='BASE_WithOverPlot')

  BASE_Action = WIDGET_BASE(BASE_AddExpo, $
      COLUMN=2, $
      FRAME=1, $
      MAP=1, $
      YPAD=20, $
      UVALUE='BASE_Action')

     FieldVal_ShiftFile =STRMID(Shiftfile,RSTRPOS(Shiftfile,'/')+1) 
  FIELD_ShiftFile = CW_FIELD( BASE_SelectShiftFile, $
      VALUE=FieldVal_ShiftFile, $
      COLUMN=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='Shift File List:', $
      UVALUE='FIELD_ShiftFile', $
      XSIZE=31, $
      YSIZE=1)

  BUTTON_SearchShiftFile = WIDGET_BUTTON( BASE_SelectShiftFile, $
      UVALUE='BUTTON_SearchShiftFile', $
      VALUE='Search File', $
      XSIZE=80, $
      YSIZE=30)

  BUTTON_SHOW_SHIFT_LIST = WIDGET_BUTTON(BASE_ShowShiftFile, $
      UVALUE='BUTTON_SHOW_SHIFT_LIST', $
      VALUE='Show File', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_XEDIT_SHIFT_LIST = WIDGET_BUTTON(BASE_ShowShiftFile, $
      UVALUE='BUTTON_XEDIT_SHIFT_LIST', $
      VALUE='XEdit File', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_PREVIOUS_FILE = WIDGET_BUTTON(BASE_WithOverPlot, $
      UVALUE='BUTTON_PREVIOUS_FILE',$
      VALUE='Previous Spectrum in OverPlot', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_NEXT_FILE = WIDGET_BUTTON(BASE_WithOverPlot, $
      UVALUE='BUTTON_NEXT_FILE',$
      VALUE='Next Spectrum in OverPlot', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_ADD_TO_SHIFT_LIST = WIDGET_BUTTON(BASE_WithOverPlot, $
      UVALUE='BUTTON_ADD_TO_SHIFT_LIST', $
      VALUE='Add OverPlot to Shift File List', $
      XSIZE=400, $
      YSIZE=50)

  BUTTON_ShiftAdd = WIDGET_BUTTON( BASE_Action, $
      UVALUE='BUTTON_ShiftAdd', $
      VALUE='Execute Shift & Add', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_ShiftAdd_Resample = WIDGET_BUTTON( BASE_Action, $
      UVALUE='BUTTON_ShiftAdd_Resample', $
      VALUE='Execute Resample Shift & Add', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_AllShiftAdd = WIDGET_BUTTON( BASE_Action, $
      UVALUE='BUTTON_AllShiftAdd', $
      VALUE='Execute All Shift & Add', $
      XSIZE=200, $
      YSIZE=50)

  BUTTON_End = WIDGET_BUTTON( BASE_Action, $
      UVALUE='BUTTON_End', $
      VALUE='End', $
      XSIZE=150, $
      YSIZE=50)

	widget_control,BASE_AddExpo,/realize
	xmanager,'addexpo',BASE_AddExpo
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro addexpo_event,event

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

  COMMON FIELD_DataFile_Comm,  FIELD_DataFile  ; Data file field  : infilename 
  COMMON FIELD_AsciiFile_Comm, FIELD_AsciiFile ; Ascii file field : outfilename
  COMMON FIELD_ShiftFile_Comm,  FIELD_ShiftFile  ; Shift File Field  : shiftfile
  COMMON ShiftFile_Comm,         shiftfile

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
  COMMON FIELD_OverplotFile_Comm,  FIELD_OverplotFile ; Oplot file field 
  COMMON ADDEXPO_Comm,addexpo_on

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'FIELD_ShiftFile': BEGIN ; Event for Shift filename
      actual_path=STRMID(ShiftFile,0,RSTRPOS(ShiftFile,'/')+1)
      shiftfile=(actual_path+Event.Value)[0]
      print,' The Shift file is set to : ',shiftfile
      END

  'BUTTON_SearchShiftFile': BEGIN ; Event for Search Shift Filename
       getfile,shiftfile,'*.list*',/read,field_to_updated=FIELD_ShiftFile
       print,' The Shift file is set to : ',shiftfile
      END

  'BUTTON_ShiftAdd': BEGIN
      print, 'OK: reading and executing shift file : ',shiftfile
      WIDGET_CONTROL, /HOURGLASS

;;;;;;;;;
;;
;;

      add_expo_file_list,shiftfile,data

;;
;;
;;;;;;;;;
;;
;   Shift_Optimize,wmin,wmax,shiftfile
;   shiftfile_Optimized=shiftfile+'_Optimized'
;   add_expo_file_list,shiftfile_Optimized,data
;;
;;;;;;;;;

      infilename=shiftfile+'_Add_Expo'
      filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
      WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
      first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
      END

  'BUTTON_ADD_TO_SHIFT_LIST': BEGIN ; Event for button Add_to_shift_list 
      if (overplot_on eq 0) then begin
          z=Dialog_message('The OverPlot Window is not Active',/error)
      endif else begin 
       get_lun,unit
        openw,unit,shiftfile,/append
         print,overname,' added to Shift File List: ',shiftfile
         writeu,unit,overname,' ',strtrim(string(shift_o_p),1)
         printf,unit,''
        close,unit
       free_lun,unit
      endelse
      END

  'BUTTON_XEDIT_SHIFT_LIST': BEGIN ; Event for button Xedit_shift_list
      Edit_ShiftFile='xedit '+shiftfile
      SPAWN, Edit_ShiftFile 
      END

  'BUTTON_SHOW_SHIFT_LIST': BEGIN ; Event for button Show_shift_list
      Xdisplayfile,shiftfile,title=STRMID(shiftfile,RSTRPOS(shiftfile,'/')+1)
      END

  'BUTTON_PREVIOUS_FILE': BEGIN ; Event for button Previous_file
      if (overplot_on eq 0) then begin
          z=Dialog_message('The OverPlot Window is not Active',/error)
      endif else begin 
       overname_nopath=STRMID(overname,RSTRPOS(overname,'/')+1)
       exposure=STRMID(overname_nopath, 8, 3)

       ON_IOERROR, Previous_number_undefined  
       nextexpo=exposure-1

       if (nextexpo ne 0) then begin
      
         beginname=STRMID(overname_nopath, 0, 8)
         endname=STRMID(overname_nopath, 11)
         nextexposure=(['00','0',''])[fix(alog10(nextexpo))]+STRTRIM(nextexpo,1)
         nextfile_nopath=beginname+nextexposure+endname
         actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
         nextfile=actual_path+nextfile_nopath

         if ( (size(findfile(nextfile)))[0] ne 0 ) then begin
           overname=nextfile
           print,' The next OverPlot file is set to : ', overname
           overplot_on=1
           read_data,overname,data0_o
           data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
           replot,data,infilename,wmin,wmax,plotname
           WIDGET_CONTROL, FIELD_OverplotFile, SET_VALUE=nextfile_nopath
         endif else begin
           z=Dialog_message([nextfile+':',$
                           'File not found'],/error)
         endelse

      endif else begin
      Previous_number_undefined: 
       z=Dialog_message(['Exposure Number no Defined', $
                      'File name not found'],/error)
      endelse
     endelse
     END

  'BUTTON_NEXT_FILE': BEGIN ; Event for button Next_file
      if (overplot_on eq 0) then begin
          z=Dialog_message('The OverPlot Window is not Active',/error)
      endif else begin 
       overname_nopath=STRMID(overname,RSTRPOS(overname,'/')+1)
       exposure=STRMID(overname_nopath, 8, 3)

       ON_IOERROR, next_number_undefined  
       nextexpo=exposure+1

       if (nextexpo ne 0) then begin
      
         beginname=STRMID(overname_nopath, 0, 8)
         endname=STRMID(overname_nopath, 11)
         nextexposure=(['00','0',''])[fix(alog10(nextexpo))]+STRTRIM(nextexpo,1)
         nextfile_nopath=beginname+nextexposure+endname
         actual_path=STRMID(overname,0,RSTRPOS(overname,'/')+1)
         nextfile=actual_path+nextfile_nopath

         if ( (size(findfile(nextfile)))[0] ne 0 ) then begin
           overname=nextfile
           print,' The next OverPlot file is set to : ', overname
           overplot_on=1
           read_data,overname,data0_o
           data_process,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o
           replot,data,infilename,wmin,wmax,plotname
           WIDGET_CONTROL, FIELD_OverplotFile, SET_VALUE=nextfile_nopath
         endif else begin
           z=Dialog_message([nextfile+':',$
                          'File not found'],/error)
         endelse

      endif else begin
      next_number_undefined:
       z=Dialog_message(['Exposure Number no Defined', $
                      'File name not found'],/error)
      endelse
     endelse
     END

  'BUTTON_AllShiftAdd': BEGIN ; Event for BUTTON_AllShiftAdd 
     get_lun,unit
      openw,unit,'allfichier_shift'
        PRINTf,unit,FORMAT = '(A,$)',FINDFILE('*.list')
        PRINTf,unit,FORMAT ='(A,/)',''
      close,unit
     free_lun,unit
; add the file from file_list
     OPENR, unit, 'allfichier_shift', /GET_LUN, /delete ;Open the text file.
     shiftfile_to_add = '' 
      READF, unit, shiftfile_to_add ;Read the first line.
      WHILE NOT EOF(unit) DO BEGIN ;While there is text left, output it.
         PRINT, 'shiftfile_to_add: ',shiftfile_to_add
         add_expo_file_list,shiftfile_to_add,data
         infilename=shiftfile_to_add+'_Add_Expo'
         filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
         WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
         first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
; write result in ascii file -> filename.dat   
         parts = STR_SEP(filename_nopath, '.')
         outfilename=parts[0]+'.dat'
         WIDGET_CONTROL, FIELD_AsciiFile,SET_VALUE= outfilename
         create_ascii,data,infilename,outfilename,content,wmin,wmax
         READF, unit, shiftfile_to_add 
      ENDWHILE
     close,unit 
      print,'Done'
     END

'BUTTON_ShiftAdd_Resample': BEGIN  ; Event for BUTTON_ShiftAdd_Resample   
      print, 'OK: reading and executing shift file : ',shiftfile
      WIDGET_CONTROL, /HOURGLASS
      add_expo_resample,shiftfile,data
      infilename=shiftfile+'_Add_Expo'
      filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
      WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
      first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
      END

  'BUTTON_End': BEGIN ; Event for button End
     addexpo_on=0
     widget_control,/destroy,event.top
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Find_Lines_button

  COMMON Find_lines_Status_Comm,Find_Lines_on
  COMMON Find_Lines_Input,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,TH2_FL,fH2_FL,Rad_vel_FL
  COMMON Find_Lines_Output,Lambda_tab, lbl_tab, Eqw_tab, Comp_tab

  COMMON Main_Comm,MAIN
  COMMON BASE_Find_Lines_Comm, BASE_Find_Lines
  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  Find_Lines_on=1
  Wmin_FL=900.
  Wmax_FL=1200.
  Eqw_FL=0.01
  NHI_FL=[1.e22,1.e00]
;  J_FL=[5,-1]
  TH2_FL=[3000.,100.]
  fH2_FL=[0.5,0.]
  Rad_vel_FL=[0.,0.]

  BASE_Find_Lines = WIDGET_BASE(GROUP_LEADER=MAIN, $
      ROW=3, $
      MAP=1, $
      TITLE='Find Lines', $
      UVALUE='MAIN')

  BASE_First_Line = WIDGET_BASE(BASE_Find_Lines, $
      COLUMN=3, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_First_Line')

  BASE_Second_Line = WIDGET_BASE(BASE_Find_Lines, $
      COLUMN=4, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_Second_Line')

  BASE_Third_Line = WIDGET_BASE(BASE_Find_Lines, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_Second_Line')

  BASE_Third_Line_Left = WIDGET_BASE(BASE_Third_Line , $
      COLUMN=4, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_Second_Line')

  BASE_Third_Line_Right = WIDGET_BASE(BASE_Third_Line , $
      COLUMN=1, $
      MAP=1, $
      UVALUE='BASE_Second_Line')

  Wmin_Field= CW_FIELD(  BASE_First_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='W Min', $
      UVALUE='Wmin_Field', $
      XSIZE=7, $
      VALUE=Wmin_FL)

  Wmax_Field= CW_FIELD(  BASE_First_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='W Max', $
      UVALUE='Wmax_Field', $
      XSIZE=7, $
      VALUE=Wmax_FL)

  Eqw_Field= CW_FIELD(  BASE_First_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Eq W Min', $
      UVALUE='Eqw_Field', $
      XSIZE=7, $
      VALUE=Eqw_FL)

  N_HI_Field_1= CW_FIELD(  BASE_Second_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='N_HI', $
      UVALUE='N_HI_1', $
      XSIZE=12, $
      VALUE=NHI_FL[0])

  Rad_Vel_Field_1= CW_FIELD(  BASE_Second_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Rad.Vel.', $
      UVALUE='Rad_Vel_1', $
      XSIZE=7, $
      VALUE=Rad_vel_FL[0])

;J_Field_1= CW_FIELD(  BASE_Second_Line, $
;      RETURN_EVENTS=1, $
;      INTEGER=1, $
;      COLUMN=1, $
;      TITLE='J_H2 max', $
;      UVALUE='J_1', $
;      XSIZE=7, $
;      VALUE=J_FL[0])

  TH2_Field_1= CW_FIELD(  BASE_Second_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Temp. H2', $
      UVALUE='TH2_1', $
      XSIZE=7, $
      VALUE=TH2_FL[0])

  fH2_Field_1= CW_FIELD(  BASE_Second_Line, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='f H2', $
      UVALUE='fH2_1', $
      XSIZE=7, $
      VALUE=fH2_FL[0])

  N_HI_Field_2= CW_FIELD(  BASE_Third_Line_Left, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='N_HI', $
      UVALUE='N_HI_2', $
      XSIZE=12, $
      VALUE=NHI_FL[1])

  Rad_Vel_Field_2= CW_FIELD(  BASE_Third_Line_Left, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Rad.Vel.', $
      UVALUE='Rad_Vel_2', $
      XSIZE=7, $
      VALUE=Rad_vel_FL[1])

;J_Field_2= CW_FIELD(  BASE_Third_Line_Left, $
;      RETURN_EVENTS=1, $
;      INTEGER=1, $
;      COLUMN=1, $
;      TITLE='J_H2 max', $
;      UVALUE='J_2', $
;      XSIZE=7, $
;      VALUE=J_FL[1])

  TH2_Field_2= CW_FIELD(  BASE_Third_Line_Left, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='Temp. H2', $
      UVALUE='TH2_2', $
      XSIZE=7, $
      VALUE=TH2_FL[1])

  fH2_Field_2= CW_FIELD(  BASE_Third_Line_Left, $
      RETURN_EVENTS=1, $
      FLOATING=1, $
      COLUMN=1, $
      TITLE='f H2', $
      UVALUE='fH2_2', $
      XSIZE=7, $
      VALUE=fH2_FL[1])

  BUTTON_End = WIDGET_BUTTON( BASE_Third_Line_Right, $
      UVALUE='BUTTON_END', $
      VALUE='END', $
      XSIZE=60, $
      XOFFSET =10, $
      YSIZE=60)

         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
;;               J_H2_max=J_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname

	widget_control,BASE_Find_Lines,/realize
	xmanager,'Find_Lines',BASE_Find_Lines
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Find_Lines_event,event

  COMMON Find_lines_Status_Comm,Find_Lines_on
  COMMON Find_Lines_Input,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,TH2_FL,fH2_FL,Rad_vel_FL
  COMMON Find_Lines_Output,Lambda_tab, lbl_tab, Eqw_tab, Comp_tab

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'Wmin_Field': BEGIN ; Event for Wmin_Field 
         Wmin_FL=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'Wmax_Field': BEGIN ; Event for Wmax_Field 
         Wmax_FL=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'Eqw_Field': BEGIN
         Eqw_FL=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'N_HI_1': BEGIN
         NHI_FL[0]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'Rad_Vel_1': BEGIN
         Rad_vel_FL[0]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'J_1': BEGIN
         J_FL[0]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'TH2_1': BEGIN
         TH2_FL[0]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'fH2_1': BEGIN
         fH2_FL[0]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'N_HI_2': BEGIN
         NHI_FL[1]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'Rad_Vel_2': BEGIN
         Rad_vel_FL[1]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'J_2': BEGIN
         J_FL[1]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'TH2_2': BEGIN
         TH2_FL[1]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'fH2_2': BEGIN
         fH2_FL[1]=event.value
         WIDGET_CONTROL, /HOURGLASS
         find_lines,Wmin_FL,Wmax_FL,NHI_FL,Eqw_FL,    $
               T_H2=TH2_FL,fH2=FH2_FL,Rad_vel=Rad_vel_FL, $ 
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab
         replot,data,infilename,wmin,wmax,plotname
      END

  'BUTTON_END': BEGIN ; Event for button End
         Find_lines_on=0
         replot,data,infilename,wmin,wmax,plotname
         widget_control,/destroy,event.top
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro find_lines,w1,w2,NHI,Eqw_min,    $
               Z=z,ATOMIC=atomic,FH2=fh2,Rad_vel=Rad_vel,T_H2=T_H2,OUT=out, $ 
               J_H2_max=J_H2_max, $
               Lambda_tab=Lambda_tab, lbl_tab=lbl_tab, Eqw_tab=Eqw_tab, Comp_tab=Comp_tab

if (n_params() lt 4) then begin
 print,'ERROR: Find_lines must me called with at least 4 parameters'
 return
endif

if (n_elements(z) le 0) then z=[1.,1.]
;if (n_elements(Rad_vel) le 0) then Rad_vel=0.
if (n_elements(atomic) le 0) then atomic='AtomicData.d'
if (n_elements(fh2) le 0) then fh2=1.0

 get_lun,unit
 openr,unit,atomic,error=err
 close,unit
 free_lun,unit
 if (err ne 0) then begin
   print,' ERROR:: file ',atomic,' not found !'
   print,' EXIT FROM FIND_LINES.'
   return
 endif

elt_list=['H ','D ','He','Li','Be','B ','C ','N ','O ','F ', $
          'Ne','Na','Mg','Al','Si','P ','S ','Cl','Ar','K ', $
          'Ca','Sc','Ti','V ','Cr','Mn','Fe','Co','Ni','Cu', $
          'Zn','Ga','Ge','H2','Ha','HD','CH']

N_NH=[   12.00,7.1,10.99,3.31,1.42,2.88,8.56,8.05,8.93,4.48, $
          8.09,6.31,7.59,6.48,7.55,5.57,7.27,5.27,6.56,5.13, $
          6.34,3.09,4.93,4.02,5.68,5.53,7.51,4.91,6.25,4.27, $
          4.65,3.13,3.63,12.00,12.00,7.00,4.00]

ion_1= [0,0,0,1,1, 1,3,4,5,0, 0,1,1,2,3,  4,2,2,0,1, 1,1,2,2,2, 1,2,1,1,1, $
        1,1,1,0,0, 0,1]


k=0
Lambda_tab=dblarr(10000)
lbl_tab=strarr(10000)
Eqw_tab=dblarr(10000)
Comp_tab=intarr(10000)

ch8=''
n_comp=n_elements(NHI)-1

for comp=0,n_comp do begin
 get_lun,unit
 openr,unit,atomic,error=err

while (not eof(unit)) do begin
  readf,unit,lambda,ch8,mss,fs,tr,format='(F9.4,X,A8,X,I3,2(X,E10.3))'
  if ((lambda ge w1) and (lambda le w2)) then begin  

    elt=strmid(ch8,0,2)
;    if ((elt ne 'CO') and (elt ne 'HD')) then begin
    if (elt ne 'CO') then begin

     ion=0
     ionization=strmid(ch8,2,2)
     if ((ionization eq 'I ') or (ionization eq 'I*')) then ion=0
     if (ionization eq 'II') then begin
       ionization=strmid(ch8,2,3)
       if (ionization eq 'II ') then ion=1
       if (ionization eq 'III') then ion=2
      endif
     if (ionization eq 'IV') then ion=3
     if (ionization eq 'V ') then ion=4
     if (ionization eq 'VI') then ion=5
 
    lbl=strtrim(ch8,2)
    excitation_correction=1.
;    if ((strpos(ch8,'*') ne -1) or (strpos(ch8,'er') ne -1)) then $
;     if (elt ne 'C ') then excitation_correction=0.1

    if ((elt eq 'H2') or (elt eq 'Ha')) then begin
      if (strmid(ch8,4,1) eq 'A') then JLevel=10 else JLevel=fix(strmid(ch8,4,1))
      if (n_elements(J_H2_max) le 0) then begin
        T_J=[0,170.5,510.0,1015.2,1681.7,2503.8,3474.4,4686.4,5829.8,7196.99,8677.32d0]
        g_J=[1,9,5,21,9,33,13,45,17,57,21]        
        if (n_elements(T_H2) le 0) then T_H2=100.
        excitation_correction=g_J[JLevel]*exp(-T_J[JLevel]/T_H2[comp]) /  $ 
                                total(g_J*exp(-T_J/T_H2[comp]))
      endif else begin 
        if (JLevel le J_H2_max[comp]) then excitation_correction=1. $
                                      else excitation_correction=0.
      endelse
      excitation_correction=excitation_correction*fH2[comp]
      lbl=elt+strtrim(string(JLevel),2)
    endif

    if (elt eq 'HD') then begin
      JLevel=fix(strmid(ch8,4,1))
      if (n_elements(J_H2_max) le 0) then begin
        T_J=[0,128.,384.,766.,1271.,1895.,2636.,3486.,4445.,5511.]
        g_J=[1,3,5,7,9,11,13,15,17,19]
        if (n_elements(T_H2) le 0) then T_H2=100.
        excitation_correction=g_J[JLevel]*exp(-T_J[JLevel]/T_H2[comp]) /  $ 
                                total(g_J*exp(-T_J/T_H2[comp]))
      endif else begin 
        if (JLevel le J_H2_max[comp]) then excitation_correction=1. $
                                      else excitation_correction=0.
      endelse
      excitation_correction=excitation_correction*fH2[comp]
      lbl=elt+strtrim(string(JLevel),2)
    endif

    j=where(elt eq elt_list,count)
    if (count ne 0) then begin 
      j=j[0]
      if (ion le ion_1[j]) then begin
       
        Eqw=10^(N_NH[j]-12.+aLog10(lambda^2*fs)+aLog10(NHI[comp]*z[comp])-20.053)

        Eqw=Eqw*excitation_correction

        if (Eqw ge Eqw_min) then begin
          lambda_tab[k]=lambda*(1.+rad_vel[comp]/3.e5)
          lbl_tab[k]=lbl
          Eqw_tab[k]=Eqw
          Comp_tab[k]=comp          
          k=k+1
        endif
      endif
    endif
  endif
endif
endwhile
close,unit
free_lun,unit
endfor

if (k ne 0) then begin
 lambda_tab=lambda_tab[0:k-1]
 lbl_tab=lbl_tab[0:k-1]
 Eqw_tab=Eqw_tab[0:k-1]
 Comp_tab=Comp_tab[0:k-1]
endif else print,' WARNING: Find_lines: No lines found'

s=sort(lambda_tab)
Lambda_tab=Lambda_tab[s]
lbl_tab=lbl_tab[s]
Eqw_tab=Eqw_tab[s]
Comp_tab=Comp_tab[s]

if (keyword_set(out) or (1 eq 1)) then for k=0,n_elements(lambda_tab)-1 do $ 
   print,Lambda_tab[k],'  ',lbl_tab[k],Eqw_tab[k],Comp_tab[k]

print,'--'

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Oplot_Find_lines

  COMMON Find_Lines_Output,Lambda_tab, lbl_tab, Eqw_tab, Comp_tab

ymin=!y.crange[0]
ymax=!y.crange[1]
dy=(ymax-ymin)/20.

ilin_max=n_elements(Lambda_tab)-1
for ilin=0,ilin_max do begin
  lda=Lambda_tab[ilin]
  if (!x.crange[1] lt 10.) then lda=lda*1d-4

  if ((lda ge !x.crange[0]) and (lda le !x.crange[1])) then begin
   lbl_elt=lbl_tab[ilin]

   color_plot=2+Comp_tab[ilin]
   y1_tick=ymax-(2.4+1.9*Comp_tab[ilin])*dy
   y2_tick=ymax-(0.6+2.7*Comp_tab[ilin])*dy
   y_label=ymax-(-0.3+3.3*Comp_tab[ilin])*dy
   oplot,[lda,lda],[y1_tick,y2_tick]
;;; COLOR BUG;   oplot,[lda,lda],[y1_tick,y2_tick],color=color_plot
;;; COLOR BUG;   xyouts,lda,y_label,lbl_elt,charsize=1.0,$
;;; COLOR BUG;      charthick=1.5,orientation=90., color=color_plot
   xyouts,lda,y_label,lbl_elt,charsize=1.0,$
      charthick=1.5,orientation=90.
  endif
endfor

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Cite_Lemoine

 get_lun,unit
 openr,unit,'Cite_Lemoine',error=err
 close,unit
 free_lun,unit
 if (err ne 0) then begin 
  statement=['If Martin Lemoine''s Fit Program is used for a published work,',$
    'the following standard acknowledgment should be inserted',$
    'at the end of the paper:',$
    '"This work has been done using the profile fitting procedure Owens.f', $
    'developed by M. Lemoine and the FUSE French Team."']
  Print,"DO NOT FORGET TO GIVE APPROPRIATE ACKNOLEDGEMENT TO Dr. M.LEMOINE"
  Print,statement
  z=Dialog_message(['RECALL ! ',statement],title='RECALL !')
 get_lun,unit
 openw,unit,'Cite_Lemoine',error=err
 if (err eq 0) then printf,unit,statement
 close,unit
 free_lun,unit
 endif

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Cite_Roueff

 get_lun,unit
 openr,unit,'Cite_Roueff',error=err
 close,unit
 free_lun,unit
 if (err ne 0) then begin 
  statement=['If E. Roueff''s table of molecular transition is used for a published work,',$
    'an acknowledgment should be inserted with reference to the papers.',$
    'The wavelengths and oscillator strengths are computed ',$
    'from Abgrall H. et al. A&AS 101, 273 (1993) for the Lyman system ',$
    'and  Abgrall H. et al. A&AS 101, 323 (1993) for the Werner system.', $  
    'The inverses of the total radiative lifetimes are reported in ',$ 
    'Abgrall H., Roueff E. & Drira I., 2000, A&AS 141, 297.', $
    ' ',$
    'The data for atomic transitions are from Morton D.C., 1991, ApJS 77, 119',$
    'and the D.C. Morton web site www.hia.nrc.ca/staff/dcm/atomic_data.html']
  Print,'DO NOT FORGET TO GIVE APPROPRIATE ACKNOLEDGEMENT'
  Print,' TO Dr. E. ROUEFF AND D. MORTON'
  Print,''
  Print,statement
  z=Dialog_message(['RECALL ! ',statement],title='RECALL !')
 get_lun,unit
 openw,unit,'Cite_Roueff',error=err
 if (err eq 0) then  printf,unit,statement
 close,unit
 free_lun,unit
 endif

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro moses_button

  COMMON FIELD_FitFile_Comm,  FIELD_FitFile  ; Fit File Field  : fitfile
  COMMON FitFile_Comm,         fitfile

  COMMON Main_Comm,MAIN
  
  BASE_Moses = WIDGET_BASE(GROUP_LEADER=MAIN, $
      MODAL=1, $
      ROW=2, $
      MAP=1, $
      TITLE='Plot Fit', $
      UVALUE='MAIN')

  BASE_FitFile = WIDGET_BASE(BASE_Moses, $
      COLUMN=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_FitFile')

  BASE_Button = WIDGET_BASE(BASE_Moses, $
      COLUMN=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_Button')

  FieldVal_FitFile =STRMID(fitfile,RSTRPOS(fitfile,'/')+1)
  FIELD_FitFile = CW_FIELD( BASE_FitFile, $
      VALUE=FieldVal_FitFile, $
      ROW=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='Fit File :', $
      UVALUE='FIELD_FitFile', $
      XSIZE=31, $
      YSIZE=1)

  BUTTON_SearchFitFile = WIDGET_BUTTON( BASE_FitFile, $
      UVALUE='BUTTON_SearchFitFile', $
      VALUE='Search File', $
      XSIZE=80, $
      YSIZE=30)

  BUTTON_Cancel = WIDGET_BUTTON( BASE_Button, $
      UVALUE='BUTTON_Cancel', $
      VALUE='Cancel', $
      XSIZE=100, $
      YSIZE=50)

  BUTTON_Plot = WIDGET_BUTTON( BASE_Button, $
      UVALUE='BUTTON_Plot', $
      VALUE='Plot Fit', $
      XSIZE=100, $
      YSIZE=50)

	widget_control,BASE_Moses,/realize
	xmanager,'moses',BASE_Moses
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro moses_event,event

  COMMON FIELD_FitFile_Comm,  FIELD_FitFile  ; Fit File Field  : fitfile
  COMMON FitFile_Comm,         fitfile

  COMMON Data_Name_Comm, nam

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'FIELD_FitFile': BEGIN ; Event for Fit filename
      actual_path=STRMID(fitfile,0,RSTRPOS(fitfile,'/')+1)
      fitfile=actual_path+Event.Value
      print,' The Fit file is set to : ',fitfile
      END

  'BUTTON_SearchFitFile': BEGIN ; Event for Search Fit Filename
       getfile,fitfile,'*r',/read,field_to_updated=FIELD_FitFile
       print,' The Fit file is set to : ',fitfile
      END

  'BUTTON_Plot': BEGIN
      get_lun,unit
      openr,unit,fitfile,error=err
      close,unit
      free_lun,unit
      if (err ne 0) then begin 
            Print,'ERROR: ',fitfile,' file not found'
            z=Dialog_message(['ERROR !! ',$
              'ERROR: '+fitfile+' file not found'])
            return
      endif  
      print, 'OK: reading fit file'
      moses_start,fitfile,nam
      widget_control,/destroy,event.top
      END

  'BUTTON_Cancel': BEGIN ; Event for button Cancel
     widget_control,/destroy,event.top
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro open_select_window,i_wind,l0k2,l1k2

  COMMON Moses_Status_Comm,Moses_on
  COMMON Select_Window_Comm,i_w_current,i_w_max
  COMMON Select_Wind_WidId_Comm,BGROUP_Window
  COMMON Main_Comm,MAIN
  COMMON BASE_Select_Window_Comm, BASE_Select_Window
  COMMON Select_Window_Status_Comm, Select_Window_on

 if (i_wind ne 1) then begin

   BASE_Select_Window = WIDGET_BASE(GROUP_LEADER=MAIN, $
      ROW=4, $
      MAP=1, $
      TITLE='Select Window', $
      UVALUE='MAIN')
 
   Btns_Window = strarr(i_wind)
   for i_w=0,i_wind-1 do $
         Btns_Window[i_w]=string(format='(i3,2f9.2)',$
                    i_w+1,l0k2(i_w),l1k2(i_w))

  if (i_wind ge 15) then $
   BGROUP_Window = CW_BGROUP( BASE_Select_Window, Btns_Window, $
      ROW=i_wind, $
      EXCLUSIVE=1, $
      NO_RELEASE=1, $
      LABEL_TOP='Window', $
      SCROLL=1, $
      Y_SCROLL_SIZE=500, $
      X_SCROLL_SIZE=160, $
      UVALUE='BGROUP_Window')$
   else $
   BGROUP_Window = CW_BGROUP( BASE_Select_Window, Btns_Window, $
      ROW=i_wind, $
      EXCLUSIVE=1, $
      NO_RELEASE=1, $
      LABEL_TOP='Window', $
      UVALUE='BGROUP_Window')     

  BASE_Previous_Next_Window= WIDGET_BASE(BASE_Select_Window, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='Previous_Next')

  BUTTON_Previous = WIDGET_BUTTON( BASE_Previous_Next_Window, $
      UVALUE='BUTTON_Previous', $
      VALUE='-', $
      XSIZE=40, $
      YSIZE=50)

  BUTTON_Next = WIDGET_BUTTON( BASE_Previous_Next_Window, $
      UVALUE='BUTTON_Next', $
      VALUE='+', $
      XSIZE=40, $
      YSIZE=50)

  BUTTON_All_in_PS = WIDGET_BUTTON( BASE_Select_Window, $
      UVALUE='BUTTON_All_in_PS', $
      VALUE='All in PS', $
      XSIZE=100, $
      YSIZE=50)

 endif else begin ; Only one window 

   BASE_Select_Window = WIDGET_BASE(GROUP_LEADER=MAIN, $
      ROW=2, $
      MAP=1, $
      TITLE='Plotting Fit', $
      UVALUE='MAIN')

   Btns_Window = strarr(i_wind)
   Btns_Window[0]=string(format='(i3,2f9.2)',1,l0k2[0],l1k2[0])
   BGROUP_Window = CW_BGROUP( BASE_Select_Window, Btns_Window, $
      ROW=i_wind, $
      EXCLUSIVE=1, $
      SET_VALUE=0, $
      NO_RELEASE=1, $
      LABEL_TOP='Window', $
      UVALUE='BGROUP_Window')

;   event_select_1 = { $
;                ID:BGROUP_Window, $
;                TOP:BASE_Select_Window, $
;                HANDLER:BASE_Select_Window, $
;                SELECT:1, $
;                VALUE:0 }

 endelse

   BUTTON_End = WIDGET_BUTTON( BASE_Select_Window, $
      UVALUE='BUTTON_End', $
      VALUE='End', $
      XSIZE=100, $
      YSIZE=50)

    Moses_on=0
    i_w_max=i_wind
    widget_control,BASE_Select_Window,/realize
    Select_Window_on=1
    if (i_wind eq 1) then Select_window_button,0
                         ;  Widget_control,BGROUP_Window,send_event=event_select_1
    xmanager,'select_window',BASE_Select_Window


 
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro select_window_event,event

  COMMON Moses_Status_Comm,Moses_on
  COMMON Select_Window_Status_Comm, Select_Window_on
  COMMON Select_Window_Comm,i_w_current,i_w_max
  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'BGROUP_Window': BEGIN
       i_w_current=Event.Value
       Change_window,i_w_current
      END

  'BUTTON_Previous': BEGIN ; Event for Previous Button
       if not(moses_on) then begin
          i_w_current=0
          Select_window_button,i_w_current
       endif else begin
         if (i_w_current gt 0) then begin
          i_w_current=i_w_current-1
          Select_window_button,i_w_current
         endif
       endelse       
      END

  'BUTTON_Next': BEGIN ; Event for Next Button
       if not(moses_on) then begin
          i_w_current=0
          Select_window_button,i_w_current
       endif else begin
         if (i_w_current lt i_w_max-1) then begin
          i_w_current=i_w_current+1
          Select_window_button,i_w_current
         endif
       endelse       
      END

  'BUTTON_All_in_PS': BEGIN ;  Event for button All in PS
     Really=DIALOG_MESSAGE(['All in PS ? Are you sure ?'],QUESTION=1)
     if (Really eq 'Yes') then begin
      moses_on_temp=moses_on
      moses_on=1
      output_mode_temp=output_mode
      output_mode=1
      plotname_root=plotname

      for i_ps=0,i_w_max-1 do begin
          pos_ps=RSTRPOS(plotname_root,'.ps')
          if (pos_ps ne -1) then $
           plotname=STRMID(plotname_root,0,pos_ps)+ $ 
                    '_'+strtrim(string(i_ps+1),2)+'.ps' $ 
          else $
           plotname=plotname_root+'_'+strtrim(string(i_ps+1),2)     

          Change_window,i_ps       
      endfor

      plotname=plotname_root
      output_mode=output_mode_temp
      moses_on=moses_on_temp
     endif 
      END

  'BUTTON_End': BEGIN ; Event for button End
     widget_control,/destroy,event.top
     moses_on=0 
     Select_Window_on=0
    
     replot,data,infilename,wmin,wmax,plotname
      END
  ENDCASE
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Change_Window,i_w

  COMMON Moses_Status_Comm,Moses_on
  COMMON Data_Name_Comm, nam
  COMMON Moses_Result_Comm,ntot,n_compo,ilin_max,$
                     x_cont,y_cont,xfit,yfit,y_nopsf,xfit_line,yfit_line,$
                     lda_line,lbl_elt_line,lbl_elt_tab, $ 
                     fwhm_iw,deg_poly_iw,chi2_w_iw,nu_chi2_iw
  COMMON Info_fit,fwhm_tab,deg_poly,chi2_w,nu_chi2

  COMMON INFO_Comm,data,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax
  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

  COMMON FSLID_Wmin_Comm, FSLID_Wmin ; wmin slider
  COMMON FSLID_Wmax_Comm, FSLID_Wmax ; wmax slider

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider
  COMMON Fmin_max_info,fmin,fmax
  COMMON Mode_Refresh_Rebin,refresh_rebin_on

  COMMON FIELD_DataFile_Comm,  FIELD_DataFile  ; Data file field  : infilename 

       moses_on=1
       print,'Window #',i_w+1,' Selected'
       WIDGET_CONTROL, /HOURGLASS
       moses_calcul,i_w,ntot,n_compo,ilin_max,$
                     x_cont,y_cont,xfit,yfit,y_nopsf,xfit_line,yfit_line,$
                     lda_line,lbl_elt_line,lbl_elt_tab

 ; set infilename Field
       if (infilename ne nam(i_w)) then begin
         infilename=nam(i_w)
         filename_nopath=STRMID(infilename,RSTRPOS(infilename,'/')+1)
         WIDGET_CONTROL, FIELD_DataFile, SET_VALUE=filename_nopath
         print,'INFILENAME=',infilename
         read_asciifile,infilename,data
         data0=data
       endif 

; set wave in Angstrom and plot small
       if ((data0.wave)[0] lt 100.) then begin
         data0.wave=(data0.wave)*1e4        
       endif
       if (refresh_rebin_on) then begin 
        data=data0
        reset_rebin
       endif else  data_process,data0,data,rebin,shift

       plot_data,data,infilename,wmin,wmax,0,plotname,/small,/set_yrange
;          Set sliders according to data 
       wavemin = min(data.wave)
       wavemax = max(data.wave)
       set_slider_min_max,FSLID_Wmin,FSLID_Wmax,wavemin,wavemax
       set_slider_min_max,FSLID_Fmin,FSLID_Fmax,fmin-10*(fmax-fmin),fmax+10*(fmax-fmin)

;      wavemm = minmax(xfit(where(xfit ne 0.)))
      wavemin = min(xfit(where(xfit ne 0.)))
      wavemax = max(xfit(where(xfit ne 0.)))
      delta=(wavemax-wavemin)
      factor=0.02
      if delta*(1.+2.*factor) lt 1. then delta=(1.-delta)/(2.*factor) ; max-min > 1.
      to_set_min= wavemin-factor*delta
      to_set_max= wavemax+factor*delta
      set_wmin_wmax,to_set_min,to_set_max
                    
      fwhm_iw=fwhm_tab(i_w)
      deg_poly_iw=deg_poly(i_w)
      chi2_w_iw=chi2_w(i_w)
      nu_chi2_iw=nu_chi2(i_w)

      plot_data,data,infilename,wmin,wmax,output_mode,plotname,/set_yrange

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Select_window_button,i_w

  COMMON Select_Wind_WidId_Comm,BGROUP_Window
  COMMON BASE_Select_Window_Comm, BASE_Select_Window

  Widget_control,BGROUP_Window,set_value=i_w

  event_select= { $
                ID:BGROUP_Window, $
                TOP:BASE_Select_Window, $
                HANDLER:BASE_Select_Window, $
                SELECT:1, $
                VALUE:i_w }
  Widget_control,BGROUP_Window,send_event=event_select

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Oplot_moses

  COMMON ColorsSetup,color_tab, black,white,red,green,blue,yellow
  COMMON Moses_Result_Comm,ntot,n_compo,ilin_max,$
                     x_cont,y_cont,xfit,yfit,y_nopsf,xfit_line,yfit_line,$
                     lda_line,lbl_elt_line,lbl_elt_tab, $ 
                     fwhm_iw,deg_poly_iw,chi2_w_iw,nu_chi2_iw

ymin=!y.crange[0]
ymax=!y.crange[1]
dy=(ymax-ymin)/20.

for ilin=0,ilin_max do begin
;  lda=lda_line(ilin)*1e-4
  lda=lda_line(ilin)
  lbl_elt=lbl_elt_line(ilin)

  oplot,[lda,lda],[ymax-3.*dy,ymax-2.*dy]
    xyouts,lda,ymax-1.5*dy,lbl_elt,charsize=1.0,$
      charthick=1.5,orientation=90.
endfor

info='FWHM='+string(fwhm_iw,format='(f5.2)')+ $ 
    '   Deg='+string(deg_poly_iw,format='(i2)')+ $ 
    '   Chi2='+string(chi2_w_iw,format='(f8.1)')+ $ 
         '/'+string(nu_chi2_iw,format='(i3)')
get_lun,unit
openr,unit,'no_info',error=err
if (err ne 0) then $
   xyouts,0.62,0.005,info,charsize=1.35,charthick=1.5,/normal
close,unit
free_lun,unit

; xyouts,0.62,0.005,info,charsize=1.35,charthick=1.5,/normal

; Continuum
xi=where(x_cont ne 0.)


;;; COLOR BUG;
oplot,x_cont(xi),y_cont(xi),color=color_tab[green],psym=0,thick=1.5
;;; COLOR BUG;
;;; oplot,x_cont(xi),y_cont(xi),color=250,psym=0,thick=1.5

; Fit of each line
if (n_elements(xfit_line) ne 0) then begin
if ((size(xfit_line))[0] eq 2) then k_max=(size(xfit_line))[2]-1 else k_max=0
for k=0,k_max do begin
  xi=where(xfit_line(*,k) ne 0.)
;;; COLOR BUG;   
oplot,xfit_line(xi,k),yfit_line(xi,k),color=color_tab[green],psym=0,thick=1.5
;;;  oplot,xfit_line(xi,k),yfit_line(xi,k),color=250,psym=0,thick=1.5
endfor
endif

; Global fit
xi=where(xfit ne 0.)
oplot,xfit(xi),y_nopsf(xi),color=color_tab[blue],psym=0,thick=1.5
;;; COLOR BUG; 
oplot,xfit(xi),yfit(xi),color=color_tab[red],psym=0,thick=3.
;;;oplot,xfit(xi),yfit(xi),color=250,psym=0,thick=3.

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro init,N_col,z_red,b_th,b_tu,lbl_elt,s_con,psf,l0k2,l1k2,y_bk,$
   lambda,fosc,delta,mass,iw_lin,xo,yo,sg,n_linj,n_linw,l_lin,k_lin,m_lin,$
   npix,n_elt,n_psf,ncal,n_comp,i_wind,shf,$
   ch_nam,nam

COMMON Dimension_Comm,Qcomp,Qelt,Qwind,Qpsf,Qpix,Qline,Qcal
COMMON Polyn14_Comm,polyn14
COMMON Info_fit,fwhm_tab,deg_poly,chi2_w,nu_chi2

COMMON New_Continuum_Comm,new_continuum


get_lun,unit
openr,unit,ch_nam
ch1=' '
ch3='   '
ch7='        '
ch2='  '
z_red=dblarr(Qcomp)
b_th=dblarr(Qcomp)
b_tu=dblarr(Qcomp)
N_col=dblarr(Qelt,Qcomp)
n_elt=intarr(Qcomp)
;n_elt=replicate(0,Qcomp)
lbl_elt=strarr(Qelt,Qcomp)
n_comp=0
cl=fltarr(Qcomp)
readf,unit,ch3,format='(A3)'
while (ch3 ne 'Tot') do begin
  if (ch3 eq 'Com') then begin
    n_comp=n_comp+1
    readf,unit,ch1
    readf,unit,ch2,format='(18X,A2)'
    if (ch2 eq 'Ra') then cl(n_comp-1)=2.99793e5
    if (ch2 eq 'Re') then cl(n_comp-1)=1.00000e0
  endif
  if (ch3 eq ' Co') then begin
    ch3='  0'
    while (ch3 ne '   ') do begin
      readf,unit,ch3,format='(A3)'
      n_elt(n_comp-1)=n_elt(n_comp-1)+1
    endwhile
    n_elt(n_comp-1)=n_elt(n_comp-1)-1
  endif
  readf,unit,ch3,format='(A3)'
endwhile
i_wind=0
while (not eof(unit)) do begin
  readf,unit,ch1,format='(A1)'
  if (ch1 eq 'I') then i_wind=i_wind+1
endwhile
close,unit
free_lun,unit
a1=0.
get_lun,unit
openr,unit,ch_nam
for i_comp=0,n_comp-1 do begin
  readf,unit,ch1
  readf,unit,ch1
  readf,unit,a1
  z_red(i_comp)=a1/cl(i_comp)
  readf,unit,a1
  b_th(i_comp)=a1
  readf,unit,a1
  b_tu(i_comp)=a1

  readf,unit,ch1
  for i_elt=0,n_elt(i_comp)-1 do begin
    readf,unit,a1,ch7,format='(X,D10.3,7X,A7)'
    lbl_elt(i_elt,i_comp)=ch7
    N_col(i_elt,i_comp)=a1
  endfor
  readf,unit,ch1
endfor
readf,unit,ch1
readf,unit,ch1
readf,unit,ch1
readf,unit,ch1
ch_prof=strarr(Qwind)
fwhm=fltarr(Qwind)
shf=fltarr(Qwind)
s_con=dblarr(15,Qwind)
polyn14=strarr(Qwind)
fwhm_tab=fltarr(Qwind)
deg_poly=intarr(Qwind)
chi2_w=fltarr(Qwind)
nu_chi2=intarr(Qwind)

a2=0.
a3=0.
a4=0.
a5=0.
ch15='               '
fitfile_path=STRMID(ch_nam,0,RSTRPOS(ch_nam,'/')+1)
nam=strarr(Qwind)
sn=fltarr(Qwind)
y_bk=dblarr(Qwind)
s_bk=dblarr(Qwind)
a2g=fltarr(Qwind)
fw2g_0=fltarr(Qwind)
fw2g_1=fltarr(Qwind)
for i_w=0,i_wind-1 do begin
  readf,unit,ch15,a2,format='(2X,A15,X,F6.1)'
  nam(i_w)=fitfile_path+strtrim(ch15,2)      
  shf(i_w)=a2
;
; read lsf
;
;  readf,unit,ch15,a1,format='(2X,A15,F5.2)'
;  ch_prof(i_w)=ch15
;  fwhm(i_w)=abs(a1)

  ch80=''
  readf,unit,ch80,format='(A80)'
  ch_prof(i_w)=strmid(ch80,2,15)
  if (strmid(ch_prof(i_w),0,11) eq 'DoubleGauss') then begin
    reads,strmid(ch80,18,62),a1,a2,a3
    a2g(i_w) = abs(a1)
    fw2g_0(i_w) = a2
    fw2g_1(i_w) = a3
  endif else begin
    reads,strmid(ch80,18,62),a1
    fwhm(i_w)=abs(a1)
    fwhm_tab(i_w)=abs(a1)
  endelse

;
; read continuum: 4th degree
;
  readf,unit,a1,a2,a3,a4,a5,a6
  s_con(0,i_w)=a1
  s_con(1,i_w)=a2
  s_con(2,i_w)=a3
  s_con(3,i_w)=a4
  s_con(4,i_w)=a5
  deg_poly(i_w)=fix(a6)

;
; read continuum: 14th degree
;

;  readf,unit,a1,a2,a3,a4,a5,format='(D14.7,X,D14.7,X,D14.7,X,D14.7,X,D14.7)'
;  readf,unit,a6,a7,a8,a9,a10,format='(D14.7,X,D14.7,X,D14.7,X,D14.7,X,D14.7)'
;  readf,unit,a11,a12,a13,a14,a15,format='(D14.7,X,D14.7,X,D14.7,X,D14.7,X,D14.7)'
;  s_con(0,i_w)=a1
;  s_con(1,i_w)=a2
;  s_con(2,i_w)=a3
;  s_con(3,i_w)=a4
;  s_con(4,i_w)=a5
;  s_con(5,i_w)=a6
;  s_con(6,i_w)=a7
;  s_con(7,i_w)=a8
;  s_con(8,i_w)=a9
;  s_con(9,i_w)=a10
;  s_con(10,i_w)=a11
;  s_con(11,i_w)=a12
;  s_con(12,i_w)=a13
;  s_con(13,i_w)=a14
;  s_con(14,i_w)=a15


  readf,unit,a1,a2,a3,a4,a5

  Guess_Polyn14 = $
    not(  (a1 gt 0.09) and (a1 lt 10000) $; a1 between 0.09 microns and 10000 Ang.
     and (a2 gt 0.09) and (a2 lt 10000) $ ; idem for a2
     and (a1 lt a2) $      ; additional criterium for likely wavelength limits
     and (((a2-a1)/a1) lt 0.5))

  if (Guess_Polyn14) then begin 
   if (i_w eq 0) then $
;       polyn14[i_w]=DIALOG_MESSAGE([ $
;        'Guess for window '+string(i_w+1)+ ' :', $ 
;        'The continuum seems to be a 3 lines 14th degree polynomial',$ 
;        'Do you confirm this guess ?'],QUESTION=1)
       polyn14[i_w]='Yes'
   if (i_w ne 0) then begin
    if (polyn14[i_w-1] eq 'Yes') then polyn14[i_w]='Yes'
    if (polyn14[i_w-1] ne 'Yes') then begin
;       polyn14[i_w]=DIALOG_MESSAGE([ $
;        'Guess for window '+string(i_w+1)+ ' :', $ 
;        'The continuum seems to be a 3 lines 14th degree polynomial',$ 
;        'Do you confirm this guess ?'],QUESTION=1)
       polyn14[i_w]='Yes'
       if (polyn14[i_w] eq 'Yes') then $
         Mess=DIALOG_MESSAGE([ $
        'WARNING !! The result of 14th degree polynomial detection',$
        ' is different for window '+string(i_w)+ 'and window '+string(i_w+1)+' !!'])
    endif 
   endif
  endif

  if (polyn14[i_w] eq 'Yes') then begin
;;     if (polyn14[0] eq 'Yes') then begin
;;       polyn14[i_w]='Yes'

       s_con(5,i_w)=a1
       s_con(6,i_w)=a2
       s_con(7,i_w)=a3
       s_con(8,i_w)=a4
       s_con(9,i_w)=a5
       readf,unit,a11,a12,a13,a14,a15
       s_con(10,i_w)=a11
       s_con(11,i_w)=a12
       s_con(12,i_w)=a13
       s_con(13,i_w)=a14
       s_con(14,i_w)=a15

       readf,unit,a1,a2,a3,a4,a5

     endif
 
  l0k2(i_w)=a1
  l1k2(i_w)=a2
  if (a1 le 1.e2) then l0k2(i_w)=1.e4*l0k2(i_w)
  if (a2 le 1.e2) then l1k2(i_w)=1.e4*l1k2(i_w)
  if ((a1 le 1.e2) and (polyn14[i_w] ne 'Yes') $
                   and not(new_continuum)) then $
     for j=0,14 do s_con(j,i_w)=(1.d-4)^j*s_con(j,i_w)
  
  sn(i_w)=a3
  y_bk(i_w)=a4
  s_bk(i_w)=abs(a5)

  readf,unit,ch1,format='(A80)'
  reads,strmid(ch1,18,10),a1
  chi2_w(i_w)=a1
  reads,strmid(ch1,31,4),nu,format='(I4)'
  nu_chi2(i_w)=nu    

endfor
close,unit
free_lun,unit

nap=intarr(Qwind)
napg=intarr(Qwind)
napd=intarr(Qwind)
naptot=intarr(Qwind)
ncal=intarr(Qwind)
n_psf=intarr(Qwind)
psf=fltarr(Qpsf,Qwind)
n1=0
for i_w=0,i_wind-1 do begin
  ainst=replicate(0.,500)
  binst=replicate(0.,500)
  if (strcompress(ch_prof(i_w),/remove_all) eq 'Gaussian') then begin
    ncal(i_w)=5
    fwhm(i_w)=abs(fwhm(i_w))/1.66511
    nap(i_w)=3*fix(1+2*fwhm(i_w))+1
    napg(i_w)=ncal(i_w)*(nap(i_w)-1)/2
    napd(i_w)=ncal(i_w)*(nap(i_w)-1)/2
    naptot(i_w)=ncal(i_w)*(nap(i_w)-1) + 1

;    for k=0,nap(i_w)-1 do begin
;      ainst(k)=float(k+1) - float((nap(i_w)+1)/2)
;      binst(k)=exp(-(ainst(k)^2)/(fwhm(i_w)^2))
;    endfor

    u=(findgen(naptot(i_w)) - naptot(i_w)/2)/float(ncal(i_w))
    psf_temp=exp(-(u*u)/(fwhm(i_w)*fwhm(i_w)))

  endif else begin

    if (strcompress(ch_prof(i_w),/remove_all) eq 'DoubleGauss') then begin
      ncal(i_w)=5
      fw0=fw2g_0(i_w)/1.665109
      fw1=fw2g_1(i_w)/1.665109
      nap(i_w)=3*fix(1+2*max([fw0,fw1]))+1
      napg(i_w)=ncal(i_w)*(nap(i_w)-1)/2
      napd(i_w)=ncal(i_w)*(nap(i_w)-1)/2
      naptot(i_w)=ncal(i_w)*(nap(i_w)-1) + 1
      u=(findgen(naptot(i_w)) - naptot(i_w)/2)/float(ncal(i_w))
      psf_temp = exp(- (u*u)/(fw0*fw0)) + $
           a2g(i_w)*exp(- (u*u)/(fw1*fw1))
      print,a2g(i_w),fw0,fw1
    endif else begin

;    ch_prof(i_w)=strtrim(ch_prof(i_w),2)
    ch_prof(i_w)=strcompress(ch_prof(i_w),/remove_all)
    get_lun,unit
    openr,unit,ch_prof(i_w)
    readf,unit,n1
    ncal(i_w)=4
    nap(i_w)=0
    k=-1
    while (not eof(unit)) do begin
      readf,unit,a1,a2
;      ainst(nap(i_w))=a1
;      binst(nap(i_w))=a2
;      nap(i_w)=nap(i_w)+1
       k=k+1
       ainst(k)=a1
       binst(k)=a2
    endwhile
    napg(i_w)=ncal(i_w)*(fix(abs(ainst(0))))
    napd(i_w)=ncal(i_w)*(fix(ainst(k)))
    naptot(i_w)=napg(i_w)+napd(i_w)+1
    close,unit
    free_lun,unit
    amin=float(fix(ainst(0)))
    amax=float(fix(ainst(k)))
    ainst=ainst(where(binst gt 0.))
    binst=binst(where(binst gt 0.))
    ainst2=amin + (amax-amin)*findgen(naptot(i_w))/(naptot(i_w)-1)
    psf_temp=interpol(binst,ainst,ainst2)
;    binst=binst(where(binst ne 0.))
;    sz=size(binst)
;    ainst_temp=fltarr(naptot(i_w))
;    ainst_temp=findgen(naptot(i_w))/float(ncal(i_w))
;    psf_temp=interpolate(binst,ainst_temp)
  endelse
 endelse
;  binst=binst(where(binst ne 0.))
;  sz=size(binst)
;  ainst_temp=fltarr(naptot(i_w))
;  ainst_temp=findgen(naptot(i_w))/float(ncal(i_w))
;  psf_temp=interpolate(binst,ainst_temp)
;  sz=size(psf_temp)
;  n_psf(i_w)=sz(1)
;  for j=0,n_psf(i_w)-1 do begin
;    psf(j,i_w)=psf_temp(j)
;  endfor
;  a1=total(psf(*,i_w))
;  for j=0,n_psf(i_w)-1 do begin
;    psf(j,i_w)=psf(j,i_w)/a1
;  endfor

  n_psf(i_w)=(size(psf_temp))[1]
  psf(0:n_psf(i_w)-1,i_w)=psf_temp
  a1=total(psf(*,i_w))
  psf(0:n_psf(i_w)-1,i_w)=psf(0:n_psf(i_w)-1,i_w)/a1

endfor
npix=replicate(-1,Qwind)
xo=dblarr(Qpix,Qwind)
yo=dblarr(Qpix,Qwind)
sg=dblarr(Qpix,Qwind)
for i_w=0,i_wind-1 do begin
  get_lun,unit
  openr,unit,nam(i_w)
  while (not eof(unit)) do begin
    readf,unit,a1,a2
;    readf,unit,a1,a2,a3
    if (a1 lt 1.e2) then a1=a1*1e4
    if (a1 ge l0k2(i_w) and a1 le l1k2(i_w)) then begin
      npix(i_w)=npix(i_w)+1
      xo(npix(i_w),i_w)=a1
      yo(npix(i_w),i_w)=a2
;      sg(npix(i_w),i_w)=a3
    endif
  endwhile
  close,unit
  free_lun,unit
endfor
; for i_w=0,i_wind-1 do begin
;   get_lun,unit
;   openr,unit,nam(i_w)
;    readf,unit,a1
;    readf,unit,a2     
;    if (a1 le 1.e2) then a1=a1*1.e4
;    if (a2 le 1.e2) then a2=a2*1.e4
;    npix(i_w)=long((l1k2(i_w)-l0k2(i_w))/(a2-a1))
;   close,unit
;   free_lun,unit
; endfor
pi=acos(-1.)
n_lin=replicate(fix(-1),Qelt,Qcomp)
n_linw=replicate(fix(-1),Qelt,Qcomp,Qwind)
iw_lin=dblarr(Qline,Qelt,Qcomp)
lambda=dblarr(Qline,Qelt,Qcomp)
fosc=dblarr(Qline,Qelt,Qcomp)
mass=dblarr(Qelt,Qcomp)
delta=dblarr(Qline,Qelt,Qcomp)
get_lun,unit
openr,unit,'AtomicData.d'
print,'Lines in windows with Weq > 1e-2 AA:'
print,' '
d1=double(0.)
n_linj=replicate(fix(-1),Qwind)
l_lin=intarr(Qline,Qwind)
k_lin=intarr(Qline,Qwind)
m_lin=intarr(Qline,Qwind)
ch8=''

get_lun,unit_Line_list
openw,unit_Line_list,'Line_list'
printf,unit_Line_list,ch_nam
printf,unit_Line_list,'-----------------'
printf,unit_Line_list,'                elt     Lambda_0 Lambda_obs  W_eq_max  Tau_0'
printf,unit_Line_list,' '

while (not eof(unit)) do begin
  readf,unit,d1,ch8,mss,fs,tr,format='(F9.4,X,A8,X,I3,2(X,E10.3))'
  ch7=strmid(ch8,0,7)
;  d1=d1*1d-4
  cha=strmid(ch7,0,2)
  if (cha eq 'H2' or cha eq 'HD' or cha eq 'Ha') then begin
    chb=strmid(ch7,4,1)
    ch7=strcompress(cha+chb)+'    '
  endif
  if (cha eq 'CO') then begin
    chb=strmid(ch8,7,1)
    chc=strmid(ch8,0,3)
    ch7=strcompress(chc+chb)+'   '
  endif
    for k=0,n_comp-1 do begin
      for l=0,n_elt(k)-1 do begin
       lbl1=strtrim(lbl_elt(l,k),2)
       lbl0=strtrim(ch7,2)
       if (lbl0 eq lbl1 ) then begin 
        
        for i_w=0,i_wind-1 do begin        
         if (d1*(1.+z_red(k)+shf(i_w)/3.d5) ge l0k2(i_w) and $
            d1*(1.+z_red(k)+shf(i_w)/3.e5) le l1k2(i_w)) then begin
          n_lin(l,k)=n_lin(l,k)+1
          n_linw(l,k,i_w)=n_linw(l,k,i_w)+1
          n_linj(i_w)=n_linj(i_w)+1
          m=n_lin(l,k)
          m_lin(n_linj(i_w),i_w)=m
          k_lin(n_linj(i_w),i_w)=k
          l_lin(n_linj(i_w),i_w)=l
          iw_lin(m,l,k)=i_w
          lambda(m,l,k)=d1
          fosc(m,l,k)=fs
          mass(l,k)=float(mss)
          delta(m,l,k)=tr/(4*pi)
          W_eq_max=N_col(l,k)*fosc(m,l,k)*(lambda(m,l,k))^2*8.85e-21 
;         if (W_eq_max gt 1.e-2) then $
            b_wid=sqrt((b_th(k)/mass(l,k)) + ((b_tu(k)/0.129)^2))
            tau_0=1.16117705d-14*N_col(l,k)*lambda(m,l,k)*fosc(m,l,k)/b_wid
            if (tau_0 gt 0.05) then begin
              print,'Component ',k+1,'  ',lbl_elt(l,k),lambda(m,l,k),  $ 
                     d1*(1.+z_red(k)+shf(i_w)/3.d5),W_eq_max,tau_0, $ 
                         format='(a10,i3,a2,a8,f9.2,f9.2,f10.2,f10.2)'
              printf,unit_Line_list,   $ 
                    'Component ',k+1,'  ',lbl_elt(l,k),lambda(m,l,k),  $ 
                     d1*(1.+z_red(k)+shf(i_w)/3.d5),W_eq_max,tau_0, $ 
                         format='(a10,i3,a2,a8,f9.2,f9.2,f10.2,f10.2)'          
            endif
          if ((cha eq 'H2') or (cha eq 'HD') or (cha eq 'CO')or (cha eq 'Ha')) then Cite_Roueff
         endif ; line in window 
        endfor  ; i_w=0,i_wind-1
       endif   ; lbl0 eq lbl1
      endfor   ; l=0,n_elt(k)-1
    endfor     ; k=0,n_comp-1
endwhile
close,unit_Line_list
free_lun,unit_Line_list


close,unit
free_lun,unit


get_lun,unit
openw,unit,'minimum_1line_per_window'
printf,unit,ch_nam
printf,unit,'-----------------'
printf,unit,'      File     Lambda1 - Lambda2  shift    FWHM       Chi2  '
for i_w=0,i_wind-1 do begin
 printf,unit,nam(i_w),l0k2(i_w),'-',l1k2(i_w),shf(i_w),fwhm_tab(i_w), $ 
             chi2_w(i_w),'/',nu_chi2(i_w), $ 
            format='(a15,f8.2,a1,f8.2,f9.2,f9.2,f9.1,a1,i3)'
 endfor
close,unit
free_lun,unit

return
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO profl,xcal,ycal,N_col,z_red,b_th,b_tu,lambda,fosc,delta,mass,ntot,$
    n_linj,l_lin,k_lin,m_lin,n_elt,n_comp,i_w,i_wind,shf

c=double(2.99793e14)
tau=double(0.)
dnud=double(0.)
a=double(0.)
hav=double(0.)
xc=double(0.)
b_wid=double(0.)
b=double(0.)
thresh=double(1.e-3)
pi=double(acos(-1.))
for ilin=0,n_linj(i_w) do begin

  l=l_lin(ilin,i_w)
  k=k_lin(ilin,i_w)
  m=m_lin(ilin,i_w)
  lda=lambda(m,l,k)*double(1.+z_red(k)+shf(i_w)*1.d9/c)
  wtemp=abs(lda-xcal(*,i_w))
  i_xcal0=0
  xcal0=double(0.)
  xcal0=min(wtemp,i_xcal0)
  b_wid=sqrt((b_th(k)/mass(l,k)) + ((b_tu(k)/0.129)^2))
;  b=4.30136955e-7*b_wid
  b=4.30136955e-3*b_wid
  dnud=b*c/lambda(m,l,k)
  if (delta(m,l,k) lt 0.d0 and $
      (xcal(i_xcal0,i_w)/(1.d0+z_red(k)+shf(i_w)*1.d9/c)) gt lambda(m,l,k)) $
  then i_xcal0=i_xcal0-1
  for incr=-1,+1,2 do begin
    i=i_xcal0
    if (incr eq +1) then i=i_xcal0+1
    hav=1.d3
    while (hav gt thresh and i le ntot-1 and i ge 0) do begin
      if (delta(m,l,k) gt 0.) then begin
        xc=xcal(i,i_w)/(1.+z_red(k)+shf(i_w)*1.d9/c)
;	v=abs(((c/xc)-(c/lambda(m,l,k)))/dnud)
	v=1.e4*abs(((c/xc)-(c/lambda(m,l,k)))/dnud)
;	tv=1.16117705d-10*N_col(l,k)*lambda(m,l,k)*fosc(m,l,k)/b_wid
	tv=1.16117705d-14*N_col(l,k)*lambda(m,l,k)*fosc(m,l,k)/b_wid
	a=delta(m,l,k)/dnud
	hav=tv*Voigt(a,v)
	if (hav le 20.d0) then  ycal(i,i_w)=ycal(i,i_w)*exp(-hav) $
          else ycal(i,i_w)=0.d0  
      endif else begin
	xc=xcal(i,i_w)/(1.+z_red(k)+shf(i_w)*1.d9/c)
	if (incr eq -1) then begin
          t0=double(sqrt(xc/(lambda(m,l,k)-xc)))
	  t2=(pi/2.d0)-double(atan(t0))
	  t1=double(exp(4.d0 - 4.d0*t0*t2))/ $
            (1.d0 - double(exp(-2.d0*pi*t0)))
	  hav=6.3d-18*N_col(l,k)*((xc/lambda(m,l,k))^4)*t1
	  ycal(i,i_w)=ycal(i,i_w)*double(exp(-hav))
	  hav=1.d3
	endif else begin
	  imax=i_xcal0+1
	  lmax=0.5d0*(lambda(m-20,l,k)+lambda(m-21,l,k))
          while ((xcal(imax,i_w)/(1.d0+z_red(k)+shf(i_w)*1.d9/c))$
    le lmax) do begin
	    imax=imax+1
	  endwhile
	  while (i lt imax) do begin
	    ycal(i,i_w)=ycal(i_xcal0,i_w) + $
              ((ycal(imax,i_w)-ycal(i_xcal0,i_w))/ $
              (xcal(imax,i_w)-xcal(i_xcal0,i_w)))* $
	      (xcal(i,i_w)-xcal(i_xcal0,i_w))
	    i=i+1
	  endwhile
	  hav=0.d0
        endelse
      endelse
      i=i+incr
    endwhile
  endfor
endfor
return
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro moses_start,fitfile,nam

common moses_info,N_col,z_red,b_th,b_tu,lbl_elt,$
s_con,psf,l0k2,l1k2,y_bk,lambda,fosc,delta,mass,iw_lin,xo,yo,sg,$
n_linj,n_linw,l_lin,k_lin,m_lin,npix,n_elt,n_psf,ncal,n_comp,i_wind,shf

COMMON Dimension_Comm,Qcomp,Qelt,Qwind,Qpsf,Qpix,Qline,Qcal

Qcomp=10
Qelt=25
Qwind=600
Qpsf=1000
Qpix=1500
Qline=1000
Qcal=10000

N_col=fltarr(Qelt,Qcomp)
z_red=fltarr(Qcomp)
b_th=fltarr(Qcomp)
b_tu=fltarr(Qcomp)
lbl_elt=strarr(Qelt,Qcomp)
s_con=dblarr(15,Qwind)
psf=fltarr(Qpsf,Qwind)
l0k2=dblarr(Qwind)
l1k2=dblarr(Qwind)
y_bk=dblarr(Qwind)
lambda=dblarr(Qline,Qelt,Qcomp)
fosc=fltarr(Qline,Qelt,Qcomp)
delta=fltarr(Qline,Qelt,Qcomp)
mass=fltarr(Qelt,Qcomp)
xo=dblarr(Qpix,Qwind)
yo=dblarr(Qpix,Qwind)
n_linj=intarr(Qwind)
n_linw=intarr(Qelt,Qcomp,Qwind)
l_lin=intarr(Qline,Qwind)
k_lin=intarr(Qline,Qwind)
m_lin=intarr(Qline,Qwind)
npix=intarr(Qwind)
n_elt=intarr(Qcomp)
n_psf=intarr(Qwind)
ncal=intarr(Qwind)
n_comp=0
i_wind=0

      WIDGET_CONTROL, /HOURGLASS

init,N_col,z_red,b_th,b_tu,lbl_elt,s_con,psf,l0k2,l1k2,y_bk,$
   lambda,fosc,delta,mass,iw_lin,xo,yo,sg,n_linj,n_linw,l_lin,k_lin,m_lin,$
   npix,n_elt,n_psf,ncal,n_comp,i_wind,shf,$
   fitfile,nam
open_select_window,i_wind,l0k2,l1k2

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro moses_calcul,i_w,ntot,n_compo,ilin_max,$
                     x_cont,y_cont,xfit,yfit,y_nopsf,xfit_line,yfit_line,$
                     lda_line,lbl_elt_line,lbl_elt_tab

common moses_info,N_col,z_red,b_th,b_tu,lbl_elt,$
s_con,psf,l0k2,l1k2,y_bk,lambda,fosc,delta,mass,iw_lin,xo,yo,sg,$
n_linj,n_linw,l_lin,k_lin,m_lin,npix,n_elt,n_psf,ncal,n_comp,i_wind,shf

COMMON Dimension_Comm,Qcomp,Qelt,Qwind,Qpsf,Qpix,Qline,Qcal
COMMON Polyn14_Comm,polyn14

COMMON New_Continuum_Comm,new_continuum

xcal=dblarr(Qcal,Qwind)
xcal0=dblarr(Qcal,Qwind)
ycal=dblarr(Qcal,Qwind)
ycal0=dblarr(Qcal,Qwind)
ycal_temp=dblarr(Qcal,Qwind)

;;n_p=total(n_elt(0:n_comp-1))

zz=where(n_linw[*,0:n_comp-1,i_w] ge 0,n_p)
print,'n_p=',n_p

if (n_p gt 0) then begin
  xfit_line=dblarr(Qcal,n_p)
  yfit_line=dblarr(Qcal,n_p)
  lbl_elt_tab=strarr(n_p)
endif 

y_nopsf=dblarr(Qcal)

n_compo=n_comp
ilin_max=n_linj(i_w)
if (ilin_max ge 0) then lda_line=dblarr(ilin_max+1)
if (ilin_max ge 0) then lbl_elt_line=strarr(ilin_max+1)

isf=replicate(0.,n_psf(i_w))
isf=psf(*,i_w)
isf=isf(where(isf ne 0.))


l0p=l0k2(i_w)
l1p=l1k2(i_w)

ntot=ncal(i_w)*(npix(i_w)-1)+1
 if ((polyn14[i_w] ne 'Yes') and not(new_continuum)) then begin

  for j=0,ntot-1 do begin
  xcal0(j,i_w)=l0k2(i_w) + double(j)* $
    (l1k2(i_w)-l0k2(i_w))/double(ntot-1)
  ycal0(j,i_w)=s_con(0,i_w) + s_con(1,i_w)*(xcal0(j,i_w)-l0k2(i_w)) + $
    s_con(2,i_w)*((xcal0(j,i_w)-l0k2(i_w))^2) + $
    s_con(3,i_w)*((xcal0(j,i_w)-l0k2(i_w))^3) + $
    s_con(4,i_w)*((xcal0(j,i_w)-l0k2(i_w))^4)
  endfor

 endif else begin

  for j=0,ntot-1 do begin
   xcal0(j,i_w)=l0k2(i_w) + double(j)* $
     (l1k2(i_w)-l0k2(i_w))/double(ntot-1)
   t0=(xcal0(j,i_w)-l0k2(i_w))/(l1k2(i_w)-l0k2(i_w))
   ycal0(j,i_w)=s_con(0,i_w)
   for k=1,14 do ycal0(j,i_w)=ycal0(j,i_w) + s_con(k,i_w)*(t0^k)
  endfor 

 endelse

wtemp=dblarr(Qcal)
wtemp=abs(l0p-xcal0(*,i_w))
i_l0=0
a1=double(0.)
a1=min(wtemp,i_l0)
wtemp=abs(l1p-xcal0(*,i_w))
i_l1=0
a1=min(wtemp,i_l1)

ntotw=i_l1-i_l0+1
for j=0,ntot-i_l0-1 do begin
  xcal(j,i_w)=xcal0(j+i_l0,i_w)
  ycal(j,i_w)=ycal0(j+i_l0,i_w)
endfor

if ntotw le n_elements(isf) then begin 
      print,'n_elements(isf)=',n_elements(isf)
      print,'isf=',isf
      print,'ntotw=',ntotw
      new_isf_size=ntotw/2*2-1
      isf_i0=(n_elements(isf)-1)/2-new_isf_size/2
      isf_i1=(n_elements(isf)-1)/2+new_isf_size/2
      isf=isf[isf_i0:isf_i1]
      print,'n_elements(new isf)=',n_elements(isf)
      print,'new isf=',isf
endif

profl,xcal,ycal,N_col,z_red,b_th,b_tu,lambda,fosc,delta,mass,ntotw,$
  n_linj,l_lin,k_lin,m_lin,n_elt,n_comp,i_w,i_wind,shf
y_nopsf=ycal(0:ntotw-1,i_w)+y_bk(i_w)
ycal_temp1=convol(y_nopsf,isf,edge_truncate=1)
ycal(0:ntotw-1,i_w)=ycal_temp1(0:ntotw-1)

for ilin=0,n_linj(i_w) do begin
  l=l_lin(ilin,i_w)
  k=k_lin(ilin,i_w)
  m=m_lin(ilin,i_w)
  lda=lambda(m,l,k)*double(1.+z_red(k)+shf(i_w)/3.e5)

  lda_line(ilin)=lda
;;  lbl_elt_line(ilin)=strtrim(lbl_elt(l,k),2)+'!L'+strtrim(k+1,2)+'!N'
  if (n_comp le 1) then lbl_elt_line(ilin)=strtrim(lbl_elt(l,k),2) $
   else    lbl_elt_line(ilin)=strtrim(lbl_elt(l,k),2)+'  ('+strtrim(k+1,2)+')'

   W_eq_max=N_col(l,k)*fosc(m,l,k)*(lambda(m,l,k))^2*8.85e-21 
   if (W_eq_max lt 1.e-2) then lbl_elt_line(ilin)=''

endfor

N_col0=fltarr(Qelt,Qcomp)
N_col0=N_col
ycal_temp=dblarr(Qcal,Qwind)

if (n_p gt 0) then begin
p=0

for k=0,n_comp-1 do begin
  for l=0,n_elt(k)-1 do begin
   if (n_linw(l,k,i_w) ge 0) then begin

    N_col=replicate(0.d0,Qelt,Qcomp)
    N_col(l,k)=N_col0(l,k)
    for j=0,ntot-i_l0-1 do begin
      ycal_temp(j,i_w)=ycal0(j+i_l0,i_w)
    endfor
   
profl,xcal,ycal_temp,N_col,z_red,b_th,b_tu,lambda,fosc,delta,mass,ntotw,$
      n_linj,l_lin,k_lin,m_lin,n_elt,n_comp,i_w,i_wind,shf
    ycal_temp2=ycal_temp(0:ntotw-1,i_w)
    ycal_temp1=convol(ycal_temp2,isf,edge_truncate=1)
    ycal_temp1=ycal_temp1+y_bk(i_w)

    xfit_line(0:ntotw-1,p)=xcal(0:ntotw-1,i_w)
    yfit_line(0:ntotw-1,p)=ycal_temp1(0:ntotw-1)

    if (n_comp le 1) then lbl_elt_tab(p)=strtrim(lbl_elt(l,k),2) $
     else    lbl_elt_tab(p)=strtrim(lbl_elt(l,k),2)+'  ('+strtrim(k+1,2)+')'

    p=p+1 & print,'p=',p,'/',long(n_p)

   endif
  endfor
endfor
endif


;;;''''''''''''''''''''''''''''''
;;;''''''''''''''''''''''''''''''
;; test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;N_col0=fltarr(Qelt,Qcomp)
;N_col0=N_col
;ycal_temp=dblarr(Qcal,Qwind)
;p=0
;for ilin=0,n_linj(i_w) do begin
;  l=l_lin(ilin,i_w)
;  k=k_lin(ilin,i_w)
;  m=m_lin(ilin,i_w)
;  lda=lambda(m,l,k)*double(1.+z_red(k)+shf(i_w)/3.e5);
;  lda_line(ilin)=lda
;  if (n_comp le 1) then lbl_elt_line(ilin)=strtrim(lbl_elt(l,k),2) $
;   else    lbl_elt_line(ilin)=strtrim(lbl_elt(l,k),2)+'  ('+strtrim(k+1,2)+')'
;
;    N_col=replicate(0.d0,Qelt,Qcomp)
;    N_col(l,k)=N_col0(l,k)
;    for j=0,ntot-i_l0-1 do begin
;      ycal_temp(j,i_w)=ycal0(j+i_l0,i_w)
;    endfor
;   
; profl,xcal,ycal_temp,N_col,z_red,b_th,b_tu,lambda,fosc,delta,mass,ntotw,$
;      n_linj,l_lin,k_lin,m_lin,n_elt,n_comp,i_w,i_wind,shf
;    ycal_temp2=ycal_temp(0:ntotw-1,i_w)
;    ycal_temp1=convol(ycal_temp2,isf,edge_truncate=1)
;    ycal_temp1=ycal_temp1+y_bk(i_w)
;
;    xfit_line(0:ntotw-1,p)=xcal(0:ntotw-1,i_w)
;    yfit_line(0:ntotw-1,p)=ycal_temp1(0:ntotw-1)
;
;    p=p+1 & print,'p=',p,'/',n_linj(i_w)+1
;
;endfor
;;;''''''''''''''''''''''''''''''
;;;''''''''''''''''''''''''''''''

N_col=N_col0

x_cont=xcal0(0:ntot-1,i_w)
y_cont=ycal0(0:ntot-1,i_w)+y_bk(i_w)
xfit=xcal(0:ntotw-1,i_w)
yfit=ycal(0:ntotw-1,i_w)

;;yfit_data=interpol(yfit,xfit,xo(0:npix(i_w),i_w))
;;chi2=total(  ( (yfit_data-yo(0:npix(i_w),i_w)) / sg(0:npix(i_w),i_w))^2)
;;print,'i_w=',i_w,'  chi2=',chi2,'/',npix(i_w),' = ',chi2/npix(i_w)

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO xiplot, infile, data, outfile, WMIN=wmin_0, WMAX=wmax_0,$
                                   FMIN=fmin_0, FMAX=fmax_0,$
                                   ASCII=ascii, $
                                   New_continuum=new_continuum, $
                                   refresh_rebin_off=refresh_rebin_off

  COMMON INFO_Comm,data_,content,infilename,outfilename,$
            output_mode,plotname,wmin,wmax

  COMMON REBIN_Comm,data0,rebin,shift,rebin_slider,shift_slider

  COMMON FIELD_DataFile_Comm, FIELD_DataFile ; Data file field  : infilename 
  COMMON FIELD_OplotFile_Comm, FIELD_OplotFile ; Oplot file field  : overname 
  COMMON FIELD_AsciiFile_Comm, FIELD_AsciiFile ; Ascci file field : outfilename
  COMMON FIELD_PlotFile_Comm, FIELD_PlotFile ; Plot file field  : plotname
  COMMON FIELD_ShiftFile_Comm,  FIELD_ShiftFile  ; Shift File Field  : shiftfile

  COMMON FSLID_Wmin_Comm, FSLID_Wmin ; wmin slider
  COMMON FSLID_Wmax_Comm, FSLID_Wmax ; wmax slider

  COMMON FSLID_Fmin_Comm, FSLID_Fmin ; fmin slider
  COMMON FSLID_Fmax_Comm, FSLID_Fmax ; fmax slider

  COMMON SCALE_Slider_Over_Comm,SCALE_Slider_Over

  COMMON TEXTID,TEXT_Click,TEXT_INFO
  COMMON LOCK_UNLOCK,BUTTON_LOCK,BUTTON_UNLOCK
  COMMON Fmin_max_info,fmin,fmax

  COMMON Wminmax_Comm,wmin_or_max,Wmin_next  ; flag for click on Wmin or Wmax.
  COMMON Fminmax_Comm,fmin_or_max,Fmin_next  ; flag for click on Fmin or Fmax.

  COMMON SLIDE_BUTTON,left,right,left_id,right_id

  COMMON OVERPLOT_Comm,overname,data0_o,data_o,rebin_o,shift_o,shift_o_p,scale_o,smooth_o,overplot_on
  COMMON ADDEXPO_Comm,addexpo_on

  COMMON Find_lines_Status_Comm,Find_Lines_on
  COMMON Moses_Status_Comm,Moses_on
  COMMON Select_Window_Status_Comm, Select_Window_on
  COMMON FitFile_Comm,         fitfile
  COMMON Info_fit,fwhm_tab,deg_poly,chi2_w,nu_chi2

  COMMON COG_Status_Comm,COG_on,COG_File_on,COG_Species_on,COG_Window_on
  COMMON COG_Comm,EqW,ew_point,COGData_on
  COMMON COG_Plot,BASE_COG_Window,Plot_id

  COMMON ShiftFile_Comm,shiftfile

  COMMON Main_Comm,MAIN

  COMMON New_Continuum_Comm,new_continuum_
  COMMON Mode_Refresh_Rebin,refresh_rebin_on

if keyword_set(new_continuum) then new_continuum_=1 else new_continuum_=0
if keyword_set(refresh_rebin_off) then refresh_rebin_on=0 $  
                                  else refresh_rebin_on=1

set_plot,'x'
set_color_table

wmin_or_max=0
fmin_or_max=0
content=[1,0,1,1,0,0,0,0]
rebin=1
shift=0
output_mode=0
plotname='idl.ps'
overplot_on=0
addexpo_on=0
overname=''
rebin_o=1
Find_Lines_on=0
Moses_on=0
Select_Window_on=0
fitfile='minimum.r'

COG_on=0
COG_File_on=0
COG_Species_on=0
COG_Window_on=0

if ((n_params(0) ge 1) and (n_elements(infile) gt 0)) then $
        infilename=infile  $
   else infilename=''

if ((n_params(0) ge 3) and (n_elements(outfile) gt 0))then $
        outfilename=outfile  $
   else outfilename='data.dat'

if (n_elements(wmin_0) gt 0) then wmin=wmin_0 else wmin=0.
if (n_elements(wmax_0) gt 0) then wmax=wmax_0 else wmax=1200.
if (n_elements(fmin_0) gt 0) then fmin=fmin_0 else fmin=0.
if (n_elements(fmax_0) gt 0) then fmax=fmax_0 else fmax=100.
 
  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

  junk   = { CW_PDMENU_S, flags:0, name:'' }

;  WIDGET_CONTROL, DEFAULT_FONT='-adobe-times-medium-r-normal--14-140-75-75-p-74-iso8859-1'
  WIDGET_CONTROL, DEFAULT_FONT='-*-*-medium-r-normal--12-120-*-*-p-*-iso8859-1'

  MAIN = WIDGET_BASE(GROUP_LEADER=Group, $
      ROW=2, $
      MAP=1, $
      TITLE='xiplot', $
      UVALUE='MAIN')

  BASE_Top = WIDGET_BASE(MAIN, $
      COLUMN=6, $
      MAP=1, $
      UVALUE='BASE_Top')

  BASE_Bottom = WIDGET_BASE(MAIN, $
      COLUMN=3, $
      MAP=1, $
      UVALUE='BASE_Bottom')

  BASE_Top_Col1 = WIDGET_BASE(BASE_Top, $
      ROW=6, $
      MAP=1, $
      UVALUE='BASE_Top_Col1')

  BASE_Top_Col2 = WIDGET_BASE(BASE_Top, $
      ROW=4, $
      MAP=1, $
      UVALUE='BASE_Top_Col2')

  BASE_Top_Col3 = WIDGET_BASE(BASE_Top, $
      ROW=3, $
      MAP=1, $
      UVALUE='BASE_Top_Col3')

  BASE_Top_Col4 = WIDGET_BASE(BASE_Top, $
      ROW=4, $
      MAP=1, $
      TITLE=' Output', $
      UVALUE='BASE_Top_Col4')

  BASE_Top_Col5 = WIDGET_BASE(BASE_Top, $
      ROW=8, $
      MAP=1, $
      UVALUE='BASE_Top_Col5')

  BASE_DataFile = WIDGET_BASE(BASE_Top_Col1, $
      COLUMN=3, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_DataFile')

  BASE_OplotFile = WIDGET_BASE(BASE_Top_Col1, $
      COLUMN=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_OplotFile')

  BASE_PlotFile = WIDGET_BASE(BASE_Top_Col1, $
      COLUMN=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_PlotFile')

  BASE_AsciiFile = WIDGET_BASE(BASE_Top_Col1, $
      COLUMN=2, $
      FRAME=2, $
      MAP=1, $
      UVALUE='BASE_AsciiFile')

  BASE_RebinShiftLine = WIDGET_BASE(BASE_Top_Col2, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_RebinShiftLine')

  BASE_FSlider = WIDGET_BASE(BASE_Top_Col2, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_FSlider')

  BASE_WSlider = WIDGET_BASE(BASE_Top_Col2, $
      COLUMN=2, $
      MAP=1, $
      UVALUE='BASE_WSlider')

  BASE_PlotButtonLine = WIDGET_BASE(BASE_Top_Col2, $
      ROW=1, $
      MAP=1, $
      UVALUE='BASE_PlotButtonLine', $
      ALIGN_CENTER=1)

  FieldVal_DataFile = infilename
  FIELD_DataFile = CW_FIELD( BASE_DataFile, $
      VALUE=FieldVal_DataFile, $
      ROW=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='Input Data File   :', $
      UVALUE='FIELD_DataFile', $
      XSIZE=25, $
      YSIZE=1)

  BUTTON_SearchDataFile = WIDGET_BUTTON( BASE_DataFile, $
      UVALUE='BUTTON_SearchDataFile', $
      VALUE='Search File', $
      XSIZE=80, $
      YSIZE=30)

  FieldVal_PlotFile = plotname
  FIELD_PlotFile = CW_FIELD( BASE_PlotFile, $
     VALUE=FieldVal_PlotFile, $
      ROW=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='Output PS File    :', $
      UVALUE='FIELD_PlotFile', $
      XSIZE=25, $
      YSIZE=1)

  BUTTON_SearchPlotFile = WIDGET_BUTTON( BASE_PlotFile, $
      UVALUE='BUTTON_SearchPlotFile', $
      VALUE='Search File', $
      XSIZE=80, $
      YSIZE=30)

  FieldVal_AsciiFile = outfilename
  FIELD_AsciiFile = CW_FIELD( BASE_AsciiFile, $
      VALUE=FieldVal_AsciiFile, $
      ROW=1, $
      STRING=1, $
      RETURN_EVENTS=1, $
      TITLE='Output Ascii File :', $
      UVALUE='FIELD_AsciiFile', $
      XSIZE=25, $
      YSIZE=1)

  BUTTON_SearchAsciiFile = WIDGET_BUTTON( BASE_AsciiFile, $
      UVALUE='BUTTON_SearchAsciiFile', $
      VALUE='Search File', $
      XSIZE=80, $
      YSIZE=30)

  TEXT_INFO = WIDGET_TEXT( BASE_Top_Col1, $
      VALUE=['Lambda =            Flux = ','Quality =     Error = '],$
      EDITABLE=0, $
      FRAME=0,$
      UVALUE='TEXT_INFO', $
      YSIZE=2, $
      XSIZE=40)

  DRAW_SMALL = WIDGET_DRAW( BASE_Top_Col1, $
      BUTTON_EVENTS=1, $
      MOTION_EVENTS=1,$
      EXPOSE_EVENTS=1,$
      RETAIN=0,$
      UVALUE='DRAW_SMALL', $
      XSIZE=400, $
      YSIZE=112)

  REBIN_SLIDER = WIDGET_SLIDER( BASE_RebinShiftLine, $
      MAXIMUM=50, $
      MINIMUM=1, $
      TITLE='Rebin', $
      UVALUE='REBIN_SLIDER', $
      XSIZE=180, $
      SCROLL=1, $
      VALUE=1)

  SHIFT_SLIDER = CW_FSLIDER( BASE_RebinShiftLine, $
      EDIT=1, $
      MAXIMUM= 1., $
      MINIMUM=-1., $
      TITLE='Shift', $
      UVALUE='SHIFT_SLIDER', $
      XSIZE=180, $
      VALUE=0.)

  FSLID_Fmin = CW_FSLIDER( BASE_FSlider, $
      EDIT=1, $
      MINIMUM=0., $
      MAXIMUM=100., $
      XSIZE=175,$
      TITLE='Ymin', $
      UVALUE='fmin_slider', $
      VALUE=fmin)

  FSLID_Fmax = CW_FSLIDER( BASE_FSlider, $
      EDIT=1, $
      MINIMUM=0., $
      MAXIMUM=100., $
      XSIZE=175,$
      TITLE='Ymax', $
      UVALUE='fmax_slider', $
      VALUE=fmax)

  FSLID_Wmin = CW_FSLIDER( BASE_WSlider, $
      EDIT=1, $
      MINIMUM=0., $
      MAXIMUM=1200., $
      XSIZE=175,$
      TITLE='Xmin', $
      UVALUE='wmin_slider', $
      VALUE=wmin)

  FSLID_Wmax = CW_FSLIDER( BASE_WSlider, $
      EDIT=1, $
      MINIMUM=0., $
      MAXIMUM=1200., $
      XSIZE=175,$
      TITLE='Xmax', $
      UVALUE='wmax_slider', $
      VALUE=wmax)

  BUTTON_YFULL = WIDGET_BUTTON( BASE_PLotButtonLine, $
      UVALUE='BUTTON_YFULL', $
      VALUE='Y Full Range', $
      XSIZE=110, $
      YSIZE=40)

  BUTTON_XFULL = WIDGET_BUTTON( BASE_PLotButtonLine, $
      UVALUE='BUTTON_XFULL', $
      VALUE='X Full Range', $
      XSIZE=110, $
      YSIZE=40)

  BUTTON_REPLOT = WIDGET_BUTTON( BASE_PLotButtonLine, $
      UVALUE='BUTTON_REPLOT', $
      VALUE='Replot', $
      XSIZE=110, $
      YSIZE=40)

  BUTTON_Help = WIDGET_BUTTON( BASE_Top_Col4, $
      UVALUE='BUTTON_Help', $
      VALUE='Help', $
      XSIZE=90, $
      YSIZE=40)
 
  BUTTON_Ascii = WIDGET_BUTTON( BASE_Top_Col4, $
      UVALUE='BUTTON_Ascii', $
      VALUE='Ascii', $
      XSIZE=90, $
      YSIZE=40)

  Btns_Content = [ $
    'Lambda', $
    'Fit_noPSF', $
    'Flux', $
    'Error', $
    'Continuum', $
    'Fit', $
    'Header', $
    'All lines' ]
  BGROUP_Content = CW_BGROUP( BASE_Top_Col4, Btns_Content, $
      ROW=8, $
      NONEXCLUSIVE=1, $
      LABEL_TOP='Ascii Content', $
      UVALUE='BGROUP_Content')

  BUTTON_Exit = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_Exit', $
      VALUE='Exit', $
      XSIZE=90, $
      YSIZE=40)

  BUTTON_Print = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_Print', $
      VALUE='Print', $
      XSIZE=90, $
      YSIZE=40)

  BUTTON_PostScript = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_PostScript', $
      VALUE='PostScript', $
      XSIZE=90, $
      YSIZE=40)

  BUTTON_OverPlot = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_OverPlot', $
      VALUE='OverPlot', $
      XSIZE=90, $
      YSIZE=40)
 
  BUTTON_AddExpo = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_AddExpo', $
      VALUE='Add Expo', $
      XSIZE=90, $
      YSIZE=40)
 
  BUTTON_Find_Lines = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_Find_Lines', $
      VALUE='Find Lines', $
      XSIZE=90, $
      YSIZE=40)

  BUTTON_Plot_Fit = WIDGET_BUTTON( BASE_Top_Col5, $
      UVALUE='BUTTON_Plot_Fit', $
      VALUE='Plot Fit', $
      XSIZE=90, $
      YSIZE=40)
  
;  BUTTON_COG = WIDGET_BUTTON( BASE_Top_Col5, $
;      UVALUE='BUTTON_COG', $
;      VALUE='Plot COG.', $
;      XSIZE=90, $
;      YSIZE=40)
 
  BASE_LEFT = WIDGET_BASE(BASE_BOTTOM, $
      ROW=3, $
      MAP=1, $
      UVALUE='BASE_Left')

  LEFT = WIDGET_DRAW( BASE_left, $
      BUTTON_EVENTS=1, $
      RETAIN=0,$
      UVALUE='LEFT', $
      XSIZE=50, $
      YSIZE=30)

  BUTTON_LEFT= WIDGET_BUTTON( BASE_LEFT, $
      UVALUE='LEFT2', $
      VALUE='<<', $
      XSIZE=50, $
      YSIZE=30)

  BUTTON_FULL_LEFT= WIDGET_BUTTON( BASE_LEFT, $
      UVALUE='FULL_LEFT', $
      VALUE='<<<<', $
      XSIZE=50, $
      YSIZE=30)

  DRAW_LARGE = WIDGET_DRAW( BASE_Bottom, $
      BUTTON_EVENTS=1, $
      MOTION_EVENTS=1,$
      EXPOSE_EVENTS=1,$
      RETAIN=0,$
      UVALUE='DRAW_LARGE', $
      XSIZE=880, $
      YSIZE=400)

  BASE_RIGHT = WIDGET_BASE(BASE_BOTTOM, $
      ROW=3, $
      MAP=1, $
      UVALUE='BASE_Right')

  RIGHT = WIDGET_DRAW( BASE_right, $
      BUTTON_EVENTS=1, $
      RETAIN=0,$
      UVALUE='RIGHT', $
      XSIZE=50, $
      YSIZE=30)

  BUTTON_RIGHT= WIDGET_BUTTON( BASE_RIGHT, $
      UVALUE='RIGHT2', $
      VALUE='>>', $
      XSIZE=50, $
      YSIZE=30)

  BUTTON_FULL_RIGHT= WIDGET_BUTTON( BASE_RIGHT, $
      UVALUE='FULL_RIGHT', $
      VALUE='>>>>', $
      XSIZE=50, $
      YSIZE=30)

;  TEXT_Click = WIDGET_TEXT( BASE_BOTTOM, $
;      VALUE=['Click on window to select Wmin'],$
;      EDITABLE=0, $
;      FONT='-adobe-times-bold-r-normal--24-240-75-75-p-132-iso8859-1', $
;      FRAME=0,$
;      UVALUE='TEXT_Click', $
;      YSIZE=1, $
;      XSIZE=23)

; spawn,'echo $DISPLAY',display
; poscolon=rstrpos(display[0],':')
; if (poscolon[0] ne -1) then display=STRMID(display[0],0,poscolon)
; uname_command= 'rsh '+display[0]+' uname'
; spawn,uname_command,uname
 if (get_display() eq 'SunOS') then begin
   device,decompose=0
   window,0,retain=2
   plot,[0,0]
   xyouts,0.1,0.9, 'PUT THE MOUSE POINTER IN THIS WINDOW',charsize=2,charthick=2
   xyouts,0.1,0.82, 'IF YOU NEED TO SEE COLORS IN XIPLOT',charsize=2,charthick=2
 endif

  WIDGET_CONTROL, MAIN, /REALIZE

  ; Get drawable window index

  COMMON DRAW_LARGE_Comm, DRAW_LARGE_Id
  WIDGET_CONTROL, DRAW_LARGE, GET_VALUE=DRAW_LARGE_Id

  wset,DRAW_LARGE_Id
 
  COMMON DRAW_SMALL_Comm, DRAW_SMALL_Id,Vx_4,X0_4,X1_4,button_pressed
  WIDGET_CONTROL, DRAW_SMALL, GET_VALUE=DRAW_SMALL_Id
  button_pressed=0

  ; Plot the symbol on left and right scroller button
   WIDGET_CONTROL, LEFT, GET_VALUE=LEFT_Id 
   wset,LEFT_Id
   xyouts,25,5,'<<',/device ,alignment=0.5,charsize=2,charthick=2

   WIDGET_CONTROL, RIGHT, GET_VALUE=RIGHT_Id 
   wset,RIGHT_Id
   xyouts,25,5,'>>',/device ,alignment=0.5,charsize=2,charthick=2

  ; Set each field of Content to ON
  WIDGET_CONTROL, BGROUP_Content, SET_VALUE=content

  ; Get drawable outfilename field index

  COMMON FIELD_AsciiFile_id_Comm, FIELD_AsciiFile_Id
  WIDGET_CONTROL, FIELD_AsciiFile, GET_VALUE=FIELD_AsciiFile_Id

; print initial message

        print," "
        print,"On plot window:   press mouse keys to replot
        print," "
        print,"  Left mouse key:   press at minimum and again at maximum wavelength"
        print,"                       to replot with the new wavelength range"
        print,"  Middle mouse key: press once to replot at full scale"
        print,"  Right mouse key:  press at minimum and again at maximum flux"
        print,"                       to replot with the new flux range"
        print," "

; set smaller margin than default
; Note: on my system default appears to be [22.5,4] and [5,10] (A.L.)
;       on manual default are written to be [10,3] and [4,2]

   !x.margin=[12,3]   ;; default=[10,3]
   !y.margin=[3,3]   ;; default=[4,2]

; Initialize

; Read ASCII

       if (n_elements(ascii) gt 0) then begin        
           read_asciifile,ascii,data
	   infilename=ascii
           first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
       endif else if (infilename ne '') then begin
; Read FITS
           read_data,infilename,data
           first_plot,data,data0,infilename,wmin,wmax,fmin,fmax
; No startup data file
        endif else begin
          data=replicate({wave:0.0,flux:0.0,error:0.0,quality:0B},2)
          data0=data 
        endelse
 
        if ((infilename ne '') and $ 
             ((n_elements(wmin_0) ne 0) or (n_elements(wmax_0) ne 0) or $
              (n_elements(fmin_0) ne 0) or (n_elements(fmax_0) ne 0))    ) then begin
          if ((n_elements(wmin_0) ne 0) or (n_elements(wmax_0) ne 0)) then begin
              if (n_elements(wmin_0) ne 0) then wmin=wmin_0
              if (n_elements(wmax_0) ne 0) then wmax=wmax_0
              set_wmin_wmax,wmin,wmax
          endif
          if ((n_elements(fmin_0) ne 0) or (n_elements(fmax_0) ne 0)) then begin
              if (n_elements(fmin_0) ne 0) then fmin=fmin_0
              if (n_elements(fmax_0) ne 0) then fmax=fmax_0
          endif
              plot_data,data,infilename,wmin,wmax,output_mode,plotname
        endif

; copy data to common area

        data_=data0

; Main Loop

  XMANAGER, 'MAIN', MAIN

; set infile and outfile before exit
  data=data_
  infile=infilename
  outfile=outfilename

END
