use 5.014000;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'App::MusicExpo',
	VERSION_FROM     => 'lib/App/MusicExpo.pm',
	ABSTRACT_FROM    => 'lib/App/MusicExpo.pm',
	AUTHOR           => 'Marius Gavrilescu <marius@ieval.ro>',
	EXE_FILES        => [ 'musicexpo' ],
	MIN_PERL_VERSION => 5.014,
	LICENSE          => 'perl',
	SIGN             => 1,
	PREREQ_PM        => {
		qw/Audio::FLAC::Header           0
		   HTML::Template::Compiled      0
		   Memoize                       0
		   MP3::Tag                      1.12
		   JSON::MaybeXS                 0
		   DB_File                       0
		   Ogg::Vorbis::Header::PurePerl 0/,
	},
	META_MERGE         => {
		dynamic_config => 0,
		resources      => {
			repository => 'http://git.ieval.ro/?p=app-musicexpo.git'
		},
	}
);
