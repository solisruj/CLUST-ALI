#!/usr/bin/perl

# Program that reads in data values (x and y) then generates k-cluster centers for a number user declares and looks for convergence using number of iterations that a user declares and then outputs into an outfile. 

$file = @ARGV[0] ;
$number_k_clusters = @ARGV[1] ;
$number_of_iterations = @ARGV[2] ;
$output_file = @ARGV[3] ;

$out_file = "temp.txt" ;

open ( File, "<", $file ) || die "Reading File could not be opened. " ;
open ( Out_file, ">", $out_file ) || die "Writing File could not be created." ;
while ( $file_line = <File>) {
    chomp ($file_line) ;
    if ( $file_line eq "\"x\"\t\"y\"" ) {
        next ;
    } else {
        @file_line_parts = split ( "\t" || " ", $file_line ) ;
        print ( Out_file $file_line_parts[0]."\t".$file_line_parts[1]."\n" ) ;
    }
}
close (File) ;
close (Out_file) ;

$data_file = "temp.txt" ;

open ( Data_file, "<", $data_file ) || die "Reading File could not be opened. " ;
open ( Output_file, ">", $output_file ) || die "Writing File could not be created." ;
open ( O_file, ">", "Centers.txt" ) || die "Writing File could not be created." ;

# Finds the max-value in reading file list.
$num_col_1 = 0 ;
$num_col_2 = 0 ;

while ( $data_file_line = <Data_file>) {
    chomp ( $data_file_line ) ;
    
    push ( @Data_file_contents, $data_file_line ) ;
    @Data_file_line_parts = split ( '\t' || ' ', $data_file_line ) ;
    
    if ( $Data_file_line_parts[0] > $num_col_1 ) {
        $num_col_1 = $Data_file_line_parts[0] ;
    }
    if ( $Data_file_line_parts[1] > $num_col_2 ) {
        $num_col_2 = $Data_file_line_parts[1] ;
    }
}
close (Data_file) ;
system ("rm -f temp.txt") ;

# Generates random numbers for k-cluster centers.
for ($i = 0 ; $i < $number_k_clusters; $i ++ ) {
    push ( @k_cluster_center_coordinates, rand($num_col_1)."\t".rand($num_col_2)."\t".($i+1) ) ;
    push ( @total_k_clus, $i+1 );
}
# Sub function calling Assigning and setting the return value to @old_data.
@old_data = Assigning ( @Data_file_contents, @k_cluster_center_coordinates ) ;

# For user number of iterations pass the values through, and check for convergence.
for ( $g = 0 ; $g < $number_of_iterations ; $g ++ ) {
    if($total == 0){
        print "Convergence reached... \n";
    } else {
        Assigning ( @Data_file_contents, @k_cluster_center_coordinates ) ;
        Averaging ( @new_data_clustered ) ;
    }
}
# If checking if convergence is not reached (still in beta).
if($total != 0){
    print "Convergence not reached...", "\n";
}
# For statement that pushed the values created in the averaging sub function and pushed into an array.
for ( $f  = 0 ; $f <= $#x_val ; $f ++ ) {
    push ( @k_cluster_center_coordinates, $x_val[$f]."\t".$y_val[$f]."\t".($f+1) ) ;
}

foreach $t ( @k_cluster_center_coordinates) {
    @t_items = split ("\t" || " ", $t) ;
    print (O_file $t_items[0]."\t".$t_items[1]."\n") ;
}

# Calls sub assinging function and sets the data into @new_data.
@new_data = Assigning ( @Data_file_contents, @k_cluster_center_coordinates ) ;
# Sub function sending information into convergence subfunction.
Convergence (@old_data ,@new_data) ;

# Prints to the outfile the clustering elements using a for statement.
print ( Output_file "X\t\tY\t\tCluster\n") ;
print ( Output_file "_______________________\n") ;
foreach $writing_data ( @new_data ) {
    $writing_data ;
    @writing_data_items = split ( "\t" || " ", $writing_data ) ;
    print ( Output_file $writing_data_items[1]."\t\t".$writing_data_items[2]."\t\t".$writing_data_items[3]."\n") ;
}
# Closes the writing file.
close (Output_file) ;
close (O_file) ;

# Subfunction checking for convergence.
sub Convergence {
    $total = 0 ;
    for ( $h = 0 ; $h <= $#new_data ; $h ++ ) {
        @new_data_item = split ( "\t" || " ", $new_data[$h] ) ;
        @old_data_item = split ( "\t" || " ", $old_data[$h] ) ;
        $counter = $new_data_item[0] - $old_data_item[0] ;
        $total = $total + $counter ;
        
    }
    return ($total);
}
# Sub function that is bidirectional in checking concatenated string of info and gets the Euclidean distance.
#       then sorts out the lowest value and pushes into a new arrat called @new_data_cluster.
sub Assigning {

    undef @new_data_clustered = () ;
    
    for ( $a = 0 ; $a <= $#Data_file_contents ; $a ++ ) {
        @x_y_values = split ( "\t" || " ", $Data_file_contents[$a] ) ;
        @Euc_val_data = () ;
        
        for ( $b = 0 ; $b <= $#k_cluster_center_coordinates ; $b ++ ) {
            @coord_values = split ( '\t' || ' ', $k_cluster_center_coordinates[$b] ) ;
            
            $Euc_dis_val = sqrt ( ( ($x_y_values[0]) - ($coord_values[0]) )**2 + ( ($x_y_values[1]) - ($coord_values[1]) )**2 ) ;
            push (@Euc_val_data, $Euc_dis_val."\t". $x_y_values[0]."\t".$x_y_values[1]."\t".$coord_values[2]) ;
        }
        @eud = sort { $a <=> $b } @Euc_val_data ;
        
        undef @Euc_val_data = () ;
        push ( @new_data_clustered, $eud[0]) ;
        undef @eud = () ;
    }
    return (@new_data_clustered) ;
}
# Sub function that takes the averages and outputs the new values to be passed back into the assigning and average subfunctions. 
sub Averaging {

    undef @k_cluster_center_coordinates = () ;
    undef @x_val ;
    undef @y_val ;
    
    $base_x = 0 ;
    $base_y = 0 ;
    
    for ( $c = 0 ; $c < $number_k_clusters ; $c ++ ) {
        for ( $d = 0 ; $d <= $#new_data_clustered ; $d ++ ) {
            @new_data_clustered_items = split ( "\t" || " ", $new_data_clustered[$d]) ;
            if ( $new_data_clustered_items[3] == ($c+1) ) {
                
                push ( @x_values, $new_data_clustered_items[1] ) ;
                push ( @y_values, $new_data_clustered_items[2] ) ;
            }
        }
        for ( $e = 0 ; $e <= $#x_values ; $e ++ ) {
            
            $base_x = $base_x + $x_values[$e] ;
            $base_y = $base_y + $y_values[$e] ;
        }
        $average_x_val = $base_x / $#x_values ;
        $average_y_val = $base_y / $#y_values ;
    
        push ( @x_val, $average_x_val ) ;
        push ( @y_val, $average_y_val ) ;
    }
    return (@k_cluster_center_coordinates) ;
}
