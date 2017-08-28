#! /bin/bash
#PBS -l nodes=1:ppn=1
#PBS -j oe
#PBS -o /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/scripts/simFilter/simNGS.output

wd="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/simFilter";
sd="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/scripts/simFilter/simNGS"
sp1="hg19"
sp2="panTro2"

[ -d $sd ] || mkdir $sd;
cd $sd;
for i in {1..10}
	do 
	echo -e "#! /bin/bash\n#PBS -l nodes=1:ppn=4\n#PBS -j oe\n#PBS -o $sd/simNGS.${sp1}.${i}.output
	cd $wd;
	simLibrary -r 101 -i 100 -x 10 -p liftOver.cDNA.${sp1}To${sp2}.${sp1}.fa |simNGS -I -o \"fastq\" /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/runfiles/s_1_4x.runfile >simReads.cDNA.${sp1}To${sp2}.${sp1}.${i}.fa" >simNGS.${sp1}.${i}.sh

	echo -e "#! /bin/bash\n#PBS -l nodes=1:ppn=4\n#PBS -j oe\n#PBS -o $sd/simNGS.${sp2}.${i}.output
	cd $wd;
	simLibrary -r 101 -i 100 -x 10 -p liftOver.cDNA.${sp1}To${sp2}.${sp2}.fa |simNGS -I -o \"fastq\" /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/runfiles/s_1_4x.runfile >simReads.cDNA.${sp1}To${sp2}.${sp2}.${i}.fa" >simNGS.${sp2}.${i}.sh
done





