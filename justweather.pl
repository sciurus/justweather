#!/usr/bin/env perl

use strict;
use warnings;
use LWP::Simple;
use XML::LibXML;
use XML::LibXSLT;

my $delay = 60 * 1;
my $path = "$ARGV[0].html";
my $url = "http://weather.yahooapis.com/forecastrss?p=$ARGV[0]";

if (-e $path) {
  my @stats = stat($path);
  if (time -$stats[9] < $delay) {
    die 'up to date';
  }
}

my $weather_rss = get($url);

die "Couldn't get $url" unless defined $weather_rss;

my $parser = XML::LibXML->new();
my $xslt = XML::LibXSLT->new();

my $source = $parser->parse_string($weather_rss);
my $style = $parser->parse_file('justweather.xsl');

my $stylesheet = $xslt->parse_stylesheet($style);
my $weather_html = $stylesheet->transform($source);

open my $RESULTS_HANDLE, '>', $path or die 'Could not save html';

print $RESULTS_HANDLE $stylesheet->output_string($weather_html);

close $RESULTS_HANDLE;

exit 0;
