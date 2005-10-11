#!/usr/bin/perl

#########################################################################################
#											#
#	hrc_create_data_html.perl: create a html page version of fitting results	#
#											#
#		author: t. isobe (tisobe@cfa.harvard.edu)				#
#											#
#		last update: Oct 11, 2005						#
#											#
#########################################################################################

open(FH, './directory_list');
@temp = ();
while(<FH>){
        chomp $_;
        push(@temp, $_);
}
close(FH);

$web_dir       = $temp[0];
$house_keeping = $temp[1];
$exc_dir       = $temp[2];

$file = "$hosue_keeping/fitting_results";

open(OUT, ">$web_dir/pha_data_list.html");

print OUT '<HTML><BODY TEXT="#FFFFFF" BGCOLOR="#000000" LINK="#00CCFF" VLINK="yellow"ALINK="#FF0000" background="./stars.jpg">',"\n";
print OUT '<title> HRC PHA Evolution Data</title>',"\n";

print OUT '<CENTER><H2>ACIS HRC PHA Evolution Data</H2></CENTER>',"\n";


print OUT '<table border=1 cellpadding=1 cellspacing=1>',"\n";
print OUT '<tr>',"\n";
print OUT '<th>OBSID</th>',"\n";
print OUT '<th>Date</th>',"\n";
print OUT '<th>Instrument</th>',"\n";
print OUT '<th>Pointing RA</th>',"\n";
print OUT '<th>Pointing DEC</th>',"\n";
print OUT '<th>Diff in RA</th>',"\n";
print OUT '<th>Diff in DEC</th>',"\n";
print OUT '<th>Rad Distance</th>',"\n";
print OUT '<th>Median</th>',"\n";
print OUT '<th>Peak Position</th>',"\n";
print OUT '<th>Peak Counts</th>',"\n";
print OUT '<th>Peak Width</th>',"\n";
print OUT '</tr>',"\n";

open(FH, "$file");
while(<FH>){
	chomp $_;
	@col = split(/\t/, $_);
	print OUT '<tr>',"\n";
	print OUT "<td>$col[0]</td>\n";
	print OUT "<td>$col[1]</td>\n";
	print OUT "<td>$col[2]</td>\n";
	print OUT "<td>$col[3]</td>\n";
	print OUT "<td>$col[4]</td>\n";
	print OUT "<td>$col[5]</td>\n";
	print OUT "<td>$col[6]</td>\n";
	print OUT "<td>$col[7]</td>\n";
	print OUT "<td>$col[8]</td>\n";
	print OUT "<td>$col[9]</td>\n";
	print OUT "<td>$col[10]</td>\n";
	print OUT "<td>$col[11]</td>\n";
	print OUT '</tr>',"\n";
}
close(FH);

print OUT '</table>',"\n";

close(OUT);
