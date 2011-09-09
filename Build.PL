use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    dist_name         => 'FuzzyRecongiser',
    module_name	      => 'EBI::FGPT::FuzzyRecogniser',
    license             => 'gpl',
    dist_author         => q{Emma Hastings <ehastings@cpan.org>},
    dist_version => '0.01',
    dist_abstract => 'A set of modules and scripts for parsing OWL ontologies',
    configure_requires => { 
    	'Module::Build' => 0.38 
    },
    build_requires => {
    	'Test::More' => 0,
    	'File::Temp' => 0,
    },
    requires => {
		'Moose' => '0.89',
		'Log::Log4perl' => 0,
		'List::Util' => 0,
		'XML::Parser' => '2.34',
    },
    recommends => {
    	'IO::File' => 0,
		'IO::Handle' => 0,
		'Getopt::Long' => 0,
    	'GO::Parser' => 0,
    	'Benchmark' => 0,
		#'Text::LevenshteinXS' => 0,
    },
    #script_files        => ['scripts/similarity_match.pl'],
    add_to_cleanup      => [ 'FuzzyRecongiser-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
