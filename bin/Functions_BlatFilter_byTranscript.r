chooseThreshold.inter <- function(blat.Sp1ToSp2, blat.Sp2ToSp1, IDs, PLs) {
	orig.sp1.0 <- do.call(rbind, strsplit(blat.Sp1ToSp2[,1], split="\\|"))
	orig.sp2.0 <- do.call(rbind, strsplit(blat.Sp2ToSp1[,1], split="\\|"))
	
	orig.sp1 <- cbind(apply(orig.sp1.0[,1:8], 1, paste, collapse="|"), orig.sp1.0[,9:ncol(orig.sp1.0)])
	orig.sp2 <- cbind(apply(orig.sp2.0[,1:8], 1, paste, collapse="|"), orig.sp2.0[,9:ncol(orig.sp1.0)])
	
	blat.Sp1ToSp2[,1] <- orig.sp1[,1]
	blat.Sp2ToSp1[,1] <- orig.sp2[,1]
	########################
	## filter interSpecies
	# remove low ID low PL and duplicate regions
	exonNums <- sapply(PLs, function(interPL) {
		sapply(IDs, function(interID) {
			sp1_2 <- blat.Sp1ToSp2[blat.Sp1ToSp2$percentID >= interID & blat.Sp1ToSp2$percentLength >= interPL,]
			sp2_1 <- blat.Sp2ToSp1[blat.Sp2ToSp1$percentID >= interID & blat.Sp2ToSp1$percentLength >= interPL,]
			dupGenes <- union(sp1_2[duplicated(sp1_2[,1]),1], sp2_1[duplicated(sp2_1[,1]),1])
			sharedGenes <- intersect(sp1_2[,1], sp2_1[,1])
			uniqGenes <- sharedGenes[!(sharedGenes %in% dupGenes)]
	
			# the blat region is the same as the liftOver region
			inter.blat0 <- cbind(sp2_1[match(uniqGenes, sp2_1[,1]),1:4], sp1_2[match(uniqGenes, sp1_2[,1]),2:4])
			inter.orig0 <- cbind(orig.sp1[match(uniqGenes, orig.sp1[,1]),], orig.sp2[match(uniqGenes, orig.sp2[,1]),-1])
	
			sum(inter.blat0[,3] == inter.orig0[,4] & inter.blat0[,4] == inter.orig0[,5] & inter.blat0[,6] == inter.orig0[,8] & inter.blat0[,7] == inter.orig0[,9])
		})
	})
	
	matplot(IDs, exonNums, type="n", main="Eene number vs interspecies ID and PL")
	text(IDs, exonNums, rep(IDs,ncol(exonNums)), col=rep(1:length(PLs), each=length(IDs)), cex=.8)
	legend("bottomleft", legend=paste("PL =", PLs), col=1:length(PLs), lty=1, cex=.8)
	
	colnames(exonNums) <- PLs
	rownames(exonNums) <- IDs
	exonNums
}

