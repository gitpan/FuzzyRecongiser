
=head1 NAME

EBI::FGPT::FuzzyRecogniser::OntologyTerm 


=head1 SYNOPSIS

EBI::FGPT::FuzzyRecogniser::OntologyTerm has three fields: accession,label and annotations. 
Annotations is an array containing synonyms (type of EBI::FGPT::!FuzzyRecogniser::OntologyTerm::Synonym) 

    use EBI::FGPT::FuzzyRecogniser::OntologyTerm;

    my $term = EBI::FGPT::FuzzyRecogniser::OntologyTerm->new();
    

=head1 AUTHOR

Emma Hastings, C<< <emma at ebi.ac.uk> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FuzzyRecogniser::OntologyTerm


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=FuzzyRecogniser-OntologyTerm>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/FuzzyRecogniser-OntologyTerm>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/FuzzyRecogniser-OntologyTerm>

=item * Search CPAN

L<http://search.cpan.org/dist/FuzzyRecogniser-OntologyTerm/>

=back


=head1 ACKNOWLEDGEMENTS

Tomasz Adamusiak <tomasz@cpan.org> 

=head1 COPYRIGHT & LICENSE

Copyright 2011 Emma Hastings.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

package EBI::FGPT::FuzzyRecogniser::OntologyTerm;

use warnings;
use strict;

use lib 'C:\strawberry\perl\site\lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

use Moose;
use List::Util qw{min max};

our $VERSION = 0.01;

has 'accession' => ( is => 'rw', isa => 'Str', required => 1 );
has 'label'     => ( is => 'rw', isa => 'Str', required => 1 );
has 'annotations' =>
  ( is => 'rw', isa => 'Any', required => 1 );
  
sub get_similarity($$) {
	my ( $self, $template, $other ) = @_;

	my $ngrams_matched = 0;

	for my $template_ngram ( keys %{$template} ) {
		$ngrams_matched++ if exists $other->{$template_ngram};
	}

	# normalise
	return int( $ngrams_matched / max( scalar keys %$template, scalar keys %$other ) * 100 );
}

1;    # End of FuzzyRecogniser::OntologyTerm
