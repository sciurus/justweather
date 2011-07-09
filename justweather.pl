#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;
use Plack::Request;
use Plack::Response;
use XML::LibXML;
use XML::LibXSLT;

my $app = sub {

    my $env = shift;
    my $req = Plack::Request->new($env);
    print "Processing request\n\n\n";
    my $zip = $req->param('zip');

    die "Invalid zip code $zip" unless $zip =~ /\d{5}/;

    my $url   = "http://weather.yahooapis.com/forecastrss?p=$zip";
    my $first = substr($zip, 0, 1);
    my $path  = "cache/$first/$zip.html";

    my $weather_rss = get($url);
    die "Couldn't get $url" unless defined $weather_rss;

    my $parser     = XML::LibXML->new();
    my $xslt       = XML::LibXSLT->new();
    my $source     = $parser->parse_string($weather_rss);
    my $style_doc  = $parser->parse_file('justweather.xsl');
    my $stylesheet = $xslt->parse_stylesheet($style_doc);
    my $xml        = $stylesheet->transform($source);
    my $html       = $stylesheet->output_as_chars($xml); 

    open my $fh, '>', $path or die "Could not write cache $path";
    print $fh $html;
    close $fh;

    my $res = $req->new_response(200);
    $res->content_type('text/html');
    $res->body($html);

    return $res->finalize;
};
