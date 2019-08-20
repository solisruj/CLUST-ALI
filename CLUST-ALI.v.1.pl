#!/usr/bin/env perl

use strict;
use Getopt::Long;

sub Arguments{

	my $input = '' ;
	my $num = 3 ;
	my $iterations = 2 ;
	my $output = '' ;
	my $help = 0;

	GetOptions(
		'input=s'	=> \$input,
		'num=n'	=> \$num,
		'iterations=n'	=> \$iterations,
		'output=s'	=> \$output,
		'help!'	=> \$help,
	) or die "Invalid command options!\n" ;

	if ($help){
		print("CLUST-ALI is a clustering algorithm implementation program. It takes\ntwo dimensional data (X,Y) and clusters the data into N groups.\n\n") ;
		print(" -input       Tab seperated value file (.tsv) with X Y columns.\n") ;
		print(" -num         Number of K-Centers.\n") ;
		print(" -iterations  Number of iterations.\n") ;
		print(" -output      Output file name.\n\n") ;
		exit;
	}

	return $input, $num, $iterations, $output ;
}

# Subroutine to read in data tab seperated value file. 
sub Read_File{

	my ($file) =  shift ;
	my $counter = 0;
	my @data;

	open(File, "<", $file) || die "ERROR: ". $file. " could not be read!" ;

	while (my $line = <File>){
		if ($counter > 0){
			chomp($line) ;
			my @values = split("\t", $line) ;
			#print($data[0], "\t", $data[1], "\n") ;
			push(@data, [$values[0], $values[1]])
		}
		$counter++ ;
	}
	close(File) ;
	return @data ;
}

sub Max{
	my @array = @{$_[0]} ;
	my $column = $_[1] ;
	my $max_value = 0;
	
	for(my $i = 0; $i <= $#array ; $i ++){
		if ( $array[$i][$column] > $max_value){
			$max_value = $array[$i][$column];
		}
	}
	return $max_value
}

sub Centers{

	my $num = $_[0];
	my $value1 = $_[1];
	my $value2 = $_[2];
	my @centers = ();

	for(my $i = 0; $i < $num ; $i ++){
		push(@centers, [rand($value1), rand($value2)]) ;
		print(rand($value1), "\t", rand($value2), "\n") ;
	}
	return @centers ;
}

sub Main{

	my @args = () ;
	@args = Arguments() ;

	my @data = Read_File($args[0]) ;

	my $x = Max(\@data, 0) ;
	my $y = Max(\@data, 1) ;

	print($x, "\t", $y, "\n\n") ;
	
	my @cluster_centers = Centers($args[1], $x, $y) ;

	print("\n\n") ;

	Assign(\@data, \@cluster_centers) ;


}

Main() ;



sub Assign{

	my @input_data = @{$_[0]} ;
	my @centers = @{$_[1]} ;
	my @clustered_data = () ;

	for(my $i = 0; $i <= $#input_data; $i ++){
		
		my $x = $input_data[$i][0] ;
		my $y = $input_data[$i][1] ;

		my @Euclidean_data = () ;

		for(my $j = 0; $j <= $#centers; $j ++){

			my $Euc_dist = sqrt((($x) - ($centers[$j][0]))**2 + (($y) - ($centers[$j][1]))**2) ;
			print($Euc_dist, "\t", $j+1, "\n") ;
		}
		print("\n") ;
	}

}