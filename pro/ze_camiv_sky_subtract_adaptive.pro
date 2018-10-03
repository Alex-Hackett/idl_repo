PRO ZE_CAMIV_SKY_SUBTRACT_ADAPTIVE,input_Array,nframes,nimages_per_pos,output_array,sky_array
;does an adaptive sky subtraction for each dithering position
;returns the subtracted image array and the sky image for each offset position
;assumes 3 exposures per dithering position
;written by J H Groh

output_array=input_array
nx=(size(input_Array))[1]
ny=(size(input_Array))[2]
noffset=FLOOR(nframes/nimages_per_pos)
sky_array=dblarr(nx,ny,noffset)
index=replicate(1L,nframes)

l=0
for I=0, noffset -1 DO BEGIN
  delframes=[l,l+1,l+2]
  index=replicate(1L,nframes)
  index[delframes]=0L
  keepframes=where(index eq 1)
  input_array_adap=input_array[*,*,keepframes]
  sky_temp=MEDIAN(input_array_adap,/DOUBLE,diMENSION=3)
  sky_array[*,*,i]=sky_temp
  FOR j=l, nimages_per_pos - 1 DO  output_array[*,*,j]=output_array[*,*,j] - sky_array[*,*,i]
  l=l+3
ENDFOR


END