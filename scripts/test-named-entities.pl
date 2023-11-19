#!/usr/bin/env perl

use PerlLib::SwissArmyKnife;

use Lingua::EN::NamedEntity;

foreach my $word (qw(Dochartaigh France the Basic Trinidad)) {
  my @entities = extract_entities($word);
  print Dumper({Entities => \@entities});
}
