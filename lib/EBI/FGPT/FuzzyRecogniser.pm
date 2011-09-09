
=head1 NAME

EBI::FGPT::FuzzyRecogniser 

=head1 SYNOPSIS

The module EBI::FGPT::FuzzyRecogniser takes in the constructor an ontology file (OWL/OBO/OMIM/MeSH) 
and parses it into an internal table of ontology terms (type of EBI::FGPT::FuzzyRecogniser::OntologyTerm). 



Perhaps a little code snippet.

    use EBI::FGPT::FuzzyRecogniser;

    my $foo = EBI::FGPT::FuzzyRecogniser->new();
    ...


=head1 AUTHOR

Emma Hastings , C<< <emma at ebi.ac.uk> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EBI::FGPT::FuzzyRecogniser


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EBI-FGPT-FuzzyRecogniser>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/EBI-FGPT-FuzzyRecogniser>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/EBI-FGPT-FuzzyRecogniser>

=item * Search CPAN

L<http://search.cpan.org/dist/EBI-FGPT-FuzzyRecogniser/>

=back


=head1 ACKNOWLEDGEMENTS

Tomasz Adamusiak <tomasz@cpan.org>
 
=head1 COPYRIGHT & LICENSE

Copyright 2011 emma.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

package EBI::FGPT::FuzzyRecogniser;

use lib 'C:\strawberry\perl\site\lib',
  'C:/Users/emma.EBI/Fuzzy/cpan-distribution/FuzzyRecogniser/lib',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib/perl5/site_perl/',
  '/ebi/microarray/ma-subs/AE/subs/PERL_SCRIPTS/local/lib64/perl5/site_perl/';

use Moose;

use IO::File;
use Getopt::Long;

use GO::Parser;
use OWL::Simple::Parser 1.00;
use MeSH::Parser::ASCII 0.02;
use Bio::Phenotype::OMIM::OMIMparser;
use EBI::FGPT::FuzzyRecogniser::OntologyTerm;
use EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation;
use EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label;
use EBI::FGPT::FuzzyRecogniser::OntologyTerm::Synonym;
use Log::Log4perl qw(:easy);
use IO::Handle;
use Benchmark ':hireswallclock';

use List::Util qw{min max};

use Data::Dumper;

our $VERSION = 0.01;

Log::Log4perl->easy_init( { level => $INFO, layout => '%-5p - %m%n' } );

# module attributes

has 'meshfile' => ( is => 'rw', isa => 'Str' );
has 'obofile'  => ( is => 'rw', isa => 'Str' );
has 'owlfile'  => ( is => 'rw', isa => 'Str' );
has 'omimfile' => ( is => 'rw', isa => 'Str' );

my @ontology_terms;

sub BUILD {

	my $self = shift;

	# ensure ontology files have been supplied

	unless ( $self->obofile()
		|| $self->owlfile()
		|| $self->meshfile()
		|| $self->omimfile() )
	{
		LOGDIE "No ontology file supplied";
	}

	INFO "Parsing file ";

	#establishes ontology object and passes it to
	#relevantparser

	parseOWL( $self->owlfile )   if $self->owlfile;
	parseOBO( $self->obofile )   if $self->obofile;
	parseMeSH( $self->meshfile ) if $self->meshfile;
	parseOMIM( $self->omimfile ) if $self->omimfile;
}

=item find_match()

Finds the best match for the supplied term in the ontology.

=cut

sub find_match($) {
	my ($self, $string_to_match) = @_;

	# terms array was already prenormalised earlier
	my $annotationToMatch =  EBI::FGPT::FuzzyRecogniser::OntologyTerm::Annotation->new(value => $string_to_match);
	

	my $matched_term;
	my $matched_acc;
	my $type;
	my $max_similarity = undef;

	for my $term (@ontology_terms) {
		for my $annotation ( @{ $term->annotations } ) {

			my $similarity =
			  $term->get_similarity( $annotation->normalised_value(), $annotationToMatch->normalised_value() );
			if ( !( defined $max_similarity ) || $similarity > $max_similarity ) {
				$max_similarity = $similarity;
				$matched_term   = $term->label();
				$matched_acc    = $term->accession();
				$type           = ref($annotation);
			}
		}

	}

	return {
		term => $matched_term,
		acc  => $matched_acc,
		sim  => $max_similarity,
		type => $type,
	};
}



=item createOntologyTerm()

Creates an OntologyTerm object given its accession and annotations

=cut

sub createOntologyTerm($$@) {
	my ( $accession, $label, @synonyms ) = @_;

	# Create annotation array
	my @annotations;

	# Create label
	my $label_annot = EBI::FGPT::FuzzyRecogniser::OntologyTerm::Label->new(value => $label);
	
	# Add label to annotations
	# NOTE stored twice for convenience, see label field
	push @annotations, $label_annot;

	# Create synonym annotations
	for my $value (@synonyms) {
		# Create synonym
		my $synonym = EBI::FGPT::FuzzyRecogniser::OntologyTerm::Synonym->new( value => $value);

		# Add synonym to term's annotations
		push @annotations, $synonym;
	}

	return EBI::FGPT::FuzzyRecogniser::OntologyTerm->new(
		accession   => $accession,
		label       => $label,
		annotations => \@annotations,
	);
}

