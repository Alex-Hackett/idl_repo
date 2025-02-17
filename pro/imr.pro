PRO imr,filein,fileout,kdif=kdif
; This is a version without making 'test' files
;
; to call use  imr,'filein.fit','fileout.fit'
;
; This is an interactive code to remove CRs on ITS images.
;            Wide version (iedit=1)
; (1) First this code replaces the brightness of 'warm' pixels,
; (2) then it uses 'imgclean' to find clusters that can be CRs,
; (3) then it suggests a user to show the rectangles 'A' inside which
; clusters detected as CRs by imgclean are not considered as CRs
; (i.e., deleting of false CRs),
; (4) then it suggests to a user to show the rectangles 'B' where
; the brightness of ALL pixels which differed from
; the median value by a factor of kdif=2 is replaced by the median value
; (i.e., we delete all CRs or stars in the rectangles 'B', including
; those which were not detected by imgclean).
; 
; Rectangules 'A' are considered mainly near the comet 
; because there could be a lot of faulse CRs near the edge of the comet.
; Rectangules 'B' can be considered when we can see that
; imgclean have not found all CRs (e.g., it often does not detect all long CRs)
; or we want to make a smooth brightness for some region (e.g., to delete stars).
; 
;           Quick version (at iedit=3)
; (1) First this code replaces the brightness of 'warm' pixels,
; (2) then it uses 'imgclean' to find clusters that can be CRs,
; (3) then it suggests a user to show the rectangle 'C' inside which
; clusters detected as CRs by imgclean are not considered as CRs
; (no changes compared with the original image inside this rectangle). 
; Outside this rectangle, 
; the brightness of ALL pixels which differed too much from
; the median value by a factor of kdif=2 is replaced by the median value.
; Rectangle 'C' must include the comet, including its bright coma and
; outbursts. All stars and CRs outside the rectangle 'C' will be deleted.
; 
;                 Recommendations
;   The code (which has different options) can show clusters deleted by 'imgclean'.
;One can show rectangles "A" inside which not to use results of 'imgclean', 
;but to use the original image. "Imgclean' detects too many false CRs near
;the edge of the comet. So one can choose several rectangles which include
;such false CRs. These rectangles can occupy the edges of the comet, or
;one can take one larger rectangle which includes all the comet and its edges.
;   The user can also choose rectangles "B", inside which brightness of 
;all pixels which differed too much from the local median value 
;is replaced by the local median value of brightness. We recommend to use 
;such rectangles to delete those glitches of cosmic rays which were not entirely
;deleted by imgclean (often imgclean can not delete all long CRs) and
;for those regions where too many clusters were detected as CRs (on ITS images,
;sometimes there are regions where brightness of pixels corresponding to
;background varied much for close pixels and therefore imgclean can detect
;a great number of false CRs in these regions). Also one may want to delete
;stars if he wants.
;   As a result of the work of the code: (1) inside rectangles A, we have initial 
;image (before imgclean), (2) inside rectangles B, the brightness is changed
;for clusters detected as CRs by imgclean and for other pixels which
;brightness differed by a factor of kdif (default value equals 2 for ITS
;images) from the local median brightness. (3) outside rectangles A and B,
;the brightness is changed for clusters detected as CRs by imgclean.
;   In the above 'wide' version, one can use any number of rectangles
;and can make many corrections of the image. These version is recommended
;if you want to edit carefully an image.
;   This code also allows to use [by choosing the answer '3']
;a 'quick' version when only one rectangle "C" is considered. Inside this
;rectangle we do the same as for the above rectangles "A", and outside this
;rectangle we do the same as for the above rectangles "B". The rectangle 'C'
;must include the comet and some region near the edges (where usually imgclean 
;detects false CRs; for images with outbursts this region can be greater). 
;This version is recommended when one needs to consider quickly a large 
;number of images. Outside the rectangle 'C', all stars are also deleted.
;   Note that a 'quick' version can work (after rewriting the code) 
;without using 'imgclean', but in this case outside rectanles "C"
;we will change the brightness only of pixels which are differed from the
;local median brightness. Further studies are needed to understand
;whether most of pixels detected as CRs by imgclean are also detected by
;the 'quick' version itself, and what value of 'kdif' must be used.
;   We suggest not to use the code for removal of CRs from images made just
;after the impact if the expected number of CRs is not more than e.g. 3 (images
;of not more than 256*256 made with a short exposure time, e.g. less than 
;1 second) and image of a comet occupies a considerable part of the frame. 
;   For frames with a large enough image of the comet for which the expected 
;number of CRs is not small, I suggest to use a �wide� version. First consider 
;CRs detected by imgclean and restore that part of initial image where there are 
;false CRs near the edge of the comet or on the comet. Then look at the image 
;and remove long CRs if there are such rays. For example, at HRI 90�861, 
;imgclean did not detect two small �long� CRs not far from the edge 
;of the comet.
;   For frames with a small image of a comet, in order to spend small time I 
;suggest to use a �quick� version of the code. The rectangle �C� must include 
;the comet. Inside this rectangle, the final image is the same as the initial 
;image. Outside the rectangle, we make a smoother brightness for CRs detected by 
;imgclean and for all pixels which brightness is greater than the local median 
;level multiplied by kdif (the default value of kdif equals 2). The number of 
;such bright pixels can be large, but all of them are located far from the comet 
;at the dark enough regions of sky (so both on initial and final images, we see 
;dark sky). Besides CRs, stars (may be except some very large stars) will be 
;deleted at such approach, but as I understand, for photometry studies, it is 
;better to delete any bright clusters. Note that if we choose a rectangle �C� 
;outside a comet, the comet itself can be removed as bright pixels in �quick� 
;version, so the rectangle must be around the comet.
;   Earlier I was against removal of CRs from ITS images, as the number of false 
;CRs detected by imgclean is greater by a factor of several than the number of 
;real CRs. Now I suggest to use removal of CRs for ITS images, as removal of 
;�false� CRs make the background smoother.
;   For frames without a comet, the interactive code may be used for manual 
;removal of long CRs which were not removed by imgclean. In this case, one does 
;not change the CRs found by imgclean (i.e., does not consider rectangles �A� 
;mentioned in my previous e-mail), but delete manually only remained long 
;clusters from the image (i.e., work only with rectangles �B�).
;
; May-June 2006; Sergei Ipatov, sipatov@umd.edu

