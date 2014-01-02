use 5.014;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'App::MusicExpo',
  VERSION_FROM  => 'lib/App/MusicExpo.pm',
  PREREQ_PM     => {
	'Audio::FLAC::Header'           => 0,
	'HTML::Template::Compiled'      => 0,
	'Memoize'                       => 0,
	'MP3::Tag'                      => 1.12,
	'DB_File'                       => 0,
	'Ogg::Vorbis::Header::PurePerl' => 0,
  },
  MIN_PERL_VERSION => 5.014,
  SIGN          => 1,
  EXE_FILES     => [ 'musicexpo' ],
  LICENSE       => 'perl',
  ABSTRACT_FROM => 'lib/App/MusicExpo.pm',
  AUTHOR        => 'Marius Gavrilescu <marius@ieval.ro>',
  META_MERGE    => {
	resources   => {
	  repository => 'http://git.ieval.ro/?p=app-musicexpo.git'
	},
	dynamic_config => 0,
  }
);
