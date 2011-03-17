#/soft/ascds/DS.release/ots/bin/perl

use DBI;
use DBD::Sybase;

#########################################################################################
#											#
#	find_ar_lac.perl: this script finds AR LAC obsid from a recent observations	#
#											#
#		author: t. isobe (tisobe@cfa.harvard.edu)				#
#											#
#		last update: Mar 17, 2011						#
#											#
#########################################################################################

################################################################
#
#--- setting directories
#
open(FH, "/data/mta/Script/HRC/Gain/house_keeping/dir_list");
@atemp = ();
while(<FH>){
        chomp $_;
        push(@atemp, $_);
}
close(FH);

$bin_dir       = $atemp[0];
$bdata_dir     = $atemp[1];
$exc_dir       = $atemp[2];
$web_dir       = $atemp[3];
$data_dir      = $atemp[4];
$house_keeping = $atemp[5];

################################################################

open(FH, "$house_keeping/hrc_obsid_list");
while(<FH>){
	chomp $_;
	push(@obsid_list, $_);
}
close(FH);	

open(FH,'/data/mta_www/mp_reports/events/mta_events.html');
@data_list = ();
while(<FH>){
        chomp $_;
        if($_ =~ /HRC/i && $_ =~/Obsid/i){
		@atemp = split(/Obsid:/, $_);
		@btemp = split(/\'/, $atemp[1]);
                push(@data_list, $btemp[0]);
        }
}
close(FH);



#-------------------------------------------------
#------ open up database and read target name etc
#-------------------------------------------------

#------------------------------------------------
#-------  database username, password, and server
#------------------------------------------------

$db_user="browser";
$server="ocatsqlsrv";
$db_passwd =`cat /data/mta/MTA/data/.targpass`;
chop $db_passwd;


#--------------------------------------
#------ output is save in ./Working_dir
#---------------------------------------

open(OUT, '>./candidate_list');
open(OUT2, ">> $house_keeping/hrc_obsid_list");
$ent_cnt = 0;

OUTER:
foreach $obsid (@data_list){
        foreach $comp (@obsid_list){
                if($obsid == $comp){
                        next OUTER;
                }
        }


#--------------------------------------
#-------- open connection to sql server
#--------------------------------------

        my $db = "server=$server;database=axafocat";
        $dsn1 = "DBI:Sybase:$db";
        $dbh1 = DBI->connect($dsn1, $db_user, $db_passwd, { PrintError => 0, RaiseError => 1});

        $sqlh1 = $dbh1->prepare(qq(select
                obsid,targid,seq_nbr,targname,grating,instrument
        from target where obsid=$obsid));
        $sqlh1->execute();
        @targetdata = $sqlh1->fetchrow_array;
        $sqlh1->finish;

        $targid     = $targetdata[1];
        $seq_nbr    = $targetdata[2];
        $targname   = $targetdata[3];
        $grating    = $targetdata[4];
        $instrument = $targetdata[5];

        $targid     =~ s/\s+//g;
        $seq_nbr    =~ s/\s+//g;
        $targname   =~ s/\s+//g;
        $grating    =~ s/\s+//g;
        $instrument =~ s/\s+//g;

	if($targname =~ /ARLAC/i){
		print OUT "$obsid\n";
		print OUT2 "$obsid\n";
	}
}
close(OUT);
close(OUT2);


