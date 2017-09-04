
## OUTPUT 
'[1] "sir_5_5_2000_250_beast1"
[1] "beta"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1777  0.2348  0.2549  0.2632  0.2819  0.4706 
RMSE 
[1] 0.04173989


[1] "wacute"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.3241  3.3210  4.4200  4.6840  5.8050 13.4300 
RMSE 
[1] 1.867688


[1] "wrisk2"
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
 0.05169  2.86600  4.38800  5.71600  7.04900 48.97000 
RMSE 
[1] 4.800657
'


'
[1] "sir_5_5_2000_250_beast0" solvepl=false
[1] "beta"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1610  0.2269  0.2468  0.2540  0.2716  0.5370 
RMSE 
[1] 0.03855796


[1] "wacute"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  1.281   3.538   4.308   4.447   5.213  10.060 
RMSE 
[1] 1.347229


[1] "wrisk2"
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
 0.000742  2.347000  3.309000  3.629000  4.545000 23.010000 
RMSE 
[1] 2.402002
'

require(Hmisc) 
require(coda)

indir <- 'sir_5_5_2000_250_beast0'
#~ indir <- 'sir_5_5_2000_250_beast1'

logfns <- list.files( path = indir, full.name=TRUE, pattern = '.log$')

truth <-  c(beta = .25
 , wacute = 5
 ,wrisk2   = 5
)

#~ X <- read.table( logfns[1] , header=TRUE)
Xs <- lapply( logfns, function(x)  read.table( x , header=TRUE) )
pnames <- names(truth) 

xsum <- setNames( lapply( names(truth), function(pname)
	{
		xs <- t( sapply( Xs, function(X) quantile(X[[pname]], prob = c(.5, .025, .975 ) )))
		xs <- xs[ order(xs[,1]), ]
		xs
	}
 ), pnames)


#~ X11()
svg(paste0( indir, '_errbar.svg'))
par( mfrow = c( 3, 1 )
 , mai = c( .1, .75, .2, .1) )
for (pname in pnames){
	errbar( 1:nrow( xsum[[pname]] ), xsum[[pname ]][,1] , yplus = xsum[[pname ]][,3], yminus=xsum[[pname ]][,2]  , xlab='', ylab = pname )
	abline( h = truth[pname] , col = 'red')
}
dev.off()

## print summary
print( indir)
for (pname in pnames ){
	print(pname)
	X <- do.call( c, lapply( Xs, '[[', pname ) )
	print(summary(X))
	cat('RMSE \n')
	print( sqrt( mean( (X - truth[pname])^2 )))
	cat( '\n\n')
}


