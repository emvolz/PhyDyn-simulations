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
  
  newXmlPath <- paste0('xmls/', gsub( '.log',  replace='.xml', logfn ) )
  writeLines(newLines,con=newXmlPath)
  #insert_tree
}


cargs <- commandArgs(trailingOnly=TRUE)
indir <- cargs[1]
simpid <- cargs[2] 
treefn <- paste0(indir, '/', simpid, '.nwk')
templatefn <- cargs[3] 
logfn <- cargs[4]

tree2xml( treefn, templatefn , logfn, mostrecentsample = 250)
