package API::Tables;
use Dancer ':syntax';
use Spreadsheet::HTML;

our $VERSION = '0.1';
our $generator = Spreadsheet::HTML->new( indent => '  ' );

get '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw(generate landscape portrait);
    $style = 'generate' unless $valid{$style};
    content_type 'text/plain';
    return $generator->$style([0..3],[4..7],[8..11]);
};

true;
