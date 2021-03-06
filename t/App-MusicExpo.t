#!/usr/bin/perl -wT
use v5.14;
use warnings;

use Test::More tests => 37;

use Storable qw/thaw/;

BEGIN { use_ok('App::MusicExpo'); }

my $flacinfo = thaw App::MusicExpo::flacinfo 'empty.flac';
my $mp3info = thaw App::MusicExpo::mp3info 'empty.mp3';
my $vorbisinfo = thaw App::MusicExpo::vorbisinfo 'empty.ogg';
my $mp4info = thaw App::MusicExpo::mp4info 'empty.aac';

is $flacinfo->{format}, 'FLAC', 'flacinfo format';
is $flacinfo->{title}, 'Cellule', 'flacinfo title';
is $flacinfo->{artist}, 'Silence', 'flacinfo artist';
is $flacinfo->{year}, 2005, 'flacinfo year';
is $flacinfo->{album}, 'L\'autre endroit', 'flacinfo album';
is $flacinfo->{tracknumber}, '01', 'flacinfo tracknumber';
is $flacinfo->{tracktotal}, '09', 'flacinfo tracktotal';
is $flacinfo->{genre}, 'Electro', 'flacinfo genre';
is $flacinfo->{file}, 'empty.flac', 'flacinfo path';

is $mp3info->{format}, 'MP3', 'mp3info format';
is $mp3info->{title}, 'Cellule', 'mp3info title';
is $mp3info->{artist}, 'Silence', 'mp3info artist';
is $mp3info->{year}, 2005, 'mp3info year';
is $mp3info->{album}, 'L\'autre endroit', 'mp3info album';
is $mp3info->{tracknumber}, '01', 'mp3info tracknumber';
is $mp3info->{tracktotal}, '09', 'mp3info tracktotal';
is $mp3info->{genre}, 'Electro', 'mp3info genre';
is $mp3info->{file}, 'empty.mp3', 'mp3info path';

is $vorbisinfo->{format}, 'Vorbis', 'vorbisinfo format';
is $vorbisinfo->{title}, 'Cellule', 'vorbisinfo title';
is $vorbisinfo->{artist}, 'Silence', 'vorbisinfo artist';
is $vorbisinfo->{year}, 2005, 'vorbisinfo year';
is $vorbisinfo->{album}, 'L\'autre endroit', 'vorbisinfo album';
is $vorbisinfo->{tracknumber}, '01', 'vorbisinfo tracknumber';
is $vorbisinfo->{tracktotal}, '09', 'vorbisinfo tracktotal';
is $vorbisinfo->{genre}, 'Electro', 'vorbisinfo genre';
is $vorbisinfo->{file}, 'empty.ogg', 'vorbisinfo path';

is $mp4info->{format}, 'AAC', 'mp4info format';
is $mp4info->{title}, 'Cellule', 'mp4info title';
is $mp4info->{artist}, 'Silence', 'mp4info artist';
is $mp4info->{year}, 2005, 'mp4info year';
is $mp4info->{album}, 'L\'autre endroit', 'mp4info album';
is $mp4info->{tracknumber}, '1', 'mp4info tracknumber';
is $mp4info->{tracktotal}, '9', 'mp4info tracktotal';
is $mp4info->{genre}, 'Electro', 'mp4info genre';
is $mp4info->{file}, 'empty.aac', 'mp4info path';
