#! usr/bin/perl -w
use Getopt::Long;
GetOptions("bed1=s" => \$bed1,
		   "bed2=s" => \$bed2,
		   "out1=s" => \$out1,
		   "out2=s" => \$out2);
unless ($bed1 && $bed2 && $out1 && $out2) {
	die "Please specify:\n --bed1 for bed file 1\n --bed2 for bed file 2\n --out1 for output file 1\n --out2 for output file 2\n"
}

open BED1, "$bed1";
%refBed = ();
while($ln=<BED1>) {
	chomp $ln;
	@line=split(/\t/, $ln);
	if ($line[0] !~ /random/) {
		$refBed{$line[3]} = $ln;
	}
}
close BED1;

open BED2, "$bed2";
open OUT1, ">$out1";
open OUT2, ">$out2";
while ($ln=<BED2>) {
	chomp $ln;
	@line=split(/\t/, $ln);
	if ($line[0] !~ /random/ && $line[0] !~ /chrUn/ && exists $refBed{$line[3]}) {	
		print OUT1 "$refBed{$line[3]}\n";
		print OUT2 "$ln\n";
	}
}
close BED2;
close OUT1;
close OUT2;


