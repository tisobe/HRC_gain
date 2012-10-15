#!/usr/bin/perl

#########################################################################################
#											#
#	hrc_create_data_html.perl: create a html page version of fitting results	#
#											#
#		author: t. isobe (tisobe@cfa.harvard.edu)				#
#											#
#		last update: Oct 15, 2012						#
#											#
#########################################################################################

($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst)= localtime(time);
$year = $uyear + 1900;
$month = $umon + 1;
$today = "$year:$uyday:00:00:00";

if($month < 10){
        $month = '0'."$month";
}
if($umday < 10){
        $umday = '0'."$umday";
}


##########################################################################
#
#----- reading directory locations
#

open(FH, "/data/mta/Script/HRC/Gain/house_keeping/dir_list");
while(<FH>){
    chomp $_;
    @atemp = split(/\s+/, $_);
    ${$atemp[0]} = $atemp[1];
}
close(FH);

##########################################################################


$file = "$hosue_keeping/fitting_results";

open(OUT, ">$web_dir/pha_data_list.html");

print OUT '<HTML><BODY TEXT="#FFFFFF" BGCOLOR="#000000" LINK="#00CCFF" VLINK="yellow"ALINK="#FF0000" background="./stars.jpg">',"\n";
print OUT '<title> HRC PHA Evolution Data</title>',"\n";

print OUT '<CENTER><H2>HRC PHA Evolution Data</H2></CENTER>',"\n";


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

print OUT '<br><br>',"\n";
print OUT 'Last Update:',"$month/$umday/$year\n";

close(OUT);

$line =  'Last Update:'."$month/$umday/$year";

foreach $file ('hrc_i_pha_radial.html', 'hrc_i_pha_time.html', 'hrc_s_pha_radial.html', 'hrc_s_pha_time.html'){
	open(FH, "$web_dir/../$file");
	@save_line = ();
	while(<FH>){
		chomp $_;
		if($_ !~ /Last Update:/){
			push(@save_line, $_);
		}else{
			push(@save_line, $line);
		}
	}
	close(FH);
	
	open(OUT, ">$web_dir/../$file");
	foreach $ent (@save_line){
		print OUT "$ent\n";
	}
	close(OUT);
}

#
#---- update the main hrc trending page
#

open(FH, '/data/mta_www/mta_hrc/Trending/hrc_trend.html');
open(OUT, '>./temp_out.html');

$chk = 0;
while(<FH>){
	chomp $_;
	if($_ =~ /QE and Gain Variation with Time/ && $chk == 0){
		print OUT '<li><a href = "#qe_gain">QE and Gain Variation with Time (HRC PHA Evolution)</a>';
		print OUT " (last update: $month-$umday-$year)\n";
		$chk++;
	}else{
		print OUT "$_\n";
	}
}
close(OUT);
close(FH);

system("mv ./temp_out.html $web_dir/../hrc_trend.html");
