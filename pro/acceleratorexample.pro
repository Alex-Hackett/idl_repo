; AcceleratorExample.pro  
; Example of the use of keyboard accelerators.  
  
pro acceleratorexample_event, event  
  
WIDGET_CONTROL, event.ID, GET_UVALUE = uvalue  
PRINT, 'Event on: ', uvalue  
  
IF ( uvalue EQ 'Quit' ) THEN BEGIN  
   WIDGET_CONTROL, event.TOP, /DESTROY  
END  
  
end  
  
pro AcceleratorExample  
  
tlb = WIDGET_BASE( /ROW, $  
   MBAR = mbar, TITLE = "Accelerator Example", $  
   XPAD = 10, YPAD = 10, XOFFSET = 25, YOFFSET = 25 )  
  
; Create a menu with accelerators. The accelerator string is   
; automatically displayed along with the menu item text.  
file = WIDGET_BUTTON( mbar, /MENU, $  
   VALUE = "File" )  
  
one = WIDGET_BUTTON( file, $  
   VALUE = "One", UVALUE = "One", $  
   ACCELERATOR = "Ctrl+1" )  
  
two = WIDGET_BUTTON( file, $  
   VALUE = "Two", UVALUE = "Two", $  
   ACCELERATOR = "Ctrl+2" )  
  
three = WIDGET_BUTTON( file, $  
   VALUE = "Three", UVALUE = "Three", $  
   ACCELERATOR = "Ctrl+3" )  
  
quit = WIDGET_BUTTON( file, $  
   VALUE = "Quit", UVALUE = "Quit", $  
   ACCELERATOR = "Ctrl+Q" )  
  
; Create a base with push buttons. Include the accelerator  
; text in the button value so users are aware of it.   
base = WIDGET_BASE( tlb, /COLUMN, /FRAME )  
  
b1 = WIDGET_BUTTON( base, $  
   VALUE = "Affirmative (Ctrl+Y)", UVALUE = "Yes", $  
   ACCELERATOR = "Ctrl+Y" )  
  
b2 = WIDGET_BUTTON( base, $  
   VALUE = "Negative (Ctrl+N)", UVALUE = "No", $  
   ACCELERATOR = "Ctrl+N" )  
  
; Create a base with radio buttons.   
base = WIDGET_BASE( tlb, /COLUMN, /FRAME, /EXCLUSIVE )  
  
b1 = widget_button( base, $  
   VALUE = "Owl (Ctrl+O)", UVALUE = "Owl", $  
   ACCELERATOR = "Ctrl+O" )  
  
b2 = WIDGET_BUTTON( base, $  
   VALUE = "Emu (Shift+E)", UVALUE = "Emu", $  
   ACCELERATOR = "Shift+E" )  
  
b3 = WIDGET_BUTTON( base, $  
   VALUE = "Bat (Alt+B)", UVALUE = "Bat", $  
   ACCELERATOR = "Alt+B" )  
  
; Create a base with check boxes.  
base = WIDGET_BASE( tlb, /COLUMN, /FRAME, /NONEXCLUSIVE )  
  
b1 = WIDGET_BUTTON( base, $  
   VALUE = "Hello (F3)", UVALUE = "Hello", $  
   ACCELERATOR = "F3" )  
  
b2 = WIDGET_BUTTON( base, $  
   VALUE = "Goodbye (F4)", UVALUE = "Goodbye", $  
   ACCELERATOR = "F4" )  
  
; Create the widgets and accept events.  
WIDGET_CONTROL, tlb, /REALIZE  
XMANAGER, 'acceleratorexample', tlb, /NO_BLOCK  
  
end  