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
<tr><td><a href="%2Fmusic%2Fempty.flac">Cellule</a><td>Silence<td>L&#39;autre endroit<td>Electro<td>01/09<td>2005<td>FLAC
<tr><td><a href="%2Fmusic%2Fempty.mp3">Cellule</a><td>Silence<td>L&#39;autre endroit<td>Electro<td>01/09<td>2005<td>MP3
</table>
OUT

ok -e $file, 'cache exists';
tie my %db, DB_File => $file;
