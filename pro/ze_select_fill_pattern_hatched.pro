FUNCTION ZE_SELECT_FILL_PATTERN_HATCHED,patt,parr

;  set up basic pattern array for this device
;  
;  Inputs : patt -          0:  solid (default)
;                           1:  hatch backward
;                           2:  hatch forward
;                           3:  vertical
;                           4:  horizontal
;                           5:  grid
;                           6:  cross hatch
;                           7:  empty
;  
;  
;
   parr = bytarr(100,100)

   case patt of
      1:  for i=0,9999,11 do parr(i) = 255
      2:  begin
             for i=0,9999,11 do parr(i) = 255 
             parr = rotate(parr,1) 
          end
      3:  for i=0,9999,10 do parr(i) = 255
      4:  begin
             for i=0,9999,10 do parr(i) = 255 
             parr = rotate(parr,1) 
          end
      5:  begin
             for i=0,9999,10 do parr(i) = 255
             parr = rotate(parr,1)
             for i=0,9999,10 do parr(i) = 255
          end
      6:  begin
             for i=0,9999,11 do parr(i) = 255
             parr = rotate(parr,1)
             for i=0,9999,11 do parr(i) = 255
          end
      7:  parr(*) = 0
      else:  parr(*) = 255
   endcase
;

RETURN,parr



END