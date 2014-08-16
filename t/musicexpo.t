#!/usr/bin/perl -wT
use v5.14;
use warnings;

use Test::More tests => 2;

use Storable qw/thaw/;

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
</table>

<pre id="json" style="display: none">{"files":[],"prefix":"/music/"}</pre>
OUT
