;This code will plot a parabola as in worksheet 3
;Alex Hackett
;29/09/17

x=findgen(200) ;;Create x values
y=x^2 ;;Create y values corresponding to a parabola

;;Plotting
graph = plot(x,y,name='y', title='My First Plot', xtitle='x',ytitle='f(x)')
graph.xrange=[0,30]
graph.yrange=[0,900]
graph.symbol='o'
graph.sym_color='red'
z=900./225.*x^2-30.*900./225.*x+900. ;;Another Parabola
;;OVERPLOTTING
graphz=plot(x,z,name='z',linestyle='dash',color='blue',/overplot)


;;Add the legend
leg = legend(target=[graph,graphz],shadow=0)


end