#! usr/bin/perl -w

while (<STDIN>) {
	if (/^>/) {
		$ID=$_;
		print $ID;
	} else {
		@IDArray = split(/\|/, $ID);
		if ($IDArray[3] eq "-") {
			chomp;
			$dna = $_;
			$revcomp = reverse($dna);
			$revcomp =~ tr/ACGTacgt/TGCAtgca/;
			print "$revcomp\n";
		} else {
			print $_;
		}
	}
}