; 
if n_elements(kdif) LE 0 then kdif=2.
kdifr=1./kdif
;;print,kdifr,kdif,'enter imitsr with another kdif, if you need another range'
; at kdif=1.3 too many pixels are replaced at the edge of a comet and on a comet on ITS image
;ima=readfits('file.fit',header)
;map = readfits('file.fit',exten=1) 
;
ima=readfits(filein,header)

; the beginning of the code uses commands from imgcleanf.
;;PRO rmwarm,ima,jma,map,header=header
;
; If the brigtness of a �warm� pixel is greater than the median value 
; of close pixels, than it is replaced by this median value
; No removal of cosmic rays
; �file.fit� is considered file
; �map.fit� is the file with �warm� pixels
; �del.fit� is the file with pixels which brightness was changed
; �finalfile� is the obtained file 
; If needed, construction of these files can be deleted
;
; ima is the input image, and jma is the output image
; to get ima use              ima=readfits('file.fit',header)
; to get map use              map = readfits('file.fit',exten=1) 
; to run this code use        rmwarm,ima,jma,header=header
; to get the final file use   fits_write,'finalfile.fit',jma,header
; to get deleted pixels use   del =ima ne jma
;                             fits_write,'del.fit',del,header
;
; (1)
; Dec. 6, 2005.
; This code restores the edges of Deep Impact MRI and HRI VIS images 
; after the work of 'imgclean' (written by E. Deutsch)
; which deletes CRs (and most of pixels at the edges of a DI VIS image).
; For images which are not made by Deep Impact, one may not need
; to restore the edges, and the edges can be different.
;
; (2)
; Jan. 18, 2006
; A new replacement of brightness of objects considered as CRs was made.
; It was needed, because near the border of a comet, 'imgclean'
; considers too many pixels as CRs and replaces their brightness with a wrong
; brightness, so part of comet becomes 'eaten' and a lot of 'dust' objects
; appear near the comet.
; Now replaced pixels get the brightness such as that of background.
; If this brightness is greater that their initial brightness,
; then the old brightness is left.
; It allows to make pixels deleted near the border to be 
; practically the same as the nearest background. 
; So the deleted pixels do not spoil the final image of a comet 
; in such a way as imgclean.
;
; The revised code 'imgcleanf' is recommended for use in all cases, 
; not only for images with a comet.
; We recommend 'imgcleanf' for automatic consideration of a large
; number of MRI or HRI images (RADREV or RAD, not raw images),
; because 'imgclean' is a reliable (it always normally comes to the end for 
; all DI images, in contrast e.g. to crfind) and fast code
; [it is not recommended for ITS and HRI IR images].
; For specific images, other codes can give better results.
; You can use the replacement suggested below for other codes (e.g. crfind).
;
; All corrections were made by Sergei Ipatov 
; (ipatov@astro.umd.edu)  
;
; (3)
; Jan 24, 2006 - Mark Desnoyer (md246@cornell.edu)
;
; Changed the way overcorrected pixels are replaced with the originals.
; it is more efficient now although the end result is the same.
;  (4)
; May - June , 2006 � Sergei Ipatov
; The previous code used for removal of cosmic rays
; was modified to remove warm pixels from ITS images.
; If the brigtness of a �warm� pixel is greater than the median value 
; of close pixels, than it is replaced by this median value.

