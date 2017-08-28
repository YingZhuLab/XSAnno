##################################################################################################################################
## chimp ##
###########
## Exons
setwd("/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/simFilter/simExp")
# count
exonCount.liftOver <- round(read.table("./liftOver/compExonCount.liftOver.txt", as.is=T, header=T, row.names=1)/101)

# RPKM
exonRPKM.liftOver <- read.table("./liftOver/compExonRPKM.liftOver.txt", as.is=T, header=T, row.names=1)

##############################################################################################

calcDEX <- function(count, cond, minCount=10, sizeFactor=NULL) {
	library(DESeq)
	countTable <- count[apply(count, 1, max) > minCount,]
	cds <- newCountDataSet(countTable, condition=cond)
	if (is.null(sizeFactor)) {
		cds <- estimateSizeFactors( cds )
	} else { sizeFactors( cds ) <- sizeFactor }
	cds <- estimateDispersions( cds, method="pooled", fitType = "local")
	nbinomTest( cds, cond[1], cond[length(cond)] )
}

setwd("/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/simFilter/simExp/liftOver/DEX")

## filter BLAT-filtered exons with simReads
blatFiltered <- read.table("/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/blatFilter/blatFiltered.hg19TopanTro2.txt", as.is=T, header=T)
exonCount.blat <- exonCount.liftOver[blatFiltered[,1],]

# keep the same exon from different transcripts unique
exonIDMat.blat <- do.call(rbind, strsplit(rownames(exonCount.blat), split="\\|"))
exonLoc.blat <- paste(exonIDMat.blat[,3], exonIDMat.blat[,5], exonIDMat.blat[,6], sep="|")
uniqLoc.exonCount.blat <- exonCount.blat[!duplicated(exonLoc.blat),]
rownames(uniqLoc.exonCount.blat) <- exonLoc.blat[!duplicated(exonLoc.blat)]

exonRes.blat <- calcDEX(exonCount.blat, cond, 10)
write.table(exonRes.blat, "simDESeq_blat.exon.txt", row.names=F, col.names=T, sep="\t", quote=F)

# simFilter from blat
inExons.blat <- rownames(exonCount.blat)[!(rownames(exonCount.blat) %in% exonRes.blat[exonRes.blat$padj <0.01,1])]
simFilteredExon <- blatFiltered[match(inExons.blat, blatFiltered[,1]),]
write.table(simFilteredExon, "simFiltered.hg19TopanTro2.txt", row.names=F, col.names=T, sep="\t", quote=F)
write.table(cbind(simFilteredExon[,c(2,4,5,1)], rep(1,nrow(simFilteredExon)), simFilteredExon[,3]), "simFiltered.hg19TopanTro2.hg19.bed", col.names=F, row.names=F, sep="\t", quote=F)
write.table(cbind(simFilteredExon[,c(6,8,9,1)], rep(1,nrow(simFilteredExon)), simFilteredExon[,7]), "simFiltered.hg19TopanTro2.panTro2.bed", col.names=F, row.names=F, sep="\t", quote=F)






