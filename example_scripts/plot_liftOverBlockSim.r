##Usage: plot_blockSim.R
##AIM: give the distribution of block similarity
##Date:2011-06-15

pdf("huam.chimp.rhesus.pairwise.sim.pdf",10,5);
par(omi=c(0.1,0.1,0.1,0.1));
layout(matrix(1:2,ncol=2));


##------human to chimp pairwise alignment
hc=read.table("hg19Topantro2.block.sim.txt");
for(i in 1:length(hc[,1])){
	simVal=as.numeric(hc[i,]);
	if(i ==1 ){
		plot(density(simVal),main="Human to Chimp",xlab="Similarity (%)",col="gray");
	}
	else{
		lines(density(simVal),col="gray");	
	}
}	
text(40,0.2,labels=paste("Median=",median(apply(hc, 1,  median))),col="lightblue");


##-----human to rhesus pairwise alignment
hr=read.table("hg19Torhemac2.block.sim.txt");
for(i in 1:length(hr[,1])){
	simVal=as.numeric(hr[i,]);
	if(i ==1 ){
		plot(density(simVal),main="Human to Rhesus",xlab="Similarity (%)",col="gray");
	}
	else{
		lines(density(simVal),col="gray");	
	}
}	
text(40,0.06,labels=paste("Median=",median(apply(hr, 1, median))),col="lightblue");

dev.off();


