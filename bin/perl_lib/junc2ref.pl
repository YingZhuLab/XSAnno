#! usr/bin/perl -w
use Getopt::Std;
getopt('irmo',\%opts);
unless(exists $opts{i} && exists $opts{r} && exists $opts{m} && exists $opts{o}) {
	die "Please specify:\n -i for input bed junciton file\n -r for junciton ref file\n -m for shift allowed\n -o for output file!";
}

###################################################
## make hash for ref junctions ##
$ref = $opts{r};
%refJunc = ();
open REF, $ref;
while (<REF>) {
	chomp;
	my @refLine = split("\t", $_);
	my $pos = join("\t",$refLine[0],$refLine[3],$refLine[4]);
	my $ID = $refLine[1];
	if (exists $refJunc{$pos}) {
		$refJunc{$pos} .= ",$ID";
	} else {
		$refJunc{$pos} = "$ID";
	}
}
close REF;

#####################################################
## search sample junctions in the ref junctions ##
$inBed = $opts{i};
$out = $opts{o};
$shift = $opts{m};

open IN, $inBed;
open OUT, ">$out";
while (<IN>) {
	chomp;
	if (/chr/) {
		my @juncLine = split("\t",$_);
		my @blocks = split(",",$juncLine[10]);
		my $indicate = 0;
		my $posInitial = join("\t",$juncLine[0],$juncLine[1]+$blocks[0],$juncLine[2]-$blocks[1]);
		my $score = $juncLine[4];
		for ($ms = -1*$shift; $ms <= $shift; $ms++){
			if ($indicate == 1) {
				last;
			} else {
				for ($me = -1*$shift; $me <= $shift; $me++){
					my $start = $juncLine[1]+$blocks[0]+$ms;
					my $end = $juncLine[2]-$blocks[1]+$me;
					my $samPos = join("\t",$juncLine[0],$start,$end);
					if (exists $refJunc{$samPos}) {
						print OUT "$juncLine[3]\t$posInitial\t$score\t$refJunc{$samPos}\t$samPos\n";
						$indicate = 1;
					}
				}
			}
		}

		if ($indicate == 0) {
			print OUT "$juncLine[3]\t$posInitial\t$score\t-\t-\t-\t-\n";
		}
	}
}
close IN;
close OUT;



	
