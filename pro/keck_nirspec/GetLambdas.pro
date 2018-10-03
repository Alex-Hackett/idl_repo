;+
;       NAME:
;			GetLambdas.Pro
;
;       PURPOSE:
;			Calls GetClix to get a list of lambda(x,y) points from lamp frames.
;
;	DESCRIPTION:
;		
;
;       CALLING SEQUENCE:
;			lamPts = GetLambdas(im)
;
;       INPUTS:
;       data    - 2-D array containing the image
;
;       OUTPUTS:
;       lamPts   - An NPTSx3 array of (lam,X,Y) triplets.
;
;       REVISON HISTORY:
;       20-APR-2004, EFY, SwRI
;-

function	GetLambdas, im

	
	b = ''	; Set up 'b' as a string
	npts = 0
	REPEAT begin
		READ, b, PROMPT = "Enter next wavelength in microns (or 'q' to exit): "
		if (b NE 'q') then begin
			lam = float(b)
			pts = GetClix(im)
			if (npts EQ 0) then begin
				npts = N_ELEMENTS(pts)/2
				lamPts = [[REPLICATE(lam, npts)], [pts[*,0]], [pts[*,1]]]
				help, lampts
			endif else begin
				npts2 = N_ELEMENTS(pts)/2
				lamPts2 = lamPts
				lamPts = fltarr(npts+npts2, 3)
				lamPts[0:(npts-1),*] = lamPts2
				lamPts[npts:(npts+npts2-1),*] = [[REPLICATE(lam, npts2)], [pts[*,0]], [pts[*,1]]]
				npts = npts + npts2
			endelse	; npts > 0 loop
		endif
	
	ENDREP UNTIL (b EQ 'q')
	
	return, lamPts

end
