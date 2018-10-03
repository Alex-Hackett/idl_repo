;+
;       NAME:
;			RefineLines.Pro
;
;       PURPOSE:
;			Refines the line centers from GetLambdas.Pro by fitting a Gaussian 
;			to get an improved y coordinate.
;
;	DESCRIPTION:
;		
;
;       CALLING SEQUENCE:
;			RefineLines, arcfn, inlistfn, outlistfn, flatfn
;
;       INPUTS:
;       arcfn    - the filename of the lamp image
;		inlistfn - the filename of the input list of (lam, X, Y)
;		outlistfn - the filename of the out list of (lam, X, Y)
;		flatfn   - the filename of the flat file
;
;       OUTPUTS:
;       A file with the name outlistfn is written with the refined line triplets.
;
;       REVISON HISTORY:
;       May-2004, LAY, SwRI
;       June 10, 2004, CBO, SwRI - modified to divide by flat instead of subtract.	
;								   also rotating image before refining lines
;-

pro refinelines, arcfn, inlistfn, outlistfn, flatfn

    ; read in the arc file
    ;superf = readfits(flatfn)
    ;im1 = rotate(readfits(arcfn)/superf, 3)
	;im = im1 - median(im1, 15)
	
	im1 = rotate(readfits(arcfn), 3)
;	im = im1 - smooth( im1, 20)
	im=im1
		
    ; read in the input list
    d=readfits(inlistfn)
    lamL = d[*,0]
    xL = d[*,1]
    yL = d[*,2]
    n = n_elements(xL)

    ; loop
    w = 8.
    wx = 0.
    for i=0, n-1 do begin
        x = xL[i]
        y = yL[i]
        indx = findgen(2*w+1)-w + x
		z = im[indx, y-wx:y+wx]
;        z = total(im[indx, y-wx:y+wx],2)
;        z = total(im[indx, x-wx:x+wx],1)
        bkgd = (z[0]+z[2*w])/2
        ampl = max(z)-bkgd
        a2 = 1. 
        a = [ampl, y, a2, bkgd]
        res = gaussfit(indx, z, a, nterms=4)
        xL[i] = a[1] 
        plot, indx, z, ps=4, /ys, title = i & oplot, indx, res  
        wait, 3 
    end

    ; write the output list
    d[*,1] = xL
    writefits, outlistfn, d
    
    
end

pro refinelinesPLUTO

    arcfn = '/Users/colkin/Data/12aug01_CD1/spec/12aus0003.fits'
    inlistfn =  "/Users/colkin/Work04/Pluto_3um/Reduction/LambdaMap/observedNeLines2.fits"
    outlistfn = "/Users/colkin/Work04/Pluto_3um/Reduction/LambdaMap/refinedNeLines4.fits"
	flatfn = '/Users/colkin/Work04/Pluto_3um/Reduction/Flatten/superFlat.fits'
	
    refinelines, arcfn, inlistfn, outlistfn, flatfn

end

pro refinelinesTRITON

    arcfn = '/Users/colkin/Data/12aug01_CD1/spec/12aus0114.fits'
    inlistfn = '/Users/colkin/Work04/Triton_NIRSPEC/Line_ID/xylambdas2.fits'
    outlistfn = '/Users/colkin/Work04/Triton_NIRSPEC/Line_ID/refinedArLines2.fits'
	flatfn = '/Users/colkin/Work04/Pluto_3um/Reduction/Flatten/superFlat.fits'
	
    refinelines, arcfn, inlistfn, outlistfn, flatfn

end
