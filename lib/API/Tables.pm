package API::Tables;
use Dancer2;

use Data::Dumper;
use Spreadsheet::HTML;
#use JSON;

our $VERSION = '0.1';
our $generator = Spreadsheet::HTML->new();

hook 'before' => sub {
    response_header('Access-Control-Allow-Origin' => 'https://www.unlocalhost.com');
};

get '/beadwork' => sub {
    my @valid = qw( preset art map bgcolor jquery scroll by bx bgdirection );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->beadwork( @params, table => {class=>"table table-bordered"} ) };
};

get '/conway' => sub {
    my @valid = qw( wechsler pad size on off colors fade interval alpha block jquery );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->conway( @params, table => {class=>"table table-bordered"} ) };
};

get '/sudoku' => sub {
    my @valid = qw( blanks attempts jquery );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->sudoku( @params ) };
};

# curl -d '{"data":[["foo","bar","baz"],[1,2,3]]}' -H "Content-Type: application/json" -X POST http://jeffa.unlocalhost.com/landscape
any ['get', 'post'] => '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw( generate landscape portrait );
    $style = 'generate' unless $valid{$style};
    my @valid = qw( data block blend alpha jquery );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    if (defined(params->{file})) {
        my $data = request->upload('file');
        push( @params, ( file => $data->tempname ) );
    }
    return { spreadsheet => $generator->$style( @params ) };
};

true;
