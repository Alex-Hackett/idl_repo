;+
;  NAME:      
;     ZE_XDISPSTR
;
;  PURPOSE:   
;     Display a string array in a text widget with a simple search capability.
;
; EXPLANATION:
;     Similar to the IDL XDISPLAYFILE procedure but includes a search capbility.
; CALLING SEQUENCE:    
;                 
;     xdispstr, array, [/BLOCK, WIDTH= , HEIGHT=, TITLE=, GROUP_LEADER=, FONT=
;                       TOP_LINE = ]
;
; INPUT PARAMETER:
;
;     array  - String array (.e.g. FITS header) to be displayed
;
;  OPTIONAL INPUT KEYWORD PARAMETERS:
;
;    block -  Set to 1 to make widget blocking.  Default = block=0
;          
;    width, height  - Scalars giving number of characters per line, number
;                           of lines.  Default = 80x24
;
;    title  - Scalar Title for outermost base widget.
;
;    group_leader  -    Group leader for top level base.
;
;    top_line - first line in the string array to display (default is 0)
;
;    font  -     Display font for text.
;
;  MODIFICATION HISTORY:
;     Written by R. S. Hill, RITSS, 17 Nov 2000
;     Use cumulative keyword to TOTAL   W. Landsamn   May 2006
;-


PRO ZE_XDISPSTR_EVENT, Event

widget_control, event.top, get_uvalue=info

search = 0b
destroy = 0b
CASE event.id OF
(*info).done_button:  destroy=1b
(*info).search_button:  search=1b
(*info).search_text:  search=1b
ELSE:
ENDCASE

IF search THEN BEGIN
    widget_control, (*info).search_text, get_value=seastr
    seastr = seastr[0]
    sp = strpos(strupcase(*(*info).arrayptr), strupcase(seastr))
    w = where(sp GE 0, c)
    IF c GT 0 THEN BEGIN
        tptr = sp[w] + (*(*info).clenptr)[w]
        tlen = strlen(seastr)
        ts = widget_info((*info).array_text, /text_select)
        this_line = max(where(ts[0] GE *(*info).clenptr, c3))
        line_frag = $
            strmid(strupcase((*(*info).arrayptr)[this_line]), $
                   ts[0] - (*(*info).clenptr)[this_line] + tlen)
        again = strpos(line_frag, strupcase(seastr))
        IF again GE 0 THEN BEGIN
            newtptr = again + tlen + ts[0]
        ENDIF ELSE BEGIN
            next = min(where(tptr GT ts[0], c2))
            IF c2 GT 0 THEN newtptr = tptr[next] ELSE newtptr = tptr[0]
        ENDELSE
        widget_control, (*info).array_text, set_text_select=[newtptr,tlen]
        new_line = max(where(newtptr GE *(*info).clenptr))
        middle = (*info).height/2
        nl = n_elements(*(*info).arrayptr)
        tl = ((new_line-middle)>0)<(nl-(*info).height)
        widget_control, (*info).array_text, set_text_top_line=tl
        widget_control, (*info).msg_text, set_value='Line '+strn(new_line)
    ENDIF ELSE BEGIN
        widget_control, (*info).msg_text, set_value='String not found'
    ENDELSE
ENDIF

IF destroy THEN widget_control, event.top, /destroy

RETURN
END

PRO ZE_XDISPSTR_CLEANUP, Id
widget_control, id, get_uvalue=info
IF ptr_valid(info) THEN BEGIN
    IF ptr_valid((*info).clenptr) THEN ptr_free, (*info).clenptr
    IF ptr_valid((*info).arrayptr) THEN ptr_free, (*info).arrayptr
    ptr_free, info
ENDIF
RETURN
END

