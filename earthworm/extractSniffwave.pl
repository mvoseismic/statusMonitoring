#!/usr/bin/perl
#
# Extracts data rates from sniffwave files
# 
# R.C. Stewart, 2024-01-22

use strict;
use warnings;
use Time::Local;
use File::Slurp;

my $daysBack = 1;

chomp(my $hostname = `hostname -s`);

my $hostSniff = "winston1";

my $dirData1 = "/mnt/mvofls2/Seismic_Data/monitoring_data/status";
my $dirData2 = "../../data";
my $dirConfig = "../../config";

# Get todays date and time
my $rightNow = time();

# Loop round days
for (my $iday = 0; $iday <= $daysBack; $iday++) {

# Get date and time (UTC)
    my ($year, $month, $day) = (gmtime($rightNow-$iday*24*60*60))[5,4,3];
    $year = 1900 + $year;
    $month++;
    my $fileDate = sprintf( '%04s%02s%02s', $year, $month, $day );
    my $fileSniff = join( '/', $dirData1, 'sniffwave', join( '-', $fileDate, join('.', $hostSniff, 'txt') ) );
    print $fileSniff, "\n";

    my $fileStations = join( '/', $dirConfig, 'stations.txt' );
    open my $if, $fileStations or die "Cant open $fileStations: $!";

    while( my $line = <$if> ) {

        my ($sta, $ip, $type, $cha) = split /\s+/, $line;

        if( substr( $line, 0, 1 ) ne "#" && $cha ne "" ) {

            my $stacha = join( ".", $sta, $cha );

            my $dirLatency = join( '/', $dirData2, 'data_latency_sniffwave', $sta );
            mkdir $dirLatency unless -d $dirLatency;

            my $fileLatency = join( '/', $dirLatency, join( '.', join( '-', $fileDate, $hostSniff ), 'txt' ) );
            my $cmd = join( '', 'grep "', $stacha, '" ', $fileSniff, ' | awk \'{print $10 "  " $19 "  " $20 "  " $21}\' | sed \'s/[()]//g; s/len//g; s/\[D://g; s/s.*$//g\' > ', $fileLatency );
            #print $cmd, "\n";
            system( $cmd );

        }
    }

    close $if;

}

