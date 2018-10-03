;+
;		ACS quicklook analysis widget
; NAME:
;	acslook.pro
;
; PURPOSE:
;	This widget provides the user with an interactive tool for 
;	preliminary data analysis. This routine will help the user verify
;	the quality of the data received (proper configuration & target, 
;	sufficient count levels, etc.).
;
; CATEGORY:
;	Widgets.
;
; CALLING SEQUENCE:
;	acslook [, image] [, image2]
;
; INPUTS:
;	None required on the command line.
;
; OPTIONAL INPUTS:
;	image:	Input image. If not given, the user must load an IRAF, FITS, 
;		or SDAS image file after the widget appears on the screen.
;		If an image is given on the command line then a header
;		array must also be given.
;      image2:	Second input image.
;	
; KEYWORD PARAMETERS:
;     header1:	First image header (string array). 
;     header2:	Second header array.
;	 bias:	If the bias subtraction is to be performed, and the bias image
;		is already loaded into an IDL variable, set this keyword.
;	 dark:	If the dark subtraction is to be performed, and the dark image
;		is already loaded into an IDL variable, set this keyword.
;	 flat:	If the flat division is to be performed, and the flat-field
;		image is already loaded into an IDL variable, set this keyword.
;
;		Note: The above keywords are only used if the image and/or
;		header are also input on the command line (see OPTIONAL 
;		INPUTS above).
;	  log:	Set this keyword so that the initial display scale is
;		logarithmic.
;	  sqt:	Set this keyword so that the initial display scale is
;		square root.
;	 hist:	Set this keyword so that the initial display scale is
;		histogram equal.
;
; OUTPUTS:
;	None explicitly.
;
; RESTRICTIONS:
;	Progrm reads IRAF, FITS, SDAS, MAMA or raw telemetry data file formats.
;	*** Program requires IDL Version 4.0 or later. ***
;
; PROCEDURE:
;	To begin, the user may input the image on the command line 
;	(See OPTIONAL INPUTS). If not, the user must select an image file 
;	type and press the 'Load File' button after the widget appears.
;	(all other widgets are commented out at this point). Once the
;	image is loaded the image will be displayed in a separate window.
;	The default size for this window in 512X512. If the input image is
;	larger or smaller, then it will be resized to fit. The user may 
;	resize this window to any desired size.
;
; SUPPORT PROCEDURES:
;	acslook_event - main event handler for acslook.
;	pdmenu11_event - event handler for pull-down menus.
;	acl_check_file - checks for existance of a file.
;	acl_displ_win - event handler for the image display window.
;	acl_displ_image - displays an image.
;	acl_scale_im - scales an image.
;	acl_load_buffer - loads an image into a pixel map buffer.
;	acl_replot_zoom - loads/refreshes an image section in the zoom window.
;	acl_get_rtfile_name - strips off the extention from a filename.
;	acl_subtract - subtracts one image from another.
;	acl_addmess - add a message to the message window.
;
;
; EXAMPLES:
;	1) To run program with an IRAF, FITS, SDAS, or MAMA image:
;		IDL>acslook		;see PROCEDURE above
;	2) To load 1 image and header from IDL variables:
;		IDL>acslook, image, header1=h1
;	3) To load 2 images & headers from IDL variables:
;		IDL>acslook, image1, header1=h1, image2, header2=h2
;	4) To load an image and its bias frame from IDL variables:
;		IDL>acslook, image, header1=h, bias=bias
;	
; MODIFICATION HISTORY:
; 	Written by:	Terry Beck	ACC	December, 1994
;	 Added 'Display Header' button. TLB/ACC	Jan 30, 1995
;	 Added Rotate Pull-down menu. TLB/ACC Jan 30, 1995
;	 Filename is now displayed on image window.  TLB/ACC Feb. 9, 1995
;	 Added 2nd image buffer capacity. TLB/ACC Feb 28, 1995
;	 Added option for bad pixel replacement. TLB/ACC Mar 6, 1995
;	 Help text removed from body of program. TLB/ACC Mar 14, 1995	
;	 Blink capability added.  TLB/ACC  Mar 16, 1995.
;	 Fixed bug that crashes program if user clicks in display
;	     window before loading image.  TLB/ACC Apr 14, 1995.
;	 Added log, sqt, & hist keywords.  TLB/ACC May 8, 1995.
;	 Can read compressed files & mama files.  TLB/ACC May 10, 1995.
;	 Output format is only in FITS.  TLB/ACC May 10, 1995.
;	 Headers are now optional.  TLB/ACC May 10, 1995.
;	 Added call to big_ps.pro.  TLB/ACC May 15, 1995.
;	 stl_mkwin.pro removed from body of program.  TLB/ACC May 29, 1995.
;	 Set default font to '6x13'.  TLB/ACC May 31, 1995.
;	 Modified to work under vax/vms.  TLB & PP/ACC  June 13, 1995.
;	 Routine now checks for 2-D images.  TLB/ACC Sept 5, 1995
;	 Fixed bug in histogram plotting of I*2 images. TLB Sept 19, 1995.
;	 Added Encircled energy option.  TLB  Sept 20, 1995.
;	 Fixed bug in reading headers from the command line. TLB Sept 28, 1995.
;	 Added FILE pulldown menu & TIFF, JPEG, GIF writing 
;	 capacity. TLB 10-26-95.
;	 Added RAW data packet reading capacity. TLB 10-30-95
;	 Title now appears in FWHM plots.  TLB  11-28-95
;	 Added B/W & reversed B/W postscript output capacity. TLB 11-28-95
;	 Added header editor pull-down menu. TLB  12-5-95
;	 Enabled time-tag capability. TLB  12-7-95
;	 Fixed bug in image scale values (integer bit-flipping). TLB 12-14-95
;	 Added variable extraction width for cross-sections. TLB  12-28-95
;	 Added Scrollable message window.  TLB  1-3-96.
;	 Added rebining option Image processing menu. TLB  2-9-96
;	 Image statistics now reports total counts also. TLB 2-9-96
;	 User now inputs PS filenames. Write permission is checked. TLB 2/13/96
;	 Help file retrieved with find_with_def.pro. TLB 2-15-96
;	 Image MIN/MAX are now be floating point numbers. TLB 2-22-96
;	 Header is now searched for EXPTIME & INTEG when doing count-rate
;	   conversion. TLB  3-5-96
;	 Fixed image subtraction bug. TLB  3-5-96.
;	 Routine now uses fits_write. TLB  3-8-96.
;	 Fixed zoom-window coordinate problem.  TLB  3-11-96
;	 Added ability to read from DB entry #.  TLB  3-15-96
;	 Changed order that messages appear. TLB 3-15-96
;	 Added more output to Im Stats & Encirc. Energy Options. TLB 3-16-96
;	 Fixed zoom-window coordinate (really this time).
;	 Fixed log-scaling problem in images with lots of zeros. TLB 7-1-96
;	 Added save header to file. TLB 7-5-96
;	 Changed save header to Print header. TLB 8-1-96
;	 Fixed Square root scaling (no negative numbers). TLB 8-9-96
;	 Removed references to /string, /floating, & /integer keywords to
;	   fields_popup.pro.  TLB  8-9-96
;	 Added "print Messages" button.  TLB  8-16-96
;	 Fixed integer addition with NCOUNTS.  TLB  8-16-96
;        Made test for Time Tag data generic, not just on RAW files JLS 8/17/96
;	 Now handles memory dump data (MIE) images.  TLB  9/11/96
;	 Doesn't crash on missing header keywords in FITS files. TLB 10/03/96
;	 Fixed string conversion in Header-Editor:Add-history. TLB 10/08/96
;	 Fixed MIE image processing problem.  TLB 11/10/96
;	 Modified to handle both pre/post-launch data.  TLB  18 Feb 97
;	 Corrected pre/post-launch type selection 	DJL  26 Feb 97
;	 Added error trapping for bad DB entry numbers. TLB  6 Mar 97
;	 Added ability to get any readout from post-launch data. TLB 6 Mar 97
;	 Fixed image rotation coordinate problem.  TLB  14 Mar 97
;	 Ported to IDL Version 5.0.  TLB  20 Mar 97
;	 Updated calling sequences to popup routines; set grl. TLB  4 Jun 97
;	 Updated calling sequence for time-tag processing.  TLB  17 Jun 97
;	 Installed error checking for missing time-tag data.  TLB  19 Jun 97
;	 Removed time-tag processing (files too large).  TLB  27 Jun 97
;	 Change rebining function. TLB 27 Jun 97
;	 Added pixel list function.  TLB  30 Jun 97
;	 Fixed image scaling problem & default font.  TLB  10 Sept 97
;	 Fixed plot_type reset problem in pixel list.  TLB 22 Oct 97
;	 Added more digits to Image min/max display field. TLB  13 Nov 97
;	 Added more digits to coord. display for SCI notation.  TLB  9 Dec 97
;	 Corrected subimage extraction problem with zoom window.  TLB 22 Jan 98
;	 Doesn't crash if user re-sizes display window before loading an
;	   image.  TLB  19 May 98
;	 Image display algorithm changed.  TLB  19 June 98
;	 Now scales the Image min & max too (LOG & SQRT).  TLB 22 Jun 98
;	 Completely re-wrote image scaling program.  DJL & TLB  24 Jun 98
;	 Coordinate display now starts at zero.  TLB  25 Jun 98
;	 Removed out-of-date overscan correction option.  TLB  25 Jun 98
;	 Histogram plots can now use flux-calibrated data.  TLB  29 Jun 98
;	 Version for Advanced Camera.  TLB  12 Aug 98
;	 Removed dependance on PRINTER env VAR.  TLB 13 Nov 98
;	 Force Zoom scale slider to be 256 pixels for IDL V5.2 TLB 4 Mar 99
;-
;_____________________________________________________________________________
;
;************************* Event Handler for pull-down menus *****************
;

PRO PDMENU11_Event, image , resized_im, header, im_pars, wid_pars, $
    fl_pars, mess_array, Event

