#! usr/bin/perl -w
use Getopt::Std;
getopts('ci:o:',\%opts);
unless (exists $opts{i} && exists $opts{o}) {
	die "Please specify:\n -i for input bed file\n -o for output interval file\n -c is a boolean variable to indicate whether exons should be combined to transcripts/genes (-c if combine, nothing otherwise)\n";
}
$bed = $opts{i};
$out = $opts{o};

if ($opts{c}) {
	%trans = ();
	open IN, "$bed";
	while (<IN>) {
		chomp;
		@line = split("\t",$_);
		if (defined $line[5]) {
			$pos = join("\t",$line[0],$line[5]);
		} else {
			$pos = join("\t",$line[0],".");
		}
		@IDs = split(/\|/,$line[3]);
		$ID = join('|',@IDs[0,1]);
		if (exists $trans{$ID}{$pos}{$line[1]}) {
			if ($line[2] > $trans{$ID}{$pos}{$line[1]}) {
				$trans{$ID}{$pos}{$line[1]} = $line[2];
			}
		}else{
			$trans{$ID}{$pos}{$line[1]} = $line[2];
		}
	}	
	close IN;

	open OUT, ">$out";
	open DIS, ">$out.discard";
	foreach $ID (keys %trans) {
		if (keys %{$trans{$ID}} == 1) {
			foreach $pos (keys %{$trans{$ID}}){
				@s = sort {$a <=> $b} keys %{$trans{$ID}{$pos}};
				$num = @s;
				$tranS = $s[0];
				@e = ();
				foreach $exonS (@s) {
					push @e,$trans{$ID}{$pos}{$exonS};
				}
				@sortE = sort {$a <=> $b} @e;
				$tranE = $sortE[-1];
				$starts = join(",", @s);
				$ends = join(",", @e);
				print OUT "$ID\t$pos\t$tranS\t$tranE\t$num\t$starts\t$ends\n";
			}
		}else {
			foreach $pos (keys %{$trans{$ID}}){
				@s = sort {$a <=> $b} keys %{$trans{$ID}{$pos}};
				@e = ();
				foreach $exonS (@s) {
					push @e,$trans{$ID}{$pos}{$exonS};
				}
				$num = @s;
				$tranS = $s[0];
        	    $tranE = $e[-1];
				$starts = join(",", @s);
				$ends = join(",", @e);
				print DIS "$ID\t$pos\t$tranS\t$tranE\t$num\t$starts\t$ends\n";
			}
		}
	}
	close OUT;
	close DIS;

} else {
	open IN, "$bed";
	open OUT, ">$out";
	while (<IN>) {
		chomp;
		@line = split("\t",$_);
		if (defined $line[5]) {
			$strand = $line[5];
		} else {
			$strand = "."
		}
		print OUT "$line[3]\t$line[0]\t$strand\t$line[1]\t$line[2]\t1\t$line[1]\t$line[2]\n";
	}
	close OUT;
}

