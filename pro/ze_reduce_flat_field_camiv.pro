PRO ZE_REDUCE_FLAT_FIELD_CAMIV

dir='/Users/jgroh/data/lna/camiv_spectra/09jun06/'

;star='agc'
angle='204'

sufix='flati'+'_'+angle+'_'

;defines list filenames ;
list_on=sufix+'on.txt'
list_off=sufix+'off.txt'
mode=sufix+'mode.txt'

list1=dir+list_on
list2=dir+list_off
list3=dir+mode

openw,1,list1     ; open file to write
openw,2,list2


;creates list of files to use in IRAF data reduction of Camiv

for i=1, 10 do begin
printf,1,FORMAT='(A,I4.4,A)','flati_on_'+angle+'_',i,'.fits'
printf,2,FORMAT='(A,I4.4,A)','flati_off_'+angle+'_',i,'.fits'

endfor

close,/all

;generate CL script to be used in IRAF
script=dir+sufix+'red.cl'
openw,9,script

;to compute average flat field images in IRAF
printf,9,'imcombine '+'@'+list_on+' output="'+sufix+'on_m.fits" combine="average" reject="avsigclip"' 
printf,9,'imcombine '+'@'+list_off+' output="'+sufix+'off_m.fits" combine="average" reject="avsigclip"'

;subtract  on - off
printf,9,'imarith '+sufix+'on_m.fits - '+sufix+'off_m.fits '+sufix+'sub.fits'

;compute the mode of the subtracted flat field image
printf,9,'imstat '+sufix+'sub.fits > '+sufix+'mode.txt'

;openr,3,list3     ;open the mode file and read the value NOT WORKING CONSISTENTLY; USING A FIXED VALUE FOR THE MODE
mode='13457.6'
;readf,3,mode

; normalized the flat by the mode
printf,9,'imarith '+sufix+'sub.fits / '+mode+' '+'flati'+angle+'n.fits'

close,9
END
