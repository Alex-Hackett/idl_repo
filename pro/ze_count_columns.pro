   FUNCTION ZE_Count_Columns, filename, skip=skip,MaxColumns = maxcolumns,compress=compress

      ;based on coyote's version, but optinally skips a number of lines to take in to account the presence of a header 
      ; This utility routine is used to count the number of
      ; columns in an ASCII data file. It uses the first row.
      ; as the count example.

      IF N_Elements(maxcolumns) EQ 0 THEN maxcolumns = 500

      OpenR, lun, filename, /Get_Lun,compress=compress

      Catch, theError
      IF theError NE 0 THEN BEGIN
         count = count-1
         RETURN, count
      ENDIF

      count = 1
      line = ''     
      ReadF, lun, line ;already read the 1st line
      IF N_elements(SKIP) GT 0 THEN FOR i=0, skip -2 DO READF, lun, line
      
      FOR j=count, maxcolumns DO BEGIN
         text = FltArr(j)
         ReadS, line, text
         count = count + 1
      ENDFOR

      RETURN, -1
   END