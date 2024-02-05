#!/usr/bin/env perl
use strict;
use warnings;
use Template;

my @files = qw(
    beadwork.html
    conway.html
    image.html
    sudoku.html
);

my $tt = Template->new;

for my $file (@files) {
    $tt->process("frontend/$file", {}, "$ENV{API_DEMO_HOME}/$file") || die $tt->error(), "\n";
    warn "deployed $file to $ENV{API_DEMO_HOME}\n";
}

#cp frontend/*.html $API_DEMO_HOME
