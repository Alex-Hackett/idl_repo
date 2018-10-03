PRO ZE_FIND_OPTIMAL_XYPLOT_RANGE,x,y,position,xrange,yrange,ofssetx=offsetx,offsety=offsety

xmin=min(x)
xmax=max(x)
ymin=min(y)
ymax=max(y)
window,31
plot,x,y,xrange=[xmin,xmax],yrange=[ymin,ymax],position=position,/nodata
wdelete,31

COORD_CONV,xmin,ymin,xminout,yminout
COORD_CONV,xmax,ymax,xmaxout,ymaxout

IF N_elements(offsetx) NE 1 THEN offsetx=0.05
IF N_elements(offsety) NE 1 THEN offsety=0.1

COORD_CONV,xminout[1]-offsetx,yminout[1]-offsety,xrangemin,yrangemin,/NORMAL
COORD_CONV,xmaxout[1]+offsetx,ymaxout[1]+offsety,xrangemax,yrangemax,/NORMAL

xrange=[xrangemin[0],xrangemax[0]]
yrange=[yrangemin[0],yrangemax[0]]

END