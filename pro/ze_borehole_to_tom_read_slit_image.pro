PRO ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,file,image,minx,maxx,miny,maxy,header
close,1

;open file as read-only
openu,1,file

;number of lines of the header; assuming 9 (from tom's pgplot_*.dat files for forbidden-line slit images)
length_header=9
header=strarr(length_header)
headert=''
desc1='' ;dummy variable which reads string stuff that we are not interested in 
desc2='' ;dummy variable which reads string stuff that we are not interested in 

;those lines read the header
FOR i=0, length_header -1 DO BEGIN 
readf,1,headert
header[i]=headert
ENDFOR

;obtain min and max values for the x axis ; assumes 1) they are located at line 7 (i.e IDL index 6) of the header and 2) the space formatting from tom's pgplot_*.dat files.
READS,header[6],FORMAT='(A15,2x,F13.2,1x,A5,3x,F15.2)',desc1,minx,desc2,maxx

;obtain min and max values for the y axis ; assumes 1) they are located at line 8 (i.e IDL index 7) of the header and 2) the space formatting from tom's pgplot_*.dat files.
READS,header[7],FORMAT='(A15,2x,F13.2,1x,A5,3x,F15.2)',desc1,miny,desc2,maxy

;obtain image size ; assumes 1) they are located at line 9 (i.e IDL index 8) of the header and 2) the space formatting from tom's pgplot_*.dat files.
READS,header[8],FORMAT='(A1,1x,I3,1x,I3)',desc1,dimx,dimy

image=dblarr(dimx,dimy)

;after we obtain the image size from the header, here we read the image
readf,1,image

;closes file
close,1
END