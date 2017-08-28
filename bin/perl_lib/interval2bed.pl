#! usr/bin/perl -w
use Getopt::Std;
getopt('io',\%opts);
unless (exists $opts{i} && exists $opts{o}) {
	die "Please specify:\n -i for input interval file\n -o for output bed file\n";
}
$interval = $opts{i};
$bed = $opts{o};

open IN, "$interval";
open OUT, ">$bed";
# print OUT "track name=human description=\"genecode GRCh37\" useScore=1\n";
while (<IN>) {
	chomp;
	@line = split(/\s+/,$_);
	@start = split(/,/,$line[6]);
	@end = split(/,/,$line[7]);
	if ($line[2] eq "-") {
		@start = reverse(@start);
		@end = reverse(@end);
	}
	for ($i=0;$i<@start;$i++) {
		$exI=$i+1;
		$ID="$line[0]|$line[1]|$line[2]|$start[$i]|$end[$i]|Exon$exI";
		print OUT "$line[1]\t$start[$i]\t$end[$i]\t$ID\t1\t$line[2]\n";
	}
}
close IN;
close OUT;

