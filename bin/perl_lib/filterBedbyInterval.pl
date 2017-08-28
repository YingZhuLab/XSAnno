#! usr/bin/perl -w
use Getopt::Std;
getopt('bio',\%opts);
unless (exists $opts{b} && exists $opts{i} && exists $opts{o}) {
	die "Please specify:\n -b for bed file\n -i for interval file\n -o for output file\n";
}
$bed = $opts{b};
$interval = $opts{i};
$out = $opts{o};

open INT, "$interval"||die;
%trans = ();
while (<INT>) {
	chomp;
	@line = split(/\t/,$_);
	$trans{$line[0]} = 1;
}

open BED, "$bed"||die;
open OUT, ">$out";
while ($in = <BED>) {
	chomp $in;
	@line = split(/\t/,$in);
	@ID = split(/\|/,$line[3]);
	$transID = join('|',@ID[0,1]);
	if (exists $trans{$transID}) {
		print OUT "$in\n";
	}
}
close INT;
close BED;
close OUT;


