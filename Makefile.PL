use 5.014;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'App::MusicExpo',
    VERSION       => '0.001001',
    PREREQ_PM     => {
	  'Audio::FLAC::Header'      => 0,
	  'HTML::Entities'           => 0,
	  'HTML::Template::Compiled' => 0,
	  'Memoize'                  => 0,
	  'MP3::Tag'                 => 0,
	  'URI::Escape'              => 0,
	  'DB_File'                  => 0,
	},
	MIN_PERL_VERSION => 5.014,
	EXE_FILES     => [ 'musicexpo' ],
	LICENSE       => 'perl',
	ABSTRACT_FROM => 'lib/App/MusicExpo.pm',
	AUTHOR        => 'Marius Gavrilescu <marius@ieval.ro>',
);
