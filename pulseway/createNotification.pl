#!/usr/bin/perl
#
# Reads from a named pipe and creates a notification for Pulseway
#
# R.C.Stewart, 2025-08-01

use warnings;
use strict;
use feature 'say';

use Errno qw(ENOENT);

my $fifo = 'pulseway.fifo';

while (1) {
    sleep 3;

    if (my $msg = read_fifo($fifo)) {
        say $msg;
    }

}

sub read_fifo {
    my ($fifo) = @_;
    open my $fh, '<', $fifo  or do {
        if ($! == ENOENT) {
            say "No file $fifo -- no new data, carry on and use default";
            return;
        }
        else { die "Can't open fifo $fifo: $!" }  # some other error
    };
    return join '', <$fh>;
}

