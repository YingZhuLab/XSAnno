#! /bin/bash
#PBS -l nodes=1:ppn=4
#PBS -j oe
#PBS -o /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/scripts/simFilter/simNGS/simNGS.hg19.1.output
	cd /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/simFilter;
	simLibrary -r 101 -i 100 -x 10 -p liftOver.cDNA.hg19TopanTro2.hg19.fa |simNGS -I -o "fastq" /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/runfiles/s_1_4x.runfile >simReads.cDNA.hg19TopanTro2.hg19.1.fa