PRO ZE_XDisplayFileGrowToScreen, tlb, text, height, nlines
; Grow the text widget so that it displays all of the text or
; it is as large as the screen can hold.

  max_y = (get_screen_size())[1] - 100
  cur_y = (WIDGET_INFO(tlb, /geometry)).scr_ysize

  ; If the display is already long enough, then there's nothing to do.
  ;
  ; We are only filling to grow the display, not shrink it, so if its
  ; already too big, there's nothing to do. This can only happen if
  ; the caller sets a large HEIGHT keyword, which is operator error.
  if ((nlines le height) || (cur_y gt max_y)) then return

  ; The strategy I use is binary divide and conquer. Furthermore,
  ; if nlines is more than 150, I limit the search to that much.
  ; (Consider that a typical screen is 1024 pixels high, and that
  ; using 10pt type, this yields 102 lines). This number may need to
  ; be adjusted as screen resolution grows but that will almost certainly
  ; be a slowly moving and easy to track target.
  ;
  ; Note: The variable cnt should never hit its limit. It is there
  ; as a "deadman switch".
  low = height
  high = MIN([150, nlines+1])
  cnt=0
  while ((low lt high) && (cnt++ lt 100)) do begin
    old_low = low
    old_high = high
    mid = low + ((high - low + 1) / 2)
    WIDGET_CONTROL, text, ysize=mid
    cur_y = (WIDGET_INFO(tlb, /geometry)).scr_ysize
    if (cur_y lt max_y) then low = mid else high = mid
    if ((old_low eq low) && (old_high eq high)) then break
  endwhile

end

PRO ZE_XDISPSTR, Array, BLOCK=block, WIDTH=width, HEIGHT=height, TITLE=title, $
                     GROUP_LEADER=group_leader, FONT=font,top_line=top_line,$
                      GROW_TO_SCREEN=grow_to_screen

on_error, 2

IF n_params(0) LT 1 THEN BEGIN
    print, 'CALLING SEQUENCE:  ZE_XDISPSTR, Array'
    print, 'KEYWORD PARAMETERS:  BLOCK, WIDTH, HEIGHT, TITLE, ' $
            + 'GROUP_LEADER, FONT'
    RETURN
ENDIF

IF n_elements(block) LT 1 THEN block=0
IF n_elements(width) LT 1 THEN width=80
IF n_elements(height) LT 1 THEN height=24
IF n_elements(title) LT 1 THEN title='ZE_XDISPSTR'

nlines = n_elements(array)

tlb = widget_base(title=title,col=1,group_leader=group_leader)

controls = widget_base(tlb, frame=1, row=1)
done_button = widget_button(controls, value='Done', /no_release)
search_button = widget_button(controls, value='Search:', /no_release)
search_text = widget_text(controls, xsize=30, ysize=1, /editable, font=font)
msg_label = widget_label(controls, value='Message: ')
msg_text = widget_text(controls, xsize=20, ysize=1, font=font)

array_text = widget_text(tlb, value=array, $
                         xsize=width, ysize=height, /scroll, edit=0, font=font)

if not keyword_set(top_line) then top_line = 0
widget_control, array_text, set_text_top_line=top_line
widget_control, array_text, set_text_select=[0,0]

nlines = n_elements(tlb)

if (keyword_set(grow_to_screen)) then $
  ZE_XDisplayFileGrowToScreen, tlb, array_text, height, nlines

widget_control, tlb, /realize
    
linelen1 = strlen(array) + 1
cumul_len = [0, total(linelen1,/cumulative,/integer)]
info = ptr_new({done_button:done_button, $
                search_button:search_button, search_text:search_text, $
                array_text:array_text, arrayptr:ptr_new(array), $
                clenptr:ptr_new(cumul_len,/no_copy), $
                msg_text:msg_text, width:width, height:height})

widget_control, tlb, set_uvalue=info

xmanager, 'ze_xdispstr', tlb, cleanup='ze_xdispstr_cleanup', $
          event_handler='ze_xdispstr_event', no_block=1b-block, $
          group_leader=group_leader

RETURN
END
