#!/usr/bin/perl -wT
use v5.14;
use warnings;

use Test::More tests => 19;

use Storable qw/thaw/;

BEGIN { use_ok('App::MusicExpo'); }

$App::MusicExpo::caching = 0;

my $flacinfo = thaw App::MusicExpo::flacinfo 'empty.flac';
my $mp3info = thaw App::MusicExpo::mp3info 'empty.mp3';

is $flacinfo->{format}, 'FLAC', 'flacinfo format';
is $flacinfo->{title}, 'Cellule', 'flacinfo title';
is $flacinfo->{artist}, 'Silence', 'flacinfo artist';
is $flacinfo->{year}, 2005, 'flacinfo year';
is $flacinfo->{album}, 'L&#39;autre endroit', 'flacinfo album';
is $flacinfo->{tracknumber}, '01', 'flacinfo tracknumber';
is $flacinfo->{tracktotal}, '09', 'flacinfo tracktotal';
is $flacinfo->{genre}, 'Electro', 'flacinfo genre';
is $flacinfo->{path}, '/music/empty.flac', 'flacinfo path';

is $mp3info->{format}, 'MP3', 'mp3info format';
is $mp3info->{title}, 'Cellule', 'mp3info title';
is $mp3info->{artist}, 'Silence', 'mp3info artist';
is $mp3info->{year}, 2005, 'mp3info year';
is $mp3info->{album}, 'L&#39;autre endroit', 'mp3info album';
is $mp3info->{tracknumber}, '01', 'mp3info tracknumber';
is $mp3info->{tracktotal}, '09', 'mp3info tracktotal';
is $mp3info->{genre}, 'Electro', 'mp3info genre';
is $mp3info->{path}, '/music/empty.mp3', 'mp3info path';
