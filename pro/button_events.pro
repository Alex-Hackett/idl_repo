PRO Button_Events, event
   Widget_Control, event.top, Get_UValue=info, /No_Copy
   info.currentButton = event.ID
   Widget_Control, event.top, Set_UValue=info, /No_Copy
   END