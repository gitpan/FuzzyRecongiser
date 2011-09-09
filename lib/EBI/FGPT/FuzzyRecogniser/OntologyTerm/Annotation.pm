
=head1 NAME

EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation;

    my $foo = EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation->new();


=head1 AUTHOR

Emma Hastings, C<< <emma at ebi.ac.uk> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EBI-FGPT-FuzzyRecogniser-OntologyTerm-Annotation>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Annotation>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Annotation>

=item * Search CPAN

L<http://search.cpan.org/dist/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Annotation/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 Emma Hastings.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

package EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation;

use lib 'C:\strawberry\perl\site\lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

use Moose;

our $VERSION = 0.01;



has 'value' => (
	is  => 'rw',
	isa => 'Str',
);

has 'normalised_value' => ( is => 'ro',
							 isa => 'HashRef', 
							 lazy_build => 1 );

sub _build_normalised_value {
	my $self = shift;
	return normalise( $self->value );
}

sub normalise {
	my $string = shift;
	$string = lc($string);
	my $q = 2;

	my $ngram;

	# pad the string
	for ( 1 .. $q - 1 ) {
		$string = '^' . $string;
		$string = $string . '$';
	}

	# split ito ngrams
	for my $i ( 0 .. length($string) - $q ) {
		$ngram->{ substr( $string, $i, $q ) }++;
	}

	return $ngram;
}

1;    # End of EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation
