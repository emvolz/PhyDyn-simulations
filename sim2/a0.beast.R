require(Hmisc) 
require(coda)

LIKTYPE <- 'pl1'
#~ LIKTYPE <- 'pl2'
#~ LIKTYPE <- 'ql'

simdir <- 'sim0'
#~ indir <- 'xml0'
indir <- 'phydyn-sim0'
BURNIN <- 1e4


parmfns <- list.files( path= simdir, pattern = 'parms.csv', full.name=T)
( t( sapply( parmfns, read.csv ) ) )  -> parmtab
parmtab <- cbind( parmtab, beta =  0.25 )
fn2pid <- function(fn){
	x <- regmatches( fn, regexpr( '/[0-9]+', fn ))
	regmatches( x, regexpr( '[0-9]+', x ))
}
rownames( parmtab ) <- sapply( rownames(parmtab ) , fn2pid )


logfns <- list.files( path = indir, full.name=TRUE, pattern = paste0(LIKTYPE,'.log$') )
logfn2pid <- regmatches( logfns,  regexpr( '/[0-9]+_', logfns ) )
logfn2pid <- regmatches( logfn2pid,  regexpr( '[0-9]+', logfn2pid ) )
names(logfn2pid) <- logfns


truth <-  c(beta = .25
 , wacute = NA
 , wrisk2   = NA
)

#~ X <- read.table( logfns[1] , header=TRUE)

Xs <- lapply( logfns, function(x)  {
	X <- read.table( x , header=TRUE) 
	X <- X[ X$Sample > BURNIN, ]
	X
})
sapply( Xs, function(x) colMeans(x)) -> Z
pnames <- names(truth) 

xsum <- setNames( lapply( names(truth), function(pname)
	{
		xs <- as.data.frame( t( sapply( Xs, function(X) quantile(X[[pname]], prob = c(.5, .025, .975 ) ))) )
#~ browser()
		xs <- cbind( unlist( parmtab[ logfn2pid[logfns], pname ]) , xs )
		xs <- xs[ order(xs[,1]), ]
		xs
	}
 ), pnames)


#~ X11()
svg(paste0( indir,'_', LIKTYPE, '_errbar.svg'))
par( mfrow = c( 4, 1 )
 , mai = c( .1, .75, .2, .1) )
for (pname in pnames){
	if ( pname %in% c('wacute', 'wrisk2') )
		errbar( 1:nrow( xsum[[pname]] ), xsum[[pname ]][,2] , yplus = xsum[[pname ]][,4], yminus=xsum[[pname ]][,3]  , xlab='', ylab = pname, ylim = c(0, 12) )
	else
		errbar( 1:nrow( xsum[[pname]] ), xsum[[pname ]][,2] , yplus = xsum[[pname ]][,4], yminus=xsum[[pname ]][,3]  , xlab='', ylab = pname )
	#abline( h = truth[pname] , col = 'red')
	points( xsum[[pname]][,1] , col = 'red', pch = 2)  
}
dev.off()

## print summary
print( indir)
for (pname in pnames ){
	print(pname)
	b <- xsum[[pname]][,2] - xsum[[pname]][,1]
	print('bias')
	print(summary( b ))
	print('rmse')
	print( sqrt( mean( b^2)))
	
	cat( '\n\n')
}


#output
invisible('

QL 
[1] "beta"
[1] "bias"
      Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
-0.0284629 -0.0184495 -0.0107967 -0.0091890 -0.0001674  0.0147219 
[1] "rmse"
[1] 0.0145686


[1] "wacute"
[1] "bias"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-3.2736 -1.9044 -0.6065 -0.9267 -0.1637  0.6285 
[1] "rmse"
[1] 1.462376


[1] "wrisk2"
[1] "bias"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-2.9520 -2.3956 -1.2480 -1.3931 -0.4463  0.5468 
[1] "rmse"
[1] 1.731157


------------------------
PL1
[1] "phydyn-sim0"
[1] "beta"
[1] "bias"
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
-0.021189 -0.010704 -0.007200 -0.004485  0.002663  0.020822 
[1] "rmse"
[1] 0.01185968


[1] "wacute"
[1] "bias"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-2.3656 -1.2941 -0.3664 -0.5733  0.1265  0.8036 
[1] "rmse"
[1] 1.040982


[1] "wrisk2"
[1] "bias"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-1.9772 -1.2808 -0.5979 -0.5826 -0.2190  1.1030 
[1] "rmse"
[1] 0.9889269

--------------------------------------

PL2
[1] "phydyn-sim0"
[1] "beta"
[1] "bias"
      Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
-0.0203513 -0.0077572 -0.0012871 -0.0003193  0.0075629  0.0235738 
[1] "rmse"
[1] 0.0116398


[1] "wacute"
[1] "bias"
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
-1.37928 -0.52203 -0.02439  0.14066  0.83574  2.38030 
[1] "rmse"
[1] 0.9810228


[1] "wrisk2"
[1] "bias"
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-1.1541 -0.5021 -0.3169  0.1079  0.4334  2.6634 
[1] "rmse"
[1] 1.053993



')

