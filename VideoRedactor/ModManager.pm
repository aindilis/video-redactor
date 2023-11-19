package VideoRedactor::ModManager;

# see also Corpus::ModManager;
# see also VideoRedactor::Mod::Attempt1

use Manager::Dialog qw(Message);
use PerlLib::Collection;

use Time::HiRes qw( usleep );
use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw { Mods InvokedMods }

  ];

sub init {
  my ($self,%args) = @_;
  Message(Message => "Starting ModManager...");
  $self->InvokedMods
    ($args{Mods} || []);
  $self->Mods
    (PerlLib::Collection->new
     (Type => "VideoRedactor::Mod"));
  $self->Mods->Contents({});
  foreach my $mod (@{$self->InvokedMods}) {
    if (OneOf(Item => $mod,
	      Set => \@registeredmods)) {
      require "VideoRedactor/Mod/$mod.pm";
      my $a = "VideoRedactor::Mod::$mod"->new();
      $self->Mods->Add
	($mod => $a);
    }
  }
}

sub OneOf {
  return 1;
}

sub StartMods {
  my ($self,%args) = @_;
  Message(Message => "Starting mods...");
  foreach my $mod ($self->Mods->Values) {
    $mod->Start;
  }
}

sub StopMods {
  my ($self,%args) = @_;
  Message(Message => "Stopping mods...");
  foreach my $mod ($self->Mods->Values) {
    $mod->Stop;
  }
}

sub RedactText {
  my ($self,%args) = @_;
  my $s = $args{String};
  print "Redacting $s\n" if $UNIVERSAL::debug;
  my $score = 0;
  foreach my $mod (values %{$self->Mods->Contents}) {
    print Dumper({mod => $mod}) if $UNIVERSAL::debug;
    my $res1 = $mod->RedactText(String => $s);
    print Dumper({Res1 => $res1}) if $UNIVERSAL::debug;
    if ($res1->{Success}) {
      if ($res1->{Recommendation} eq 'redact') {
	print "redact: $s\n";
	$score = 1;
      } else {
	print "allow: $s\n";
      }
    }
  }
  return $score;
}

sub Reload {
  my ($self,%args) = @_;
  foreach my $mod ($self->Mods->Values) {
    $mod->Reload(%args);
  }
}

1;
