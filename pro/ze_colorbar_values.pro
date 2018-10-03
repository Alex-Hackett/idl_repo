

FUNCTION Colorbar_Annotate, axis, index, value
   text = ['','Lowest', 'Lower', 'Middle', 'Higher', 'Highest']
   possibleval = [ 0, 10, 30, 70, 85, 100]
   selection = Where(possibleval eQ value)
   IF selection[0] EQ -1 THEN RETURN, "" ELSE $
      RETURN, (text[selection])[0]
   END

   Device, Decomposed=0
   Window, XSize=500, YSize=75, Title='Colorbar Annotation Example'
   LoadCT, 33
   Colorbar, XTickV=[10, 30, 70, 85, 100], Range=[0,100], $
      XTickformat='colorbar_annotate', XMinor=0, Color=FSC_Color('black'), $
       Position=[0.1, 0.35, 0.9, 0.85], Font=0
end
