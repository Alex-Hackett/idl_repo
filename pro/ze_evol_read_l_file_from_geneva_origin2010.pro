PRO ZE_EVOL_READ_L_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_l_file
;reads xxx.l* files that are output from Geneva Stellar Evolution code, Origin2010

model=STRMID(modeldir,strpos(modeldir,'/',/REVERSE_SEARCH) +1)
lfile=modeldir+'/'+model_name+'.l'+strcompress(string(timestep, format='(I07)')) 

IF FILE_EXIST(lfile+'.gz') THEN BEGIN
    OPENR,lun,lfile+'.gz',/get_LUN,/COMPRESS 
    nlines_lfile=file_lines(lfile+'.gz',/COMPRESS)
    compress=1
    lfile=lfile+'.gz'
    print,'Reading the following l file:  ', lfile
ENDIF ELSE BEGIN 
    OPENR,lun,lfile,/get_LUN
    nlines_lfile=FILE_LINES(lfile)
    compress=0
    print,'Reading the following l file:  ', lfile
ENDELSE   

lfile_content=strarr(nlines_lfile)

READf,lun,lfile_content
CLOSE,lun

ze_hgrep,lfile_content,'integration step',ini_atmos_line_numbers,/keepcase,/linenum
header_atmos=lfile_content(ini_atmos_line_numbers[0]+1)

ze_hgrep,lfile_content,'End of the atmosphere',end_atmos_line_numbers,/keepcase,/linenum

ze_hgrep,lfile_content,'henyey-methode',end_env_line_numbers,/keepcase,/linenum

print,compress
;ZE_READCOL,lfile,uvlp,tau,vlt,beta,vlro,vlka,skipline=ini_atmos_line_numbers[0]+1,numline=end_atmos_line_numbers[0]-ini_atmos_line_numbers[0],compress=compress

a=''
c=''
i=0
counter=0
temp_array=strarr(4000) ;will be trimmed later
b=strarr(end_atmos_line_numbers[0]+1)
openR,lun,lfile,/GET_LUN,compress=compress     ; open file without writing
READf,lun,b
FOR j=0., end_env_line_numbers[1]-end_atmos_line_numbers[0]-13  do BEGIN
  READF,lun,a
;  print,'a ', a
  c=string(strcompress(a,/remove_all),FORMAT='(A2)')
  d=string(strcompress(a,/remove_all),FORMAT='(A3)')
 IF (c NE 'BE') AND (c NE '--') AND (c NE 'En') AND (c NE '  ') AND (c NE 'en') AND (c NE 'NR') AND (c NE 'IH')  AND (c NE 'UV') AND (d NE '1NR') THEN begin
;    print,'a ', a
;    print,'c ', c
;    print,'d ', d
    temp_array[counter]=a
    counter=counter+1
 ENDIF
ENDFOR 
CLOSE,lun
free_lun,lun  
;up to here OK, reading l file fine and removing unnecessary layers
;now have to parse data into arrays
data_lfile_read=temp_array[0:counter-1]
ncol=43.
data_lfile_parsed=dblarr(fix(counter/3),ncol)
line1=dblarr(15)
line2=dblarr(15)
line3=dblarr(13)
t=0
for t=0, counter -1, 3 do begin
  line1=double(strsplit(data_lfile_read[0+t],/extract))
  line2=double(strsplit(data_lfile_read[1+t],/extract))
  line3=double(strsplit(data_lfile_read[2+t],/extract))
  if n_elements(line1) eq 10 then data_lfile_parsed[t/3,0:14]=[line1,0.0,1.0,0.0,0.0,0.0] eLSE data_lfile_parsed[t/3,0:14]=line1
  if n_elements(line2) eq 11 then data_lfile_parsed[t/3,15:29]=[line2,0.0,0.0,0.0,0.0] eLSE data_lfile_parsed[t/3,15:29]=line2 
  if n_elements(line3) eq 9 then data_lfile_parsed[t/3,30:42]=[0.0,line3[0:7],0.0,0.0,0.0,line3[8]] else begin 
    if n_elements(line3) eq 8 then begin
;      print,data_lfile_read[2+t]
      line3=double(strsplit(strmid(data_lfile_read[2+t],0,59)+' '+strmid(data_lfile_read[2+t],59),/extract))
      data_lfile_parsed[t/3,30:42]=[0.0,line3[0:7],0.0,0.0,0.0,line3[8]]
    endif else begin   
;      print,data_lfile_read[2+t]
;      print, line3
      line3=double(strsplit(strmid(data_lfile_read[2+t],0,34)+' '+strmid(data_lfile_read[2+t],34,24)+' ' +strmid(data_lfile_read[2+t],58),/extract))
;      print,line3
      data_lfile_parsed[t/3,30:42]=line3
   endelse
   endelse
endfor

data_l_file=data_lfile_parsed
END
