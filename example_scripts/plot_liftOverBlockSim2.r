simV <- read.table("test.txt", header=F, as.is=T);
pdf("simV.pdf", 6, 6)
	plot(density(simV[,1]), xlab="Median similarity (%)", col="gray")
	text(40,0.2,labels=paste("Median =",median(simV[,1])),col="lightblue");
dev.off()

