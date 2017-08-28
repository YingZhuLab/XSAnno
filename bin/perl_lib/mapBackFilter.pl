#! usr/bin/perl
use Getopt::Long;
$getopt = GetOptions("sp1CoordIn=s" => \$humanCoordIn,
		   "sp2CoordIn=s" => \$primateCoordIn,
		   "sp1Ref=s" => \$humanRef,
		   "sp2CoordOut=s" => \$primateCoordOut,
		   "sp1CoordOut=s" => \$humanCoordOut);
# unless ($humanCoordIn && $primateCoordIn && $humanRef && $humanCoordOut && $primateCoordOut) {die "Please specify:\n --sp1CoordIn for liftOver bed file on Species1 genome coordinate\n --sp2CoordIn for liftOver bed file on Species2 genome coordinate\n --sp1Ref for original Species1 annotation in bed format\n --sp1CoordOut for prefix of output bed file on Species1 genome coordinate\n --sp2CoordOut for prefix of output bed file on Species2 genome coordinate\n";}

# build reference hash
open REF, "$humanRef"||die;
%refAnno = ();
while (<REF>) {
	chomp;
	@line = split(/\t/,$_);
	$pos = join("\t",$line[0],$line[1],$line[2],$line[5]);
	if (exists $refAnno{$line[3]}) {
		$refAnno{$line[3]} = push(@{$refAnno{$line[3]}},$pos);
	}else {$refAnno{$line[3]} = [$pos];}
}
close REF;

# filter exons cannot map back to original locations in human
open HUMANIN, "$humanCoordIn"||die;
open HUMANOUT, ">$humanCoordOut.bed";
open HUMANDIS, ">$humanCoordOut.discard";
%cleaned = ();
while ($in = <HUMANIN>) {
	chomp $in;
	@line = split(/\t/,$in);
	$pos = join("\t",$line[0],$line[1],$line[2],$line[5]);
	if (grep {$_ eq $pos} @{$refAnno{$line[3]}}) {
		print HUMANOUT "$in\n";
		$cleaned{$line[3]}=1;
	} else {
		print HUMANDIS "$in\n";
	}
}
close HUMANIN;
close HUMANOUT;
close HUMANDIS;

# change back to primate coordinates
open PRIMATEIN, "$primateCoordIn"||die;
open PRIMATEOUT, ">$primateCoordOut.bed";
open PRIMATEDIS, ">$primateCoordOut.discard";
while ($in = <PRIMATEIN>) {
	chomp $in;
	@line = split(/\t/,$in);
	if (exists $cleaned{$line[3]}) {
		print PRIMATEOUT "$in\n";
	} else {
	    print PRIMATEDIS "$in\n";
	}
}
close PRIMATEIN;
close PRIMATEOUT;
close PRIMATEDIS;

