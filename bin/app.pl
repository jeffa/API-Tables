#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Dancer2;
use API::Tables;
use File::Pid;
 
`rm -f /home/jeffa/api.pid`;
my $pidfile = File::Pid->new({ file => '/home/jeffa/api.pid' });
$pidfile->write;

API::Tables->to_app;
start;