chooseThreshold.intra <- function(blat.Sp1ToSp1, blat.Sp2ToSp2, IDs, PLs) {
	orig.sp1.0 <- do.call(rbind, strsplit(blat.Sp1ToSp1[,1], split="\\|"))
	orig.sp2.0 <- do.call(rbind, strsplit(blat.Sp2ToSp2[,1], split="\\|"))
	
	orig.sp1 <- cbind(apply(orig.sp1.0[,1:8], 1, paste, collapse="|"), orig.sp1.0[,9:ncol(orig.sp1.0)])
	orig.sp2 <- cbind(apply(orig.sp2.0[,1:8], 1, paste, collapse="|"), orig.sp2.0[,9:ncol(orig.sp1.0)])
	
	blat.Sp1ToSp1[,1] <- orig.sp1[,1]
	blat.Sp2ToSp2[,1] <- orig.sp2[,1]
	########################
	## filter intraSpecies
	# remove low ID low PL and duplicate regions
	exonNums <- sapply(PLs, function(PL) {
		sapply(IDs, function(ID) {
			sp1_1 <- blat.Sp1ToSp1[blat.Sp1ToSp1$percentID >= ID & blat.Sp1ToSp1$percentLength >= PL,]
			sp2_2 <- blat.Sp2ToSp2[blat.Sp2ToSp2$percentID >= ID & blat.Sp2ToSp2$percentLength >= PL,]
			dupGenes <- union(sp1_1[duplicated(sp1_1[,1]),1], sp2_2[duplicated(sp2_2[,1]),1])
			sharedGenes <- intersect(sp1_1[,1], sp2_2[,1])
			uniqGenes <- sharedGenes[!(sharedGenes %in% dupGenes)]
	
			# the blat region is the same as the liftOver region
			inter.blat0 <- cbind(sp1_1[match(uniqGenes, sp1_1[,1]),1:4], sp2_2[match(uniqGenes, sp2_2[,1]),2:4])
			inter.orig0 <- cbind(orig.sp1[match(uniqGenes, orig.sp1[,1]),], orig.sp2[match(uniqGenes, orig.sp2[,1]),-1])
	
			sum(inter.blat0[,3] == inter.orig0[,4] & inter.blat0[,4] == inter.orig0[,5] & inter.blat0[,6] == inter.orig0[,8] & inter.blat0[,7] == inter.orig0[,9])
		})
	})
	
	matplot(IDs, exonNums, type="n", main="Eene number vs intraspecies ID and PL")
	text(IDs, exonNums, rep(IDs,ncol(exonNums)), col=rep(1:length(PLs), each=length(IDs)), cex=.8)
	legend("bottomleft", legend=paste("PL =", PLs), col=1:length(PLs), lty=1, cex=.8)
	
	colnames(exonNums) <- PLs
	rownames(exonNums) <- IDs
	exonNums
}



# filter the BLAT'ed exons and remove paralogs
blatFilter <- function(blat.Sp1ToSp1, blat.Sp1ToSp2, blat.Sp2ToSp1, blat.Sp2ToSp2, interID, interPL, intraID, intraPL, sp1Name, sp2Name) {
	# original coordination
	orig.sp1.0 <- do.call(rbind, strsplit(unique(c(blat.Sp1ToSp1[,1],blat.Sp1ToSp2[,1])), split="\\|"))
	orig.sp2.0 <- do.call(rbind, strsplit(unique(c(blat.Sp2ToSp1[,1], blat.Sp2ToSp2[,1])), split="\\|"))
	
	orig.sp1 <- cbind(apply(orig.sp1.0[,1:8], 1, paste, collapse="|"), orig.sp1.0[,9:ncol(orig.sp1.0)])
	orig.sp2 <- cbind(apply(orig.sp2.0[,1:8], 1, paste, collapse="|"), orig.sp2.0[,9:ncol(orig.sp1.0)])
	
	########################
	## filter interSpecies
	# remove low ID low PL and duplicate regions
	sp1_2 <- blat.Sp1ToSp2[blat.Sp1ToSp2$percentID >= interID & blat.Sp1ToSp2$percentLength >= interPL,]
	sp1_2[,1] <- apply(do.call(rbind, strsplit(sp1_2[,1], split="\\|"))[,1:8], 1, paste, collapse="|")
	sp2_1 <- blat.Sp2ToSp1[blat.Sp2ToSp1$percentID >= interID & blat.Sp2ToSp1$percentLength >= interPL,]
	sp2_1[,1] <- apply(do.call(rbind, strsplit(sp2_1[,1], split="\\|"))[,1:8], 1, paste, collapse="|")
	dupGenes <- union(sp1_2[duplicated(sp1_2[,1]),1], sp2_1[duplicated(sp2_1[,1]),1])
	sharedGenes <- intersect(sp1_2[,1], sp2_1[,1])
	uniqGenes <- sharedGenes[!(sharedGenes %in% dupGenes)]
	
	# the blat region is the same as the liftOver region
	inter.blat0 <- cbind(sp2_1[match(uniqGenes, sp2_1[,1]),1:4], sp1_2[match(uniqGenes, sp1_2[,1]),2:4])
	inter.orig0 <- cbind(orig.sp1[match(uniqGenes, orig.sp1[,1]),], orig.sp2[match(uniqGenes, orig.sp2[,1]),-1])
	
	inter.blat <- inter.orig0[inter.orig0[,4] == inter.blat0[,3] & inter.orig0[,5] == inter.blat0[,4] & inter.orig0[,8] == inter.blat0[,6] & inter.orig0[,9] == inter.blat0[,7],]

	########################
	## filter paralogs
	sp1_1 <- blat.Sp1ToSp1[blat.Sp1ToSp1$percentID >= intraID & blat.Sp1ToSp1$percentLength >= intraPL,]
	sp1_1[,1] <- apply(do.call(rbind, strsplit(sp1_1[,1], split="\\|"))[,1:8], 1, paste, collapse="|")
	sp2_2 <- blat.Sp2ToSp2[blat.Sp2ToSp2$percentID >= intraID & blat.Sp2ToSp2$percentLength >= intraPL,]
	sp2_2[,1] <- apply(do.call(rbind, strsplit(sp2_2[,1], split="\\|"))[,1:8], 1, paste, collapse="|")
	intra.dupGenes <- union(sp1_1[duplicated(sp1_1[,1]),1], sp2_2[duplicated(sp2_2[,1]),1])
	intra.sharedGenes <- intersect(sp1_1[,1], sp2_2[,1])
	intra.uniqGenes <- intra.sharedGenes[!(intra.sharedGenes %in% intra.dupGenes)]
	
	############################
	## output
	out <- inter.blat[inter.blat[,1] %in% intra.uniqGenes,]
	colnames(out) <- c("ID", paste(rep(c(sp1Name, sp2Name), each=4), rep(c("chr", "strand", "start", "end"), 2), sep="."))
	return(out)
}

