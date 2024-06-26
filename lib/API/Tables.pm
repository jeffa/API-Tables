package API::Tables;
use Dancer2;

use Data::Dumper;
use Spreadsheet::HTML;
#use JSON;

our $VERSION = '0.1';
our $CORS = $ENV{API_Tables_CORS} || 'https://www.unlocalhost.com';
our $generator = Spreadsheet::HTML->new();

hook 'before' => sub {
    response_header('Access-Control-Allow-Origin' => $CORS);
};

get '/beadwork' => sub {
    my @valid = qw( preset art map bgcolor jquery scroll by bx bgdirection );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->beadwork( @params ) };
};

get '/conway' => sub {
    my @valid = qw( wechsler pad size on off colors fade interval block jquery );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->conway( @params, table => {class=>"table table-bordered"} ) };
};

get '/sudoku' => sub {
    my @valid = qw( blanks attempts jquery );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    return { board => $generator->sudoku( @params ) };
};

post '/upload' => sub {
    response_header('Access-Control-Allow-Origin' => 'https://www.unlocalhost.com');
    my $data = request->upload('file');
    unless ($data) {
        return { error => "file param not received" };
    }
 
    my $dir = path(config->{appdir}, 'uploads');
    mkdir $dir if not -e $dir;
 
    my $path = path($dir, $data->basename);
    if (-e $path) {
        return { error => "'$path' already exists" };
    }
    $data->link_to($path);
    return { success => "'$path' uploaded" };
};

# curl -d '{"data":[["foo","bar","baz"],[1,2,3]]}' -H "Content-Type: application/json" -X POST http://jeffa.unlocalhost.com/landscape
any ['get', 'post'] => '/*' => sub {
    my ($style) = splat;
    my %valid = map {$_=>1} qw( generate landscape portrait );
    $style = 'generate' unless $valid{$style};
    my @valid = qw( data block blend jquery indent encode encodes scroll );
    my @params = map { defined(params->{$_}) ? ( $_ => params->{$_} ) : () } @valid;
    if (defined(params->{file})) {
        my $data = request->upload('file');
        return { error => "file param not received" } unless $data;
        my $dir = path(config->{appdir}, 'uploads');
        mkdir $dir if not -e $dir;
        my $path = path($dir, $data->basename);
        $data->link_to($path);
        push( @params, ( file => $path ) );
    }
    return { spreadsheet => $generator->$style( @params ) };
};


true;
