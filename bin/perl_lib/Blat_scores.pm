package Blat_scores;
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

1;

