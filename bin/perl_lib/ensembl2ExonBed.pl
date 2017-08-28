#! /usr/bin/perl -w 
use Getopt::Std;
getopt('io',\%opts);
unless((exists $opts{i}) && (exists $opts{o})){die "Please sepecify -i for gtf file and -o for output bed file!";}

$gtf = $opts{i};
$bed = $opts{o};
%exon = ();
open GTF, "$gtf";
open BED, ">$bed";
while(<GTF>){
	unless (/^#/) {
		chomp;
		@line = split("\t",$_);
		if ($line[2] =~ /exon|UTR/){
			@anno = split("\"",$line[8]);
			$ID = join('|',$anno[1],$anno[3],$anno[9],$anno[15],$anno[11]);
			$start = $line[3]-1; # change to 0-based
			$pos = join("\t",$start,$line[4]);
			if (exists $exon{$line[0]}{$line[6]}{$ID}{$pos}) {
				if ($exon{$line[0]}{$line[6]}{$ID}{$pos} eq "exon") {
					$exon{$line[0]}{$line[6]}{$ID}{$pos}=$line[2];
				}
			} else {$exon{$line[0]}{$line[6]}{$ID}{$pos}=$line[2]};
		}
	}
}
foreach $chr (sort keys %exon) {
	foreach $strand (sort keys %{$exon{$chr}}){
		foreach $ID (keys %{$exon{$chr}{$strand}}){
			sub sort_exon {
				@ex1 = split("\t",$a);
				@ex2 = split("\t",$b);
				if(($ex1[0]<$ex2[0])||($ex1[0]==$ex2[0] && $ex1[1]<$ex2[1])){-1}elsif($ex1[0]==$ex2[0] && $ex1[1]==$ex2[1]){0}else{1};
			}
			$i=1;
			$u5=1;
			$u3=1;
			@posArray0 = sort sort_exon keys %{$exon{$chr}{$strand}{$ID}};
			if ($strand eq "+") {
				@posArray = @posArray0;
			} else {
				@posArray = reverse @posArray0;
			}
			foreach $pos (@posArray) {
				if ($exon{$chr}{$strand}{$ID}{$pos} eq "UTR") {
					if ($i > 1) {
						print BED "$chr\t$pos\t$ID\|3\'${exon{$chr}{$strand}{$ID}{$pos}}-$u3\t1\t$strand\n";
						$u3++;
					}else {
						print BED "$chr\t$pos\t$ID\|5\'${exon{$chr}{$strand}{$ID}{$pos}}-$u5\t1\t$strand\n";
						$u5++;
					}
				}else {
					print BED "$chr\t$pos\t$ID\|${exon{$chr}{$strand}{$ID}{$pos}}-$i\t1\t$strand\n";
					$i++;
				}
			}
		}
	}
}
close GTF;
close BED;

		
