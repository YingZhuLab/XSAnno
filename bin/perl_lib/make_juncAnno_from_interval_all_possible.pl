#! usr/bin/perl -w
use Getopt::Std;
getopt('io',\%opts);
unless(exists $opts{i} && exists $opts{o}) {
    die "Please specify -io for input and output files!"
}
$inFile = $opts{i};
$outFile = $opts{o};
open IN, "$inFile";
open OUT, ">$outFile";

while (<IN>) {
	chomp;
	@line = split("\t", $_);
	@starts = split(",", $line[6]);
	shift @starts;
	@ends = split(",", $line[7]);
	pop @ends;
	for ($i=0; $i<@ends; $i++) {
		for ($j=$i; $j<@starts; $j++){
			$se=$i+1;
			$ee=$j+2;
			print OUT "$line[1]\t$line[0]\|exon$se-$ee\t$line[2]\t$ends[$i]\t$starts[$j]\n";
		}
	}
}
close IN;
close OUT;


