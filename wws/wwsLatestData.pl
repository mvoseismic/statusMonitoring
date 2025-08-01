#!/usr/bin/perl
#
# Gets latest data available on WWS for each station
#
# R.C. Stewart 2025-07-31
#

use strict;
use warnings;
use LWP::Simple;
use HTML::Restrict;
use Time::Piece;
use feature 'say';

if ( not defined $ARGV[0] ){
    die "Needs argument";
}

my $fifo = 'pulseway.fifo';

my $ip;
if( $ARGV[0] eq 'winston1' ) {
    $ip = '172.17.102.60';
} elsif( $ARGV[0] eq 'winston2' ){
    $ip = '172.17.102.65';
} else {
    die "Bad host";
}

my $t2 = gmtime;

print "wwsLatestData.pl  $t2\n";

my $wwsMenu = get join( '', 'http://', $ip, ':16022/menu' );

my $hr = HTML::Restrict->new();
my $wwsMenuText = $hr->process( $wwsMenu );

my @wwsMenuLines = split( "\n", $wwsMenuText );
#print $wwsMenuText, "\n";

my $fileSta = '../config/stations.txt';
open(my $fh, '<:encoding(UTF-8)', $fileSta)
    or die "Could not open file '$fileSta' $!";

while (my $row = <$fh>) {

    chomp $row;
    next if $row =~ /^#/;
    my ($sta, $ip, $type, $band) = split /\s+/, $row;
    my $staband = join( '', $sta, $band, 'Z' );

    my @lines = grep( /$staband/, @wwsMenuLines );
    my $line = $lines[0];
    $line =~ /\d+(M.{10}).{19}(.{19})/;
    my $scnl = $1;
    my $datim = $2;
    $datim =~ s/ /T/;
    $datim = join( '', $datim, '.000Z' );

    my ($whole, $ms) = $datim =~ /([^.]+)(.*)Z$/;
    my $t1 = Time::Piece->strptime($whole => '%Y-%m-%dT%H:%M:%S');

    my $diff = $t2 - $t1;

    if( $diff > 3600 ){
        my $oldHours = $diff / 3600;
        my $oldDays = $oldHours / 24.0;
        my $message;
        if( $oldHours < 72 ) {
            $message = sprintf( "%4.1f hours old", $oldHours );
        } else {
            $message = sprintf( "%4.1f days old", $oldDays );
        }
        print "$scnl    $datim   $diff   $message\n";

        # Message to named pipe
        #if (-e $fifo) { unlink $fifo  or die "Can't unlink $fifo: $!" }
        #system('mkfifo', $fifo) and system('mknod', $fifo, 'p') 
        #    and die "Can't make $fifo: $!";
        #open my $fh, '>', $fifo or die "Can't open fifo $fifo: $!";  # Blocks here until
        #say $fh "Old data $sta";                           # there's a reader
        #close $fh;
        #unlink $fifo or die "Error unlinking $fifo: $!"; 
        

    } else {
        print "$scnl    $datim   $diff\n";
    }
}

