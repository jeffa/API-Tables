package API::Tables;
use Dancer ':syntax';
use Spreadsheet::HTML;
use JSON;

our $VERSION = '0.1';
our $generator = Spreadsheet::HTML->new();

# curl -d '{"data":[["foo","bar","baz"],[1,2,3]]}' -H "Content-Type: application/json" -X POST http://www.unlocalhost.com:3000/landscape

post '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw(generate landscape portrait);
    $style = 'generate' unless $valid{$style};
    return { table => $generator->$style( data => params->{data} ) };
};

true;
