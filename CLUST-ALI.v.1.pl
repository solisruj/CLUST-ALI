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

	print($args[0], "\n") ;

	Read_File($args[0]) ;

}


Main() ;







# setup my defaults
#my $name     = 'Bob';
#my $age      = 26;
#my $employed = 0;
#my $help     = 0;

#GetOptions(
#    'name=s'    => \$name,
#    'age=i'     => \$age,
#    'employed!' => \$employed,
#    'help!'     => \$help,
#) or die "Incorrect usage!\n";

#if( $help ) {
#    print "Common on, it's really not that hard.\n";
#} else {
#    print "My name is $name.\n";
#    print "I am $age years old.\n";
#    print "I am currently " . ($employed ? '' : 'un') . "employed.\n";
#}


# test for the existence of the options on the command line.
# in a normal program you'd do more than just print these.
#print "-h $options{h}\n" if defined $options{h};
#print "-j $options{j}\n" if defined $options{j};
#print "-l $options{l}\n" if defined $options{l};
#print "-n $options{n}\n" if defined $options{n};
#print "-s $options{s}\n" if defined $options{s};

# other things found on the command line
#print "Other things found on the command line:\n" if $ARGV[0];
#foreach (@ARGV) {
#  print "$_\n";
#}