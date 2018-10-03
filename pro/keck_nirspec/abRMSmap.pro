;+
;       NAME:
;               abRMSmap.Pro
;
;       PURPOSE:
;		Returns a 2-D rms map from the various noise sources
;
;	DESCRIPTION:
;		Estimates the noise for an A-B pair of exposures. Calls ROBOMEAN
;		to estimate the sky background and noise on a COLUMN by COLUMN basis.
;		It's assumed that both A and B frames have been rectified such that 
;		the x-axis is WAVELENGTH. The estimated noise is returned in units
;		of DN, but calculated in electrons from the following terms:
;
;		Noise = SQRT(Variances due to SOURCE_ELECTRONS, BACKGROUND_ELECTRONS, and READ_NOISE)
;
;		or more specifically,
;
;		Noise = SQRT(Gain * DN_Source + Gain * DN_Background + RN^2)/gain
;
;		where Gain = no. of electrons per DN,
;		      DN_Source = pixel counts (in DN) on the array after subtracting background
;		      DN_Background = the estimated background counts
;		      RN = read noise in ELECTRONS
;
;       CALLING SEQUENCE:
;               rms = abRMSmap(A, B, gain, rn, bgA, bgB)
;
;       INPUTS:
;       A,B	- 2-D arrays containing the beam-switched image pair
;	gain	- The detector gain, in e-/DN
;	rn	- the detector read noise, in electrons
;	bgA,bgB - the backgrounds, in DN
;
;
;       OUTPUTS:
;       rms	- An array of estimated noise ( the SQRT(variance)).
; 
;       REVISON HISTORY:
;       28-APR-2004, EFY, SwRI
;-

function	abRMSmap, A, B, gain, rn, bgA, bgB

	sz = SIZE(A,/DIM)
	nCol = sz[0]
	nRow = sz[1]

	rmsA = SQRT(((A-bgA)>0)*gain + (bgA>0)*gain + rn^2)/gain	; rms (in DN) at ea. pixel for A
	rmsB = SQRT(((B-bgB)>0)*gain + (bgB>0)*gain + rn^2)/gain

	return, SQRT(rmsA^2 + rmsB^2)
end

pro abRMSmapDRIVE

	file =  '/Users/colkin/Work04/Pluto_3um/Reduction/fileNameMaxRow2'
    
    readcol, file, list1, list2, maxrow, format="A, A, F"
    
    num = n_elements(list1)
    
    dir2 = '/Users/colkin/Work04/Pluto_3um/BackgroundAonly2/'
	datadir = '/Users/colkin/Work04/Pluto_3um/Rectified6/'
	dirOut = '/Users/colkin/Work04/Pluto_3um/VarMaps2/'
	
	gain = 5.
	rn = 33.
	
	for i=0, num-1 do begin

		d1 = readfits(datadir+list1[i])
		d2 = readfits(datadir+list2[i])
		b1 = readfits(dir2+list1[i])
		b2 = readfits(dir2+list2[i])
		
		tmp = abRMSmap(d1, d2, gain, rn, b1, b2)
		
		writefits, dirOut+list1[i], tmp
		
		atv, tmp
		
	endfor
	
end

pro abRMSmapTRITON
	
	file = "/Users/colkin/Work04/Triton_NIRSPEC/Reduction/filePairs"
	 
    readcol, file, list1, list2, maxrow, format="A, A, F"
    
    num = n_elements(list1)
    
    dir2 = "/Users/colkin/Work04/Triton_NIRSPEC/BackgroundAonly/"
	datadir = "/Users/colkin/Work04/Triton_NIRSPEC/Rectified1/"
	dirOut = "/Users/colkin/Work04/Triton_NIRSPEC/SigmaMaps/"
	
	gain = 5.
	rn = 33.
	
	for i=0, num-1 do begin

		d1 = readfits(datadir+list1[i])
		d2 = readfits(datadir+list2[i])
		b1 = readfits(dir2+list1[i])
		b2 = readfits(dir2+list2[i])
		
		tmp = abRMSmap(d1, d2, gain, rn, b1, b2)
		
		writefits, dirOut+list1[i], tmp
		
		atv, tmp
		
	endfor
	
end