mp =fl_pars.mapped
ds = fl_pars.dwin_size


  CASE Event.Value OF 

  '  Image Processing  .Convert to Count Rate': BEGIN	;count rate conversion

	exp = sxpar(header, 'EXPTIME')
	if (exp eq 0) then exp = sxpar(header, 'INTEG')
	if (exp eq 0) then begin
	    message = "Can't get exposure time from header! Operation aborted."
	    acl_addmess, mess_array, message, wid_pars.mess
	    print, string(7b)
	    wait, 2.0
	endif else begin
	    widget_control, /hourglass
	    message = 'Converting to count rate...'
	    acl_addmess, mess_array, message, wid_pars.mess
	    fl_pars.y_units(mp) = 'counts per second'
	    image = float(image)/exp	 		;divide by exptime    
	    resized_im = frebin(image, ds(0), ds(1))
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
		wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	    hist = 'Converted to count rate: ' + systime(0)
	    sxaddhist, hist, header			;update the header
	endelse
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Processing  .Fix Bad Column(s)': BEGIN	;bad pixel replacement

	q = 'Enter coordinates of bad column(s):
	t = 'Bad Pixels'
	label = ['X1', 'X2', 'Y1', 'Y2']
	output = fields_popup(t,q,label,grl=event.top)

	if (output.cancel eq 0) then begin		;valid ranges?
	    if (output.values(0) lt 0 or $
		output.values(1) ge im_pars.nx(mp) or $
		output.values(2) lt 0 or $
		output.values(3) ge im_pars.ny(mp)) then begin
		print, string(7b)
		message = 'Invalid subscript range!'
		acl_addmess, mess_array, message, wid_pars.mess
		wait, 2.0
	    endif else begin				;subscript ranges good
		message = 'Fixing bad pixels...'
		acl_addmess, mess_array, message, wid_pars.mess
		widget_control, /hourglass
		fixpix, image, output.values, image
		resized_im = frebin(image, ds(0), ds(1))
	        acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
		    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, $
		    im_pars, fl_pars, wid_pars
		reg = output.values
		region = '[' + $
		    strcompress(string(reg(0)), /remove_all) + ':' + $
		    strcompress(string(reg(1)), /remove_all) + ',' + $
		    strcompress(string(reg(2)), /remove_all) + ':' + $
		    strcompress(string(reg(3)), /remove_all) + ']'
		hist = 'Fixed bad pixels ' + region + ' ' + systime(0)
		sxaddhist, hist, header			;update the header
	    endelse
	    acl_addmess, mess_array, 'Ready.', wid_pars.mess
	endif	
    END

  '  Image Processing  .Bias Subtraction': BEGIN	;bias subtraction

	acl_subtract, image, resized_im, header, 'bias', im_pars, $
	    fl_pars, wid_pars, mess_array
    END

  '  Image Processing  .Dark Subtraction': BEGIN	;dark subtraction

	acl_subtract, image, resized_im, header, 'dark', im_pars, $
	    fl_pars, wid_pars, mess_array
    END

  '  Image Processing  .Flat Field': BEGIN		;flat field

	acl_addmess, mess_array, 'Flat fielding...', wid_pars.mess
	
	widget_control, /hourglass
	if (fl_pars.file_type eq 'IDL') then begin	;image is an IDL array
	    if (fl_pars.no_flat eq 'yes') then begin	;keyword not set
		m1 = 'Select the flat field file type '
		m2 = 'and choose this option again.'
        	err_mess = m1 + m2
        	err = 1
	    endif else begin
		err = 0
		flat = im_pars.flat
	    endelse
	endif else begin				;image is from a file
	    title= 'Select Normalized flat field image'
	    infile = pickfile(filter=fl_pars.filter, title=title, $
            	path=fl_pars.path, get_path=newpath)
	    if (infile ne '') then begin
		type = '/' + fl_pars.file_type
		com = 'readimage, infile, flat, flat_hd, ' + type
        	r = execute(com)
		err = 0
	    endif else begin
		err = 1
		err_mess = 'Operation canceled.'
	    endelse
	endelse

	if (err eq 0) then begin			;got a valid flat
	    s = size(flat)				;images same size?
	    if (s(1) eq im_pars.nx(mp) and s(2) eq im_pars.ny(mp)) then begin
		flatten, flat, 0, 0, float(image), 0, 0, output
		image = output
		err = 0
	    endif else begin				;if not, try to 
		ix = sxpar(header, 'X0', count=ixc)	;register the flat
	    	iy = sxpar(header, 'Y0', count=iyc)
		if (ixc ne 0 and iyc ne 0) then begin
		    flatten, flat, 0, 0, float(image), ix, iy, output
		    image = output
		    err = 0
		endif else begin
		    err = 1
		    err_mess = 'Cannot register flat! Operation aborted.'
		endelse
	    endelse
	endif

	if (err eq 1) then begin			;operation unsucessful
	    print, string(7b)
	    acl_addmess, mess_array, err_mess, wid_pars.mess
	    wait, 2.0
	endif else begin				;it worked!
	    mess = 'Operation successful - displaying processed image...'
	    acl_addmess, mess_array, mess, wid_pars.mess
	    ds = fl_pars.dwin_size
	    resized_im = frebin(image, ds(0), ds(1))
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
		wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	    hist = 'Flat fielded: ' + systime(0)
	    sxaddhist, hist, header                     ;update header
	endelse
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END
    
  '  Image Processing  .Rebin: 2x2': BEGIN		;Rebin
  
  	widget_control, /hourglass
  	nx = im_pars.nx(mp)
  	ny = im_Pars.ny(mp)
  	new_nx = nx/2
  	new_ny = ny/2
  	snnx = strcompress(string(new_nx), /remove_all)
	snny = strcompress(string(new_ny), /remove_all)
	snx = strcompress(string(nx), /remove_all)
	sny = strcompress(string(ny), /remove_all)
  	message = 'Rebining: ' + snx + 'X' + sny + ' -> ' + snnx + 'X' + snny
  	acl_addmess, mess_array, message, wid_pars.mess	
  	image = rebin(image*4l,new_nx, new_ny)
	im_pars.nx(mp) = new_nx
	im_pars.ny(mp) = new_ny
	im_pars.cenx = im_pars.cenx/2
	im_pars.ceny = im_pars.ceny/2
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Rebined to ' + snnx + 'X' + snny + ' ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END
    
  '  Image Filtering  .Median 3X3': BEGIN		;3x3 median filter

	widget_control, /hourglass
	message = 'Median filtering 3X3...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = median(image,3)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Median filtered (3x3): ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Median 5X5': BEGIN		;5x5 median filter

	widget_control, /hourglass
	message = 'Median filtering 5X5...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = median(image,5)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Median filtered (5x5): ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Smooth 3X3': BEGIN		;3x3 smooth filter

	widget_control, /hourglass
	message = 'Smoothing using 3X3 boxcar...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = smooth(image,3)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Smoothed (3x3) boxcar: ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Smooth 5X5': BEGIN		;5x5 smooth filter

	widget_control, /hourglass
	message = 'Smoothing using 5X5 boxcar...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = smooth(image,5)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Smoothed (5x5) boxcar: ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Roberts': BEGIN			;edge enhancement

	widget_control, /hourglass
	message = 'Performing Roberts edge enhancement...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = roberts(image)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Edge enhancement VIA Roberts: ' + systime(0)
	sxaddhist, hist, header                     ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Sobel': BEGIN			;edge enhancement

	widget_control, /hourglass
	message = 'Performing Sobel edge enhancement...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = sobel(image)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
	hist = 'Edge enhancement VIA Sobel: ' + systime(0)
	sxaddhist, hist, header                    	;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Image Filtering  .Convolution': BEGIN		;convolution

	title = 'Select FITS file containing kernel'
	infile = pickfile( title=title, path=fl_pars.path)
	if (infile ne '') then begin
	    widget_control, /hourglass
	    acl_addmess, mess_array, 'Convolving...', wid_pars.mess
            readimage, infile, kernel, hd, /fits
	    image = convol(image,kernel)
	    ds = fl_pars.dwin_size
	    resized_im = frebin(image, ds(0), ds(1))
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    	wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    	fl_pars, wid_pars
	    hist = 'Convolved with: ' + infile + ' ' + systime(0)
	    sxaddhist, hist, header                     ;update header
	    acl_addmess, mess_array, 'Ready.', wid_pars.mess
	endif
    END

  '  Plots  .Cross Section.1 pixel wide': BEGIN		;cross-section 1-pixel

	message = 'Position cursor on each endpoint & click left'
	acl_addmess, mess_array, message, wid_pars.mess
	fl_pars.plot_type='cross_section_p1'
	fl_pars.c_sect_width = 1
    END

  '  Plots  .Cross Section.3 pixels wide': BEGIN         ;cross-section 3-pixel

        message = 'Position cursor on each endpoint & click left'
	acl_addmess, mess_array, message, wid_pars.mess
        fl_pars.plot_type='cross_section_p1'
        fl_pars.c_sect_width = 3
    END

  '  Plots  .Cross Section.5 pixels wide': BEGIN         ;cross-section 5-pixel

        message = 'Position cursor on each endpoint & click left'
	acl_addmess, mess_array, message, wid_pars.mess
        fl_pars.plot_type='cross_section_p1'
        fl_pars.c_sect_width = 5
    END

  '  Plots  .Cross Section.7 pixels wide': BEGIN         ;cross-section 7-pixel

        message = 'Position cursor on each endpoint & click left'
	acl_addmess, mess_array, message, wid_pars.mess
        fl_pars.plot_type='cross_section_p1'
        fl_pars.c_sect_width = 7
    END

  '  Plots  .Cross Section.9 pixels wide': BEGIN         ;cross-section 9-pixel

        message = 'Position cursor on each endpoint & click left'
	acl_addmess, mess_array, message, wid_pars.mess
        fl_pars.plot_type='cross_section_p1'
        fl_pars.c_sect_width = 9
    END


  '  Plots  .Row Sum': BEGIN				;row sum

	message = 'Position cursor on first and last row to sum & click left'
	acl_addmess, mess_array, message, wid_pars.mess
	fl_pars.plot_type = 'row_sum_p1'
    END

  '  Plots  .Column Sum': BEGIN				;column sum

	message = 'Position cursor on first and last column to sum & click left'
	acl_addmess, mess_array, message, wid_pars.mess
	fl_pars.plot_type = 'column_sum_p1'
    END

  '  Plots  .Histogram': BEGIN				;histogram

	message = 'Creating histogram...'
	acl_addmess, mess_array, message, wid_pars.mess
	widget_control, /hourglass
	file = fl_pars.file(fl_pars.mapped)
     	hi = max(image)
	lo = min(image)
	nbins = 500
	bins = (hi - lo)/500.0
	h = histogram(image, min=lo, max=hi, binsize=bins)
	x = findgen(nbins)*bins + lo
	yt = 'Number of Pixels'
	junk = plot_popup(x, h, title='Histogram - '+file, $
	    xtitle='Data Value', ytitle=yt, /histogram, grl=event.top)
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Rotate  .CW 90 degrees': BEGIN

	widget_control, /hourglass
	message = 'Rotating Image 90 degrees clock-wise...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = rotate(image,3)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	fl_pars, wid_pars
	hist = 'Rotated 90 degrees CW ' + systime(0)
	sxaddhist, hist, header          	        ;update header
	s = size(image)
	im_pars.nx(mp) = s(1)
	im_pars.ny(mp) = s(2)
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Rotate  .CCW 90 degrees': BEGIN

	widget_control, /hourglass
	message = 'Rotating Image 90 degrees counter-clock-wise...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = rotate(image,1)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	fl_pars, wid_pars
	hist = 'Rotated 90 degrees CCW ' + systime(0)
	sxaddhist, hist, header          	        ;update header
	s = size(image)
	im_pars.nx(mp) = s(1)
	im_pars.ny(mp) = s(2)
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Rotate  .Transpose X -> -X': BEGIN

	widget_control, /hourglass
	message = 'Transposing Image X --> -X...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = rotate(image,5)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	fl_pars, wid_pars
	hist = 'Tranposed X ' + systime(0)
	sxaddhist, hist, header          	        ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
    END

  '  Rotate  .Transpose Y -> -Y': BEGIN

	widget_control, /hourglass
	message = 'Transposing Image Y --> -Y...'
	acl_addmess, mess_array, message, wid_pars.mess
	image = rotate(image,7)
	ds = fl_pars.dwin_size
	resized_im = frebin(image, ds(0), ds(1))
	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    wid_pars.im_win, ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	fl_pars, wid_pars
	hist = 'Tranposed Y ' + systime(0)
	sxaddhist, hist, header          	        ;update header
	acl_addmess, mess_array, 'Ready.', wid_pars.mess

    END

   '  Image Info  .Statistics': BEGIN
	message = 'Computing Statistics...'
	acl_addmess, mess_array, message, wid_pars.mess
	widget_control, /hourglass

	imstat, image, stats
	ncts = total(image)

	strstdev = strcompress(string(stats.standdev), /remove_all)
	smean = strcompress(string(stats.mean), /remove_all)
	npix = strcompress(string(stats.npix), /remove_all)
	med = strcompress(string(stats.median), /remove_all)
	minimum = strcompress(string(stats.min), /remove_all)
	maximum = strcompress(string(stats.max), /remove_all)
	ncounts = strcompress(string(ncts), /remove_all)

	title= 'Image Statistics: '
	file = fl_pars.file(fl_pars.mapped)
	
	exptime = float(sxpar(header, 'EXPTIME'))
	sexptime = strcompress(string(exptime), /remove_all)

	if (exptime ne 0.) then begin
	    cps = ncts/exptime
	    pcps = stats.max/exptime
	endif else begin
	    cps = 'Undefined'
	    pcps = 'Undefined'
	endelse
	scps = strcompress(string(cps), /remove_all)
	spcps = strcompress(string(pcps), /remove_all)
	
	mess_arr = [ file, $
	    'NPIX       = ' + npix, $
	    'NCOUNTS    = ' + ncounts, $
	    'EXPTIME    = ' + sexptime, $
	    'GLOBAL CPS = ' + scps, $
	    'PEAK CPS   = ' + spcps, $
	    'MIN        = ' + minimum, $
	    'MAX        = ' + maximum, $
	    'MEAN       = ' + smean, $
	    'MEDIAN     = ' + med, $
	    'STDEV      = ' + strstdev]

	off = [600,0]
	acl_addmess, mess_array, mess_arr, wid_pars.mess
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
	message_popup, mess_arr, title=title, group=event.top, offset=off
    END

   '  Image Info  .Encircled Energy': BEGIN
	m1 = 'Position cursor on diagonal corners of'
        m2 = ' desired region & click left'
	message = m1 + m2
	acl_addmess, mess_array, message, wid_pars.mess
	fl_pars.plot_type = 'circle_ener_p1'
    END
    
   '  Image Info  .Pixel List': BEGIN
   	m1 = 'Position cursor on center of desired region'
   	m2 = ' & click left'
   	message = m1 + m2
   	acl_addmess, mess_array, message, wid_pars.mess
   	fl_pars.plot_type = 'pix_list'
    END

  ENDCASE
