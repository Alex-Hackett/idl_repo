
pro primary_update,fcb,header_in

;+
;
;*NAME:
;       PRIMARY_UPDATE	
;
;*PURPOSE:
;	To update a fits primary header.
;
;*CATEGORY:
;	INPUT/OUTPUT
;
;*CALLING SEQUENCE:
;	primary_update, fcb, header_in
;
;*INPUTS:
;	FCB: name of the FITS control block returned by FITS_OPEN
;		(called with the /UPDATE parameter).
;	HEADER_IN: FITS header keyword.  
;		   Required FITS keywords, SIMPLE, BITPIX, XTENSION, NAXIS, 
;		   are added by PRIMARY_UPDATE and do not need to be supplied
;                  with the header.
;
;-----------------------------------------------------------------------------
;
; print calling sequence if no parameters supplied
;
	if n_params(0) lt 1 then begin
	    print,'CALLING SEQUENCE: primary_update, fcb, header_in'
	    return
	end
;
	point_lun, fcb.unit, fcb.start_header(0)
;
	header = header_in
;
; on I/O error go to statement IOERROR
;
;	on_ioerror,ioerror
;
; verify file is open for writing
;
	if fcb.open_for_write ne 3 then begin
		message,'File is not open for updating'
		goto,error_exit
	endif
;
; update naxis and bitpix (primary unit has no data)
;
	naxis = 0
	bitpix = 8
;
; separate header into main and extension header
;
	keywords = strmid(header,0,8)
	hpos1 = where(keywords eq 'BEGIN MA') & hpos1 = hpos1(0) ;begin main
	hpos2 = where(keywords eq 'BEGIN EX') & hpos2 = hpos2(0) ;begin ext.
	hpos3 = where(keywords eq 'END     ') & hpos3 = hpos3(0) ;end of header	

	if (hpos1 gt 0) and (hpos2 lt hpos1) then begin
		message,'Invalid header BEGIN EXTENSION HEADER ... out of place'
		goto,error_exit
	endif

	if (hpos3 lt 0) then begin
	  print, $
	   'PRIMARY_UPDATE: END missing from input header and was added'
	  header = [header,'END     ']
	  hpos2 = n_elements(header)-1
	endif
;
; get primary header
;
		if (hpos1 gt 0) and (hpos2 gt (hpos1+1)) then $
			hmain = [header(hpos1+1:hpos2-1),'END     ']
;
; create required keywords for the header
;
	h = strarr(20)
	h(0) = 'END     '

	sxaddpar,h,'SIMPLE','T','image conforms to FITS standard' 
	sxaddpar,h,'bitpix',bitpix,'bits per data value'
	sxaddpar,h,'naxis',naxis,'number of axes'
	sxaddpar,h,'EXTEND','T','file may contain extensions'
;
; combine the two headers
;
	last = where(strmid(h,0,8) eq 'END     ')
	header = [h(0:last(0)-1),hmain]
;
; convert header to bytes and write
;
write_header:
	last = where(strmid(header,0,8) eq 'END     ')
	n = last(0) + 1
	hsize = n*80
	if hsize GT (fcb.start_data(0) - fcb.start_header(0)) then begin
	   message,'Updated header too big for allocated area'
	   goto,error_exit
        endif
	byte_header = replicate(32b,80,n)
	for i=0,n-1 do byte_header(0,i) = byte(header(i))
	writeu,fcb.unit,byte_header
;
; pad header to 2880 byte records
;
	npad = 2880 - (80L*n mod 2880)	
	if npad eq 2880 then npad = 0
	if (npad gt 0) then writeu,fcb.unit,replicate(32b,npad)
	nbytes_header =  npad + n*80
	!err = 1
	return
;
; error exit
;
ioerror:
	message = !err_string
error_exit:
	free_lun,fcb.unit
	print, message
	!err = -1
	return
end

