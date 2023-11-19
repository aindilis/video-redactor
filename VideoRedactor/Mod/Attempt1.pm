package VideoRedactor::Mod::Attempt1;

# see also Corpus::Mod::UniLang

use KBS2::Util;

use PerlLib::CaseTypeConversion;
use PerlLib::SwissArmyKnife;

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
  my $res1 = $UNIVERSAL::agent->QueryAgent
    (
     Receiver => $args{Agent} || 'Agent1',
     Data => {
	      Eval => [
		       ['_prolog_list',
			Var('?Results'),
			['redactedAtoms',Var('?Results')]
		       ]
		      ]
	     },
    );
  if ($res1) {
    my $list = $res1->{Data}{Result}[1];
    shift @$list;
    print Dumper({Reloaded => $list});
    $self->GenRegexDeCamelCase(Strings => $list);
  } else {
    print "Nope\n";
  }
}

sub GenRegex {
  my ($self,%args) = @_;
  my @strings = @{$args{Strings}};
  my @con;
  push @strings, qw(andrew dougherty);
  foreach my $item (@strings) {
    $item =~ s/(\W)/\\$1/g;
    push @con, $item;
  }
  my $regex = '('.join("|",@con).')';
  print Dumper({Regex => $regex});
  $self->Regex(qr|$regex|i);
}

sub GenRegexDeCamelCase {
  my ($self,%args) = @_;
  my @strings = @{$args{Strings}};
  my @con;
  push @strings, qw(andrew dougherty);
  foreach my $item (@strings) {
    foreach my $word (split /\s+/, DeCamelCase(String => $item)) {
      $item =~ s/(\W)/\\$1/g;
      push @con, $word;
    }
  }
  my $regex = '('.join("|",@con).')';
  print Dumper({Regex => $regex});
  $self->Regex(qr|$regex|i);
}

sub RedactText {
  my ($self,%args) = @_;
  my $s = $args{String};
  my $regex = $self->Regex;
  print Dumper({Regex => $regex}) if $UNIVERSAL::debug;
  if ($s =~ $regex) {
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
