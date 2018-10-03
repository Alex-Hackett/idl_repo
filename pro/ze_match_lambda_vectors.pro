PRO ZE_MATCH_LAMBDA_VECTORS,lambda1,lambda2,sub1,sub2,count

lambda2i=cspline(lambda2,lambda2,lambda1)
match, lambda1, lambda2i, sub1, sub2, COUNT=count
 
END