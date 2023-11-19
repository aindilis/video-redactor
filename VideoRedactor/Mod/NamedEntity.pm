package VideoRedactor::Mod::NamedEntity;

# see also Corpus::Mod::UniLang

use KBS2::Util;

use PerlLib::CaseTypeConversion;
use PerlLib::SwissArmyKnife;

use Lingua::EN::NamedEntity;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Regex /

  ];

sub init {
  my ($self,%args) = @_;
}

sub Start {
  my ($self,%args) = @_;
  $self->Reload(%args);
}

sub Stop {
  my ($self,%args) = @_;
}

sub Reload {
  my ($self,%args) = @_;
  print Dumper({TryingToReload => 1});
}

sub RedactText {
  my ($self,%args) = @_;
  my @entities = extract_entities($args{String});
  print Dumper
    ({
      Input => $args{String},
      Entities => \@entities,
     });
  if (scalar @entities) {
    return {
	    Success => 1,
	    Recommendation => 'redact',
	   };
  } else {
    return {
	    Success => 1,
	    Recommendation => 'do-not-redact',
	   };
  }
}

1;
