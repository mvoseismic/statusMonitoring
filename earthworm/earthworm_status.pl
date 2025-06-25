#!/usr/bin/env perl
#
# Perl script to get earthworm status
#
# Version 1.0
# Rod Stewart, UWI/SRC/MVO, 2021-07-15
#
#


use strict;
use warnings;
use Time::Local;

my $command = '. /home/wwsuser/earthworm/run_mvo/params/ew_linux.bash;status';

my $now = `date -R`;
chomp $now;
print "$now\n";

my @status = `$command`;
print @status;

