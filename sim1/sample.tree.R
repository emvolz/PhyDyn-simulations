# make a tree from simulation output of sir.py
# sampling is heterochronous at constant intervals
# usage : Rscript sample.tree.R [sim id number] [sample size] [earliest sample time]
# example : Rscript sample.tree.R 18772 150 85
cargs <- commandArgs(trailingOnly=TRUE )
n <- as.numeric( cargs[2] )
pid <- cargs[1] # actually the path to all data files including prefix for data files
st0 <- as.numeric( cargs[3] )

# constants
SEQLENGTH = 5e2
MEANRATE  = 2e-3

source('epiHistory2tree0.R')

# data files with names like: 
#~ sir.out/18772-transm.csv 18772-rem.csv


transmission_table <- read.csv(paste0(pid, '-transm.csv'), header=F) 
colnames(transmission_table ) <-  c('donor', 'recip', 't')
for (x in colnames(transmission_table)) transmission_table[[x]] <- as.vector( transmission_table[[x]] )
transmission_table$donor <- as.character( transmission_table$donor )
transmission_table$recip <- as.character( transmission_table$recip )

removal_table <- read.csv(  paste0(pid ,'-rem.csv'), header=F) 
colnames(removal_table ) <-  c('pids', 'tremoval', 'tiplab')
for (x in colnames(removal_table)) removal_table[[x]] <- as.vector( removal_table[[x]] )
removal_table$pids <- as.character( removal_table$pids ) 

tre <- epi2tree( transmission_table, removal_table )

# sample randomly from tips in last x years
tfin <- max( removal_table$tremoval )
X <- removal_table[ removal_table$tremoval > st0 , ]
tokeep <- sample(X$tiplab, size = n, replace=F)

tre2 <- drop.tip( tre, setdiff( tre$tip.label, tokeep))

write.tree( tre2, file = paste0( pid, '.nwk') ) 

