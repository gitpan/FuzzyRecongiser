
=head1 NAME

EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label - The great new EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label!

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label;

    my $label = EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label->new();

=head1 AUTHOR

Emma Hastings, C<< <emma at ebi.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ebi-fgpt-fuzzyrecogniser-ontologyterm-label at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=EBI-FGPT-FuzzyRecogniser-OntologyTerm-Label>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EBI-FGPT-FuzzyRecogniser-OntologyTerm-Label>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Label>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Label>

=item * Search CPAN

L<http://search.cpan.org/dist/EBI-FGPT-FuzzyRecogniser-OntologyTerm-Label/>

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

package EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label;

use Moose;
extends 'EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation';

use lib 'C:\strawberry\perl\site\lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

1;    # End of EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label
