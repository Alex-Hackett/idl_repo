
   PRO TextBox_Event, event

      ; This event handler responds to all events. Widget
      ; is always destoyed. The text is recorded if ACCEPT
      ; button is selected or user hits CR in text widget.

   Widget_Control, event.top, Get_UValue=info
   CASE event.ID OF
      info.cancelID: Widget_Control, event.top, /Destroy
      ELSE: BEGIN

            ; Get the text and store it in the pointer location.

         Widget_Control, info.textID, Get_Value=theText
         (*info.ptr).text = theText[0]
         (*info.ptr).cancel = 0 ; The user hit ACCEPT.
         Widget_Control, event.top, /Destroy
         ENDCASE
   ENDCASE
   END