imgmode=sxpar(header,'imgmode')
inst=sxpar(header, 'INSTRUME')
nx=sxpar(header,'naxis1')-1
ny=sxpar(header,'naxis2')-1  ; size of the image [0:ny]
wjma=ima  ; jma will be changed by imgclean
jmae=ima ; we use jmae to restore the edges
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;(((
;http://jplsdc.astro.cornell.edu/DeepImpact/Src/idl/DiCal/dical_flags.pro 
;
; Replacement of the brightness of 'warm' pixels:
map = readfits(filein,exten=0) 
@dical_flags 
map = map AND FLAG_BAD 
;;;;;;;;;   fits_write ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  test
;fits_write, 'map.fit',map
;;;;;;;;;;;;;;;                 ;;;;;;;;;;;;;;;;;;;;;  test
cr=map
imaw=ima
      for k=1,2 do begin  ; the number of cycles can be changed
sky=median(imaw,7)  ; the number can be taken to be another 
;
; if new brightness is greater than old brightness
; then we take an old brightness because CRs
; are brighter than background                    
; in order to try to get a better result,
; i.e., we replace only those 'map' pixels which are bright;
; faint 'map' pixels remains the same.
w = where(cr,cnt)      ;; where shows nonzero elements; cnt is the number of nonzero elements
if cnt GT 0 then begin
	wjma[w] = sky[w]
	tooBright = where(sky[w] GT imaw[w],c2)
	if c2 GT 0 then wjma[w[tooBright]] = imaw[w[tooBright]]
endif
      imaw=wjma   ; in order to use imaw in a new cycle
      endfor ; two cycles are needed for IR images 1024*512 where there is a large cluster of 'warm' pixels
;  end of replacing of warm pixels; the obtained image is wjma
;
;  for discussion    for discussion   for discussion  (((
;;;wjmaold=wjma
;;;       for ik=0, nx do begin
;;;       for jk=0, ny do begin
;;;       if wjma(ik,jk) LT 0 then wjma(ik,jk)=0
;;;       endfor
;;;       endfor
;  We suggest to replace negative brightness to zero brightness
;  This will not change the image because it still remains dark, 
;  but will make easier to clear images from CRs
;  for discussion    for discussion   for discusion   )))
;
print,'the brightness of bright warm pixels was replaced by the median value'
;
;  below we remove cosmic rays from wjma
;
wjmae=wjma ; wjmae is for below correction
jma=wjma
imgclean,jma   ; jma is changed by imgclean ; running imgclean ==========
cr=jma ne wjma  ; pixels considered as CRs
sky=median(wjma,7)  ; the number can be taken to be another 
; If new brightness is greater than old brightness,
; then we take an old brightness because CRs
; are brighter than background                    
; in order to try to get a better result
w = where(cr,cnt)
if cnt GT 0 then begin
	jma[w] = sky[w]
	tooBright = where(sky[w] GT ima[w],c2)
	if c2 GT 0 then jma[w[tooBright]] = ima[w[tooBright]]
endif

; if you do not need to store the edges, you can deleted 
; the text below (before '***')
;
; We find the sizes of the edges based on imgmode.
; Notes: The number of restored raws and lines in the edges is
; greater than that in Table IV on page 71 in Space Science 
; Reviews, v. 117, Nos. 1-2, 2005 (e.g. 8 for mode=1),
; because e.g. for mode=1 9th row and 9th line are bright,
; 10th row and 10th line can have a lot of bright pixels,
; and 11th line can have some bright pixels which are not cosmic rays.
; The values of iy presented below were suggested 
; by Dennis Wellnitz. Dennis suggested to use ix=iy-1, 
; but for mode=3 I found that the 6th column also can contain a lot of 
; deleted pixels. So below the values of ix were taken to be
; equal to iy suggested by Dennis. Probably for some modes
; the values of ix can be the same as it was suggested to Dennis,
; but as there are some examples which give larger edges, I took ix=iy.
; I will be glad to get any comments about the sizes of the edges
; which must be restored in order to find true values.
; For what modes can we take ix=iy-1?
; Depending on one's problem, one can consider other values of ix and iy.
ix0=0	;;Number of rows to delete on the left
ix1=0	;;the right
iy0=0	;;the bottom
iy1=0	;;the top
if strtrim(inst,2) EQ 'HRIIR' then begin	;;IR instrument
        n512256=256   ; used in congrid
	switch imgmode of
	1:
	5:begin
		ix0=3
		iy0=3
		iy1=1
		break
	end
	2:
	3:begin
		ix0=3
		iy0=2
		iy1=2
		break
	end
	4:
	6:begin
		ix0=5
		iy0=5
		iy1=1
		break
	end
	endswitch
	ix1=ix0

endif else begin	;;VIS instruments
        n512256=512   ; used in congrid
	switch imgmode of
	1:
	9: BEGIN
		ix0=11 & break
	END
	2:
	3: BEGIN
		ix0=6 & break
	END
	5:
	6: BEGIN
		ix0=4 & break
	END
	7: BEGIN 
		ix0=2 & break
	END
	8: BEGIN
		ix0=1 & break
	END
	endswitch

	ix1=ix0
	iy0=ix0
	iy1=ix0
endelse

;
; now restore the edges   ; it was jmae=ima; below we change the center
jmae(ix0:nx-ix1,iy0:ny-iy1) = $
	jma(ix0:nx-ix1,iy0:ny-iy1)
jma = jmae    ;;;;;;;;;  ??
; ***
;;;;;;;;;;;;;;;;;;; (((  ; wjma=wjmae before imgclean, but after correction of warm pixels
wjmae(ix0:nx-ix1,iy0:ny-iy1) = $
	jma(ix0:nx-ix1,iy0:ny-iy1)
wwjma = wjmae
cr=wjma ne wwjma   ; these are CRs detected by imgclean, not considering the edges
;  corrected 'warm' pixels are not considered as CRs
; to get the final file use   

; to get pixels deleted as cosmic rays use   
del =ima ne jma   ;;;;  del includes those 'warm' pixels that were changed; this is not statistic for CRs

;;;;;; fits_write ;;;;;;;;;;;;                                  ;;;;;;;;;;;;;;test
;fits_write,'finalfile.fit',jma,header  ;; final file before manual correction
;fits_write,'warm.fit',del,header       ;; warm pixels that were changed
;fits_write,'cr.fit',cr,header          ;;; cr - clusters detected as CRs before manual correction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                  ;;;;;;;;;;;;;;;test
;; tvscl,jma   ; how to have two windows: with jma and cr? 

;    (((
;;;skyold=sky
;;;       for ik=0, nx do begin
;;;       for jk=0, ny do begin
;;;       if sky(ik,jk) LT 0 then sky(ik,jk)=0
;;;       endfor
;;;       endfor
;  we replace negative brightness of sky to zero brightness
;  because it is needed below for smoothing rectangle B
;   )))
;


nxx=sxpar(header,'naxis1')
nyy=sxpar(header,'naxis2')  ; size of the image [0:nyy-1=ny]
second=sxpar(header, 'INTTIME')*0.001  ; exposure time in seconds
print, 'the exposure time is ', second
  if second lt 2. then begin
  second=2.
  print, 'below we consider the time = 2 sec, as for smaller time the number of CRs does not depend much on time'
  endif
print, 'the size of the image is ', nxx,nyy
extime=3.*second*(nxx/64)*(nyy/64)/64.   ;if nxx<64, then extime=0 ; division of integers is integer
print, 'the expected number of CRs is', extime
cr2=cr
cr3=fltarr(nx+1,ny+1)  ; nxx=nx+1
for i=0,nx do begin   ; was nxx-1
for j=0,ny do begin
cr3(i,j)=cr(i,j)
endfor
endfor
jma2=jma
  print,'print 1 if you want to see images and use mouse to edit the images'
  print,'else (any other number) you need to know in advance the coordinates of corrected regions'
  read,medit
  print,medit

ixy1=intarr(2)
ixy2=intarr(2)

        if medit ne 1 then begin  ;;;;;;;;;;;;;;;;////////////// without mouse

;   without mouse   without mouse   without mouse     without mouse
print,'print 1 if you want to edit detected CRs'
print,'print 3 if you want not to consider CRs (i.e., not to change the initial image)'
print,'inside a rectangle and delete all bright pixels (including stars)'
print,'outside this rectangle'    
print,'else print any other number'                                      ;#
read,iedit
print,iedit
  if iedit eq 1 or iedit eq 3 then begin ;+++++                       ;#
            iz=0
while iz ne 1 do begin
;;while !mouse.button ne 1 and !mouse.button ne 4 do begin
;;endwhile
print,'mark coordinates of two vertexes of the rectangle' 
print,'where brightness of all clusters detected as CRs'
print,'is replaced by the brightness which was before imgclean'
;

print, 'print x,y for the left below corner'  
read,ixy1
print,'x,y for the left below corner are',ixy1
print, 'print x,y for the right upper corner' 
read,ixy2
print,'x,y for the right upper corner are',ixy2

  for i=ixy1(0),ixy2(0) do begin
  for j=ixy1(1),ixy2(1) do begin
  cr2(i,j)=0   ; 0 means no CRs
    if cr(i,j) ne cr2(i,j) then begin
    jma2(i,j)=wjma(i,j) ; the same value as before imgclean but after changing warm pixels
    cr3(i,j)=0.01  ; faint=0.01 - what clusters we do not consider as crs
;;;;;;;;;;;;;  test ;;;;;;;;;;;;;;;;;;;;;  test
;    print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma2(i,j),jma(i,j),ima(i,j)
;;;;;;;;;;;;;  test  ;;;;;;;;;;;;;;;;;;;;  test
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
    endif
  endfor
  endfor
      if iedit eq 1 then begin                                   ;#
  print,'print 1 if you wish to finish to edit image, else 0'
  read,iz
      endif                                                      ;#
      if iedit eq 3 then iz=1                                    ;#
endwhile

   endif                              ;;+++++
;;tvscl,cr3
;;tvscl,jma2
;; then delete additional clusters ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

jma3=jma2
       if iedit ne 3 then begin       ;======    iedit ne 3        ;#
print,'print 1 if you want to delete bright clusters by yourself'
read,jedit
print,jedit
;;;       endif                                                    ;#
;;;       if iedit eq 3 then jedit=1                               ;#
  if jedit eq 1 then begin ;+++++
iz=0
;
;;while !mouse.button ne 1 and !mouse.button ne 4 do begin
;; Cursor,x,y,/device


while iz ne 1 do begin  ;;;;

print,'mark coordinates of two vertexes of the rectangle' 
print,'where brightness of all pixels is replaced by the median value'
print, 'print x,y for the left below corner'   

read,ixy1
print,'x,y for the left below corner are',ixy1
print, 'print x,y for the right upper corner' 
read,ixy2
print,'x,y for the right upper corner are',ixy2
  
  for i=ixy1(0),ixy2(0) do begin
  for j=ixy1(1),ixy2(1) do begin
;;;    if jma3(i,j) lt sky(i,j)*kdifr or jma3(i,j) gt kdif*sky(i,j) then begin
;;; kdifr  is not good for ITS images because most of brightness can be negative
;;if sky(i,j) gt 0 and jma3(i,j) gt kdif*sky(i,j) or sky(i,j) lt 0 and jma3(i,j) lt kdif*sky(i,j) then begin
;; there is no sense to change negative brightness
    if sky(i,j) gt 0 and jma3(i,j) gt kdif*sky(i,j)  then begin
    jma3(i,j)=sky(i,j)
;   to find out what may be better than sky. May be median for a larger value?
; may be only those pixels which brightness is too different from a median value
    cr3(i,j)=0.002  
; faint=0.002 - what pixels we replace with a median
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
;print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma3(i,j),jma2(i,j),jma(i,j),ima(i,j),kdif,kdifr
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
    endif
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
  endfor
  endfor

  print,'print 1 if you wish to finish to edit image, else 0'
  read,iz
endwhile                ;;;;

  endif ; ++++
             endif          ;======    iedit ne 3        ;#

      if iedit eq 3 then  begin    ; ========= iedit eq 3  ;#
  for i=ix0,nx-ix1 do begin
  for j=iy0,ny-iy1 do begin
      if (i lt ixy1(0) or i gt ixy2(0)) or $
         (j lt ixy1(1) or j gt ixy2(1)) then begin  ;;;;\\\\\
    if sky(i,j) gt 0 and jma3(i,j) gt kdif*sky(i,j)  then begin
    jma3(i,j)=sky(i,j)
    cr3(i,j)=0.002  
; faint=0.002 - what pixels we replace with a median
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
;    print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma3(i,j),jma2(i,j),jma(i,j),ima(i,j),kdif,kdifr
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
    endif
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
         endif                                      ;;;;;\\\\\
  endfor
  endfor
      endif                        ; ========= iedit eq 3  ;#
           endif;;;;;;;;;;;;;;;;;;;;;;;;;//////////////////  end without mouse


;  two possibilities: medit=1 with mouse, medit=0 without mouse
;  now with mouse  mouse  mouse  mouse  mouse   mouse  mouse
;;;  if  your computer allows to use 1024*1024 window then n512=1024  ;;;;;
   n512=512
        if medit eq 1 then begin  ;;;;;;;;;;//////////////////  begin with mouse

   if nxx le n512 then begin tvscl,cr2
   endif else begin
   cr22=congrid(cr2,512,n512256)
   tvscl,cr22
   endelse

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print,'You see CRs detected by imgclean'    ; this is a addition to imitsrr
print,'print 1 if you want to see an image (after imgclean)'
print,'It is recommended if you have not yet understood the location of a comet'
print,'and you want to remove all bright clusters outside'
print,'the rectangle which includes the comet.'
print,'If you will edit detected CRs, press 0'
print,'else print any other number'
   read,nedit
   print,nedit
n1=-3     ; intervals for presentation of brightness
  n2=-1
 jscale=1   ;  jscale is needed for 'while - endwhile'
  iscale=1  ;  iscale=2 if we reduce image on a screen
     if nedit eq 1 then begin       ;;;====
   if nxx le n512 then begin tvscl,alog10(jma2)>n1<n2
   endif else begin
   jma22=congrid(jma2,512,n512256)
   tvscl,alog10(jma22)>n1<n2
    iscale=2
   endelse

          while jscale ne 2 do begin
     print,'print 0 0 if you do not want to change the resolution; was',n1,n2
     print,'print n1 n2 if you want to change resolution in'
     print,'tvscl,alog10(jma2)>n1<n2'
     read,n1,n2

       if n1 ne 0 and n2 ne 0 then begin 
   if nxx le n512 then begin tvscl,alog10(jma2)>n1<n2
   endif else begin
;   jma22=congrid(jma2,512,n512256)
   tvscl,alog10(jma22)>n1<n2
   endelse
       endif
      if n1 eq 0 and n2 eq 0 then jscale=2  
          endwhile             ;  end of addition to imitsr
           endif                    ;;;====
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print,'print 1 if you want to edit detected CRs'
print,'print 3 if you do not want to consider CRs'
print,'(i.e., not to change the initial image)'
print,'inside a rectangle and you want to delete all bright pixels '
print,'(including stars) outside this rectangle'                                        ;#
print,'else print any other number'
read,iedit
print,iedit
  if iedit eq 1 or iedit eq 3 then begin ;+++++     iedit,1,3           ;#
                       iz=0
  while iz ne 1 do begin                 ;////
;;while !mouse.button ne 1 and !mouse.button ne 4 do begin
;;endwhile


if iedit eq 1 then begin   ;;;;;;;;;;;;;;;;;;;;;;;;;;  correction to imitsr
print, 'mark coordinates of two vertexes of the rectangle' 
print,'where the brightness of all clusters detected as CRs'
print,'is replaced by the values of brightness which was before imgclean'
endif                     

if iedit eq 3 then begin   
print,'mark coordinates of two vertexes of the rectangle' 
print,'outside which the brightness of all bright pixels'
print,'is replaced by the local median values of brightness'
endif 

if nedit ne 1 then begin  ;; at nedit=1 we consider image, not CRs
     iscale=1
     if nxx le n512 then begin tvscl,cr2
     endif else begin
     cr22=congrid(cr2,512,n512256)
     tvscl,cr22
     iscale=2
     endelse
endif                    ;;;;;;;;;;;;;;;;;;;;;;;;;; end of correction to initsr


;;  with mouse   <=>  medit=1

ixy11=intarr(2)
ixy22=intarr(2)
print, 'click the left lower corner'  
cursor,x,y,/device,/up
ixy11(0)=x
ixy11(1)=y
print,'x,y for the left lower corner are',ixy11
print, 'click the right upper corner' 
cursor,x,y,/device,/up
ixy22(0)=x
ixy22(1)=y
;cursor,ixy22(0),ixy22(1),/device
print,'x,y for the right upper corner are',ixy22
ixy1=ixy11*iscale
ixy2=ixy22*iscale
print,'iscale=',iscale,ixy1,ixy2
;
  for i=ixy1(0),ixy2(0) do begin  ;;;
  for j=ixy1(1),ixy2(1) do begin
  cr2(i,j)=0   ; 0 means no CRs
    if cr(i,j) ne cr2(i,j) then begin
    jma2(i,j)=wjma(i,j) ; the same value as before imgclean but after changing warm pixels
    cr3(i,j)=0.01  ; faint=0.01 - what clusters we do not consider as crs
;                test                       test                           test
;    print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma2(i,j),jma(i,j),ima(i,j),kdif
;                test                       test                           test
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
    endif
  endfor
  endfor                          ;;;

  if nxx le n512 then begin tvscl,cr2
  endif else begin
  cr22=congrid(cr2,512,n512256)
  tvscl,cr22
  endelse
    if iedit eq 1 then begin                                   ;#
  print,'print 1 if you wish to finish to edit CR image, else 0'
  read,iz 
    endif                                                      ;#
   if iedit eq 3 then begin
   iz=1         
   endif                           ;#
    endwhile    ;;;  ///////////
   endif  ;;+++++               iedit,1,3
;;tvscl,cr3
;;tvscl,jma2
;; below we can delete additional clusters ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
  n1=-3     ; intervals for presentation of brightness
  n2=-1
  jma3=jma2
   if nxx le n512 then begin
   tvscl,alog10(jma3)>n1<n2
   endif else begin
    jma33=congrid(jma3,512,n512256)
    tvscl,alog10(jma33)>n1<n2
    endelse
       if iedit ne 3 then begin                                 ;#
print,'print 1 if you want to delete clusters by yourself'
read,jedit
print,jedit
       endif                                                    ;#
;
       if iedit ne 3 then begin ;;;///  iedit ne 3                    ;# 
  if jedit eq 1 then begin ;+++++         ;  jedit=1
  iz=0
;
;;while !mouse.button ne 1 and !mouse.button ne 4 do begin
;; Cursor,x,y,/device
;;jma3=jma2

     n1=-3  ; initial resolution
     n2=-1

while iz ne 1 do begin   ;;;;((((

     iscale=1
;;     n1=-3   ;;;  initial resolution
;;     n2=-1
      nn1=n1
      nn2=n2
     if nxx le n512 then begin    ;;  no congrid 
     tvscl,alog10(jma3)>n1<n2
 ;   tvscl,alog10(jma3)>(-4)<4  ; was
     print,'print 0 0 if you do not want to change the resolution; was',n1,n2
     print,'print n1 n2 if you want to change resolution in'
     print,'tvscl,alog10(jma)>n1<n2'
     read,n1,n2
      if n1 ne 0 and n2 ne 0 then begin 
      tvscl,alog10(jma3)>n1<n2
      endif 
     endif else begin      ;;;--
;                                          reducing image
     jma33=congrid(jma3,512,n512256)
 ;    tvscl,alog10(jma33)>(-4)<4   ;  was
    tvscl,alog10(jma33)>n1<n2
      print,'print 0 0 if you do not want to change the resolution; was',n1,n2
     print,'print n1 n2 if you want to change resolution in'
     print,'tvscl,alog10(jma)>n1<n2'
     read,n1,n2

       if n1 ne 0 and n2 ne 0 then begin 
       tvscl,alog10(jma33)>n1<n2
       endif 
     iscale=2
     endelse                ;;;--
       if n1 eq 0 and n2 eq 0 then begin
       n1=nn1
       n2=nn2   ;  in order to get final image after 0 0
       endif

;;    if iedit ne 3 then begin         ;; ==== iedit ne 3          ;#
  print,'print 1 if you wish to finish to edit image, else 0'
  read,iz
;;      endif else iz=1                                    ;#

   if iz ne 1 then begin   ;;;===    iz ne 1
print, 'mark coordinates of two vertexes of the rectangle where' 
print,'brightness of all bright pixels will be replaced with the median value'
ixy11=intarr(2)
ixy22=intarr(2)
print, 'click the left below corner'  
;cursor,ixy11(0),ixy11(1),/device
cursor,x,y,/device,/up
ixy11(0)=x
ixy11(1)=y
print,'x,y for the left below corner are',ixy11
print, 'click the right upper corner' 
;cursor,ixy22(0),ixy22(1),/device,/up
cursor,x,y,/device
ixy22(0)=x
ixy22(1)=y
print,'x,y for the right upper corner are',ixy22
ixy1=ixy11*iscale
ixy2=ixy22*iscale
print,'iscale=',iscale,ixy1,ixy2
  
  for i=ixy1(0),ixy2(0) do begin
  for j=ixy1(1),ixy2(1) do begin
;;    if jma3(i,j) lt 0.8*sky(i,j) or jma3(i,j) gt 1.2*sky(i,j) then begin
    if sky(i,j) gt 0 and jma3(i,j) gt kdif*sky(i,j) then begin             ;##
    jma3(i,j)=sky(i,j)
;   to find out what may be better than sky. May be to consider median value for a larger region?
; may be only those pixels which brightness is too different from a median value
    cr2(i,j)=0  ; if in this rectangle, we have Crs, we replace them, 
;; but we replace also other bright or dark pixels
    cr3(i,j)=0.002  
; faint=0.002 - what pixels we replace with a median value
;               test                         test                    test
;    print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma3(i,j),jma2(i,j),jma(i,j),ima(i,j)
;               test                         test                    test
    endif
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
  endfor
  endfor
       endif              ;;;===      iz ne 1
;;  print,'print 1 if you wish to finish to edit image, else 0'
;;  read,iz
endwhile  ;;;                                                     endwhile
  endif ; ++++                    ;  jedit=1
             endif       ;;;/// iedit ne 3                      ;# 
;
;
         if iedit eq 3 then begin       ;;\\\\\\  iedit eq 3    ;#
  for i=ix0,nx-ix1 do begin
  for j=iy0,ny-iy1 do begin
      if (i lt ixy1(0) or i gt ixy2(0)) or $
         (j lt ixy1(1) or j gt ixy2(1)) then begin  ;;;;\\\\\
    if sky(i,j) gt 0 and jma3(i,j) gt kdif*sky(i,j)  then begin
    jma3(i,j)=sky(i,j)
    cr3(i,j)=0.002  
; faint=0.002 - what pixels we replace with a median
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
;    print,i,j,cr(i,j),cr2(i,j),cr3(i,j),jma3(i,j),jma2(i,j),jma(i,j),ima(i,j),kdif,kdifr
;;;;;;;;;;;;;;                            ;;;;;;;;;;;;;  test
    endif
    endif
   endfor
   endfor
; the difference between cr2 and cr3 is in 'faint' pixels which show clusters 
; which are not considered as CRs
         endif                          ;;\\\\\\\   iedit eq 3
;
           endif;;;;;;;;;;;;;;;;;;;;;;;;;//////////////////

   if medit eq 1 then begin
     if nxx le n512 then begin 
     tvscl,alog10(jma3)>n1<n2
;     endif 
     endif else begin
     jma33=congrid(jma3,512,n512256)   ; we decrease the image on a screen if it is large (>512)
     tvscl,alog10(jma33)>n1<n2
     endelse
   print,'this is the final image with resolution',n1,n2
   endif

; while correcting brightness in rectangles 'B', one can spoil the edges of the images
; (so cr2 can include objects from the edges)
; now restore the edges again  ; it was jmae=ima; below we change the center

wjmae(ix0:nx-ix1,iy0:ny-iy1) = $
	jma3(ix0:nx-ix1,iy0:ny-iy1)   ;  we insert the new central part to the old image 
cr4=wjma ne wjmae   ; these pixels changed their brightness; the edges were not considered
;  wjma was before imgclean

fits_write,fileout,wjmae,header          ;;; fileout is the corrected image
print,'Everything is OK. Do not pay attention if you will get an error message'
return
;for tests:                                                               test
;fits_write,'cr3.fit',cr3,header          ;; cr3 
;; 0.01 and 0.002 in cr3 show all corrected pixels, exclusive 'warm' pixels
;; =0.01 - For chosed  rectangles A, brightness of clusters detected as CRs  was replaced by background
;; =0.002 - For chosed  rectangles, brighness of ALL pixels with the previous brightness differed 
;; by a factor of 1.3 from background was replaced by background
;;; cr - CRs detected by imgclean
;;; all cr2 inside rectangles A and B are considered to be equal to 0
;;;;;;;;;;;;; fits_write                            ;;;;;;;;;;;;  test  test    test
;fits_write,'cr2.fit',cr2,header   ;;; here CRs may include the edges, if rectangles B include them
;                                     or we consider all region outside C rectangle
;fits_write,'jma2.fit',jma2,header          ;;; 
;fits_write,'jma3.fit',jma3,header ;;;   jma3 is the final obtained file, but the edges may be corrupted
;fits_write, 'cr4.fit',cr4,header  ;  here CRs are for the region exclusive the edges
;mode=sxpar(header,'imgmode')
;qrmcr,cr4,outmy,header=header,mode=mode,limf=0.5 ; for statistics of CRs  ; was cr2
;;;;;;;;;;;;;;;;;                                  ;;;;;;;;;;;;;;;;;  test  test   test
return
end

