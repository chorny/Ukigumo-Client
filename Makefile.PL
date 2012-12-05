use 5.010; #should be in both places
use ExtUtils::MakeMaker;

WriteMakefile1(
    NAME          => 'Ukigumo-Client',
    AUTHOR        => 'Tokuhiro Matsuno <tokuhirom+cpan@gmail.com>',
    VERSION_FROM  => 'lib/Ukigumo/Client.pm',
    ABSTRACT_FROM  => 'lib/Ukigumo/Client.pm',
	LICENSE => 'perl',
    PREREQ_PM     => {
		'LWP::UserAgent' => 6,
		'JSON' => 2,
		'Mouse' => 0,
		'File::HomeDir' => 0,
		'String::IRC' => 0,
		'Ukigumo::Common' => 0.03,
		'Time::Piece' => '1.15',
		'Capture::Tiny' => 0,
		'Encode::Locale' => 0,
		'URI::Escape' => 0,
		'Test::Requires' => 0,
    },
    #BUILD_REQUIRES => {
    #},
    META_MERGE => {
        resources => {
            repository => 'https://github.com/ukigumo/Ukigumo-Client',
        },
    },
    MIN_PERL_VERSION => '5.010000',
    (-d 'xt' and ($ENV{RELEASE_TESTING} || -d '.git')) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
	EXE_FILES => [ 'bin/ukigumo-client.pl' ]
);

sub WriteMakefile1 {  #Compatibility code for old versions of EU::MM. Written by Alexandr Ciornii, version 0.23. Added by eumm-upgrade.
    my %params=@_;
    my $eumm_version=$ExtUtils::MakeMaker::VERSION;
    $eumm_version=eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{AUTHOR} and ref($params{AUTHOR}) eq 'ARRAY' and $eumm_version < 6.5705) {
        $params{META_ADD}->{author}=$params{AUTHOR};
        $params{AUTHOR}=join(', ',@{$params{AUTHOR}});
    }
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;
    delete $params{AUTHOR} if $] < 5.005;
    delete $params{ABSTRACT_FROM} if $] < 5.005;
    delete $params{BINARY_LOCATION} if $] < 5.005;

    WriteMakefile(%params);
}
