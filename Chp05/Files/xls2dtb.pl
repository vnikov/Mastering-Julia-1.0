#! /usr/local/ActivePerl-5.20/bin/perl

use strict; 
use warnings;

use DBI;
use Spreadsheet::ParseExcel;

die "usage: $0 <xlsfile> <dtbfile>" unless $#ARGV == 1;

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($ARGV[0]);
if (!defined $workbook) { die $parser->error(), ".\n"; }

my $dbfile = $ARGV[1];
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","")
	or die "Couldn't connect to database: " . DBI->errstr;

my $ddl = "drop table if exists Quotes";
$dbh->do($ddl);

$ddl = "create table Quotes (ID integer primary key,\n";
$ddl .= "Category varchar(50),\n";
$ddl .= "Author   varchar(50),\n";
$ddl .= "Quote    varchar(250) not null)";
$dbh->do($ddl);

my $id  = 0;
for my $worksheet ( $workbook->worksheets() ) {
    my ( $row_min, $row_max ) = $worksheet->row_range();
    my ( $col_min, $col_max ) = $worksheet->col_range();
    for my $row ( $row_min .. $row_max ) {
        $id++;
        my $ddl = 'insert into Quotes values('.$id;
        for my $col ( $col_min .. $col_max ) {
            my $cell = $worksheet->get_cell( $row, $col );
            my $value = '.';
            $value = trim($cell->value()) if $cell;
            $value =~ s/\'/\'\'/g;
            $ddl .= $value eq '.' ? ',null' : ",'$value'";
        }
        $ddl .= ')';
        # print "$ddl\n";
        $dbh->do($ddl);
    }
}
$dbh->disconnect;
exit;

sub trim {
  my $s = shift;
  $s =~ s/^\s+|\s+$//g;
  return $s;
}

