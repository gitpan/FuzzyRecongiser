#!perl

use lib 'C:\strawberry\perl\site\lib',
  'C:/Users/emma.EBI/Fuzzy/cpan-distribution/FuzzyRecogniser/lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

use Test::More tests => 2;


use EBI::FGPT::FuzzyRecogniser;
use EBI::FGPT::FuzzyRecogniser::OntologyTerm;


my $fuzzy = EBI::FGPT::FuzzyRecogniser->new(owlfile => 'owl.txt');    # create an object
ok( defined $fuzzy, 'new() returned something' )
  ;    # check that we got something
ok( $fuzzy->isa('EBI::FGPT::FuzzyRecogniser'), "  and it's the right class" )
  ;    # and it's the right class

use Data::Dumper;
print Dumper( $fuzzy->find_match("ahjhenohhcarcinoma") );

  
  