; NAME:
;      CNVLGAUSS
;
; PURPOSE: 
;      This function Gaussian smooths an array in it's first dimension
;
; CALLING SEQUENCE:
;      Result = CNVLGAUSS(inarray, sigma, fwhm=fwhm)
;
; INPUTS:
;      Inarray = Vector to be spread
;      Sigma =   Width of Gaussian
; 
; KEYWORD:
;      FWHM = Used instead of sigma for Gaussian, Full Width at Half Maximum
;
; OUTPUT:
;      A 1D array that is smoothed according to a Gaussian
;      
; PROCEDURE:
;      Create a Gaussian and convol it
;
; MODIFICATION HISTORY:
;      created April 19 2003 by John Dermody


function CNVLGAUSS, inarray, sigma, fwhm=fwhm

if (keyword_defined(fwhm)) then begin
  res = fwhm / 2.354 
endif else begin
  res = sigma
endelse

if (res eq 0) then return, inarray

; make the Gaussian
nx = round(res * 4) * 2 + 1  < ((size(inarray))[1] - 1)
ctr = nx / 2
x = findgen(nx) - ctr
k = 1.0 / (res * sqrt(2.*!pi)) * exp((-1./2.) * (x / res)^2) 

; convol it
cnvlarray = convol (inarray, k, total(k), /edge_truncate)

return, cnvlarray
end
