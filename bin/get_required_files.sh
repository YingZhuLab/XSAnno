#! /usr/bin/bash

# updated 02/05/2013
# ================================================================
#
# File Description:
# Script to download and format files required by XSAnno package.
#
# =================================================================

if [ "$#" == "0" ]; then
	echo "bash get_required_files.sh <Sp1> <Sp2>";
	echo "This command downloads and formats the files required for XSAnno package";
	echo "<Sp1> the name of the reference species (UCSC name; e.g. hg19)";
	echo "<Sp2> the name of the second species (UCSC name; e.g. panTro2)";
	exit 1
fi

Sp1=`echo $1 |awk '{a=substr($0,1,1); print (tolower(a))substr($0,2,100)}'`;
Sp2=`echo $2 |awk '{a=substr($0,1,1); print (tolower(a))substr($0,2,100)}'`;

capSp1=`echo $Sp1 |awk '{a=substr($0,1,1); print (toupper(a))substr($0,2,100)}'`
capSp2=`echo $Sp2 |awk '{a=substr($0,1,1); print (toupper(a))substr($0,2,100)}'`
#####################
# Chain files
cd $wd;
[ -d chain ] || mkdir chain;
cd chain
wget ftp://hgdownload.cse.ucsc.edu/goldenPath/$Sp1/liftOver/${Sp1}To${capSp2}.over.chain.gz;
wget ftp://hgdownload.cse.ucsc.edu/goldenPath/$Sp2/liftOver/${Sp2}To${capSp1}.over.chain.gz;

gunzip ${Sp1}To${capSp2}.over.chain.gz;
mv ${Sp1}To${capSp2}.over.chain.gz ${Sp1}To${Sp2}.over.chain.gz;
gunzip ${Sp2}To${capSp1}.over.chain.gz;
mv ${Sp2}To${capSp1}.over.chain.gz ${Sp2}To${Sp1}.over.chain.gz;

#####################
## genome .fa files
# Sp1
cd $wd;
[ -d genome ] || mkdir genome;
cd genome

[ -d $Sp1 ] || mkdir $Sp1;
cd $Sp1
wget ftp://hgdownload.cse.ucsc.edu/goldenPath/$Sp1/bigZips/chromFa.tar.gz
tar xzf chromFa.tar.gz
find ./ \( -name "*.fa" ! \( -name "*hap*.fa" -o -name "*random.fa" -o -name "chrUn*.fa" -o -name "$Sp1.fa" \) \) -exec cat {} > $Sp1.fa \;
find ./* ! -name "$Sp1.fa" -exec rm -r {} \;

# bowtie index
bowtie-build $Sp1.fa $Sp1

# Sp2
cd $wd;
cd genome
[ -d $Sp2 ] || mkdir $Sp2;
cd $Sp2
wget ftp://hgdownload.cse.ucsc.edu/goldenPath/$Sp2/bigZips/chromFa.tar.gz
tar xzf chromFa.tar.gz
find ./ \( -name "*.fa" ! \( -name "*hap*.fa" -o -name "*random.fa" -o -name "chrUn*.fa" -o -name "$Sp2.fa" \) \) -exec cat {} > $Sp2.fa \;
find ./* ! -name "$Sp2.fa" -exec rm -r {} \;

# bowtie index
bowtie-build $Sp2.fa $Sp2

#####################
## 2bit files
cd $wd;
[ -d 2bit ] || mkdir 2bit;
cd 2bit;
wget http://hgdownload.soe.ucsc.edu/goldenPath/$Sp1/bigZips/$Sp1.2bit
wget http://hgdownload.soe.ucsc.edu/goldenPath/$Sp2/bigZips/$Sp2.2bit

#####################
## runfile
wget http://www.ebi.ac.uk/goldman-srv/simNGS/runfiles5/HiSeq/s_1_4x.runfile

