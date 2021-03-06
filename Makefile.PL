use inc::Module::Install;

RTx 'RT-Extension-MergeUsers';

repository('https://github.com/bestpractical/rt-extension-mergeusers');

my ($lib_path) = $INC{'RT.pm'} =~ /^(.*)[\\\/]/;
my $local_lib_path = "$RT::LocalPath/lib";

# Straight from perldoc perlvar
use Config;
my $secure_perl_path = $Config{perlpath};
if ($^O ne 'VMS') {
    $secure_perl_path .= $Config{_exe}
        unless $secure_perl_path =~ m/$Config{_exe}$/i;
}

substitute( {
        RT_LIB_PATH => join( ' ', $local_lib_path, $lib_path ),
        PERL        => $ENV{PERL} || $secure_perl_path,
    },
    { sufix => '.in' },
    'bin/rt-update-merged-users',
    'bin/rt-merge-users',
    'bin/rt-clean-merged-users',
    'lib/RT/Extension/MergeUsers/Test.pm',
);

no_index( package => 'RT::User', 'RT::Users', 'RT::Principal');

sign();
WriteAll();
