;1st method

FUNCTION TEST,cost,play,plays

g=dblarr(n_elements(cost[*,0,0]) *n_elements(cost[0,*,0])+1) 
sum=dblarr(n_elements(cost[*,0,0]) *n_elements(cost[0,*,0])) 
l=0
for i=0, n_elements(cost[*,0,0]) -1 do for j=0, n_elements(cost[0,*,0]) -1  do $
 if j GT i then begin
  sum[l]=TOTAL(plays[i,j,*])
  g[i]=sum[l]-play[i,j]
  l=l+1    
 endif
  

;OK THIS FUNCTION WORKS!
partialsum=0
for i=0, n_elements(cost[*,0,0]) -1 do for j=0, n_elements(cost[0,*,0]) -1  do if j GT i then for k=0,n_elements(cost[0,0,*]) -1 do begin 
  d=partialsum
  partialsum=cost[i,j,k]*plays[i,j,k]
  partialsum=partialsum+d
endfor 
g[n_elements(cost[*,0,0]) *n_elements(cost[0,*,0])]=partialsum
return,g
END

;nTeams=3
;Teams=indgen(nTeams)
;nWeeks=6
;Weeks=indgen(nWeeks)
;Play=[[indgen(nTeams)],[indgen(nTeams)]]; = ... // Array of games to play 
;Cost=[[indgen(nTeams)],[indgen(nTeams)],indgen(nWeeks)]; = ... //Array of costs 
;plays=[[indgen(nTeams)],[indgen(nTeams)],indgen(nWeeks)] ;assumes binary values 0 or 1

cost=replicate(2,3,3,3)
Play=[[indgen(3)],[indgen(3)]]
plays=replicate(0,3,3,5)

;Maximize
;  sum (i in Teams, j in Teams: j>i, k in Weeks)
;      Cost[i,j,k]*plays[i,j,k] ;THIS IS OK in function g[1]

;Subject to {
;      forall (i, j in Teams: j>i)  
;            sum(k in Weeks) plays[i,j,k] = Play[i,j];
;      forall (k in weeks, i in Teams)
;                sum(j in Teams: j < i) plays[j,i,k]+
;                     sum(j in Teams: j>i) 
;                         plays[i,j,k] = 1;
;};

;test
;minimize
;4∗x0 − 2∗x1;
;subject to { x0 − x1 >= 1; x0 >= 0;
;}

playsbndmin   = plays
playsbndmax   = plays
playsbndmin[*,*,*]=1
playsbndmax[*,*,*]=1
gbnd   = [[1, 0], [1.0e30, 0]]
nobj   = 0
gcomp  = 'TEST'
title  = 'Testing'
report = '/Users/jgroh/temp/test.txt'
x=plays
CONSTRAINED_MIN, x, [playsbndmin,playsbndmax], gbnd, nobj, gcomp, inform, $
   REPORT = report, TITLE = title
;g = TEST(x)
;;; Print minimized objective function for HMBL11 problem:
;PRINT, g[nobj]
;




;FUNCTION TEST,x
;
;g=dblarr(2)
;g[0]=x[0]-x[1]
;;g[1]=x[1]
;g[1]=4*x[0]-2*x[1]
;return,g
;END
;;test
;;minimize
;;4∗x0 − 2∗x1;
;;subject to { x0 − x1 >= 1; x0 >= 0;
;;}
;
;xbnd   = [[0, -1.0e30], [1.0e30, 1.0e30]]
;gbnd   = [[1, 0], [1.0e30, 0]]
;nobj   = 1
;gcomp  = 'TEST'
;title  = 'Testing'
;report = '/Users/jgroh/temp/test.txt'
;x=[0,0]
;CONSTRAINED_MIN, x, xbnd, gbnd, nobj, gcomp, inform, $
;   REPORT = report, TITLE = title
;g = TEST(x)
;;; Print minimized objective function for HMBL11 problem:
;PRINT, g[nobj]





;2nd method
;nTeams=8
;Teams=intarr(nTeams)+1
;nWeeks=7
;Weeks=intarr(nWeeks)+1
;Play=intarr(nTeams,nTeams); = ... // Array of games to play 
;Cost=intarr(nTeams,nTeams,nWeeks); = ... //Array of costs 
;plays=intarr(nTeams,nWeeks)
;
;;Maximize
;;sum (i in Teams, k in Weeks)
;;    Cost[i,plays[i,k]] 
;;
;;Subject to {
;;   forall (i in Teams, k in Weeks) 
;;      { plays[i,k] <> i;
;;        plays[plays[i,k],k] = i;
;;forall (i in Teams) {
;;alldifferent((all k in Weeks) plays[i,k]; };
;;};
;



END