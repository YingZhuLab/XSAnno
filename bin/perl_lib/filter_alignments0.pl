#! usr/bin/perl -w
use Getopt::Std;
getopt('iosl',\%opts);
unless (exists $opts{i} && exists $opts{o} && exists $opts{s} && exists $opts{l}) {
	die "Please specify:\n -i for input .psl file\n -o for output txt file\n -s for shreshold of percent ID score\n -l for shreshold of percentage of mapped length\n";
}

use Blat_scores;
$in = $opts{i};
$out = $opts{o};
$idThreshold = $opts{s};
$lengthThreshold = $opts{l};

open IN, "$in";
# remove header lines
for ($i=1; $i<6; $i++) {
	$header = <IN>;
}
undef $header;

open OUT,">$out";
print OUT "qName\tchr\tstart\tend\tpercentID\tpercentLength\n";
while($ln = <IN>){
	($qName, $percentID, $percentLength) = Blat_scores::pslCalcPercentID($ln);
	chomp $ln;
	@line = split(/\t/, $ln);
	if ($percentID > $idThreshold && $percentLength > $lengthThreshold) {
		$tLoc = join("\t", $line[13], $line[15], $line[16]);
		print OUT "$qName\t$tLoc\t$percentID\t$percentLength\n";
	}
}
close OUT;