END

;
;*************************** Event Handler for main program *****************
;

PRO acslook_Event, Event

WIDGET_CONTROL, Event.Id, GET_UVALUE=uval
widget_control, event.top, get_uvalue=ptrs

release = float(strmid(!version.release,0,3))		;version of IDL

widget_control, ptrs.im_ptr, get_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, get_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, get_uvalue=wid_pars, /no_copy
widget_control, ptrs.im1_ptr, get_uvalue=image, /no_copy
widget_control, ptrs.im1r_ptr, get_uvalue=resized_im, /no_copy
widget_control, ptrs.im2_ptr, get_uvalue=image2, /no_copy
widget_control, ptrs.im2r_ptr, get_uvalue=resized_im2, /no_copy
widget_control, ptrs.hd_ptr, get_uvalue=header, /no_copy
widget_control, ptrs.hd2_ptr, get_uvalue=header2, /no_copy
widget_control, ptrs.ms_ptr, get_uvalue=mess_array, /no_copy

CASE uval OF 

  '1': BEGIN						;FILE menu
  
  	ids = wid_pars.file_ids
  	loading = 0
  	saving = 0
  	
	ev = event.value
	CASE 1 OF
 					     ;Set file type
  	    (ev eq 2): BEGIN					
    		fl_pars.file_type = 'FITS'		;FITS format
		fl_pars.filter = '*.fits*'
		loading = 1
    		END
  	    (ev eq 3): BEGIN
    		fl_pars.file_type = 'IRAF'		;IRAF format
		fl_pars.filter = '*.imh'
		loading = 1
    		END
 	    (ev eq 4): BEGIN
    		fl_pars.file_type = 'SDAS'		;SDAS format
		fl_pars.filter = '*.hhh'
		loading = 1
    		END
	    (ev eq 5): BEGIN
    		fl_pars.file_type = 'MAMA'		;MAMA format
		fl_pars.filter = '*.dat*'
		loading = 1
    		END
    	    (ev eq 6): BEGIN
    	    	fl_pars.file_type = 'ENTRY'		;database entry
    	    	fl_pars.filter = ''
    	    	loading = 1
    	    	END
	    (ev eq 7): BEGIN
		fl_pars.file_type = 'RAW'		;RAW packets
		fl_pars.filter = '*.SDI'
		loading = 1
		END
    					    ;Save file
	    (ev eq 9): BEGIN
    		fextent = '.fits'			;in FITS format
    		ftype = 'FITS'
    		saving = 1
    		END
	    (ev eq 10): BEGIN
    		fextent = '.gif'			;in GIF format
    		ftype = 'GIF'
    		saving = 1
    		END
	    (ev eq 11): BEGIN
    		fextent = '.tif'			;in TIFF format
    		ftype = 'TIFF'
    		saving = 1
    		END
	    (ev eq 12): BEGIN
    		fextent = '.jpg'			;in JPEG format
    		ftype = 'JPEG'
    		saving = 1
    		END

	    (ev eq 14) or (ev eq 15): BEGIN	;Image to PS
	    
	        title = ' Name the output postscript file '
		outfile = pickfile( title=title, path=fl_pars.path, $
		    file='idl.ps')
		    
		goodfile = 0
		if (outfile ne '') then begin
		    openw, unit, outfile, error=err, /get_lun
		    if (err eq 0) then begin
			goodfile=1
			close, unit
		    endif else begin
			goodfile=0
			message = ['Error opening output file:', $
			    'No write permission - operation aborted.'] 
			junk = widget_message(message, /error)
		    endelse
		endif
			
		if (outfile ne '' and goodfile eq 1) then begin
    		    message = 'Sending image to PS file ' + outfile
		    acl_addmess, mess_array, message, wid_pars.mess
		    widget_control, /hourglass

		    mp = fl_pars.mapped
		    if (mp eq 0) then tmp_im = image
		    if (mp eq 1) then tmp_im = image2
		    ptitle = fl_pars.file(mp)

		    type = fl_pars.displ_scale(mp)
		    scalev = fl_pars.scalev(mp,*)

		    acl_scale_im, tmp_im, type, im, scalev

		    case type of 			;set scale & title
		    	0: begin
			    tscale = ''
			    minv = scalev(0) & maxv = scalev(1)
			    end
		    	1: begin
			    tscale = ' Log scale '
			    minv = alog10(scalev(0))
			    maxv = alog10(scalev(1))
			    end
		    	2: begin
			    tscale = ' Sqrt scale '
			    minv = sqrt(scalev(0))
			    maxv = sqrt(scalev(1))
			    end
		    	3: begin
			    tscale = ' Histogram equal scale '
			    minv = 0 & maxv = 255
			    end
		    endcase

		    if (tscale eq '') then begin
		    	if (ev eq 14) then $
		    	    big_ps, im, immin=minv, $
		    	    immax=maxv, title=ptitle, $
		    	    colortable=-1, scaletitle=tscale, $
			    filename=outfile  
                    	if (ev eq 15) then $
                    	    big_ps, im, immin=minv, $
                    	    immax=maxv, title=ptitle, colortable=-1, $
                            scaletitle=tscale, filename=outfile, /rev
		    endif else begin
		    	if (ev eq 14) then $
			    big_ps, im, title=ptitle, colortable=-1, $
			    immin=minv, immax=maxv, $
			    scaletitle=tscale, filename=outfile
		    	if (ev eq 15) then $
                    	    big_ps, im, title=ptitle, colortable=-1, $
			    immin=minv, immax=maxv, $
			    scaletitle=tscale, filename=outfile, /rev
		    endelse

		    acl_addmess, mess_array, 'Ready.', wid_pars.mess
				
		endif
			
    		END

  	    (ev eq 16): BEGIN					;Quit
    		widget_control, event.top, /destroy
    		END
    		
      	ENDCASE
      	
      	if (loading eq 1) then begin			;Load file
 					
	    mp = fl_pars.mapped
	    if (fl_pars.file_type eq 'ENTRY') then begin	;DB entry	
	        q = 'Enter database entry number'	
	        label = ['Entry:']				
	        sw_l = ['PRELAUNCH']
	        sw= ' '
	        sw_def = 1
	        edat = fields_popup('ACS_READ', q, label, switch=sw, $
	            sw_label_arr=sw_l, def_sw=1, grl=event.top)
	        if (edat.cancel eq 0) then begin	
	            entry = edat.values(0)
	            abs_entry = abs(entry)
	            sentry = strcompress(string(abs(entry)), /remove_all)
	            if (edat.sw_num eq 0) then begin
	            	if (entry gt 0) then begin
	            	    dbase1 = 'acs_log'
	            	    prefix = 'ACS_LOG Entry '
	                endif else begin
	                    dbase1 = 'acs_log'
	                    prefix = 'ACS_LOG Entry '
	                endelse
	            endif else begin
	                dbase1 = 'acs_log'
	                prefix = 'ACS_LOG Entry '
	            endelse
		    unavail = 0
	            dbopen, dbase1, unavail=unavail
		    if (unavail eq 1) then begin		;database exists?
		        mess = 'Database does not exist!'
			junk = widget_message(mess,/error)
			infile = ''
			newpath = ''
		    endif else begin
		        newpath = fl_pars.path
			infile = prefix + sentry
		    endelse
	        endif else begin
	            infile = ''
	            newpath = ''
	        endelse
	    endif else begin					;other file
	        title= 'Select ' + fl_pars.file_type + ' image'
	        infile = pickfile(filter=fl_pars.filter, title=title, $
	    	    path=fl_pars.path, get_path=newpath)
	    endelse

	    if (infile ne '' and infile ne newpath) then begin
		
		if (fl_pars.file_type eq 'ENTRY') then begin
		    message = 'Loading Entry number:' + sentry
		endif else begin
	    	    message = 'Loading ' + fl_pars.file_type + $
	    	        ' image: ' + infile
	    	endelse
		
		acl_addmess, mess_array, message, wid_pars.mess

	    	widget_control, /hourglass

	    	type = '/' + fl_pars.file_type
	    	
	    	if (type eq '/ENTRY') then begin
	    	    acs_read, entry, h, im, /no_abort, message=message
	    	    if !err lt 0 then begin
	    	        print, string(7b)
	    	        junk = widget_message(message, /error, $
	    	            dialog_parent=event.top)
	    	        goto, skip_alot
	    	    endif
	    	endif else begin
	    	    com = 'acs_readimage, infile, im, h, ' + type
	    	    r = execute(com)
	    	endelse

