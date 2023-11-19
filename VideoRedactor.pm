package VideoRedactor;

use VideoRedactor::ModManager;

use BOSS::Config;
use MyFRDCSA;
use UniLang::Agent::Agent;
use UniLang::Util::Message;

use JSON qw(encode_json);

use Data::Dumper;

# $UNIVERSAL::debug = 1;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Config Loaded MyModManager /

  ];

sub init {
  my ($self,%args) = @_;
  $specification = "
	--mods <mods>...	Start Modules

	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";

  $UNIVERSAL::systemdir = ConcatDir(Dir("minor codebases"),"videoredactor");
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->DoNotDaemonize(1);
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
  # parse and load
  my @mods = ();
  if (exists $conf->{'--mods'}) {
    push @mods, @{$conf->{'--mods'}};
  } else {
    push @mods, 'Attempt1';
    push @mods, 'NamedEntity';
  }
  $self->MyModManager
    (VideoRedactor::ModManager->new
     (Mods => \@mods));
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      print Dumper({Echo => $1});
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^reload$/i) {
      $UNIVERSAL::agent->QueryAgentReply
	(
	 Message => $m,
	 Data => {
		  _DoNotLog => 1,
		  Result => $self->Reload(),
		 },
	);
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  } elsif ($m->Data) {
    print Dumper($m->Data->{Contents}) if $UNIVERSAL::debug;
    if ($m->Data->{Contents} eq 'reload') {
      $UNIVERSAL::agent->QueryAgentReply
	(
	 Message => $m,
	 Data => {
		  _DoNotLog => 1,
		  Result => $self->Reload(),
		 },
	);
    } else {
      $UNIVERSAL::agent->QueryAgentReply
	(
	 Message => $m,
	 Data => {
		  _DoNotLog => 1,
		  Result => encode_json($self->RedactTextArray(Array => $m->Data->{Contents})),
		 },
	);
    }
  }
}

sub RedactTextArray {
  my ($self,%args) = @_;
  my $aos = $args{Array};
  my @results;
  foreach my $string (@$aos) {
    print "<$string>\n" if $UNIVERSAL::debug;
    push @results, $self->RedactText(String => $string);
  }
  return \@results;
}

sub RedactText {
  my ($self,%args) = @_;
  print "Doing Redacting\n" if $UNIVERSAL::debug;
  if (! $self->Loaded) {
    print "Reloading as needed\n" if $UNIVERSAL::debug;
    $self->Reload();
    $self->Loaded(1);
  }
  return $self->MyModManager->RedactText(%args);
}

sub Reload {
  my ($self,%args) = @_;
  return $self->MyModManager->Reload(%args);
}

1;
