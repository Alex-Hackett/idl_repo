PRO ZE_GIF_ANIMATE_USING_CONVERT,dir_movie,sufix_gif,digits,init_image,end_image,delay_time,movie_output_gif,CONVERT_MOV=CONVERT_MOV

str_array_inc_images=strarr(end_image-init_image+1)
FOR I=init_image, end_image -1 DO str_array_inc_images[i]=dir_movie+sufix_gif+strcompress(string(i, format='(I04)'))+'.gif'
str_all_inc_images=strjoin(str_array_inc_images,' ')

spawn,'convert -delay '+delay_time+' '+str_all_inc_images+'-loop 0 '+dir_movie+movie_output_gif,result1,/sh
;

;converting to quicktime .mov will only work in Mac OSX with QTAmateur installed
IF KEYWORD_SET(CONVERT_MOV) THEN BEGIN

pos=strpos(movie_output_gif,'.')
movie_output_mov=strmid(movie_output_gif,0,pos)+'.mov'

;;command line to open gif movie with QTAmateur
spawn,'open '+dir_movie+movie_output_gif+' -a QTAmateur',result1,/sh
;
;;command line to Use the app_test application written by Jose Groh with Automator to do the conversion to Quicktime .mov  using QTAmateur; this will always create the file 'teste'
spawn,'open -a /Users/jgroh/Documents/app_test.app/Contents/MacOS/Application\ Stub',result2,/sh
spawn,'osascript -e ''tell application "QTAmateur" to activate''',result3,/sh

ENDIF

END