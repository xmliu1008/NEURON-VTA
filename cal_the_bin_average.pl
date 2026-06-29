#!/usr/bin/env perl
use strict;
use warnings;


die usage() if @ARGV == 0;

my %hash_index;
my %hash_sum;
my %hash_number;
open NEW,"$ARGV[0]" or die;
while(<NEW>){
	chomp;
	my @array = split /\s+/;
	if(/^index/){
		for(my $number = 1;$number < @array - 3;$number++){
			$hash_index{$number} = $array[$number];
		}
	}
	else{
		for(my $number = 1;$number < @array - 3;$number++){
			$hash_sum{$array[-3]}{$array[-2]}{$array[-1]}{$number}+=$array[$number];
			$hash_number{$array[-3]}{$array[-2]}{$array[-1]}{$number}++;
		}
	}
}
close NEW;

open NEW,">$ARGV[1]" or die;
#####################  The header line
print NEW "Bin_1\tBin2\tBin3\t";
foreach my $key(sort {$a <=> $b} keys %hash_index){
	print NEW "$hash_index{$key}\t";
}
print NEW "\n";

foreach my $key1(sort {$a <=> $b} keys %hash_sum){
	foreach my $key2(sort {$a <=> $b} keys %{$hash_sum{$key1}}){
		foreach my $key3(sort {$a <=> $b} keys %{$hash_sum{$key1}{$key2}}){
			print NEW "$key1\t$key2\t$key3\t";
			foreach my $key4(sort {$a <=> $b} keys %hash_index){
				if(exists $hash_sum{$key1}{$key2}{$key3}{$key4}){
					my $average = $hash_sum{$key1}{$key2}{$key3}{$key4}/$hash_number{$key1}{$key2}{$key3}{$key4};
					print NEW "$average\t";
				}
				else{
					print NEW "NA\t";
				}
			}
			print NEW "\n";
		}
	}
}

close NEW;



sub usage{
	my $die =<<DIE;
	usage : perl *.pl Table.xls output
DIE
}
