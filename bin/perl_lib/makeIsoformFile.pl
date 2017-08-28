#! /usr/bin/perl -w
use Getopt::Std;
getopt('io', \%opts);
unless (exists $opts{i} && exists $opts{o}) {
	die "Please specify:\n -i for input interval file\n -o for output isoform file\n";
}

$interval = $opts{i};
$out = $opts{o};

open IN, "$interval";
open OUT, ">$out";
%iso = ();
$i = 1;
while (<IN>) {
	chomp;
	@line = split(/\s+/,$_);
	@IDArray = split(/;|\|/,$line[0]);
	$gID = join("|", @IDArray[0,1]);
	if (exists $iso{$gID}) {
		print OUT "$iso{$gID}\t$line[0]\n";
	} else {
		$iso{$gID} = $i;
		print OUT "$iso{$gID}\t$line[0]\n";
		$i++;
	}
}
close IN;
close OUT;

