; IDL Function to read MESA profiles and history files into a
; structure
;
; Rich Townsend 2012-10-30
; townsend@astro.wisc.edu

FUNCTION read_mesa, file

  ; Open the file

  OPENR, lun, file, /GET_LUN

  ; Read global column names

  line = ' '

  READF, lun, line
  READF, lun, line

  glob_col_names = STRSPLIT(line, /EXTRACT)

  n_glob_cols = N_ELEMENTS(glob_col_names)

  ; Now read the data

  READF, lun, line

  glob_data = STRSPLIT(line, /EXTRACT)

  ; Read table column names

  READF, lun, line

  READF, lun, line
  READF, lun, line

  col_names = STRSPLIT(line, /EXTRACT)

  n_cols = N_ELEMENTS(col_names)

  ; Now read the data

  n_rows = ulong(0)

  data = DBLARR(n_cols, 64)

  while not EOF(lun) do begin

    ; Check that there is enough space in the data
    ; array for the next row - if not, double
    ; the size of the array

    if(n_rows eq (size(data))[2]) then begin
      temp = data[*,0:n_rows-1]
      data = DBLARR(n_cols, n_rows*2)
      data[*,0:n_rows-1] = temp
    endif

    ; Read in a line of data

    READF, lun, line

    row_data = STRSPLIT(line, /EXTRACT)

    ; Store the data

    if(n_rows gt 0) then begin

      if(row_data[0] gt data[0,n_rows-1]) then begin

        data[*,n_rows] = row_data
        n_rows = n_rows + 1

      endif else begin

        data[*,n_rows-1] = row_data

      endelse

    endif else begin

      data[*,n_rows] = row_data
      n_rows = n_rows + 1

    endelse

  endwhile

  ; Close the file

  free_lun,lun

  ; Shrink down data

  data = data[*,0:n_rows-1]

  ; Now create the struct

  s = CREATE_STRUCT(glob_col_names[0], glob_data[0])

  for c = 1,n_glob_cols-1 do begin
    s = CREATE_STRUCT(s, glob_col_names[c], glob_data[c])
  endfor

  for c = 0,n_cols-1 do begin
    s = CREATE_STRUCT(s, col_names[c], TRANSPOSE(data[c,*]))
  endfor

  ; Return it

  return, s

END
