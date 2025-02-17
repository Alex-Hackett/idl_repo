;------------------------------------------------------------
;	newsweb.pro = Newsletter generator
;	R. Sterner, 2004 Apr 12
;	R. Sterner, 2004 Apr 26 --- Allowed ktitle in *.ctr file.
;
;	Article subdirectories must have an article file, *.txt,
;	which may have html code or be plain text, and control.ctr,
;	which has 2 or 3 lines:
;	title: article title
;	author: article author
;	ktitle: optional descriptive title for kwic index
;------------------------------------------------------------
 
	pro newsweb
 
	;==========================================
	;  Move to working directory
	;==========================================
	tmp = filename('','',delim=del)		; Find delimiter character.
	dir = dialog_pickfile(/dir,title='Move to working directory')
	cd, dir
 
	;==========================================
	;  Check for needed parts
	;==========================================
 
	;------------------------------------------
	;  Find article directories
	;------------------------------------------
	dir_a = file_search('a*',count=cnt_a,/test_dir)
 
	if cnt_a eq 0 then begin
	  tprint,/init
	  tprint,' newsweb: found no article subdirectories.'
	  tprint,'   May be in wrong directory.  Must run this'
	  tprint,'   from the month subdirectory, just above the'
	  tprint,'   article subdirectories (a1, a2, ..., an).'
	  tprint,out=txt
	  xhelp,exit='Dismiss',txt
	  return
	endif
 
	;------------------------------------------
	;  Check for all the needed parts
	;------------------------------------------
	err = 0
	tprint,/init
	for i=0, cnt_a-1 do begin
	  wild_txt = filename(dir_a(i), '*.txt', /nosym)
	  f_txt = file_search(wild_txt, count=cnt_txt)
	  wild_ctr = filename(dir_a(i), '*.ctr', /nosym)
	  f_ctr = file_search(wild_ctr, count=cnt_ctr)
	  if cnt_txt ne 1 then begin
	    tprint,' Error in newsweb: Must have one *.txt file in'
	    tprint,'   article subdirectories.  None in '+dir_a(i)
	    err = 1
	  endif
	  if cnt_ctr ne 1 then begin
	    tprint,' Error in newsweb: Must have one *.ctr in'
	    tprint,'   article subdirectories.  None in '+dir_a(i)
	    err = 1
	  endif
	endfor
 
	;------------------------------------------
	;  Check for needed frontend parts
	;------------------------------------------
	file = 'issue.txt'
	f = file_search(file, count=cnt_iss)
	if cnt_iss eq 0 then begin
	  tprint,' Error in newsweb: Must have at the month level a file'
	  tprint,'   named issue.txt with the volume, number, and date.'
	  tprint,'   Ex: "Volume 1, Number 1.   2004 Apr"'
	  err = 1
	endif else begin
	  iss_txt = getfile(file)
	endelse
	file = '../../front.html'
	f = file_search(file, count=cnt_f)
	if cnt_f eq 0 then begin
	  tprint,' Error in newsweb: Must have at the root level a file'
	  tprint,'   named front.html with the newsletter front end written'
	  tprint,'   in html.'
	  err = 1
	endif else begin
	  front_html = getfile(file)
	endelse
 
	;------------------------------------------
	;  Bail out if errors
	;------------------------------------------
	if err ne 0 then begin
	  tprint,' '
	  tprint,' newsweb aborting.  Correct listed errors and run again.'
	  tprint,out=txt
	  xhelp,exit='Dismiss',txt
	  return
	endif
 
	;==========================================
	;  Generate newsletter
	;==========================================
 
	;------------------------------------------
	;  Start web page: newsletter title,
	;    Volume, Number, Date.
	;------------------------------------------
	cd,curr=dir
	out = repchr(getwrd(dir,del=del,/last,-2,0),del,'_')
	openw, lun, out+'.html', /get_lun
	printf,lun,'<html>'
	printf,lun,'<head>'
	printf,lun,'<title>'
	printf,lun,iss_txt
	printf,lun,'</title>'
	printf,lun,'</head>'
	printf,lun,'<body bgcolor="white">'
	printf,lun,'<blockquote>'
	printf,lun,front_html
	printf,lun,'<br>'+iss_txt
	printf,lun,'<p>'
 
	;------------------------------------------
	;  Collect control file info
	;------------------------------------------
	titl  = strarr(cnt_a)
	ktitl = strarr(cnt_a)
	auth  = strarr(cnt_a)
	for i=0, cnt_a-1 do begin
	  ;-----  read in control file  ---------
	  wild_ctr = filename(dir_a(i), '*.ctr', /nosym)   ; Control files.
	  f_ctr = file_search(wild_ctr, count=cnt_ctr)
	  ctxt = getfile(f_ctr(0),/quiet,err=err)
	  ;-----  Move contents to arrays  ------
	  if err eq 0 then begin
	    ttl = txtgetkey(init=ctxt,'title', del=':')
	    titl(i) = ttl
	    kttl = txtgetkey(init=ctxt,'ktitle', del=':')
	    if kttl eq '' then kttl=ttl
	    ktitl(i) = kttl
	    auth(i) = txtgetkey('author', del=':')
	  endif else begin
            titl(i) = ''
            auth(i) = ''
          endelse
	endfor
 
	;------------------------------------------
	;  In this issue
	;------------------------------------------
	tag = 'a'+string(indgen(cnt_a),form='(I2.2)')
	printf,lun,'<p><table cellpadding=10 border=3><tr><td>'
	printf,lun,'<b>In This Issue:</b><br>'
	printf,lun,'<font size=-1>'
	for i=0, cnt_a-1 do begin
	  if titl(i) ne '' then $
	  	printf,lun,'<a href="#'+tag(i)+'">'+titl(i)+'</a><br>'
	endfor
	printf,lun,'</td></tr></table><p>'
 
	;------------------------------------------
	;  Articles
	;------------------------------------------
	for i=0, cnt_a-1 do begin
 
	  wild_txt = filename(dir_a(i), '*.txt', /nosym)   ; Text files?
	  f_txt = file_search(wild_txt, count=cnt_txt)
 
	  ;-----  Deal with text file  --------
	  txt = getfile(f_txt(0))
	  w = where(txt eq '', cnt)
	  if cnt gt 0 then txt(w)='<p>'
	  printf,lun,'<a name="'+tag(i)+'">'
	  printf,lun,'<font size=+2><b>'
	  printf,lun,titl(i)
	  printf,lun,'</b></font>'
	  if auth(i) ne '' then printf,lun,'<br>by '+auth(i)
	  printf,lun,'<p>'
	  for j=0,n_elements(txt)-1 do printf,lun,txt(j)
	  printf,lun,'<p><hr><p>'
 
	  ;-----  Deal with any images  --------
	  wild_img = filename(dir_a(i), '*.gif', /nosym)   ; GIF.
	  fg = file_search(wild_img, count=cnt_g)
	  wild_img = filename(dir_a(i), '*.png', /nosym)   ; PNG.
	  fp = file_search(wild_img, count=cnt_p)
	  wild_img = filename(dir_a(i), '*.jpg', /nosym)   ; JPG.
	  fj = file_search(wild_img, count=cnt_j)
	  if (cnt_g>cnt_p>cnt_j) gt 0 then begin  ; Any images found?
	    f = [fg,fp,fj]			  ; Combine lists.
	    f = drop_comments(f)		  ; Drop any null entries.
	    for j=0,n_elements(f)-1 do begin	  ; Loop through images.
	      filebreak,f(j),nvfile=f2		  ; Get file name.
;	      file_copy, f(j), f2, /overwrite	  ; Copy into current dir.
	      futil, /copy, f(j), to=f2		  ; Copy into current dir.
	    endfor
	  endif
 
	endfor
 
	;------------------------------------------
	;  Terminate web page.
	;------------------------------------------
	printf,lun,' '
	printf,lun,'</blockquote>'
	printf,lun,'</body>'
	printf,lun,'</html>'
	free_lun, lun
 
	tprint,/init
	tprint,' Web page complete: '+out+'.html'
	tprint,' '
 
 
	;------------------------------------------
	;  Make links file
	;------------------------------------------
	links_out = out+'.links'
	putfile,links_out,out+'#'+tag+'  '+titl
	tprint,' '
	tprint,' Links file complete: '+links_out
	tprint,' '
	tprint,out=txt
	xhelp,exit='Dismiss',txt
 
	end
