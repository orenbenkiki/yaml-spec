#!/usr/bin/perl -w

use strict;
use English;

my $text = "";
my $in_final_tables = 0;
while (my $line = <>) {
    # Get rid of the URLs of external links
    $line =~ s/\s*\[<fo:basic-link external-destination="[^"]*">[^<]*<\/fo:basic-link>\]//g;
    # Align two-column examples.
    $line =~ s/-4pc/-1pc/g;
    # Ensure productions have some leading space.
    $line =~ s/fo:table id/fo:table space-before.minimum="0.8em" space-before.optimum="1em" space-before.maximum="2em" id/;
    # Ensure Escaped characters are separated from productions.
    $line =~ s/^ [ ]+Escaped/&#160;Escaped/;
    # Ensure the production counter has enough space.
    $line =~ s/"5%"/"10mm"/g;
    # Expand the monospace family
    $line =~ s/{\$monospace\.font\.family}/monospace/g;
    # Add the special symbols to monospace.
    $line =~ s/"monospace"/"monospace,Symbol,ZapfDingbats"/g;
    # Convert URLs to monospace.
    $line =~ s!(</fo:basic-link><fo:inline)!$1 font-family="monospace"!g;
    # enforce keep-together.
    $line =~ s/<fo:table-row/<fo:table-row keep-together="always"/g;
    # Add margin and p[adding to preview examples.
    $line =~ s/border-style/margin="2pt" padding="2pt" border-style/ if ($line =~ /fo:block><fo:block wrap-option/);
    # Add margin and padding to syntax examples.
    $line =~ s/border-style/margin="2pt" padding="2pt" border-style/ if ($line =~ /^<fo:block wrap-option/);
    # Fix the disappearing trademark problem.
    $line =~ s/\(YAML\)/(YAML&#8482;)/g;
    # Break the attempt to one-line the title
    $line =~ s|^    : $|</fo:block><fo:block>|;
    # YAML calls "Symbols" Indicators"
    $line =~ s/Symbols/Indicators/g;
    # Collapse multiple spaces in index terms
    for (my $i = 0; $i < 6; $i++) {
        $line =~ s/key="((?:[^" ]+ )+)[ ]+/key="$1/;
    }
    # Get rid of the non-ASCII characters.
    $line =~ s/\302?\240/&#160;/g; # nbsp
    $line =~ s/\302?\251/&#169;/g; # copyright
    $line =~ s/\302?\260/&#176;/g; # deg
    $line =~ s/\302?\267/&#183;/g; # middot
    $line =~ s/\303?\327/&#215;/g; # times
    $line =~ s/d[^ ]*t Net/d&#246;t Net/g; # ouml

    $in_final_tables++ if $line =~ />Tag Resolution</;
    $line =~ s/column-number="1"\//column-number="1" column-width="60%"\// if $in_final_tables > 1;
    $line =~ s/column-number="2"\//column-number="2" column-width="40%"\// if $in_final_tables > 1;

    print $line;
}
