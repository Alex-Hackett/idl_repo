;       NAME:;               optimalExtraction.Pro;;       PURPOSE:;		To optimally extract a 1-D spectrum from 2-D data.;;		DESCRIPTION:;		Given a data file, and a normalized gaussian image, optimally extract;		the spectrum.  Use the variance maps as weighting functions.;		 ;;       CALLING SEQUENCE:;               optimalExtraction, data, gauss, sig, dirOut;;       INPUTS:;       data    - The data image;       gauss   - The normalized gaussian;		sigma   - the std deviation map;		dirOut  - the directory to save the data;       OUTPUTS:;		The output is the 1-D spectrum.;;       REVISON HISTORY:;       04-MAY-2004, CBO, SwRI;	17-May-2004, CBO, SwRI: modified to use weighted mad scale.;-pro	optimalExtraction, fn, data, gauss, sig, dirOut	sz = SIZE(data, /DIM)	spec = FLTARR(sz[0])	w = 1/sig^2	for i=0, sz[0]-1 do spec[i]=madscalew(gauss[i,*], data[i,*], w[i,*])		WRITEFITS, dirout+fn, spec	endpro	plutoExtractionDRIVEREADCOL, '/Users/colkin/Work04/Pluto_3um/Reduction/fileNamesForExtract.txt', p1file, $p2file, pctr, s1file, s2file, sctr, format="A, A, F, A, A, F"num = N_ELEMENTS(p1file)dirG = '/Users/colkin/Work04/Pluto_3um/ShiftedNG2/'dirD = '/Users/colkin/Work04/Pluto_3um/BackgroundSubt3/'dirV = '/Users/colkin/Work04/Pluto_3um/VarMaps2/'dirOut = '/Users/colkin/Work04/Pluto_3um/PlutoSpectra3/';		 For the Pluto 3um nirspec data, I suggest the following:;	   			rangelow = 31.;   			   	rangehigh = 1015.;	    			boxhalfwidth = 22.;            This will chop off the ends of the image that do not contain data in the rectified;					images and uses a boxwidth equal to that used in the gaussian fits.rangelow = 31.rangehigh = 1015.boxhalfwidth = 22.meanCtr = pctrfor i=0, num-1 do begin		d = READFITS(dirD+ p1file[i])	s = READFITS(dirV+ p1file[i])	data  = d[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]	sig   = s[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]	gauss = READFITS(dirG+ p1file[i])		optimalExtraction, p1file[i], data, gauss, sig, dirOutendendpro	starExtractionDRIVEREADCOL, '/Users/colkin/Work04/Pluto_3um/Reduction/maxRowBS6060', s1file, s2file, sctr, $format="A, A, F, A, A, F"num = N_ELEMENTS(s1file)dirG = '/Users/colkin/Work04/Pluto_3um/NormalizedGaussians2/'dirD = '/Users/colkin/Work04/Pluto_3um/BackgroundSubt3/'dirV = '/Users/colkin/Work04/Pluto_3um/VarMaps2/'dirOut = '/Users/colkin/Work04/Pluto_3um/Spectra3/'rangelow = 31.rangehigh = 1015.boxhalfwidth = 22.meanCtr = sctrfor i=0, num-1 do begin		d = READFITS(dirD+ s1file[i])	s = READFITS(dirV+ s1file[i])	gauss = READFITS(dirG+ s1file[i])	data  = d[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]	sig   = s[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]		optimalExtraction, s1file[i], data, gauss, sig, dirOutendendpro	starExtractionDRIVETfile = "/Users/colkin/Work04/Triton_NIRSPEC/Reduction/filePairs"	 READCOL, file, s1file, list2, meanCtr, format="A, A, F"num = N_ELEMENTS(s1file)dirG = '/Users/colkin/Work04/Triton_NIRSPEC/NormalizedGaussians/'dirD = '/Users/colkin/Work04/Triton_NIRSPEC/BackgroundSubt/'dirS = '/Users/colkin/Work04/Triton_NIRSPEC/SigmaMaps/'dirOut = '/Users/colkin/Work04/Triton_NIRSPEC/Spectra/'boxHalfWidth = 22.rangelow = 98.rangehigh = 935.for i=0, num-1 do begin		d = READFITS(dirD+ s1file[i])	s = READFITS(dirS+ s1file[i])	gauss = READFITS(dirG+ s1file[i])	data  = d[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]	sig   = s[rangelow:rangehigh, meanCtr[i] - boxhalfwidth: meanCtr[i] + boxhalfwidth]		optimalExtraction, s1file[i], data, gauss, sig, dirOutendend