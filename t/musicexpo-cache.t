#!/usr/bin/perl -wT
use v5.14;
use warnings;

use Test::More tests => 3;

use File::Temp qw/tempfile/;
use DB_File;
use Storable qw/thaw/;

my $file;

BEGIN {
  $file = (tempfile UNLINK => 1)[1];
  @ARGV = (-cache => $file, 'empty.flac', 'empty.mp3');
}
BEGIN { use_ok('App::MusicExpo'); }

close STDOUT;
my $out;
open STDOUT, '>', \$out;

App::MusicExpo->run;

is $out, <<'OUT', 'output is correct';
<!DOCTYPE html>
<title>Music</title>
<meta charset="utf-8">
<link rel="stylesheet" href="/music.css">

<table border>
<thead>
<tr><th>Title<th>Artist<th>Album<th>Genre<th>Track<th>Year<th>Type
<tbody>
<tr><td>Cellule<td>Silence<td>L&#39;autre endroit<td>Electro<td>01/09<td>2005<td><a href="/music/empty.flac">FLAC</a> <a href="/music/empty.mp3">MP3</a> 
</table>

<pre id="json" style="display: none">{"files":[{"album":"L'autre endroit","artist":"Silence","file":"empty.flac","format":"FLAC","formats":[{"file":"empty.flac","format":"FLAC"},{"file":"empty.mp3","format":"MP3"}],"genre":"Electro","title":"Cellule","tracknumber":"01","tracktotal":"09","year":"2005"}],"prefix":"/music/"}</pre>
OUT

ok -e $file, 'cache exists';
tie my %db, DB_File => $file;
