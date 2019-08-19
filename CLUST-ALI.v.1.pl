#!/usr/bin/env perl

#!/usr/bin/perl
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
			@data = split("\t", $line) ;
			print($data[0], "\t", $data[1], "\n") ;
		}
		$counter++ ;
	}
	close(File) ;
	return @data ;
}


sub Main{

	my @args = () ;
	@args = Arguments() ;

	#print($args[0], "\n") ;

	Read_File($args[0]) ;

}

Main() ;