; check for MIE (memory dump) image

		im_type = sxpar(h,'im_type')
		if (!err ge 0) then begin
		    if (im_type eq 'Memory Dump Data') then begin
		    	mess = 'Processing memory Dump data...'
		    	acl_addmess, mess_array, mess, wid_pars.mess
		    	tmpsize=fix(sqrt(n_elements(im)))
		    	im = reform(im,tmpsize,tmpsize)
		    	sxaddpar, h, 'NAXIS', 2, 'number of axes'
		    	sxaddpar, h, 'NAXIS1', tmpsize
		    	sxaddpar, h, 'NAXIS2', tmpsize
		    endif
		endif
		
	    	naxis = sxpar(h, 'NAXIS', count=nn)
		if ( nn eq 0) then begin
		    sxhmake, im, 1, h
		endif
		naxis = sxpar(h, 'NAXIS')
		
		scalev = minmax(im)

	    	ds = fl_pars.dwin_size			;display window size

	    	if (fl_pars.num_images eq 0) then begin	;buffers empty
		    if (naxis eq 2) then begin		;check for 2-D image
		    	image = im & header = h
		    	resized_im = frebin(image, ds(0), ds(1))
		    	acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    		    wid_pars.im_win, ds, fl_pars.displ_scale(mp), $
	    		    scalev
		    	fl_pars.num_images = 1
		    	s = size(image)
		    endif
	
	    	endif else begin		;1 or 2 images already loaded
		    widget_control, wid_pars.scale, get_value=scale
		    q = '   Frame to be written into?   '
		    buffer = q_popup('Load Image:', q, button1='1', $
		        button2='2', grl=event.top)
		    mp = fix(buffer) - 1
		    widget_control, /hourglass
		    fl_pars.displ_scale(mp) = scale

		    if (mp eq 0) then begin		;buffer 1 selected
		    	if (naxis eq 2) then begin	;check for 2-D image
			    image = im & header = h
			    resized_im = frebin(image, ds(0), ds(1))
			    acl_load_buffer, resized_im, im_pars.pixmaps(mp), $
	    		    	wid_pars.im_win, ds, fl_pars.displ_scale(mp), scalev
			    s = size(image)
			    if (fl_pars.num_images eq 2) then begin
			    	wset, im_pars.pixmaps(mp+2)
				erase
			    endif
		    	endif
		    endif else begin			;buffer 2 selected
		    	if (naxis eq 2) then begin	;check for 2-D image
			    image2 = im & header2 = h
			    resized_im2 = frebin(image2, ds(0), ds(1))
			    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), $
	    		    	wid_pars.im_win, ds, fl_pars.displ_scale(mp), scalev
			    s = size(image2)
			    if (fl_pars.num_images eq 2) then begin
			    	wset, im_pars.pixmaps(mp+2)
				erase
			    endif
		    	endif
		    endelse

		    widget_control, wid_pars.frame, set_value=mp
		    num_i = fl_pars.num_images
		    if (num_i eq 1 and mp eq 1 and naxis eq 2) then begin
		    	fl_pars.num_images = 2
		    	widget_control, wid_pars.frame, sensitive=1
		    	widget_control, wid_pars.blink, sensitive=1
		    endif

	    	endelse

	    	if (naxis eq 2) then begin		;update database if
	    	    fl_pars.path = newpath		;we had a good image
	    	    fl_pars.file(mp) = infile
	    	    fl_pars.lfile_type(mp) = fl_pars.file_type
	    	    acl_get_rtfile_name, infile, newpath, $
	    	        fl_pars.file_type, rtfile
	    	    fl_pars.rtfile(mp) = rtfile		;root filename
	    	    im_pars.nx(mp) = s(1)
	    	    im_pars.ny(mp) = s(2)
		    fl_pars.scalev(mp,*) = scalev

	    	    widget_control, wid_pars.displ_base, $
		    	tlb_set_title=fl_pars.file(mp)
	    
	    	    widget_control, wid_pars.zoom_slider, get_value=zm
	    	    fl_pars.zoom_scale(mp) = zm
	    	    wset, wid_pars.zm_win
	    	    erase
	    	    
		    widget_control, ids(8), sensitive=1
	    	    widget_control, ids(13), sensitive=1
	    	    widget_control, wid_pars.displ_base, sensitive=1
	    	    widget_control, wid_pars.subbase, sensitive=1
	    	    widget_control, wid_pars.subbase1, sensitive=1
	    	    widget_control, wid_pars.pdmenu_base, sensitive=1
	    	    widget_control, wid_pars.zoom_draw, sensitive=0
		    widget_control, wid_pars.im_min, set_value=scalev(0)
		    widget_control, wid_pars.edit_h, sensitive=1
		    widget_control, wid_pars.im_max, set_value=scalev(1)
	    	    fl_pars.mapped = mp
	    	endif else begin
		    message = 'Image is not two-dimensional. Aborting...'
		    acl_addmess, mess_array, message, wid_pars.mess
		    print, string(7b)
		    wait, 1.5
	    	endelse
