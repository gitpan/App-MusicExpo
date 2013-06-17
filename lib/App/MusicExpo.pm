package App::MusicExpo 0.001;
use v5.14;
use warnings;

use Audio::FLAC::Header qw//;
use HTML::Entities qw/encode_entities/;
use HTML::Template::Compiled qw//;
use Memoize qw/memoize/;
use MP3::Tag qw//;
use URI::Escape qw/uri_escape/;

use DB_File qw//;
use File::Basename qw/fileparse/;
use Fcntl qw/O_RDWR O_CREAT/;
use Getopt::Long;
use Storable qw/thaw freeze/;

##################################################

our $prefix='/music/';
our $cache='cache.db';
our $caching=1;
our $template='index.tmpl';

GetOptions (
  "template=s" => \$template,
  "prefix=s" => \$prefix,
  "cache=s" => \$cache,
  "caching!" => \$caching,
);


sub fix{
  utf8::decode($_[0]);
  encode_entities($_[0])
}

sub flacinfo{
  my $file=$_[0];
  my $flac=Audio::FLAC::Header->new($file);
  $file = $prefix . uri_escape scalar fileparse $file;

  freeze +{
	format => 'FLAC',
	title => fix ($flac->tags('TITLE') // '?'),
	artist => fix ($flac->tags('ARTIST') // '?'),
	year => fix ($flac->tags('DATE') // '?'),
	album => fix ($flac->tags('ALBUM') // '?'),
	tracknumber => fix ($flac->tags('TRACKNUMBER') // '?'),
	tracktotal => fix ($flac->tags('TRACKTOTAL') // '?'),
	genre => fix ($flac->tags('GENRE') // '?'),
	path => $file,
  }
}

sub mp3info{
  my $file=$_[0];
  my $mp3=MP3::Tag->new($file);
  $file = $prefix . uri_escape scalar fileparse $file;

  freeze +{
	format => 'MP3',
	title => fix ($mp3->title || '?'),
	artist => fix ($mp3->artist || '?'),
	year => fix ($mp3->year || '?'),
	album => fix ($mp3->album || '?'),
	tracknumber => fix ($mp3->track1 || '?'),
	tracktotal => fix ($mp3->track2 || '?'),
	genre => fix ($mp3->genre) || '?',
	path => $file,
  }
}

sub normalizer{
  "$_[0]|".(stat $_[0])[9]
}

sub run {
  tie my %cache, 'DB_File', $cache, O_RDWR|O_CREAT, 0644 if $caching;
  memoize 'flacinfo', NORMALIZER => \&normalizer, LIST_CACHE => 'MERGE', SCALAR_CACHE => [HASH => \%cache] if $caching;
  memoize 'mp3info' , NORMALIZER => \&normalizer, LIST_CACHE => 'MERGE', SCALAR_CACHE => [HASH => \%cache] if $caching;

  my @files;
  for my $file (@ARGV) {
	push @files, thaw flacinfo $file if $file =~ /.flac$/i;
	push @files, thaw mp3info $file if $file =~ /.mp3$/i;
  }

  my $ht=HTML::Template::Compiled->new(filename => $template);
  $ht->param(files=>[sort { $a->{title} cmp $b->{title} } @files]);
  print $ht->output;
}

1;

__END__

=head1 NAME

App::MusicExpo - script which generates a HTML table of music tags

=head1 SYNOPSIS

  use App::MusicExpo;
  App::MusicExpo->run;

=head1 DESCRIPTION

App::MusicExpo creates a HTML table from a list of songs.

The default template looks like:

    | Title   | Artist  | Album           | Genre   | Track | Year | Type |
    |---------+---------+-----------------+---------+-------+------+------|
    | Cellule | Silence | L'autre endroit | Electro | 01/09 | 2005 | FLAC |

where the title is a download link.

=head1 OPTIONS

=over

=item B<--template> I<template>

Path to the HTML::Template::Compiled template used for generating the music table. Defaults to 'index.tmpl'.

=item B<--prefix> I<prefix>

Prefix for download links. Defaults to '/music/'.

=item B<--cache> I<filename>

Path to the cache file. Created if it does not exist. Defaults to 'cache.db'

=item B<--caching>, B<--no-caching>

Enables or disables caching. Defaults to B<--caching>

=back

=head1 AUTHOR

Marius Gavrilescu, E<lt>marius@ieval.roE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Marius Gavrilescu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.
