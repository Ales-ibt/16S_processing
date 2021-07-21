#!/usr/bin/perl
use strict;
use warnings;

######## PROGRAMA QUE CALCULA EL INDICE DE GOOD (GOODS COVERAGE) A PARTIR DE UN TABLA DE OTUS #######
######## Alejandra Escobar Zepeda, UUSMB, IBt, UNAM
######## 18/Enero/2018

scalar@ARGV == 1 || die "usage: $0 <filtered_OTU_matrix.txt>
";

my $file=$ARGV[0];

## Recorriendo la matriz
open (FILE, $file) or die ("I cannot open the file $file\n");
my $header=<FILE>;
chomp $header;
my @header=split(/\t/, $header);
shift(@header);
my$tamano=scalar@header;

my %singletones=();
my %Total=();
my $indice=0;
while (<FILE>) {
	chomp;
	my@line=split(/\t/, $_);
	shift@line;

	foreach my $var (@line){
		
		if ($var == 1) {
			if ($singletones{$indice}){
				$singletones{$indice}++;
			}else{
				$singletones{$indice}=1;
			}

		} elsif ($var > 1){
			if ($Total{$indice}){
				my $last=$Total{$indice};
				my $new=$last+$var;
				$Total{$indice}=$new;
			}else{
				$Total{$indice}=$var;
			}
		}
		$indice++;
	}
	$indice=0;
}
close(FILE);

open OUT, ">goods_$file" || die ("I cannot create goods_$file\n");
print OUT "Sample\tGoods_coverage\tTotal_singletones\n";
for (my $i=0; $i<$tamano; $i++){
	my$total=$Total{$i}+$singletones{$i};
	my$good=1-($singletones{$i}/$total);
	print OUT "$header[$i]\t$good\t$singletones{$i}\n";
}
close(OUT);

