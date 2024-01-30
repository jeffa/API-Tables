#!/usr/bin/env perl
use Dancer;
use API::Tables;
use File::Pid;
 
my $pidfile = File::Pid->new({ file => '/home/jeffa/api.pid' });
$pidfile->write;

dance;
