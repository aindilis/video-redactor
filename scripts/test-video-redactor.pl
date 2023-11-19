#!/usr/bin/env perl

# VideoRedactor

use UniLang::Util::TempAgent;

use PerlLib::SwissArmyKnife;

my $tempagent = UniLang::Util::TempAgent->new;

my $message = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "VideoRedactor",
   Contents => '',
   Data => {
	    _DoNotLog => 1,
	    Contents => ["hi","there"],
	   },
  );

print Dumper({ReturnMessage => $message});