skip_alot:
		acl_addmess, mess_array, 'Ready.', wid_pars.mess

	     endif
	endif
	
	if (saving eq 1) then begin			;Saving file
	    mp = fl_pars.mapped

	    if (fl_pars.rtfile(mp) eq '') then begin	;default for pickfile
	    	def_file = 'idl' + fextent
	    endif else begin
	    	def_file = fl_pars.rtfile(mp) + fextent
	    endelse

	    outfile = pickfile(path=fl_pars.path, file=def_file, $
	    	title=' Name the output ' + ftype + ' file ')

	    if (outfile ne '') then begin
	    	s = strpos(outfile, fextent)
	    	if (s eq -1) then outfile = outfile + fextent
	    	acl_check_file, outfile, answer, event.top
	    	if (answer eq 'EXISTS-OK' or $
		    answer eq 'DOES-NOT-EXIST') then begin
		    message = 'Saving image to ' + ftype + ' file: ' + outfile
		    acl_addmess, mess_array, message, wid_pars.mess
		    widget_control, /hourglass
		    if (mp eq 0) then begin
		    	im = image
		    	h = header
		    endif else begin
		    	im = image2
		    	h = header2
		    endelse

		    type = fl_pars.displ_scale(mp)
		    scalev = fl_pars.scalev(mp,*)
		    sc_minmax = scalev
		    acl_scale_im, im, type, scaled_im, sc_minmax

		    case ftype of
		    	'FITS': fits_write, outfile, im, h
		    	'TIFF': tiff_write, outfile, bytscl(scaled_im)
		    	'JPEG': write_jpeg, outfile, bytscl(scaled_im)
		    	'GIF': write_gif, outfile, bytscl(scaled_im)
		    endcase
		    
	    	endif
	    endif

	    wait, 1
	    acl_addmess, mess_array, 'Ready.', wid_pars.mess
	
	endif
	
      	END

  '1a': BEGIN						;edit header

	ev = event.value
	mp = fl_pars.mapped
	case ev of

	    1: BEGIN					;add parameter

		if (mp eq 0) then $
		    htool_add, header, group=event.top
		if (mp eq 1) then $
		    htool_add, header2, group=event.top

	    	END

	    2: BEGIN					;delete parameter

		title = 'Select Keyword to be deleted'
		if (mp eq 0) then begin 
		    key = hlist(header, title=title, group=event.top)
		    if (key ne '') then $
			sxdelpar, header, key
		endif else begin
		    key = hlist(header2, title=title, group=event.top)
		    if (key ne '') then $
                        sxdelpar, header2, key
		endelse
	
	    	END
	
	    3: BEGIN					;modify parameter

		title = 'Select Keyword to be modified'
		if (mp eq 0) then begin
		    key = hlist(header, title=title, group=event.top)
		    if (key ne '') then $
			htool_add, header, key, group=event.top, /modify
		endif else begin
		    key = hlist(header2, title=title, group=event.top)
		    if (key ne '') then $
			htool_add, header2, key, group=event.top, /modify
		endelse

		END

	    4: BEGIN					;add history

	        title='ADD HISTORY'
	        q = ' Enter comment to be added to header: '
	        comment_label = ['Comment:']
	        output = fields_popup(title, q, comment_label, /string, $
	            grl=event.top)
        	if (output.cancel eq 0) then begin
            	    if (fl_pars.mapped eq 0) then begin
                	sxaddhist, output.values, header
            	    endif else begin
                	sxaddhist, output.values, header2
            	    endelse
        	endif

		END

	ENDCASE

       END

  '2': BEGIN						;change buffer
	wset, wid_pars.im_win
	device, copy=[0, 0, fl_pars.dwin_size(0), $
	    fl_pars.dwin_size(1), 0, 0, im_pars.pixmaps(event.value)]

	wset, wid_pars.zm_win
	device, copy=[0,0,256,256,0,0,im_pars.pixmaps(event.value+2)]

	widget_control, wid_pars.displ_base, $
	    tlb_set_title=fl_pars.file(event.value)
	widget_control, wid_pars.scale, $
	    set_value=fl_pars.displ_scale(event.value)
	widget_control, wid_pars.zoom_slider, $
	    set_value=fl_pars.zoom_scale(event.value)

        widget_control, wid_pars.im_min, $
	    set_value=fl_pars.scalev(event.value,0)
	widget_control, wid_pars.im_max, $
	    set_value=fl_pars.scalev(event.value,1)

	fl_pars.mapped = event.value
	END
	
  '3': BEGIN						;image processing,
	mp = fl_pars.mapped				;filtering, plots, 
	if (mp eq 0) then begin				;rotate & info
	    PDMENU11_Event, image, resized_im,  $
		header, im_pars, wid_pars, fl_pars, mess_array, Event
	endif else begin
	    PDMENU11_Event, image2, resized_im2,  $
		header2, im_pars, wid_pars, fl_pars, mess_array, Event
	endelse
	END

  '3a': BEGIN						;image statistics
	message = 'Computing Statistics...'
	acl_addmess, mess_array, message, wid_pars.mess
	widget_control, /hourglass

	if (fl_pars.mapped eq 0) then begin
	    imstat, image, stats
	endif else begin
	    imstat, image2, stats
	endelse

	strstdev = strcompress(string(stats.standdev), /remove_all)
	smean = strcompress(string(stats.mean), /remove_all)
	npix = strcompress(string(stats.npix), /remove_all)
	med = strcompress(string(stats.median), /remove_all)
	minimum = strcompress(string(stats.min), /remove_all)
	maximum = strcompress(string(stats.max), /remove_all)

	title= 'Image Statistics: '
	file = fl_pars.file(fl_pars.mapped)

	mess_arr = [ file, $
	    'NPIX       =    ' + npix, $
	    'MIN         =   ' + minimum, $
	    'MAX        =    ' + maximum, $
	    'MEAN      =    ' + smean, $
	    'MEDIAN  =	    ' + med, $
	    'STDEV     =    ' + strstdev]

	off = [600,0]
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
	message_popup, mess_arr, title=title, group=event.top, offset=off
	END

  '4': BEGIN						;zoom window events
	mp = fl_pars.mapped
	ds = float(fl_pars.dwin_size)
	nx = float(im_pars.nx(mp))
	ny = float(im_pars.ny(mp))
	in_x = (float(event.x)/fl_pars.zoom_scale(mp))*nx/ds(0)
	in_y = (float(event.y)/fl_pars.zoom_scale(mp))*ny/ds(1)
	mx = nx - 1
	my = ny - 1

	x = in_x - im_pars.sx1(mp) + im_pars.ix1(mp)	;device to image coords.
	y = in_y - im_pars.sy1(mp) + im_pars.iy1(mp)

	if (x ge 0 and x le mx and y ge 0 and y le my) then begin
	    if (mp eq 0) then z = image(x,y)
	    if (mp eq 1) then z = image2(x,y)
	    strx = 'X: ' + strcompress(string(fix(x)), /remove_all)
	    stry = 'Y: ' + strcompress(string(fix(y)), /remove_all)
	    strz = 'Z: ' + strcompress(string(z), /remove_all)
	    widget_control, wid_pars.zm_x, set_value=strx
	    widget_control, wid_pars.zm_y, set_value=stry
	    widget_control, wid_pars.zm_z, set_value=strz
	endif
      	END

  '5': BEGIN						;change zoom scale
	mp = fl_pars.mapped
	zm = event.value
	fl_pars.zoom_scale(mp) = zm
	widget_control, /hourglass
	if (mp eq 0 and fl_pars.zoom eq 1) then $
	    acl_replot_zoom, image, im_pars, fl_pars, wid_pars
	if (mp eq 1 and fl_pars.zoom eq 1) then $
	    acl_replot_zoom, image2, im_pars, fl_pars, wid_pars
      	END

  '6': BEGIN						;change display scale
	mp = fl_pars.mapped
	widget_control, /hourglass
      	CASE Event.Value OF
	    0: begin					;linear scale
		message = 'Replotting with linear scale...'
		acl_addmess, mess_array, message, wid_pars.mess
		fl_pars.displ_scale(mp) = 0
		end
	    1: begin					;logarithmic scale
		message = 'Replotting with natural log scale...'
		acl_addmess, mess_array, message, wid_pars.mess
		fl_pars.displ_scale(mp) = 1
		end
	    2: begin					;square root scale
		message = 'Replotting with square root scale...'
		acl_addmess, mess_array, message, wid_pars.mess
		fl_pars.displ_scale(mp) = 2	
		end
	    3: begin					;histogram equal scale
		message = 'Replotting with histogram equal scale...'
		acl_addmess, mess_array, message, wid_pars.mess
		fl_pars.displ_scale(mp) = 3
		end
      	ENDCASE

	scalev = fl_pars.scalev(mp,*)
	
	if (mp eq 0) then begin				;reload buffers
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), scalev
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	endif else begin
	    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), scalev
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image2, im_pars, $
		fl_pars, wid_pars
	endelse
	
	fl_pars.scalev(mp,*) = scalev
	
	widget_control, wid_pars.im_min, set_value=fl_pars.scalev(mp,0)
	widget_control, wid_pars.im_max, set_value=fl_pars.scalev(mp,1)
	
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
	
      	END

  '7': BEGIN						;xloadct
	xloadct, group=event.top
      	END

  '8': BEGIN						;blink control panel
	acl_blink, im_pars, fl_pars, wid_pars, group=event.top
	END

  '9': BEGIN						;display header
	if (fl_pars.mapped eq 0) then begin
	    xdisplayfile, "", group=event.top, $
		title='Header', text=header
	endif else begin
	    xdisplayfile, "", group=event.top, $
		title='Header', text=header2
	endelse
	END

  '9a': BEGIN						; Print Header
  	mess = 'Printing header on system default printer...'
  	acl_addmess, mess_array, mess, wid_pars.mess
	if (fl_pars.mapped eq 0) then begin
	    hwrite,header,'/tmp/header.tmp'
	endif else begin
	    hwrite,header2,'/tmp/header.tmp'
	endelse
	spawn, 'lpr /tmp/header.tmp'
	spawn, '/usr/bin/rm -f /tmp/header.tmp'
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
	END
	
  '9b': BEGIN						; Print Messages
  	printer = gettok(getlog('PRINTER'), '/')
  	mess = 'Printing messages on printer ' + printer
  	acl_addmess, mess_array, mess, wid_pars.mess
  	hwrite,mess_array,'/tmp/mess.tmp'
	spawn, 'lpr -P' +  printer + ' /tmp/mess.tmp'
	spawn, '/usr/bin/rm -f /tmp/mess.tmp'
	acl_addmess, mess_array, 'Ready.', wid_pars.mess
	END
	
  '10': begin						;reset minimum image 
	mp = fl_pars.mapped				;scale value
	widget_control, event.id, get_value=immin
	fl_pars.scalev(mp,0) = immin

	if (mp eq 0) then begin			
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	endif else begin
	    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image2, im_pars, $
		fl_pars, wid_pars
	endelse

	end

  '11': begin						;reset maxminum image
	mp = fl_pars.mapped				;scale value
	widget_control, event.id, get_value=immax
	fl_pars.scalev(mp,1) = immax

	if (mp eq 0) then begin			
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	endif else begin
	    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image2, im_pars, $
		fl_pars, wid_pars
	endelse

	end
	
  '11a': begin						;reset scale values
  	mp = fl_pars.mapped
  	
  	if (mp eq 0) then begin	
  	    scalev = minmax(image)
	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), scalev
	    fl_pars.scalev(mp,*) = scalev
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
		fl_pars, wid_pars
	endif else begin
	    scalev = minmax(image2)
	    fl_pars.scalev(mp,*) = minmax(image2)
	    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), scalev
	    fl_pars.scalev(mp,*) = scalev
	    if (fl_pars.zoom eq 1) then acl_replot_zoom, image2, im_pars, $
		fl_pars, wid_pars
	endelse
	
	widget_control, wid_pars.im_min, set_value=fl_pars.scalev(mp,0)
	widget_control, wid_pars.im_max, set_value=fl_pars.scalev(mp,1)
	end

  '12': begin						;help!
	help_file = find_with_def('acslook.hlp', 'JDOC', /nocur)
	xdisplayfile, help_file, group=event.top, title='Help'
	end

ENDCASE

widget_control, ptrs.im_ptr, set_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, set_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, set_uvalue=wid_pars, /no_copy
widget_control, ptrs.im1_ptr, set_uvalue=image, /no_copy
widget_control, ptrs.im1r_ptr, set_uvalue=resized_im, /no_copy
widget_control, ptrs.im2_ptr, set_uvalue=image2, /no_copy
widget_control, ptrs.im2r_ptr, set_uvalue=resized_im2, /no_copy
widget_control, ptrs.hd_ptr, set_uvalue=header, /no_copy
widget_control, ptrs.hd2_ptr, set_uvalue=header2, /no_copy
widget_control, ptrs.ms_ptr, set_uvalue=mess_array, /no_copy

if widget_info(event.top, /valid) then $		;put the pointers back
    widget_control, event.top, set_uvalue=ptrs 		;if we did not quit

END

;
;*************************** Support Procedures ******************************
;

pro acl_check_file, file, answer, grl			

; procedure tests the existance of an output file. If it does exist, a popup
; dialog widget is created to ask the user if it is OK to overwrite the file.

openr, 1, file, error=err
close, 1

if (err eq 0) then begin			;file already exists
    title='Save'
    q = 'Operation will overwrite existing file. Are you sure?'
    b1 = 'Yes, overwrite'
    b2 = 'Cancel'
    print, string(7b)
    ans = q_popup(title,q,button1=b1,button2=b2,grl=grl)
    if (ans eq b1) then begin
	answer = 'EXISTS-OK'
    endif else begin
	answer = 'EXISTS-NOT-OK'
    endelse
endif else begin
    answer = 'DOES-NOT-EXIST'
endelse

return
end

;
;_____________________________________________________________________________

pro acl_displ_win, event

; Event handler for the image display window.

widget_control, event.top, get_uvalue=gleader
widget_control, gleader, get_uvalue=ptrs

release = float(strmid(!version.release,0,3))		;version of IDL

widget_control, ptrs.im_ptr, get_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, get_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, get_uvalue=wid_pars, /no_copy
widget_control, ptrs.im1_ptr, get_uvalue=image, /no_copy
widget_control, ptrs.im1r_ptr, get_uvalue=resized_im, /no_copy
widget_control, ptrs.im2_ptr, get_uvalue=image2, /no_copy
widget_control, ptrs.im2r_ptr, get_uvalue=resized_im2, /no_copy
widget_control, ptrs.hd_ptr, get_uvalue=header, /no_copy
widget_control, ptrs.hd2_ptr, get_uvalue=header2, /no_copy
widget_control, ptrs.ms_ptr, get_uvalue=mess_array, /no_copy

mp = fl_pars.mapped
num_images = fl_pars.num_images
if (mp eq 0) then working_image = image
if (mp eq 1) then working_image = image2

if (event.id eq event.top) then begin			;resize the display
    widget_control, /hourglass
    acl_addmess, mess_array, 'Resizing...', wid_pars.mess
    fl_pars.dwin_size = [event.x,event.y]
    widget_control, wid_pars.displ_base, tlb_get_offset=off
    widget_control, wid_pars.displ_base, /destroy
    acl_mkwin, 'acl_displ_win', draw_id, win_id, c_labels, xsize=event.x, $
	ysize=event.y, xoff=off(0), yoff=off(1), gleader=wid_pars.gleader
    wid_pars.displ_labels = c_labels
    wid_pars.displ_base = draw_id
    wid_pars.im_win = win_id
    
    for n = 0,1 do begin				;re-make pixel maps
    	wdelete, im_pars.pixmaps(n)
    	window, /FREE, /PIX, xs=event.x, ys=event.y
    	im_pars.pixmaps(n) = !d.window
    endfor
    
    if (num_images ne 0) then begin		; no images loaded
    	resized_im = frebin(image, event.x, event.y)
    	if (fl_pars.num_images eq 2) then $
    	    resized_im2 = frebin(image2, event.x, event.y)

    	widget_control, wid_pars.displ_base, tlb_set_title=fl_pars.file(mp)

    	resized_im = frebin(image, event.x, event.y)
    	if (fl_pars.num_images eq 2) then $
    	    resized_im2 = frebin(image2, event.x, event.y)

    	if (mp eq 0) then begin 			    ;load
    	    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    if (fl_pars.num_images eq 2) then begin
		wset, im_pars.pixmaps(1)
    		acl_displ_image, resized_im2, fl_pars.displ_scale(1), $
		    fl_pars.scalev(mp,*)
	    endif
    	endif else begin
	    acl_load_buffer, resized_im2, im_pars.pixmaps(mp), wid_pars.im_win, $
		fl_pars.dwin_size, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
	    wset, im_pars.pixmaps(0)
    	    acl_displ_image, resized_im, fl_pars.displ_scale(0), $
		fl_pars.scalev(mp,*)
    	endelse
    	acl_addmess, mess_array, 'Ready', wid_pars.mess
    endif

