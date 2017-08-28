#!/usr/bin/perl -w

use Getopt::Std;
getopt('iof',\%opts);
unless(exists $opts{i} && exists $opts{o} && exists $opts{f}) {
	die "Please specify:\n -i input gtf file\n -o output bed file\n -f format (gtf or gff)\n";
}

$gtf=$opts{i};
$bed=$opts{o};
$format=$opts{f};

open GTF, "$gtf";
open BED, ">$bed";
while (<GTF>) {
	chomp;
	# skip comments
	next if /^#/;
	
	@line = split(/\t/, $_);

	if ($line[2] eq "exon") {
		# gtf
		if ($format eq "gtf") {
			@anno = split(/; /, $line[8]);
			%ID = ();
			foreach $item (@anno) {
				if ($item =~ /gene_id/) {
					@gID = split(/ /, $item);
					$gID[1] =~ s/"//g;
					$ID{"gene_id"} = $gID[1];
				} elsif ($item =~ /transcript_id/) {
					@tID = split(/ /, $item);
					$tID[1] =~ s/"//g;
					$ID{"transcript_id"} = $tID[1];
				} elsif ($item =~ /gene_name/) {
					@gName = split(/ /, $item);
					$gName[1] =~ s/"//g;
					$ID{"gene_name"} = $gName[1];
				} elsif ($item =~ /transcript_name/) {
					@tName = split(/ /, $item);
					$tName[1] =~ s/"//g;
					$ID{"transcript_name"} = $tName[1];
				} elsif ($item =~ /gene_type/) {
					@gType = split(/ /, $item);
					$gType[1] =~ s/"//g;
					$ID{"gene_type"} = $gType[1];
				}
			}

		# gff
		} elsif ($format eq "gff") {
			@anno = split(/;/, $line[8]);
			%ID = ();
			foreach $item (@anno) {
				if ($item =~ /gene_id/) {
					@gID = split(/=/, $item);
					$ID{"gene_id"} = $gID[1];
				} elsif ($item =~ /transcript_id/) {
					@tID = split(/=/, $item);
					$ID{"transcript_id"} = $tID[1];
				} elsif ($item =~ /gene_name/) {
					@gName = split(/=/, $item);
					$ID{"gene_name"} = $gName[1];
				} elsif ($item =~ /transcript_name/) {
					@tName = split(/=/, $item);
					$ID{"transcript_name"} = $tName[1];
				} elsif ($item =~ /gene_type/) {
					@gType = split(/=/, $item);
					$ID{"gene_type"} = $gType[1];
				}
			}
		} else {
			die "Format can only be gtf or gff!\n";
		}
		
		$start = $line[3]-1;
		$gName = join(';', $ID{"gene_id"}, $ID{"gene_name"});
		$tName = join(';', $ID{"transcript_id"}, $ID{"transcript_name"});
		$exonAnno = join("|", $gName, $tName, $line[0], $line[6], $start, $line[4], $ID{"gene_type"});
		$outLine = join("\t", $line[0], $start, $line[4], $exonAnno, 1, $line[6]);
		print BED "$outLine\n";
	}
}
close GTF;
close BED;


	


