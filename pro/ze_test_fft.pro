
n = 256  
x = FINDGEN(n)  
y = COS(x*!PI/6)*EXP(-((x - n/2)/30)^2/2)  
  
; Construct a two-dimensional image of the wave.  
z = REBIN(y, n, n)  
; Add two different rotations to simulate a crystal structure.  
z = ROT(z, 10) + ROT(z, -45)  
WINDOW, XSIZE=540, YSIZE=540  
LOADCT, 39  
TVSCL, z, 10, 270  

; Compute the two-dimensional FFT.  
f = FFT(z)  
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.  
TVSCL, logpower, 270, 270   
t=size(x)
x = [ x, REVERSE( x ) ]
t1=size(x)
END