endif else begin
    device_x = float(event.x)
    device_y = float(event.y)
    file = fl_pars.file(fl_pars.mapped)
    dw = float(fl_pars.dwin_size)

    cenx = device_x*im_pars.nx(mp)/dw(0)		;translate from device
    ceny = device_y*im_pars.ny(mp)/dw(1)		;to image coordinates

    if (event.type eq 0) then begin			;button events
   	
	case fl_pars.plot_type of
	    'cross_section_p1': begin
		fl_pars.pt1 = [cenx,ceny]
		fl_pars.plot_type='cross_section_p2'
		end

	    'row_sum_p1': begin
		fl_pars.pt1 = [cenx,ceny]
		fl_pars.plot_type='row_sum_p2'
		end

	    'column_sum_p1': begin
		fl_pars.pt1 = [cenx,ceny]
		fl_pars.plot_type='column_sum_p2'
		end

	    'circle_ener_p1': begin
		fl_pars.pt1 = [cenx,ceny]
		fl_pars.plot_type='circle_ener_p2'
		end

	    'cross_section_p2': begin
	    	p1x = fl_pars.pt1(0)
	    	p1y = fl_pars.pt1(1)
		w = fl_pars.c_sect_width
		cross_section, working_image, p1x, p1y, cenx, ceny, w, $
		    file, grl=gleader
	    	fl_pars.plot_type=''
		acl_addmess, mess_array, 'Ready', wid_pars.mess
		end

	    'row_sum_p2': begin
		row_sum, working_image, fl_pars.pt1(1), ceny, file, $
		    grl=gleader
		fl_pars.plot_type=''
		acl_addmess, mess_array, 'Ready', wid_pars.mess
		end

	    'column_sum_p2': begin
		column_sum, working_image, fl_pars.pt1(0), cenx, file, $
		    grl=gleader
		fl_pars.plot_type=''
		acl_addmess, mess_array, 'Ready', wid_pars.mess
		end

	    'circle_ener_p2': begin
		p1 = fix(fl_pars.pt1)
		p2 = [cenx, ceny]
		p2 = fix(p2)
		title= 'Total counts: '
		if (p1(0) lt p2(0)) then begin
		     x1 = p1(0) & x2 = p2(0)
		     sx1 = strcompress(string(p1(0)), /remove_all)
		     sx2 = strcompress(string(p2(0)), /remove_all)
		endif else begin
		     x1 = p2(0) & x2 = p1(0)
		     sx1 = strcompress(string(p2(0)), /remove_all)
		     sx2 = strcompress(string(p1(0)), /remove_all)
		endelse
		if (p1(1) lt p2(1)) then begin
		     y1 = p1(1) & y2 = p2(1)
		     sy1 = strcompress(string(p1(1)), /remove_all)
		     sy2 = strcompress(string(p2(1)), /remove_all)
		endif else begin
		     y1 = p2(1) & y2 = p1(1)
		     sy1 = strcompress(string(p2(1)), /remove_all)
		     sy2 = strcompress(string(p1(1)), /remove_all)
		endelse
		
		ener = total(working_image(x1:x2, y1:y2))	;ncounts
		sener = strcompress(string(ener), /remove_all)
		scd = '['+sx1+':'+sx2+','+sy1+':'+sy2+']'	;coordinates
		
		exptime = float(sxpar(header, 'INTEG'))
		sexptime = strcompress(string(exptime), /remove_all)

		npix = (long(x2)-x1+1)*(y2-y1+1)		;# of pixels
		snpix = strcompress(string(npix), /remove_all)
		
		standev = stdev(working_image(x1:x2, y1:y2), mean)
		sstandev = strcompress(string(standev), /remove_all)
		smean = strcompress(string(mean), /remove_all)
		
		if (exptime ne 0.) then begin
		    cps = ener/exptime			;cts per sec
		    cppps = mean/exptime		;cts per pixel per sec
		endif else begin
		    cps = 'Undefined'
		    cppps = 'Undefined'
		endelse
		
		scps = strcompress(string(cps), /remove_all)
		scppps = strcompress(string(cppps), /remove_all)
		
		
		
		mess_arr = [ file, $
		    'COORDINATES:   ' + scd, $
		    'NCOUNTS       = ' + sener, $
		    'NPIX          = ' + snpix, $
		    'MEAN          = ' + smean, $
		    'STDEV         = ' + sstandev, $
		    'CTS/SEC       = ' + scps, $
		    'CTS/PIX/SEC   = ' + scppps]
		    
		off = [600,0]
		acl_addmess, mess_array, mess_arr, wid_pars.mess
		acl_addmess, mess_array, 'Ready.', wid_pars.mess
		message_popup, mess_arr, title=title, group=event.top, $
		    offset=off
		fl_pars.plot_type=''
		end
	
	    'pix_list': begin
	        imlist, working_image, cenx, ceny, textout=3, descrip=' '
	        xdisplayfile, 'imlist.prt', group=event.top, $
	            title='Pixel List'
	        fl_pars.plot_type=''
	    	end

	    '': begin				;zoom
		widget_control, wid_pars.zoom_draw, sensitive=1
	    	fl_pars.zoom = 1
	       	widget_control, /hourglass
	    	im_pars.cenx = cenx
	    	im_pars.ceny = ceny
	       	acl_replot_zoom, working_image, im_pars, $
		    fl_pars, wid_pars
	   	widget_control, wid_pars.zoom_draw, sensitive=1
		end
	 endcase
    endif else $
    if (event.type eq 2) then begin			;motion events
	z = float(working_image(cenx,ceny))
	strx = 'X: ' + strcompress(string(fix(cenx)), /remove_all)
	stry = 'Y: ' + strcompress(string(fix(ceny)), /remove_all)
	strz = 'Z: ' + strcompress(string(z), /remove_all)
	widget_control, wid_pars.displ_labels(0), set_value=strx
	widget_control, wid_pars.displ_labels(1), set_value=stry
	widget_control, wid_pars.displ_labels(2), set_value=strz
    endif
endelse

widget_control, ptrs.im_ptr, set_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, set_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, set_uvalue=wid_pars, /no_copy
widget_control, ptrs.im1_ptr, set_uvalue=image, /no_copy
widget_control, ptrs.im1r_ptr, set_uvalue=resized_im, /no_copy
widget_control, ptrs.im2_ptr, set_uvalue=image2, /no_copy
widget_control, ptrs.im2r_ptr, set_uvalue=resized_im2, /no_cop
widget_control, ptrs.hd_ptr, set_uvalue=header, /no_copy
widget_control, ptrs.hd2_ptr, set_uvalue=header2, /no_copy
widget_control, ptrs.ms_ptr, set_uvalue=mess_array, /no_copy

widget_control, gleader, set_uvalue=ptrs

return
end

;
;_____________________________________________________________________________

pro acl_displ_image, image, type, scalev

; Displays image according to scale type. 

acl_scale_im, image, type, scaled_im, scalev

erase
topv = (!d.n_colors-1)<255
case type of
	0: begin & minv = scalev(0) & maxv = scalev(1) & end
	1: begin & minv = alog10(scalev(0)) & maxv = alog10(scalev(1)) & end
	2: begin & minv = sqrt(scalev(0)) & maxv = sqrt(scalev(1)) & end
	3: begin & minv = 0 & maxv = 255 & end
endcase
tv, bytscl(scaled_im,min=minv,max=maxv,top=topv)

return
end

;
;_____________________________________________________________________________

pro acl_scale_im, image, type, scaled_im, sc_minmax

s = size(image)

case type of 
    0: begin						;linear scaling
    	scaled_im = image > sc_minmax(0) < sc_minmax(1)
	end
    1: begin						;log
    	if (sc_minmax(1) gt 0) then begin
	    if sc_minmax(0) le 0 then sc_minmax(0) = sc_minmax(1)/1e5
	    scaled_im = alog10(image>sc_minmax(0)<sc_minmax(1))
    	endif else begin
    	    scaled_im = image > sc_minmax(0) < sc_minmax(1)
    	endelse
    	end
    2: begin						;square root
	if (sc_minmax(0) lt 0) then sc_minmax(0) = 0
	scaled_im = sqrt(image>sc_minmax(0)<sc_minmax(1))
	end
    3: begin
    	good = where((image ge sc_minmax(0)) and (image le sc_minmax(1)),ngood)
	scaled_im = fltarr(s(1),s(2))
	if ngood gt 1 then scaled_im(good) = hist_equal(image(good))
	scaled_im = scaled_im + (image gt sc_minmax(1))*255
       end
	    
endcase

return
end

;
;_____________________________________________________________________________

pro acl_load_buffer, image, pixmap, im_win, win_size, scale, scalev

; loads image into the pixel map buffer and copies it to the display window.
 
wset, pixmap

acl_displ_image, image, scale, scalev

wset, im_win
device, copy=[0, 0, win_size(0), win_size(1), 0, 0, pixmap]
 
return 
end

;
;_____________________________________________________________________________

pro acl_replot_zoom, image, im_pars, fl_pars, wid_pars	;displays the zoomed
							;image
		
mp = fl_pars.mapped					;get needed parameters
zm = float(fl_pars.zoom_scale(mp))
cenx = im_pars.cenx
ceny = im_pars.ceny
nx = float(im_pars.nx(mp))
ny = float(im_pars.ny(mp))
xs = 256.0*nx/fl_pars.dwin_size(0)
ys = 256.0*ny/fl_pars.dwin_size(1)

max = max(image)
min = min(image)

x1 = fix(cenx - xs/(zm*2.0))				;compute image section
x2 = fix(x1 + xs/zm)					;to zoom in on
y1 = fix(ceny - ys/(zm*2.0))
y2 = fix(y1 + ys/zm)
sub_xs = x2 - x1
sub_ys = y2 - y1

if (x2 gt nx-1) then x2 = nx - 1			;make sure section does
if (y2 gt ny-1) then y2 = ny - 1			;not run off top or
							;right side of image

subim = fltarr(sub_xs, sub_ys)

; these statments place the extracted subimage in the correct place in the zoom
; window if the image section will not completely fill it when expanded.
; This only comes into play when the user zooms in on a corner or edge of the
; image

if (x1 lt 0 and y1 lt 0) then begin			;lower left corner
    subim(-x1:sub_xs-1,-y1:sub_ys-1) = image(0:x2-1,0:y2-1)
    im_pars.sx1(mp) = -x1				;save coord. systems
    im_pars.sy1(mp) = -y1
    im_pars.ix1(mp) = 0
    im_pars.iy1(mp) = 0
endif else $
if (x1 lt 0 and y1 ge 0) then begin			;left edge
    subim(-x1:sub_xs-1,0:y2-y1-1) = image(0:x2-1,y1:y2-1)
    im_pars.sx1(mp) = -x1				;save coord. systems
    im_pars.sy1(mp) = 0
    im_pars.ix1(mp) = 0
    im_pars.iy1(mp) = y1
endif else $
if (x1 ge 0 and y1 lt 0) then begin			;bottom edge
    subim(0:x2-x1-1,-y1:sub_ys-1) = image(x1:x2-1,0:y2-1)
    im_pars.sx1(mp) = 0					;save coord. systems
    im_pars.sy1(mp) = -y1
    im_pars.ix1(mp) = x1
    im_pars.iy1(mp) = 0
