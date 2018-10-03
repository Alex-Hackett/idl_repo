;+;       NAME:;               GetClix.Pro;;       PURPOSE:;		Returns an array of mouse click positions.;;	DESCRIPTION:;		Similar to RDPIX. The cursor position and value are continually;		updated. Mouse clicks save the current pixel position to an array,;		and a right-click exits the routine.;;       CALLING SEQUENCE:;               pts = GetClix(im);;       INPUTS:;       data    - 2-D array containing the image ;       OUTPUTS:;       pts   - An array or X,Y coordinate pairs, NPTS x 2. The X points are PTS[*,0].;;       REVISON HISTORY:;       19-APR-2004, EFY, SwRI;-function	GetClix, im;	Basic idea:;	The whole routine runs inside of a WHILE loop until a right mouse-down event occurs.;	Within that main WHILE loop, a second tier loop runs until a left mouse-down occurs.;	This second-tier loop continuously displays the updated cursor position.	print, "Click to store an (x,y) position, right-click to exit."	!mouse.button = 0		s = SIZE(im)	if s[s[0]+1] ge 4 then form = 'F' else form = 'I'	case !version.os_family of		'Windows': cr = string("15b)+string("12b)       ; carriage and new line		'MacOS': cr = string("15b)                      ; carriage return		'unix': cr = string("15b)                       ; carriage (for BC on		                                                ; UNIX use CR rather	        	                                        ; than CR/LF)		else: cr = string("15b)                         ; carriage return	endcase	form="($,'x=',i4,', y=',i4,', value=',"+form+",a)"	npts = 0	pts = fltarr(1,2)	WHILE (!mouse.button LT 2) do begin	; !mouse.button=1 for a left-click		!mouse.button=0		WHILE (!mouse.button LT 1) do begin			wait, 0.4			CURSOR, x, y, 2, /dev			print, form = form, x, y, im[x>0, y>0], cr		ENDWHILE	; The second-level WHILE loop, ends on a left-click.;		The user clicked, so we'll add the current cursor position to the PTS array.		if (npts LT 1) then begin			pts[0,0] = x			pts[0,1] = y		endif else begin			pts2 = pts			pts = fltarr(npts+1,2)			pts[0:(npts-1),*] = pts2			pts[npts,0] = x			pts[npts,1] = y		endelse		npts = npts + 1		print, form="($,a)", string("12b)	ENDWHILE	; The main WHILE loop, ends on a right-click.	return, ptsend