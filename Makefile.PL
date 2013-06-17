use 5.014002;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'App::MusicExpo',
    VERSION_FROM  => 'lib/App/MusicExpo.pm',
    PREREQ_PM     => {
	  'Audio::FLAC::Header'      => 0,
	  'HTML::Entities'           => 0,
	  'HTML::Template::Compiled' => 0,
	  'Memoize'                  => 0,
	  'MP3::Tag'                 => 0,
	  'URI::Escape'              => 0,
	},
	LICENSE       => 'perl',
	ABSTRACT_FROM => 'lib/App/MusicExpo.pm',
	AUTHOR        => 'Marius Gavrilescu <marius@ieval.ro>',
);
