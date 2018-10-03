data = [0.8829,$
    	0.9832,$
	0.9822,$
	0.9812,$
	0.9985,$
	0.0183,$
	0.0188,$
	0.0490,$
	0.0702,$
	0.0722,$
	0.5406,$
	0.6291,$
	0.6296,$
	0.6306,$
	0.7893,$
	0.7898,$
	0.9055,$
	0.7527,$
	0.7547,$
	0.8298,$
	0.8827,$
	0.0211,$
	0.0221,$
	0.0829,$
	0.0023,$
	0.0019,$
	0.0043,$
	0.0048,$
	0.9940,$
	0.9964,$
	0.9974,$
	0.9984,$
;	0.9994,$
	0.9999,$
	0.9762,$
	0.9767,$
	0.9777,$
	0.9826,$
	0.9475,$
	0.1512,$
	0.1205,$
	0.3746,$
	0.3133,$
	0.3825,$
	0.5304,$
	0.4888,$
	0.0229,$
	0.0011,$
	0.0006,$
;	0.9976,$
	0.9281,$
	0.0176,$
	0.1016,$
	0.0897,$
	0.0734,$
	0.0709,$
	0.2455,$
	0.2791]

vel = [ -800,$
    	-1170,$
	-1259,$
	-1108,$
	-1605,$
	-860,$
	-929,$
	-778,$
	-785,$
	-780,$
	-671,$
	-683,$
	-700,$
	-688,$
	-759,$
	-751,$
	-784,$
	-770,$
	-762,$
	-728,$
	-777,$
	-1154,$
	-1170,$
	-772,$
	-1290,$
	-1505,$
	-1481,$
	-1150,$
	-1451,$
	-1365,$
	-1490,$
	-1347,$
;	-1332,$
	-1681,$
	-1159,$
	-1141,$
	-1189,$
	-1132,$
	-831,$
	-759,$
	-718,$
	-658,$
	-696,$
	-694,$
	-670,$
	-678,$
	-896,$
	-1159,$
	-1380,$
;	-1093,$
	-809,$
	-1188,$
	-756,$
	-777,$
	-818,$
	-784,$
	-657,$
	-628]
	
	;compute error
error=vel
error(WHERE(vel ge -900))=50
error(WHERE(vel lt -900))=200

set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]
!X.OMARGIN=[10,3]
!Y.OMARGIN=[3,-3]
!Y.MARGIN=[5,8]
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.5
!Y.charsize=2.1
!X.charsize=2.1
!P.THICK=13
!X.THiCK=20
!Y.THICK=20
!P.CHARTHICK=12
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

width=20
xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y

ticklen = 39.
!x.ticklen = ticklen/(0.85*ysize)
!y.ticklen = ticklen/(2*xsize)
device,filename='/Users/jgroh/temp/10830_phaxvel.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches

;    plot, data, vel, charsize=1.5,$
;    	xrange=[-0.05,1.05], xstyle=1,$
;    	xtitle=TEXTOIDL('phase of the spectroscopic cycle'),$
;	ytitle=TEXTOIDL('v_{edge} (km/s)'),YTICKINTERVAL=500.,$
;    	psym=symcat(16)

    plot, data, vel, charsize=1.5,$
    	xrange=[.5,1.5], xstyle=9,$
  xtitle=TEXTOIDL('phase of the spectroscopic cycle'),$
	ytitle=TEXTOIDL('v_{edge} (km/s)'),YTICKINTERVAL=500.,$
    	psym=symcat(16),symsize=1.3
    oplot, data+1, vel, psym=symcat(16),symsize=1.3
;    oploterror,[0.6,0.6],[-1100,-1600],[0,0],[50,200],psym=symcat(16),symsize=0.2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=6
    plots,[0.5,1.5],[-900,-900],linestyle=2,color=fsc_color('red')
    plots,[0.976,0.976],[-500,-2000],linestyle=2,color=fsc_color('blue')
    plots,[1.023,1.023],[-500,-2000],linestyle=2,color=fsc_color('blue')
    AXIS,XAXIS=1,XSTYLE=1,COLOR=fsc_color('black'),XRANGE=[-1011.35,+1011.35],XTICKFORMAT='(I5)',charsize=1.5,xtitle='Days before phase zero'
    
    plot, data, vel, charsize=1.5,$
    	xrange=[.90,1.10], xstyle=9,$
  xtitle=TEXTOIDL('phase of the spectroscopic cycle'),$
	ytitle=TEXTOIDL('v_{edge} (km/s)'),YTICKINTERVAL=500.,$
    	psym=symcat(16)
    oplot, data+1, vel, psym=symcat(16)
     oploterror,data,vel,error,psym=symcat(16),symsize=0.2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=6
     oploterror,data+1,vel,error,psym=symcat(16),symsize=0.2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=6
;    oploterror,[0.92,0.92],[-1100,-1600],[0,0],[50,200],psym=symcat(16),color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=6
    plots,[0.9,1.1],[-900,-900],linestyle=2,color=fsc_color('red')
    plots,[0.976,0.976],[-500,-2000],linestyle=2,color=fsc_color('blue')
    plots,[1.023,1.023],[-500,-2000],linestyle=2,color=fsc_color('blue')
    AXIS,XAXIS=1,XSTYLE=1,COLOR=fsc_color('black'),XRANGE=[-202.270,+202.270],XTICKFORMAT='(I5)',charsize=1.5,xtitle='Days before phase zero'
device, /close
set_plot, 'x'
!p.font=-1

end
