PRO setname, filename, dir, fname

           l = strlen (filename)
	   pos = 0
           i = 0
           while (i ne -1) do begin
	     i = strpos(filename, '/', i)
	     if (i ne -1) then begin
	        pos = i
	        i = i + 1
             endif
           endwhile
           if (pos EQ 0) then begin
            dir = ''
           endif else begin
            pos = pos + 1
            dir = strmid(filename, 0, pos)
          endelse
          fname = strmid (filename, pos, l-pos)

 END
