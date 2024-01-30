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
    #header('Access-Control-Allow-Origin' => '*');
    return { board => $generator->conway( @params ) };
};

get '/sudoku' => sub {
    my @valid = qw(blanks attempts jquery);
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    my $blanks   = params->{blanks}   || 50;
    my $attempts = params->{attempts} || 3;
    #header('Access-Control-Allow-Origin' => '*');
    return { board => $generator->sudoku( @params ) };
};

# curl -d '{"data":[["foo","bar","baz"],[1,2,3]]}' -H "Content-Type: application/json" -X POST http://www.unlocalhost.com:3000/landscape
post '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw(generate landscape portrait);
    $style = 'generate' unless $valid{$style};
    #header('Access-Control-Allow-Origin' => '*');
    return { spreadsheet => $generator->$style( data => params->{data} ) };
};

true;
