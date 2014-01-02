package App::MusicExpo;
use v5.14;
use strict;
use warnings;

our $VERSION = 0.003001;

use Audio::FLAC::Header qw//;
use HTML::Template::Compiled qw//;
use Memoize qw/memoize/;
use MP3::Tag qw//;
use Ogg::Vorbis::Header::PurePerl;

use DB_File qw//;
use File::Basename qw/fileparse/;
use Fcntl qw/O_RDWR O_CREAT/;
use Getopt::Long;
use Storable qw/thaw freeze/;

##################################################

my $default_template;

our $prefix='/music/';
our $cache='';
our $template='';

GetOptions (
  "template=s" => \$template,
  "prefix=s" => \$prefix,
  "cache=s" => \$cache,
);


sub fix{
  my $copy = $_[0];
  utf8::decode($copy);
  $copy
}

sub flacinfo{
  my $file=$_[0];
  my $flac=Audio::FLAC::Header->new($file);
  $file = scalar fileparse $file;

  freeze +{
	format => 'FLAC',
	title => fix ($flac->tags('TITLE') // '?'),
	artist => fix ($flac->tags('ARTIST') // '?'),
	year => fix ($flac->tags('DATE') // '?'),
	album => fix ($flac->tags('ALBUM') // '?'),
	tracknumber => fix ($flac->tags('TRACKNUMBER') // '?'),
	tracktotal => fix ($flac->tags('TRACKTOTAL') // '?'),
	genre => fix ($flac->tags('GENRE') // '?'),
	file => $file,
  }
}

sub mp3info{
  my $file=$_[0];
  my $mp3=MP3::Tag->new($file);
  $file = scalar fileparse $file;

  freeze +{
	format => 'MP3',
	title => fix ($mp3->title || '?'),
	artist => fix ($mp3->artist || '?'),
	year => fix ($mp3->year || '?'),
	album => fix ($mp3->album || '?'),
	tracknumber => fix ($mp3->track1 || '?'),
	tracktotal => fix ($mp3->track2 || '?'),
	genre => fix ($mp3->genre) || '?',
	file => $file,
  }
}

sub vorbisinfo{
  my $file=$_[0];
  my $ogg=Ogg::Vorbis::Header::PurePerl->new($file);
  $file = scalar fileparse $file;

  freeze +{
	format => 'Vorbis',
	title => fix($ogg->comment('TITLE') || '?'),
	artist => fix ($ogg->comment('artist') || '?'),
	year => fix ($ogg->comment('DATE') || '?'),
	album => fix ($ogg->comment('ALBUM') || '?'),
	tracknumber => fix ($ogg->comment('TRACKNUMBER') || '?'),
	tracktotal => fix ($ogg->comment('TRACKTOTAL') || '?'),
	genre => fix ($ogg->comment('GENRE')) || '?',
	file => $file,
  }
}

sub normalizer{
  "$_[0]|".(stat $_[0])[9]
}

sub run {
  tie my %cache, 'DB_File', $cache, O_RDWR|O_CREAT, 0644 unless $cache eq '';
  memoize 'flacinfo', NORMALIZER => \&normalizer, LIST_CACHE => 'MERGE', SCALAR_CACHE => [HASH => \%cache] unless $cache eq '';
  memoize 'mp3info' , NORMALIZER => \&normalizer, LIST_CACHE => 'MERGE', SCALAR_CACHE => [HASH => \%cache] unless $cache eq '';
  memoize 'vorbisinfo' , NORMALIZER => \&normalizer, LIST_CACHE => 'MERGE', SCALAR_CACHE => [HASH => \%cache] unless $cache eq '';

  my %files;
  for my $file (@ARGV) {
	my $info;
	$info = thaw flacinfo $file if $file =~ /.flac$/i;
	$info = thaw mp3info $file if $file =~ /.mp3$/i;
	$info = thaw vorbisinfo $file if $file =~ /.og(?:g|a)$/i;
	next unless defined $info;
	my $basename = fileparse $file, '.flac', '.mp3', '.ogg', '.oga';
	$files{$basename} //= [];
	push $files{$basename}, $info;
  }

  my $ht=HTML::Template::Compiled->new(
	default_escape => 'HTML',
	global_vars => 2,
	$template eq '' ? (scalarref => \$default_template) : (filename => $template),
  );

  my @files;
  for (values %files) {
	my @versions = @$_;
	my %entry = (%{$versions[0]}, formats => []);
	push $entry{formats}, {format => $_->{format}, file => $_->{file}} for @versions;
	push @files, \%entry
  }

  $ht->param(files=>[sort { $a->{title} cmp $b->{title} } @files], prefix => $prefix);
  print $ht->output;
}

$default_template = <<'HTML';
<!DOCTYPE html>
<title>Music</title>
<meta charset="utf-8">
<link rel="stylesheet" href="/music.css">

<table border>
<thead>
<tr><th>Title<th>Artist<th>Album<th>Genre<th>Track<th>Year<th>Type
<tbody><tmpl_loop files>
<tr><td><a href=<tmpl_var title><td><tmpl_var artist><td><tmpl_var album><td><tmpl_var genre><td><tmpl_var tracknumber>/<tmpl_var tracktotal><td><tmpl_var year><td><tmpl_loop formats><a href="<tmpl_var ...prefix><tmpl_var ESCAPE=URL file>"><tmpl_var format></a> </tmpl_loop></tmpl_loop>
</table>
HTML

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

where the type is a download link. If you have multiple files with the same
basename (such as C<cellule.flac> and C<cellule.ogg>), they will be treated
as two versions of the same file, so a row will be created with two download
links, one for each format.

=head1 OPTIONS

=over

=item B<--template> I<template>

Path to the HTML::Template::Compiled template used for generating the music table. If '' (empty), uses the default format. Is empty by default.

=item B<--prefix> I<prefix>

Prefix for download links. Defaults to '/music/'.

=item B<--cache> I<filename>

Path to the cache file. Created if it does not exist. If '' (empty), disables caching. Is empty by default.

=back

=head1 AUTHOR

Marius Gavrilescu, E<lt>marius@ieval.roE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Marius Gavrilescu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.