endif else begin
    subim(0:x2-x1-1,0:y2-y1-1) = image(x1:x2-1,y1:y2-1)
    im_pars.sx1(mp) = 0					;save coord. systems
    im_pars.sy1(mp) = 0
    im_pars.ix1(mp) = x1
    im_pars.iy1(mp) = y1
endelse

subim = frebin(subim, 256.0, 256.0)			;expand image section

acl_load_buffer, subim, im_pars.pixmaps(mp+2), $
    wid_pars.zm_win, [256,256], fl_pars.displ_scale(mp), $
    fl_pars.scalev(mp,*)

return
end

;
;_____________________________________________________________________________

pro acl_get_rtfile_name, infile, path, type, rtfile

; procedure returns the the filename without the suffix or path.

case type of 

    'IRAF': begin
	s = strpos(infile, '.imh')
	suffix_off = strmid(infile, 0, s)
	end

    'FITS': begin
	s = strpos(infile, '.fits')
	if (s ne -1) then begin
	    suffix_off = strmid(infile, 0, s)
	endif else begin
	    suffix_off = infile
	endelse
	end

    'SDAS': begin
	s = strpos(infile, '.hhh')
	suffix_off = strmid(infile, 0, s)
	end

    'MAMA': begin
	s = strpos(infile, '.dat')
	suffix_off = strmid(infile, 0, s)
	end

    'RAW': begin
	s = strpos(infile, '.SDI')
	suffix_off = strmid(infile, 0, s)
	end
    
    'ENTRY': begin
        suffix_off = ''
        end
        
endcase

off_len = strlen(suffix_off)
pathlen = strlen(path)
rtfile = strmid(suffix_off, pathlen, off_len)

return
end

;
;_____________________________________________________________________________

pro acl_subtract, image, resized_im, header, type, im_pars, fl_pars, $
   wid_pars, mess_array

; routine is an interface between the widget and the routine that performs
; the bias/dark subtraction. Performs the necessary file I/O and
; error checking/trapping.

mp = fl_pars.mapped

if (type eq 'bias') then begin
    idl_flag = fl_pars.no_bias
    idl_cal_frame = im_pars.bias
endif else begin
    idl_flag = fl_pars.no_dark
    idl_cal_frame = im_pars.dark
endelse

mess = 'Performing ' + type + ' subtraction...'
acl_addmess, mess_array, mess, wid_pars.mess
wait, 0.5
widget_control, /hourglass

if (idl_flag eq 'yes') then begin			;cal frame not loaded
							;on command line.
    title= 'Select FITS ' + type + ' image'
    infile = pickfile(filter='*.fits*', title=title, $
	path=fl_pars.path, get_path=newpath)
    if (infile ne '') then begin			;cancel button pressed
        widget_control, /hourglass
	com = 'readimage, infile, cal_frame, cal_header'
	r = execute(com)
	imsubtract, image, cal_frame, newim, error=err, message=err_mess
    endif else begin
	err = 1
	err_mess = 'Operation Canceled.'
    endelse

endif else begin					;always use cal frame
							;given on command line.
    imsubtract, image, idl_cal_frame, newim, error=err, $
	message=err_mess

endelse

if (err eq 1) then begin			;operation unsuccessful
    print, string(7b)
    acl_addmess, mess_array, err_mess, wid_pars.mess
    wait, 2.0
endif else begin				;it worked!
    mess = 'Operation successful - displaying processed image...'
    acl_addmess, mess_array, mess, wid_pars.mess
    ds = fl_pars.dwin_size
    image = newim
    resized_im = frebin(image, ds(0), ds(1))
    acl_load_buffer, resized_im, im_pars.pixmaps(mp), wid_pars.im_win, $
	    ds, fl_pars.displ_scale(mp), fl_pars.scalev(mp,*)
    if (fl_pars.zoom eq 1) then acl_replot_zoom, image, im_pars, $
	    fl_pars, wid_pars
    hist = type + ' subtraction: ' + systime(0)
    sxaddhist, hist, header			;update header
endelse

acl_addmess, mess_array, 'Ready', wid_pars.mess

return
end

;
;_____________________________________________________________________________

pro acl_addmess, mess_array, message, mess_wid

;routine updates messages window.

s = size(mess_array)
len = s(1)
messlen = n_elements(message)
messtmp = mess_array

mess_array = strarr(len+messlen)
mess_array(len:len+messlen-1) = message
mess_array(0:len-1) = messtmp

widget_control, mess_wid, set_value=mess_array
widget_control, mess_wid, set_text_top_line=len+messlen-3
return
end

;
;_____________________________________________________________________________

;
;***************************		  ************************************
;*************************** Main Program ************************************
;***************************		  ************************************
;

PRO acslook, image, image2, header1=header, header2=header2, bias=bias, $
   dark=dark, flat=flat, log=log, sqt=sqt, hist=hist

; make sure we have windows.

if ((!d.flags and 65536) eq 0) then begin
    print, 'Display does not support widgets. Returning...'
    retall
endif

;
;*************************** Initialize Variables ***************************
;
!x.range=0
!y.range=0
scalev = fltarr(2,2)

case n_params() of 
    0: begin						;no images loaded
	num_images = 0
	im = 0 & im2 = 0
	nx = [0,0] & ny = [0,0]
	header = strarr(20) & header2 = strarr(20)
	resized_im = 0 & resized_im2 = 0
	lfile_type = ['', '']
	end
    1: begin
	num_images = 1
	im = image & im2 = 0
	s = size(image)
	nx = [s(1), 0] & ny = [s(2), 0]
	if not keyword_set(header1) then $ 
	    sxhmake, image, 0, header
	header2 = strarr(20)
	resized_im = frebin(im, 512, 512)
	resized_im2 = 0
	lfile_type = ['IDL', '']
        scalev(0,*) = minmax(im)
	end
    2: begin
	num_images = 2
	im = image & im2 = image2
	s = size(image) & s2 = size(image2)
	nx = [s(1), s2(1)] & ny = [s(2), s2(2)]
	if not keyword_set(header1) then $ 
	    sxhmake, image, 0, header
	if not keyword_set(header2) then $ 
	    sxhmake, image2, 0, header2
	resized_im = frebin(im, 512, 512)
	resized_im2 = frebin(im2, 512, 512)
	lfile_type = ['IDL', 'IDL']
        scalev(0,*) = minmax(im)
        scalev(1,*) = minmax(im2)
	end
    else: begin
	print, 'CALLING SEQUENCE:'
	print, '	acslook [, image] [, image2]'
	print
	print, ' Note: 	Arguments are only required if you wish to load'
	print, '	image & header arrays already in IDL memory.'
	retall
	end
endcase

no_bias = 'no'
no_dark = 'no'
no_flat = 'no'

if (not keyword_set(bias)) then begin
    bias = 0
    no_bias = 'yes'
endif
if (not keyword_set(dark)) then begin
    dark = 0
    no_dark = 'yes'
endif
if (not keyword_set(flat)) then begin
    flat = 0
    no_flat = 'yes'
endif

scale = 0
if keyword_set(log) then scale=1
if keyword_set(sqt) then scale=2
if keyword_set(hist) then scale=3

cd, current=path				;get CWD

;
;*************************** Create the Widget *******************************
;

acslook = WIDGET_BASE( COLUMN=1, TITLE='ACSLook', xoffset=0, yoffset=0)

