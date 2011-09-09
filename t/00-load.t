#!perl

use lib 'C:\strawberry\perl\site\lib',
  'C:/Users/emma.EBI/Fuzzy/cpan-distribution/FuzzyRecogniser/lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

use Test::More tests => 1;

BEGIN {
    use_ok( 'EBI::FGPT::FuzzyRecogniser' );
}

diag( "Testing EBI::FGPT::FuzzyRecogniser $EBI::FGPT::FuzzyRecogniser::VERSION, Perl $], $^X" );