# bed file to gene length
Bed2geneLength <- function(bed) {
	gID <- apply(do.call(rbind, strsplit(bed[,4], split="\\|"))[,1:2], 1, paste, collapse="|")
	tapply(bed[,3]-bed[,2], gID, sum)
}


## filter genes models with length
# choose parameter
chooseLengthFilterThreshold <- function(blatFiltered, initialGL, Ls, PLs) {
	gID <- apply(do.call(rbind, strsplit(blatFiltered[,1], split="\\|"))[,1:2], 1, paste, collapse="|")
	sp1GL <- tapply(blatFiltered[,4]-blatFiltered[,3], gID, sum)
	sp2GL <- tapply(blatFiltered[,7]-blatFiltered[,6], gID, sum)
	iniGL <- initialGL[names(sp1GL)]
	
	gNum <- sapply(PLs, function(PL) {
		sapply(Ls, function(L) {
			sum((sp1GL >= L & sp2GL >= L) | (sp1GL/iniGL >= PL & sp2GL/iniGL >= PL))
		})
	})
	
	matplot(Ls, gNum, type="n", main="Gene number vs gene length and percentage of length")
	text(Ls, gNum, rep(Ls,ncol(gNum)), col=rep(1:length(PLs), each=length(Ls)), cex=.8)
	legend("bottomleft", legend=paste("PL =", PLs), col=1:length(PLs), lty=1, cex=.8)
	
	colnames(gNum) <- PLs
	rownames(gNum) <- Ls
	gNum
}

# filter by length
lengthFilter <- function(blatFiltered, initialGL, L, PL) {
	gID <- apply(do.call(rbind, strsplit(blatFiltered[,1], split="\\|"))[,1:2], 1, paste, collapse="|")
	sp1GL <- tapply(blatFiltered[,4]-blatFiltered[,3], gID, sum)
	sp2GL <- tapply(blatFiltered[,7]-blatFiltered[,6], gID, sum)
	iniGL <- initialGL[names(sp1GL)]
	
	selGenes <- names(iniGL)[(sp1GL >= L & sp2GL >= L) | (sp1GL/iniGL >= PL & sp2GL/iniGL >= PL)]
	blatFiltered[gID %in% selGenes,]
}
	