widget_control, default_font='6x13'			;set font

  mess_array = strarr(1)
  if (num_images eq 0) then begin
    mess_array(0) = 'To begin, Select LOAD from the  FILE menu.'
  endif else begin
    mess_array(0) = 'Displaying frame #1...'
  endelse
  base2 = widget_base(acslook, /row)
    junk = widget_label( base2, value='Messages: ')
    FIELD2 = Widget_text( base2, VALUE=mess_array, $
      XSIZE=75, ysize=4, /scroll)

  BASE4 = WIDGET_BASE(acslook, ROW=1, FRAME=2)
  junk = { CW_PDMENU_S, flags:0, name:'' }
    MenuDesc100 = [ $
      { CW_PDMENU_S,       3, '   FILE   ' }, $ ;        		0
        { CW_PDMENU_S,       1, ' LOAD ' }, $ ;        			1
          { CW_PDMENU_S,       0, ' FITS file ' }, $ ;        		2
          { CW_PDMENU_S,       0, ' IRAF image ' }, $ ;        		3
          { CW_PDMENU_S,       0, ' SDAS image ' }, $ ;        		4
          { CW_PDMENU_S,       0, ' MAMA (binary) file ' }, $ ;        	5
          { CW_PDMENU_S,       0, ' DB Entry Number ' }, $ ; 		6
	{ CW_PDMENU_S,       2, ' Raw packetized data ' }, $ ;          7
        { CW_PDMENU_S,       1, ' SAVE AS ' }, $ ;        		8
          { CW_PDMENU_S,       0, ' FITS ' }, $ ;        		9
          { CW_PDMENU_S,       0, ' GIF ' }, $ ;        		10
          { CW_PDMENU_S,       0, ' TIFF (greyscale) ' }, $ ;        	11
        { CW_PDMENU_S,       2, ' JPEG (greyscale) ' }, $ ;       	12
        { CW_PDMENU_S,       1, ' Image to PS ' }, $ ;       		13
          { CW_PDMENU_S,       0, ' As displayed ' }, $ ;        	14
        { CW_PDMENU_S,       2, ' Reverse colortable ' }, $ ;        	15
      { CW_PDMENU_S,       2, ' QUIT ' } $  ;     			16
    ]
  
    fstr1 = '-adobe-helvetica-bold-r-normal'
    fstr2 = '--14-140-75-75-p-82-iso8859-1'
    fstr = fstr1 + fstr2

    MenuDesc110 = [ $
      { CW_PDMENU_S,       1, ' EDIT HEADER ' }, $ ; 		0
        { CW_PDMENU_S,       0, ' ADD Parameter ' }, $ ;	1
        { CW_PDMENU_S,       0, ' DELETE Parameter ' }, $ ;        2
        { CW_PDMENU_S,       0, ' MODIFY Parameter ' }, $ ;        3
        { CW_PDMENU_S,       2, ' ADD History ' } $ ;        4
    ]
      
    PDMENU2 = CW_PDMENU( base4, MenuDesc100, UVALUE='1', ids=ids, font=fstr)

    PDMENU3 = CW_PDMENU( base4, MenuDesc110, UVALUE='1a', ids=ids3, font=fstr)
      
    Btns244 = ['1 ', '2 ']
    Bgroup6 = CW_BGROUP( BASE4, Btns244, Row=1, EXCLUSIVE=1, $
      LABEL_LEFT='Frame:', uvalue='2', set_value=0, frame=2)

    BASE5 = widget_base( base4 , /row )
    BUTTON49 = WIDGET_BUTTON( BASE5, UVALUE='12', FONT=fstr, $
      VALUE='    HELP    ')

  BASE6 = widget_base(acslook, /row)
    MenuDesc524 = [ $
      { CW_PDMENU_S,       1, '  Image Processing  ' }, $ ;        0
        { CW_PDMENU_S,       0, 'Convert to Count Rate' }, $ ;        1
	{ CW_PDMENU_S,       0, 'Fix Bad Column(s)' }, $ ;        3
        { CW_PDMENU_S,       0, 'Bias Subtraction' }, $ ;        4
        { CW_PDMENU_S,       0, 'Dark Subtraction' }, $ ;        5
        { CW_PDMENU_S,       0, 'Flat Field' }, $ ;        6
        { CW_PDMENU_S,       2, 'Rebin: 2x2' }, $ ; 7
      { CW_PDMENU_S,       1, '  Image Filtering  ' }, $ ;        8
        { CW_PDMENU_S,       0, 'Median 3X3' }, $ ;        9
        { CW_PDMENU_S,       0, 'Median 5X5' }, $ ;        10
        { CW_PDMENU_S,       0, 'Smooth 3X3' }, $ ;        11
        { CW_PDMENU_S,       0, 'Smooth 5X5' }, $ ;        12
	{ CW_PDMENU_S,       0, 'Roberts' }, $ ;        13
	{ CW_PDMENU_S,       0, 'Sobel' }, $ ;        14
        { CW_PDMENU_S,       2, 'Convolution' }, $ ;       15
      { CW_PDMENU_S,       1, '  Plots  ' }, $ ;       16
        { CW_PDMENU_S,       1, 'Cross Section' }, $ ;       17
	  { CW_PDMENU_S,       0, '1 pixel wide' }, $ ;		18		
	  { CW_PDMENU_S,       0, '3 pixels wide' }, $ ;	19
	  { CW_PDMENU_S,       0, '5 pixels wide' }, $ ;	20
	  { CW_PDMENU_S,       0, '7 pixels wide' }, $ ;	21
	  { CW_PDMENU_S,       2, '9 pixels wide' }, $ ;	22
        { CW_PDMENU_S,       0, 'Row Sum' }, $ ;       23
        { CW_PDMENU_S,       0, 'Column Sum' }, $ ;       24
        { CW_PDMENU_S,       2, 'Histogram' }, $  ;     25
      { CW_PDMENU_S,       1, '  Rotate  ' }, $ ;        26
        { CW_PDMENU_S,       0, 'CW 90 degrees' }, $ ;        27
        { CW_PDMENU_S,       0, 'CCW 90 degrees' }, $ ;        28
        { CW_PDMENU_S,       0, 'Transpose X -> -X' }, $ ;        29
        { CW_PDMENU_S,       2, 'Transpose Y -> -Y' }, $ ;        30
      { CW_PDMENU_S,       3, '  Image Info  ' }, $ ;        31
        { CW_PDMENU_S,       0, 'Statistics' }, $ ;        32
        { CW_PDMENU_S,       0, 'Pixel List' }, $ ;        33
        { CW_PDMENU_S,       2, 'Encircled Energy' } $ ;        34 

    ]

    PDMENU11 = CW_PDMENU( base6, MenuDesc524, /RETURN_FULL_NAME, $
      UVALUE='3')

  BASE16 = WIDGET_BASE(acslook, ROW=1)

    BASE17 = WIDGET_BASE(BASE16, COLUMN=1, FRAME=2)

      BASE18 = WIDGET_BASE(BASE17, ROW=1, XPAD=20)

	LABEL19 = WIDGET_LABEL( BASE18, FRAME=2, VALUE=' X:0000')

  	LABEL20 = WIDGET_LABEL( BASE18, FRAME=2, VALUE=' Y:0000')

  	LABEL21 = WIDGET_LABEL( BASE18, FRAME=2, VALUE=' Z:000000000000.0')

      DRAW31 = WIDGET_DRAW( BASE17, MOTION_EVENTS=1, RETAIN=2, $
        UVALUE='4', XSIZE=256, YSIZE=256)

      LABEL33 = WIDGET_LABEL( BASE17, VALUE='Zoom Scale:')

      SLIDER34 = WIDGET_SLIDER( BASE17, MAXIMUM=20, MINIMUM=1, $
        UVALUE='5', VALUE=2, xsize=255)

    BASE36 = WIDGET_BASE(BASE16, COLUMN=1, FRAME=2)

      Btns1536 = ['Linear', 'Logarithm', 'Square Root', 'Histogram Eq.']
      BGROUP37 = CW_BGROUP( BASE36, Btns1536, COLUMN=1, EXCLUSIVE=1, $
        FRAME=2, LABEL_TOP='Display Scale:', UVALUE='6', set_value=scale, $
	/no_release)

      BUTTON40 = WIDGET_BUTTON( BASE36, UVALUE='7', VALUE='  Contrast  ')

      base38 = widget_base(base36, column=1, frame=2)
      
        LABEL34 = WIDGET_LABEL( BASE38, VALUE='Image:')

      	im_min = cw_field(base38, row=1, float=1, return_events=1, $
	  title='MIN', uvalue='10', xsize=12, value=scalev(0,0)) 

      	im_max = cw_field(base38, row=1, float=1, return_events=1, $
          title='MAX', uvalue='11', xsize=12, value=scalev(0,1))
        
        autoscale = widget_button(base38, uvalue='11a', $
          value='Reset values')

    BASE41 = WIDGET_BASE(BASE16, COLUMN=1, FRAME=2)

      BASE43 = widget_base(base41, /column)

        BUTTON41 = WIDGET_BUTTON( BASE43, UVALUE='8', $
          VALUE='  Blink  ')

	BUTTON45 = WIDGET_BUTTON( BASE43, uvalue='9', $
	  value= '   Display Header   ')

	BUTTON47 = WIDGET_BUTTON( BASE43, uvalue='9a', $
	  value= ' Print Header ')
	  
	BUTTON49 = WIDGET_BUTTON( BASE43, uvalue='9b', $
	  value= ' Print Messages ')
;
;*********************** Initialize widgets *********************************
;

widget_control, DRAW31, sensitive=0

WIDGET_CONTROL, acslook, /REALIZE

version = widget_info(/version)
if (version.style eq 'Motif') then begin
    widget_control, acslook, tlb_set_xoffset=0
    widget_control, acslook, tlb_set_yoffset=0
endif

WIDGET_CONTROL, DRAW31, GET_VALUE=zoom_win		;get zoom window index

; create display window & pixel maps

acl_mkwin, 'acl_displ_win', dbase_id, win_id, c_labels, xsize=512, $
    ysize=512, xoff=420, yoff=350, gleader=acslook
    
pixmaps = intarr(4)

for n = 0, 3 do begin
    sz = 512/(fix(n/2) + 1)
    window, /FREE, /PIX, xs=sz, ys=sz
    pixmaps(n) = !d.window
endfor

case num_images of
    0: begin
	widget_control, ids(8), sensitive=0
	widget_control, ids(13), sensitive=0
    	widget_control, BASE36, sensitive=0
    	widget_control, BASE43, sensitive=0
	widget_control, button41, sensitive=0
    	widget_control, BASE6, sensitive=0
	widget_control, Bgroup6, sensitive=0
	widget_control, pdmenu3, sensitive=0
	widget_control, dbase_id, sensitive=0
	end
    1: begin
	widget_control, /hourglass
	widget_control, Bgroup6, sensitive=0
	widget_control, button41, sensitive=0
	end
    2: begin
	widget_control, /hourglass
	wset, pixmaps(1)
	acl_displ_image, resized_im2, scale, scalev(1,*)
	end
endcase

if (num_images ne 0) then begin				;display first frame
    wset, pixmaps(0)
    acl_displ_image, resized_im, scale, scalev(0,*)
    wset, win_id
    device, copy=[0,0,512,512,0,0,pixmaps(0)]
    widget_control, FIELD2, set_value='Ready.'
endif

;
;*********************** Setup data structures ******************************
;

i2 = intarr(2)

im_pars = {nx:nx, ny:ny, cenx:0.0, ceny:0.0, ix1:i2, iy1:i2, sx1:i2, sy1:i2, $
    bias:bias, dark:dark, flat:flat, pixmaps:pixmaps}

fl_pars = {file:['IDL', 'IDL'], path:path, zoom_scale:[2,2], zoom:0, $
    y_units:['counts', 'counts'], displ_scale:[scale,scale], $
    pt1:[0.0,0.0], num_images:num_images, plot_type:'', mapped:0, $
    dwin_size:[512,512], file_type:'', filter:'', no_bias:no_bias, $
    no_dark:no_dark, no_flat:no_flat, rtfile:['', ''], c_sect_width:1, $
    lfile_type:lfile_type, blink_rate:1.0, scalev:scalev, scalev_save:scalev }

wid_pars = {im_win:win_id, zm_win:zoom_win, displ_base:dbase_id, $
    mess:FIELD2, zm_x:LABEL19, zm_y:LABEL20, zm_z:LABEL21, $
    displ_labels:c_labels, zoom_draw:DRAW31, file_ids:ids, $
    subbase:BASE36, subbase1:BASE43, pdmenu_base:BASE6, gleader:acslook, $
    frame:Bgroup6, scale:Bgroup37, zoom_slider:Slider34, blink:button41, $
    im_min:im_min, im_max:im_max, header_ids:ids3, edit_h:pdmenu3}

;
;*********************** Setup Pointers/handles *****************************
;

release = strmid(!version.release,0,3)			;version of IDL

im_ptr = widget_base()
fl_ptr = widget_base(group_leader=im_ptr)
wid_ptr = widget_base(group_leader=im_ptr)
im1_ptr = widget_base(group_leader=im_ptr)
im1r_ptr = widget_base(group_leader=im_ptr)
im2_ptr = widget_base(group_leader=im_ptr)
im2r_ptr = widget_base(group_leader=im_ptr)
hd_ptr = widget_base(group_leader=im_ptr)
hd2_ptr = widget_base(group_leader=im_ptr)
ms_ptr = widget_base(group_leader=im_ptr)
widget_control, im_ptr, set_uvalue=im_pars, /no_copy
widget_control, fl_ptr, set_uvalue=fl_pars, /no_copy
widget_control, wid_ptr, set_uvalue=wid_pars, /no_copy
widget_control, im1_ptr, set_uvalue=im, /no_copy
widget_control, im1r_ptr, set_uvalue=resized_im, /no_copy
widget_control, im2_ptr, set_uvalue=im2, /no_copy
widget_control, im2r_ptr, set_uvalue=resized_im2, /no_copy
widget_control, hd_ptr, set_uvalue=header
widget_control, hd2_ptr, set_uvalue=header2
widget_control, ms_ptr, set_uvalue=mess_array

pointers = {im_ptr:im_ptr, fl_ptr:fl_ptr, wid_ptr:wid_ptr, im1_ptr:im1_ptr, $
    im1r_ptr:im1r_ptr, hd_ptr:hd_ptr, im2_ptr:im2_ptr, im2r_ptr:im2r_ptr, $
    hd2_ptr:hd2_ptr, ms_ptr:ms_ptr}

widget_control, acslook, set_uvalue=pointers		;stick the pointers
							;into the user value
							;of the base widget  

;*********************** Hand off to the Xmanager ***************************
;

  XMANAGER, 'acslook', acslook

;*********************** Clean up pointers when finished ********************
;

wdelete, pixmaps(0)
wdelete, pixmaps(1)
wdelete, pixmaps(2)
wdelete, pixmaps(3)

widget_control, im_ptr, /destroy
		
END
