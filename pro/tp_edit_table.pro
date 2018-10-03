;+
; Project     : SOHO - CDS
;
; Name        : TP_EDIT_TABLE()
;
; Purpose     : 2-D array screen editor for technical planning.
;
; Explanation : An amended version of the original EDIT_TABLE which caters
;               specifically for features of the technical planning line-
;               window editing.  For instance, if an entry is inserted in a
;               column then all the columns are adjusted to make room for
;               a new entry in all and certain interdependencies of the 
;               columns are catered for eg if a wavelength is specified the
;               line centre pixel location is automatically calculated and
;               if the window width is changed then the left hand edge pixel 
;               value is reset.  Others can be added later as appropriate.
;
;       
; This compound widget function produces a spreadsheet-type table
; of text data which can be edited by the user.  The table is defined
; in terms of a number of columns and a number of rows and hence
; takes data from a 2-D array.  Each column in the table can be
; given a text header and an integer row index can be optionally
; displayed in a column along the edge of the table.  The table may
; include editable and non-editable columns as defined by the
; caller.  Optionally the text data which is entered may be
; specified as representing integer or float values in which case
; any illegal values will be flagged as in error.
;
; The widget consists of an array of single line text widgets.
; The user can direct the keyboard input to any text 'Cell' by
; clicking on that cell with the mouse.  If the user presses the 
; return key the keyboard input moves to the next cell.  The
; direction in which the active cell moves, down columns or across
; rows, is under the control of the user via the 'Row_skip' and
; 'Column_skip' toggle buttons.  When the end of a column or row
; is reached the input moves to the begining of the next column or
; row.
;
; The caller can specify two different fonts via the FONTS keyword
; to distinguish between editable and non-editable data.
;
; A number of editing features are provided with this edit widget.
; These features are listed with toggle buttons along the bottom
; of the edit cell array.  To use an edit feature position the
; keyboard input cursor on the required cell, switch on the edit
; facility with its toggle button and then press the return key
; to perform the operation.  The edit facilities are;
;
;   Delete - Set the text cells in the current row to empty.
;   Remove - Delete all the entries for the current line (row)
;   Insert - Insert a blank line (row)
;   Copy   - Copy the value from the current CELL into a
;      buffer.
;   Paste  - Copy the current buffer contents into the
;      current CELL.
;
; These edit control buttons can be removed from the widget by
; specifying the NOCON keyword.
;
;       This file includes the event management and SET_VALUE/GET_VALUE
;       routines.  The VALUE of this widget is the 2-D string array of
; text from the array of table edit cells.
;
; Use         :
;           IDL> data = make_array(5,6,/float,value=25.0)
;           IDL> strdata = string(data)
;           IDL> base = WIDGET_BASE(/COLUMN)
;           IDL> edid = TP_EDIT_TABLE(base,NCOLS=5,NROWS=6,$
;                                           VALUE=strdata,/FLOAT)
;
; Creates a table edit widget for an array of
; float values.  The keyword /FLOAT instructs the widget to check
; all user input to see if it represents a valid floating point
; number.  This code does not realize the widget.
;
; The value of the widget, the string array, can be set and
; read using WIDGET_CONTROL.  The following code will reset the
; data in the table to new values;
;
; WIDGET_CONTROL,edid,SET_VALUE=strdata2
;
; The following code will read the current string data from the
; edit table, perhaps after the user has made modifications;
;
; WIDGET_CONTROL,edid,GET_VALUE=outdata
;
; This code creates an edit table with column headers.  Column
; headers 1 and 3 have two rows of text.  The row index column
; which appears to the left of the table by default is switched off.
; Of the four columns only the first and second columns are
; editable.  The data are taken to be text data.  The edit control
; buttons are switched off.
;
; IDL> strdata = make_array(4,3,value='Text Data')
; IDL> base = WIDGET_BASE(/COLUMN)
; IDL> edid = TP_EDIT_TABLE(base,NCOLS=4,NROWS=3,VALUE=strdata, $
;             COLHEAD=[['Column 1','Column 2,'Column 3','Column 4'], $
;               ['Data','','Data','']], $
;               COLEDIT=[1,1,0,0],/NOINDEX,/NOCON)
;
; The basic widget does not include 'Quit' or 'Done' buttons.
; This widget does not generate events itself, all events are
; handled internally.
;
; Inputs      :  PARENT   - The ID of the parent widget.
;
; Opt. Inputs :  None.  See the keywords for additional controls.
;
; Outputs     :  The return value of this function is the ID of the compound
;                widget which is of type LONG integer.
;
; Opt. Outputs:  None
;
; Keywords    :
;
; NCOLS    - The number of columns of data.  The default is one column.
;
; NROWS    - The number of rows of data. The default is one row.
;
; COLEDIT  - Flags to indicate which columns are editable, type
;      INTARR(NCOLS).  The default is all columns are editable.
;
; COLHEAD  - Column headers, type STRARR(NCOLS,n).  Each of the n
;      rows of header is placed one below another at the top
;      of each column.
;
; VALUE    - Array of initial data values, type STRARR(NCOLS,NROWS).
;      Elements of the string array may contain empty strings.
;      The default is blank data fields.
;
; FLOAT    - Set this keyword to indicate that the data values must
;      represent valid floating point numbers.
;
; INTEGER  - Set this keyword to indicate that the data values must
;      represent valid integer numbers.
;
; UVALUE   - Supplies the user value for the widget.
;
; NOINDEX  - Set this keyword to remove the column of integer index
;      values at the far left of the table.  The default is
;      for the index column to appear.
;
; NOCON    - Set this keyword to remove the edit control buttons
;      delete, remove, insert etc.
;
; YSIZE    - Specifies the ysize of the table in rows of cells.
;      If ysize is less than the number of rows the columns
;      are split and placed side-by-side.
;
; CELLSIZE - Specifies the character width of the text widget
;      cells which make up the table.  The default is 8.
;      In some circumstances the windows toolkit may ignore
;      this setting depending on the width of the column
;      header.
;
; NOEDIT   - Set this keyword to make all data fields non-editable.
;      The default is for all data columns specified by COLEDIT
;      to be editable.
;
; ROWSKIP  - By default the cursor skips down columns of cells
;      when the return key is pressed.  Set this keyword to
;      cause the cursor to skip across rows in the table.
;
; FONTS  - Structure of two fonts to use for table,
;      {font_norm:string, font_input:string}
;
; Calls       :
; NUM_CHK   Checks that a string represents a legal number.
; CW_LOADSTATE  Recover compound widget state.
; CW_SAVESTATE  Save compound widget state.
; See side effects for other related widget management routines.
;
; Side effects:
; This widget uses a COMMON BLOCK: CW_TP_EDTAB_BLK to hold the
;       widget state.
;
;       Three other routines are included which are used to manage the
;       widget;
;
; TP_EDTAB_SETVAL
; TP_EDTAB_GETVAL()
; TP_EDTAB_EVENT()
;
; Category    :  Technical planning, Util, Widget
;
; Prev. Hist. :  Original CW_EDIT_TABLE by Andrew Bowen, 
;                Tessella Support Services plc, 4-Mar-1993
;
; Written     :  CDS Technical planning version by C D Pike, RAL, 26-May-1993
;
; Modified    :  Update for new tp_edit_lines.  CDP, 22-Sep-94
;                Got rid of delete line capability (use remove). CDP, 9-Nov-95
;    
; Version     :  Version 3, 9-Nov-95
;-

PRO tp_edtab_setval, id, value

  COMMON cw_tp_edtab_blk, state_base, state_stash, state, tp_detector, $
         changed

    ;**** Return to caller on error ****
  ON_ERROR, 2

    ;**** Retrieve the state ****
  CW_LOADSTATE, id, state_base, state_stash, state

    ;**** Set the data field values ****
  for i = 0 , state.ncols-1 do begin
    for j = 0 , state.nrows-1 do begin
      widget_control, state.fields(i,j), set_value = value(i,j)
    end
  end

END

;-----------------------------------------------------------------------------


FUNCTION tp_edtab_getval, id
    ;**** The value is recovered directly from   ****
    ;**** the text widgets.  The copy of VALUE   ****
    ;**** which is held in the state structure   ****
    ;**** is only used to prevent unnecessary    ****
    ;**** calls to NUM_CHK in the event handler. ****

  COMMON cw_tp_edtab_blk, state_base, state_stash, state, tp_detector, $
         changed

    ;**** Return to caller on error ****
  ON_ERROR, 2

    ;**** Retrieve the state ****
  CW_LOADSTATE, id, state_base, state_stash, state

    ;**** Declare the output value ****
  value = strarr(state.ncols,state.nrows)

    ;**** Get the data field values ****
  for i = 0 , state.ncols-1 do begin
    for j = 0 , state.nrows-1 do begin
      widget_control, state.fields(i,j), get_value = text
      value(i,j) = text
    end
  end

    ;**** Check input is valid numeric data if required ****
    ;**** overwrite bad values with '!error'.           ****
  if state.integer eq 1 or state.float eq 1 then begin
    if state.float eq 1 then integer = 0 else integer = 1
    for i = 0 , state.ncols-1 do begin
      for j = 0 , state.nrows-1 do begin
  if strtrim(value(i,j),2) ne '' then begin
    error = num_chk(value(i,j),integer=integer)
    if error eq 1 then value(i,j) = '!error'
  end
      end
    end
  end

  RETURN, value

END

;-----------------------------------------------------------------------------

FUNCTION tp_edtab_event, event

  COMMON cw_tp_edtab_blk, state_base, state_stash, state, tp_detector, $
         changed
  common comm_with_table, info_2

    ;**** Base ID of compound widget ****
  parent=event.handler

    ;**** Retrieve the state ****
  CW_LOADSTATE, parent, state_base, state_stash, state

    ;**** Clear any error message ****
  widget_control,state.messid,set_value=' '

    ;**** Structure of text widget uvalue ****
  pos = {row:0,col:0}


    ;************************
    ;**** Process Events ****
    ;************************
  CASE event.id OF

    ;**** Toggle edit controls on/off ****

    state.remid: if event.select eq 1 then $
                   state.control = 'Remove' else $
                   state.control = 'none'

    state.insid: if event.select eq 1 then $
                   state.control = 'Insert' else $
                   state.control = 'none'



    ;**** Toggle row/column skip control ****
    state.rskipid: begin
         if event.select eq 1 then begin
           state.rowskip = 1
           widget_control,state.cskipid,set_button=0
         endif else begin
           state.rowskip = 0
           widget_control,state.cskipid,set_button=1
         endelse
       end


    state.cskipid: begin
         if event.select eq 1 then begin
           state.rowskip = 0
           widget_control,state.rskipid,set_button=0
         endif else begin
           state.rowskip = 1
           widget_control,state.rskipid,set_button=1
         endelse
       end


    ;**** Text widget event, return key.           ****
    ;**** NB only editable widgets generate events ****
    ELSE: begin

      CASE state.control OF


  'Remove' : begin
    ;**** shift all values up one cell from event widget ****
      ;**** Get the position of text event widget ****
    widget_control,event.id,get_uvalue=pos
    row = pos.row
    col = pos.col

          for j=0,state.ncols-1 do begin

      ;**** Copy values up one cell ****
         for i = row, state.nrows-2 do begin
         widget_control,state.fields(j,i+1),get_value=temp
         widget_control,state.fields(j,i),set_value=temp
       end
      ;**** blank in the last cell ****
       widget_control,state.fields(j,state.nrows-1),set_value=''

          endfor

    state.control = 'none'
    widget_control,state.remid,set_button=0
    
  end

  'Insert' : begin
                ;**** shift all values down one cell from event widget ****
                        ;**** Get the position of text event widget ****
          widget_control,event.id,get_uvalue=pos
          row = pos.row
          col = pos.col
;
;  for all columns
;
          for j=0,state.ncols-1 do begin
;
;**** Copy values down one cell ****
;
             for i = state.nrows-1, row+1, -1 do begin
               widget_control,state.fields(j,i-1),get_value=temp
               widget_control,state.fields(j,i),set_value=temp
             end
;
;**** blank in the event cell ****
;
             widget_control,state.fields(j,row),set_value=''

          endfor

          state.control = 'none'
          widget_control,state.insid,set_button=0
  end


  ELSE     : begin
      ;******************************
      ;**** Skip cursor position ****
      ;******************************

      ;**** Get the position of text event widget ****
    widget_control,event.id,get_uvalue=pos
    row = pos.row
    col = pos.col

;
;  if this is the first change in a widget then need new title and decriptor
;
          if not changed then begin
             flash_msg,info_2,'Need new title and descriptor now...'
             widget_control, info_2, set_v=' '
             changed = 1
          endif

;
;  Technical planning extension of original
;  ==================
;
;  to cater for certain interdependencies of the columns  eg....
;
;
;  .. if wavelength is given then figure out the central pixel
;
          if col eq 1 then begin
             widget_control,state.fields(col,row),get_value=tempw
             widget_control,state.fields(4,row),get_value=tempb
             widget_control,state.fields(2,row),get_value=tempo
             tempo = tempo(0)
             tempb = tempb(0)
             tempw = tempw(0)

             if tempo eq '' then tempo = 1 else tempo = fix(tempo)
             widget_control,state.fields(2,row),$
                            set_value=string(tempo,form='(i8)')

             if tempb eq '' then begin
                if tp_detector eq 'N' then begin
                   tempb = strtrim(string(which_nis_band(tempw*tempo)),2)
                endif else begin
                   tempb = strtrim(string(which_gis_band(tempw*tempo)),2)
                endelse
             endif

             if tempb eq '-1' then begin
                flash_msg,state.fields(1,row),'   No way.'
                widget_control,state.fields(4,row), set_value=''
             endif else begin
                wave = float(tempw)*float(tempo)
                xpos = wave2pix(tp_detector+tempb,wave)
                widget_control,state.fields(4,row),$
                            set_value=string(tempb,form='(i8)')
                widget_control,state.fields(1,row),$
                            set_value=string(tempw,form='(f9.3)')
                widget_control,state.fields(3,row),$
                            set_value=string(xpos,form='(i8)')
             endelse
          endif

;
;  .. and vice versa, pixel given find wavelength
;
          if col eq 3 then begin
             widget_control,state.fields(col,row),get_value=tempp
             widget_control,state.fields(4,row),get_value=tempb
             widget_control,state.fields(2,row),get_value=tempo
             tempp = tempp(0)
             tempb = tempb(0)

             tempo = tempo(0)
             if tempo eq '' then tempo = 1 else tempo = fix(tempo)
             widget_control,state.fields(2,row),$
                            set_value=string(tempo,form='(i8)')

             if tempb eq '' then begin
                flash_msg,state.fields(4,row),'  ???'
                widget_control,state.fields(3,row),set_value=''
             endif else begin
                wave = pix2wave(tp_detector+tempb,tempp)
                widget_control,state.fields(3,row),$
                            set_value=string(tempp,form='(i8)')
                widget_control,state.fields(4,row),$
                            set_value=string(tempb,form='(i8)')
                widget_control,state.fields(1,row),$
                            set_value=string(wave,form='(f9.3)')
             endelse
          endif
           

    if state.rowskip eq 0 then begin
      ;**** Skip cursor down one field, move to the ****
      ;**** next editable column when the bottom of ****
      ;**** current column is reached.              ****
      row = row + 1
      if row ge (state.nrows) then begin
        row = 0
        col = col + 1
        if col ge (state.ncols) then begin
          col = 0
        end

        while (state.coledit(col) eq 0) do begin
          col = col + 1
          if col ge (state.ncols) then begin
            col = 0
          end
        end
      end
    endif else begin
      ;**** Skip cursor across one field to the ****
      ;**** next editable column.  When the end ****
      ;**** of the table is reached wrap around ****
      ;**** to the first column and step down   ****
      ;**** one row.          ****
      col = col + 1
      if col ge (state.ncols) then begin
        col = 0
        row = row + 1
        if row ge (state.nrows) then begin
          row = 0
        end
      end

        while (state.coledit(col) eq 0) do begin
          col = col + 1
          if col ge (state.ncols) then begin
            col = 0
            row = row + 1
            if row ge (state.nrows) then begin
              row = 0
            end
          end
        end
    endelse

    widget_control,/input_focus,state.fields(col,row)

  end

      ENDCASE

    end

  ENDCASE

    ;**** Check input is valid numeric data if required ****
  if state.integer eq 1 or state.float eq 1 then begin
    error = 0
    mess = ['Floating Point','Integer']
    if state.float eq 1 then integer = 0 else integer = 1

    ;**** Find the first error and then stop ****
    i = 0
    while (i lt state.ncols and error eq 0) do begin
      j = 0
      while (j lt state.nrows and error eq 0) do begin

    widget_control,state.fields(i,j),get_value=numstr
          numstr = numstr(0)

    ;**** Only check values which have changed ****
    ;**** Only update the state.value when new ****
    ;**** values check out okay.               ****
    if numstr ne state.value(i,j) then begin
      if strcompress(numstr,/remove_all) ne '' then begin
        error = num_chk(numstr,integer=integer)
        if error eq 1 then begin
          widget_control,state.messid, $
      set_value='****  Illegal '+mess(integer)+' Value  ****'
          widget_control,state.fields(i,j),/input_focus
        endif else begin
          state.value(i,j) = numstr
        endelse
      end
    end

  j = j+1
      end
      i = i+1
    end

  end

  RETURN, 0L
END

;-----------------------------------------------------------------------------

FUNCTION tp_edit_table, parent, NCOLS = ncols, NROWS = nrows, $
      COLEDIT = coledit, COLHEAD = colhead, $
      VALUE = value, FLOAT = float, INTEGER = integer, $
      UVALUE = uvalue, NOINDEX = noindex, $
      NOCON = nocon, YSIZE = ysize, CELLSIZE = cellsize, $
      NOEDIT = noedit, ROWSKIP = rowskip, FONTS = fonts, $
                        DET = det

  COMMON cw_tp_edtab_blk, state_base, state_stash, state, tp_detector, $
         changed

  IF (N_PARAMS() EQ 0) THEN MESSAGE, 'Must specify a parent for cw_edit_tab'
  ON_ERROR, 2         ;return to caller

    ;**** Set defaults for keywords ****
  IF NOT (KEYWORD_SET(ncols)) THEN ncols = 1
  IF NOT (KEYWORD_SET(nrows)) THEN nrows = 1
  IF NOT (KEYWORD_SET(coledit)) THEN coledit = make_array(ncols,/int,value=1)
  IF NOT (KEYWORD_SET(colhead)) THEN $
      colhead = make_array(ncols,/string,value='')
  IF NOT (KEYWORD_SET(value)) THEN $
      value = make_array(ncols,nrows,/string,value='')
  IF NOT (KEYWORD_SET(float)) THEN float = 0
  IF NOT (KEYWORD_SET(integer)) THEN integer = 0
  IF NOT (KEYWORD_SET(uvalue))  THEN uvalue = 0
  IF NOT (KEYWORD_SET(noindex)) THEN noindex = 0
  IF NOT (KEYWORD_SET(nocon)) THEN nocon = 0
  IF NOT (KEYWORD_SET(ysize)) THEN ysize = nrows
  IF NOT (KEYWORD_SET(cellsize)) THEN cellsize = 8
  IF NOT (KEYWORD_SET(noedit)) THEN  noedit = 0
  IF NOT (KEYWORD_SET(rowskip)) THEN rowskip = 0
  IF NOT (KEYWORD_SET(fonts)) THEN fonts = {font_norm:'',font_input:''}
  IF NOT (KEYWORD_SET(det)) THEN tp_detector = 'N' else tp_detector = det

;
;  try to check on changes in the line detail widgets
;
  changed = 0

    ;**** Create the main base for the table ****
  mainbase = WIDGET_BASE(parent, UVALUE = uvalue, $
    EVENT_FUNC = "tp_edtab_event", $
    FUNC_GET_VALUE = "tp_edtab_getval", $
    PRO_SET_VALUE = "tp_edtab_setval", $
    /COLUMN)

    ;**** Structure for uvalue of text widgets **** 
  pos = {col:0,row:0}

    ;**** Array of text widget IDs ****
  fields = lonarr(ncols,nrows)

    ;**** Create table base ****
  tabbase = widget_base(mainbase,/row,$
                        x_scroll_size=600,y_scroll_size=600)

    ;**** Create controls base ****
  if nocon eq 0 then conbase = widget_base(mainbase,/column)

    ;**** Create message area ****
  messid = widget_label(mainbase,value=' ',xsize=40,font=fonts.font_norm)

    ;********************************
    ;**** The Main Table of Data ****
    ;********************************

    ;**** How many rows of header are there? ****
  headsize = size(colhead)
  if headsize(0) eq 1 then numhrow = 1 else numhrow = headsize(2)

    ;**** Create the side-by-side sections of the table ****
  nsec = fix((nrows-1)/ysize)+1
  for k = 0 , nsec-1 do begin
    fstrow = k*ysize
    lstrow = min([((k+1)*ysize)-1,nrows-1])

    ;**** Create index column if required ****
    if noindex eq 0 then begin
      col_base = widget_base(tabbase,/column)
      rc = widget_label(col_base,value='Line #',font=fonts.font_norm)
      for i = 1 , numhrow-1 do $
     rc = widget_label(col_base,value=' ',font=fonts.font_norm)
      for j = fstrow, lstrow do begin
        rc = widget_text(col_base,xsize=3,value=string(j+1), $
              font=fonts.font_norm)
      end
    endif

    ;**** Create field columns, label at the top ****
    for i = 0 , ncols-1 do begin
 
      col_base = widget_base(tabbase,/column)
      for j = 0 , numhrow-1 do begin
        header = colhead(i,j)
        if header eq '' then header = ' '
        rc = widget_label(col_base,value=header,font=fonts.font_norm)
      end

      for j = fstrow, lstrow do begin
        pos.col = i
        pos.row = j
        if coledit(i) eq 1 then begin
          fields(i,j) = widget_text(col_base,/editable,xsize=cellsize, $
      font=fonts.font_input,value=value(i,j),uvalue=pos)
        endif else begin
          fields(i,j) = widget_text(col_base,xsize=cellsize, $
      font=fonts.font_norm,value=value(i,j),uvalue=pos)
        endelse
      end

    end
  end


    ;**** Create controls buttons ****
  if nocon eq 0 then begin
    conbase1 = widget_base(conbase,/row)
    dummy = widget_label(conbase1, value='Complete line: ')
    leftcon = widget_base(conbase1,/row,/exclusive,/frame)
    remid = widget_button(leftcon,value='Remove',font=fonts.font_norm)
    insid = widget_button(leftcon,value='Insert',font=fonts.font_norm)


    widget_control,leftcon,set_button=0
    rightcon = widget_base(conbase,/row,/nonexclusive,/frame)
    rskipid = widget_button(rightcon,value='Row_skip',font=fonts.font_norm)
    cskipid = widget_button(rightcon,value='Column_skip',font=fonts.font_norm)
    if rowskip eq 0 then begin
      widget_control,cskipid,set_button=1
    endif else begin
      widget_control,rskipid,set_button=1
    endelse
  endif else begin
    remid = long(0)
    insid = long(0)
  endelse

    ;**** Create an empty paste buffer ****
  paste_buf = ''

    ;**** Create state structure ****
  new_state =  {NCOLS:ncols, NROWS:nrows, FIELDS:fields, $ 
    VALUE:value, $
    INTEGER:integer, FLOAT:float, MESSID:messid, $
    REMID:remid, INSID:insid, $
    CSKIPID:cskipid, $
    RSKIPID:rskipid, PASTE_BUF:paste_buf, $
    COLEDIT:coledit, NOEDIT:noedit, CONTROL:'none', $
    ROWSKIP:rowskip}

    ;**** Save initial state structure ****
  ;CW_SAVESTATE, mainbase, state_base, new_state
 WIDGET_CONTROL, mainbase, /REALIZE
  RETURN, mainbase

END