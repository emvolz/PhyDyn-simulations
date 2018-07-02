require(ape)

getTaxaXML <- function(treeFile) {
  tree <- read.tree(treeFile)
  taxa <- tree$tip.label
  endStr <- "totalcount=\"4\" value=\"??\"/>\n"
  seqs <- ""
  for(taxon in taxa) {
    seqs <- paste(seqs,"<sequence id=\"",taxon,"\"  ",sep="")
    seqs <- paste(seqs,"taxon=\"",taxon,"\" ",sep="")
    seqs <- paste(seqs,endStr,sep=" ")
  }
  seqs <- paste(seqs,"\n")
  # write.tree(tree)
  return(list(seqs,write.tree(tree)))
}

getDatesXML <- function(treeFile, mostrecentsample = 250){
  tree <- read.tree(treeFile)
  taxa <- tree$tip.label
  n <- length(taxa)
  rtt <- unname( node.depth.edgelength( tree )[1:n] )
  sts <- rtt - max(rtt) + mostrecentsample
  sts_strs <- paste( taxa, sts, sep='=')
  paste(collapse=',\n', sts_strs )
}

tree2xml <- function(treeFile,xmlFile,logfn, mostrecentsample = 250) {
  treePath <- paste(treeFile,sep='')
  strs <- getTaxaXML(treePath)
  xmlPath <- paste(xmlFile,sep='')
  pid <- strsplit(treeFile,'.',fixed=TRUE)[[1]][1]
  xmlName <-  strsplit(xmlFile,'.',fixed=TRUE)[[1]][1]
  
  lines <- readLines(xmlPath)
  #for(l in lines) print(l)
  # insert_sequences
  newLines <- gsub(pattern = "insert_sequences", replace = strs[[1]], x = lines)
  newLines <- gsub(pattern = "insert_tree", replace = strs[[2]], x = newLines)
  newLines <- gsub(pattern = "insert_logfn", replace = logfn, x = newLines)
  newLines <- gsub(pattern = "insert_dates", replace =  getDatesXML(treeFile, mostrecentsample=mostrecentsample)
   , x = newLines)
  
  newXmlPath <-paste0( odir,  gsub( '.log',  replace='.xml', logfn ) )
  writeLines(newLines,con=newXmlPath)
  #insert_tree
}




indir <- 'sim0/' 
odir <- 'xml0/' 
nwkfns <- list.files( pattern = 'nwk', path = indir )
nwkfns <- nwkfns[!grepl( pattern = 'substitutions', nwkfns) ]
simpids <- regmatches( nwkfns , regexpr( pattern = '[0-9]+', nwkfns ) )
templatefn_pl1 <- 'beast_template_pl1.xml' 
templatefn_pl2 <- 'beast_template_pl2.xml' 
templatefn_ql <- 'beast_template_ql.xml' 
logfns_pl1 <- gsub( pattern = '\\.nwk', '_pl1.log' , nwkfns )
logfns_pl2 <- gsub( pattern = '\\.nwk', '_pl2.log' , nwkfns )
logfns_ql <- gsub( pattern = '\\.nwk', '_ql.log' , nwkfns )

for (k in 1:length(nwkfns )){
	tree2xml( paste0( indir, nwkfns[k] )
	  , templatefn_pl1
	  , logfns_pl1[k]
	  , mostrecentsample = 101)
}

for (k in 1:length(nwkfns )){
	tree2xml( paste0( indir, nwkfns[k] )
	  , templatefn_pl2
	  , logfns_pl2[k]
	  , mostrecentsample = 101)
}

for (k in 1:length(nwkfns )){
	tree2xml( paste0( indir, nwkfns[k] )
	  , templatefn_ql
	  , logfns_ql[k]
	  , mostrecentsample = 101)
}
