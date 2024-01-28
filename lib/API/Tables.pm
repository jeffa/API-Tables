package API::Tables;
use Dancer ':syntax';

use Data::Dumper;
use Spreadsheet::HTML;
use JSON;

our $VERSION = '0.1';
our $generator = Spreadsheet::HTML->new();


get '/conway' => sub {
    my @valid = qw(wechsler pad size on off colors fade interval alpha block jquery);
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->conway( @params ) };
};

get '/sudoku' => sub {
    my $blanks   = params->{blanks}   || 50;
    my $attempts = params->{attempts} || 3;
    return { board => $generator->sudoku( blanks => $blanks, attempts => $attempts ) };
};

# curl -d '{"data":[["foo","bar","baz"],[1,2,3]]}' -H "Content-Type: application/json" -X POST http://www.unlocalhost.com:3000/landscape
post '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw(generate landscape portrait);
    $style = 'generate' unless $valid{$style};
    return { spreadsheet => $generator->$style( data => params->{data} ) };
};

true;
