#! usr/bin/perl -w
#### Functions needed for calculating BLAT scores ####
# pslCalcMilliBad calculates the percent identity score for each psl file line #
sub pslCalcPercentID {
	my ($pslLine) = @_;
	chomp $pslLine;
	my @line = split(/\t/,$pslLine);
	$qStart = $line[11];
	$qEnd = $line[12];
	$tStart = $line[15];
	$tEnd = $line[16];
	$qNumInsert = $line[4];
	$tNumInsert = $line[6];
	$match = $line[0];
	$repMatch = $line[2];
	$misMatch = $line[1];
	$qSize = $line[10];
	$name = $line[9];

	$qAliSize = $qEnd - $qStart;
	$tAliSize = $tEnd - $tStart;
	$aliSize = ($qAliSize, $tAliSize)[$qAliSize > $tAliSize]; # min of $qAliSize and $tAliSize
	if ($aliSize <= 0) {
		die "The alignment size is less than 0!";
	}
	$sizeDif = abs($qAliSize - $tAliSize);
	$insertFactor = $qNumInsert;
	$insertFactor += $tNumInsert;
	$total = $match + $repMatch + $misMatch;
	if ($total != 0) {
		$percentID = 1-(1 * ($misMatch + $insertFactor + printf('%d',3*log(1+$sizeDif)))) / $total;
	}else { $percentID = 0; }
	$percentLength = $aliSize/$qSize;
	return ($name,$percentID, $percentLength);
}

sub pslScore {
	my ($pslLine) = @_;
	chomp $pslLine;
    my @line = split(/\t/,$pslLine);
	$qNumInsert = $line[4];
	$tNumInsert = $line[6];
	$match = $line[0];
	$repMatch = $line[2];
	$misMatch = $line[1];
	
	$score = $match + $repMatch - $misMatch - $qNumInsert - $tNumInsert;
	return $score;
}


################################
use Getopt::Std;
getopt('iosl',\%opts);
unless (exists $opts{i} && exists $opts{o} && exists $opts{s} && exists $opts{l}) {
	die "Please specify:\n -i for input .psl file\n -o for output txt file\n -s for shreshold of percent ID score\n -l for shreshold of percentage of mapped length\n";
}

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
	($qName, $percentID, $percentLength) = pslCalcPercentID($ln);
	chomp $ln;
	@line = split(/\t/, $ln);
	if ($percentID > $idThreshold && $percentLength > $lengthThreshold) {
		$tLoc = join("\t", $line[13], $line[15], $line[16]);
		print OUT "$qName\t$tLoc\t$percentID\t$percentLength\n";
	}
}
close OUT;