=item parseMeSH()

Custom MeSH parser for the MeSH ASCII format.

=cut

sub parseMeSH($) {
	my ($file) = @_;
	my $term;
	INFO "Parsing MeSH file $file ...";

	my $parser = MeSH::Parser::ASCII->new( meshfile => $file );

	# parse the file
	$parser->parse();

	# loop through all the headings
	while ( my ( $id, $heading ) = each %{ $parser->heading } ) {
		my $accession = $heading->id();
		my $label     = $heading->label();
		my @synonyms  = $heading->synonyms();
		my $term      = createOntologyTerm( $accession, $label, @synonyms );

		# Add term to ontology_terms array
		push @ontology_terms, $term;
	}
}

=item parseMeSH()

Custom OMIM parser.

=cut

sub parseOMIM($) {
	my ($file) = @_;
	INFO "Parsing OMIM file $file ...";

	my $synonym_count;

	# FIXME: The external parser is suboptimal in many ways
	# if this becomes more often used consider creating
	# a custom one from sratch
	my $parser = Bio::Phenotype::OMIM::OMIMparser->new( -omimtext => $file );

	# loop through all the records
	while ( my $omim_entry = $parser->next_phenotype() ) {

		# *FIELD* NO
		my $id = $omim_entry->MIM_number();
		$id = 'OMIM:' . $id;

		# *FIELD* TI - first line
		my $title = $omim_entry->title();
		$title =~ s/^.\d+ //;       # remove id from title
		$title =~ s/INCLUDED//g;    # remove INCLUDED as it screws up scoring

		# *FIELD* TI - additional lines
		my $alt = $omim_entry->alternative_titles_and_symbols();

		# OMIM uses this weird delimiter ;;
		# to signal sections irrespective of actual line endings
		# this is a major headache to resolve, the parser doesn't
		# do this and we're not going to bother with it either
		$alt =~ s/;;//g;
		$alt =~ s/INCLUDED//g;      # remove INCLUDED as it screws up scoring
		my @synonyms = split m!\n!, $alt;

		# if alt doesn't start with ;; it's an overspill from the
		# title (go figure!)
		if (   $alt ne ''
			&& $omim_entry->alternative_titles_and_symbols() !~ /^;;/ )
		{
			$title .= shift @synonyms;
		}

		# Instantiate new ontology term

		my $term = createOntologyTerm( $id, $title, @synonyms );

		# Add term to ontology_terms array
		push @ontology_terms, $term;

		$synonym_count += scalar @synonyms;

	}

}

=item parseOBO()

Custom OBO parser.

=cut

sub parseOBO($) {
	my $file = shift;
	INFO "Parsing obo file $file ...";
	my $parser = new GO::Parser( { handler => 'obj' } );
	$parser->parse($file);
	my $graph = $parser->handler->graph();

	# load terms into hash
	my $class_count;
	my $synonym_count;

	for my $OBOclass ( @{ $graph->get_all_terms() } ) {
		if ( $OBOclass->is_obsolete ) {
			INFO $OBOclass->public_acc() . ' obsoleted';
			next;
		}
		$class_count++;
		$synonym_count += scalar( @{ $OBOclass->synonym_list() } );

		# Instantiate new ontology term
		my $accession = $OBOclass->public_acc();
		my $label     = $OBOclass->name();
		my @synonyms  = @{ $OBOclass->synonym_list() };
		my $term      = createOntologyTerm( $accession, $label, @synonyms );

		# Add term to ontology_terms array
		push @ontology_terms, $term;
	}

	INFO "Loaded " . $class_count . " classes and " . $synonym_count . " synonyms";

}

=item parseOWL()

Custom OWL parser.

=cut

sub parseOWL($) {
	my ($file) = @_;
	INFO "Parsing owl file $file ...";
	my $parser;

	# invoke parser
	$parser = OWL::Simple::Parser->new( owlfile => $file );

	# parse file
	$parser->parse();

	while ( my ( $id, $OWLClass ) = each %{ $parser->class } ) {
		unless ( defined $OWLClass->label ) {
			WARN "Undefined label in $id";
		}
		elsif ( $OWLClass->label =~ /obsolete/ ) {
			next;
		}

		# Instantiate new ontology term
		my $accession = $OWLClass->id();
		my $label     = $OWLClass->label();
		my @synonyms  = @{ $OWLClass->synonyms() }; 

		my $term = createOntologyTerm( $accession, $label, @synonyms );

		# Add term to ontology_terms array
		push @ontology_terms, $term;
	}

}
1;    # End of EBI::FGPT::FuzzyRecogniser
