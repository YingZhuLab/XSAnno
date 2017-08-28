#! /bin/bash
#PBS -l nodes=1:ppn=4
#PBS -j oe
#PBS -o /data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P/scripts/liftOver_HP.output

# liftOver parameters
liftOver_minMatch="0.98"; # liftOver min match Sp1 to Sp2
Sp1ToSp2_chain="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/H2P/hg19ToPanTro2.over.chain";
Sp2ToSp1_chain="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/H2P/panTro2ToHg19.over.chain";

# filter parameters
perl_dir="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/bin/perl_lib"
Sp1Anno="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/gtf/ensembl.hg19.exonTranscript.bed";
output_dir="/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/data/byTranscript/H2P";
Sp1="hg19";
Sp2="panTro2";



/data/brainSeq/brainSeq2/yingDATA/XSAnno_v2/bin/AnnoConvert $perl_dir $Sp1Anno $Sp1ToSp2_chain $Sp2ToSp1_chain $liftOver_minMatch $output_dir $Sp1 $Sp2 N

