PRO ZE_CCD_NORM_SPECTRA,lambda,spectrum_array,angle,spectrum_array_norm
;routine for continuum normalization of an array containing spectra
;trying to smart guess xnodes location based on grating angle, working very well for 157

npix=(size(spectrum_array))[1]
ndim=size(spectrum_array,/n_dimensions)
IF ndim EQ 2 THEN nframes=(size(spectrum_array))[2] else nframes=1
spectrum_array_norm=dblarr(npix,nframes)

FOR i=0, nframes -1 DO BEGIN   
   
   CASE angle OF
    '157': xnodesnorm=[3777,3787, 3828,3879,3910,3943,3988,4016,4055,4077,4128,4156,4193,4212,4297,4400,4542,4744,4825,4886]*1d0
    ELSE: BEGIN
          nnodes=8
          xnodesnorm=indgen(nnodes)*(npix-300.)/(nnodes-1.) +30.
          xnodesnorm=lambda(temporary(xnodesnorm))
          END
   ENDCASE 
   number_of_nodes=n_elements(xnodesnorm)
   ynodesnorm=xnodesnorm
   print,xnodesnorm
 for  j=0, number_of_nodes -1 do  print,j,' ',max([FINDEL(xnodesnorm[j],lambda)-10,0]),min([FINDEL(xnodesnorm[j],lambda)+10,npix-1])
   for j=0, number_of_nodes -1 do ynodesnorm[j]=MEDIAN(spectrum_array[max([FINDEL(xnodesnorm[j],lambda)-10,0]):min([FINDEL(xnodesnorm[j],lambda)+10,npix-1]),i])

;   print,xnodesnorm
;   print,ynodesnorm  
   line_norm,lambda,spectrum_array[*,i],spectrum_array_normt,spectrum_arraynvalst,xnodesnorm,ynodesnorm
   spectrum_array_norm[*,i]=spectrum_array_normt
ENDFOR
END