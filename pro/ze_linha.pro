input='/home/groh/plots_grace/rden1.txt'  ;define arquivo input
openu,1,input     ; abre arquivo sem modificar

linha=''
i=0
x=dblarr(1000)
y=dblarr(1000)

while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip
endif
i=i+1
skip:
endwhile

close,1

openu,1,input
for j=0,i-1 do begin
readf,1,xi,yi
x[j]=xi
y[j]=yi
endfor

close,1

x=x(where(x ne 0))
y=y(where(y ne 0))

plot,alog10(x),alog10(y),/nodata
plots,alog10(x),alog10(y),psym=1,symsize=1.5
;t=dindgen(max(x)-min(x))+min(x)
t=1.1*x
result=cspline(x,y,t)
oplot,alog10(t),alog10(result),psym=2
end
