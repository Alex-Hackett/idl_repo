;+
; NAME:
;	ACS_READIMAGE.PRO
;
; PURPOSE:
;	This procedure reads IRAF, FITS, MAMA, CC200, SDAS, or
;	RAW packetized image files.
;
; CATEGORY:
;	Image processing.
;
; CALLING SEQUENCE:
;	ACS_READIMAGE, Infile, Image, Header
;
; INPUTS:
;      Infile:	Image file to be read, enclosed in "".
;
; KEYWORDS:
;
;	 Fits:	Set this keyword if the input is in FITS or compressed
;		FITS format.
;	 Iraf:	Set this keyword if the input file is an IRAF image.
;	 Sdas:	Set this keyword if the input file is an SDAS image.
;	 Mama:	Set this keyword if the input file is a MAMA image
;		(unformatted binary data). Note: Image must be square
;		Integer*2 format.
;	cc200:	Set this keyword if the input file is a photometrics
;		CC200 data file.
;	  Raw:	Set this keyword if the input file is raw packetized
;		data.
;
; OUTPUTS:
;	Image: 	Image array.
;      Header:	Header array.
;
; RESTRICTIONS:
;	UNIX systems only.
;
; OPERATIONAL NOTES:
;	Program utilizes irafrd.pro, readfits.pro, sxopen.pro, 
;	sxread.pro, scatt_rd.pro and read_mama.pro. Program will uncompress
;	or gunzip the file if filename contains the suffix '.Z' or '.gz'.
;	If one of the above file-type keywords is not specified then
;	the program will attempt to determine the input file type by
;	looking at the filenames' suffix (extension). Standard extensions:
;
;	FITS:	'.fits'
;	IRAF:	'.imh'
;	SDAS:	'.hhh'
;	MAMA:	'.dat'
;	CC200:	none		# user must specify keyword for CC200 data.
;	RAW:	'.SDI'
;
; EXAMPLES:
;	IDL>readimage, 'test.imh', im, hd, /iraf		#iraf image
;	IDL>readimage, 'test.hhh', im, hd, /sdas		#sdas image
;	IDL>readimage, 'test.fits', im, hd		#suffix identifies it
;
; MODIFICATION HISTORY:
;       Written by:     Terry Beck      ACC     December 1, 1994
;	Added /mama keyword.			TLB	5-10-95
;	Added on-the-fly decompression.		TLB	5-10-95
;	Added CC200 read capability.		TLB	5-12-95
;	Ported to vax/vms.			TLB	6-14-95
;	Added RAW packet reading capability.	TLB	10-30-95
;	Changed FITS reader to Don'e new one.	TLB	10-30-95
;	Changed upper->lower case for VMS	TLB	3-5-96
;	All users can now uncompress files.	TLB	6-10-96
;	ACS version.				TLB	08-19-98
;-
;______________________________________________________________________________

pro acs_readimage, infile, image, header, fits=fits, iraf=iraf, sdas=sdas, $
    mama=mama, cc200=cc200, raw=raw

if (n_params() eq 0) then begin
    print, 'CALLING SEQUENCE:'
    print, '	Acs_readimage, Infile, Image, Header'
    print
    print, '	Keywords: FITS, IRAF, SDAS, MAMA, CC200, RAW
    retall
endif

; Under VMS strip off the version # 

if (!version.os eq 'vms') then infile=gettok(infile,';')

; check for keywords

type = ''
if keyword_set(iraf) then type = 'IRAF'
if keyword_set(fits) then type = 'FITS'
if keyword_set(sdas) then type = 'SDAS'
if keyword_set(mama) then type = 'MAMA'
if keyword_set(cc200) then type = 'CC200'
if keyword_set(raw) then type = 'RAW'

; if no keyword is set then try to determine 
; file type by the extension, if any.

if (type eq '') then begin
    s = strpos(strlowcase(infile), '.imh')
    if (s ne -1) then type = 'IRAF'
    s = strpos(strlowcase(infile), '.hhh')
    if (s ne -1) then type = 'SDAS'
    s = strpos(strlowcase(infile), '.dat')
    if (s ne -1) then type = 'MAMA'
    s = strpos(strlowcase(infile), '.fits')
    if (s ne -1) then type = 'FITS'
    s = strpos(strlowcase(infile), '.SDI')
    if (s ne -1) then type = 'RAW'
endif

; uncompress the file if it is compressed
uncompress=0

s = strpos(infile, '.Z')
if (s ne -1) then begin
    message, 'Uncompressing ' + type + ' data file', /inform
    fdecomp,infile,disk,dir,fname,ext
    spawn, 'uncompress -c ' + infile + ' > /tmp/'+fname
    infile = '/tmp/' + fname
    uncompress = 1
endif

; Unzip the file if it has been g-zipped

s = strpos(infile, '.gz')
if (s ne -1) then begin
    message, 'Gun-zipping ' + type + ' data file', /inform
    fdecomp,infile,disk,dir,fname,ext
    spawn, 'gunzip -c ' + infile + ' > /tmp/'+fname
    infile = '/tmp/' + fname
    uncompress = 1
endif

; read the image

case type of
    'IRAF': begin
	s = strpos(infile, '.imh')
	rtfile = strmid(infile, 0, s)
	irafrd, image, header, rtfile
	end

    'FITS': fits_read, infile, image, header

    'SDAS': begin
	sxopen, 1, infile, header
	image = sxread(1)
	end

    'MAMA': read_mama, infile, image, header

    'CC200': begin
	scatt_rd, infile, ah, bh, ch, image
	sxhmake, image, 0, header
	end

    'RAW': begin
	acs_acquire, infile, header, image, /nowrite
	end

    ELSE: begin
	print, 'Invalid or unknown file type.'
	print
	retall
	end
endcase

if uncompress then spawn,'/usr/bin/rm -f '+infile

; for data types other than FITS, need to convert from IEEE to VAX
; format. READFITS does this automatically

if (type ne 'FITS' and type ne 'IRAF' and !version.os eq 'vms' $
    and type ne 'RAW') then ieee_to_host,image

return
end
	
