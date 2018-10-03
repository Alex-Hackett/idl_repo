PRO ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,filename,data,header
;reads data output from AmberBrowser3.0.3 from Alex Kreplin
;converts visibilities and vis error to linear
;sorts into increasing lambda
data_read=READ_ASCII(filename,DATA_start=5,header=header)
data=data_read.field01
data_sort=data

for i=1, 6, 2 do begin
  data[i,*]=(sqrt(data_read.field01[i,*])>0)
  data[i+1,*]=data_read.field01[i+1,*]/(2.*data_read.field01[i,*])
endfor

for i=0, 20 do begin
  temp=data[i,*]
  data_sort[i,*]=temp(sort(data[0,*]))
endfor 

data=data_sort

END