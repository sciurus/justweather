#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;
use Plack::Request;
use Plack::Response;
use XML::LibXML;
use XML::LibXSLT;

my $justweather = sub {

    my $env = shift;
    my $reg = Plack::Request->new($env);
    my $zip = $req->param('zip');

    # move to configuration file
    my $delay = 60 * 1;
    my $url   = "http://weather.yahooapis.com/forecastrss?p=$ARGV[0]";

    my $path  = "$zip.html";
    #if ( -e $path ) {
    #    my @stats = stat($path);
    #    if ( time - $stats[9] < $delay ) {
    #        # read and return cached response
    #    }
    #}

    my $weather_rss = get($url);

    die "Couldn't get $url" unless defined $weather_rss;

    my $parser     = XML::LibXML->new();
    my $xslt       = XML::LibXSLT->new();
    my $source     = $parser->parse_string($weather_rss);
    my $style_doc  = $parser->parse_file('justweather.xsl');
    my $stylesheet = $xslt->parse_stylesheet($style_doc);
    my $xml        = $stylesheet->transform($source);
    my $html       = $stylesheet->output_as_chars($xml); 

    open my $fh, '>', $path or die 'Could not save html';
    print $fh $html;
    close $fh;

    my $res = $req->new_response(200);
    $res->content_type('text/html');
    $res->body($html);

    return $res->finalize;
}

use HTTP::Server::PSGI;
my $server = HTTP::Server::PSGI->new(
  host => "127.0.0.1",
  port => 9091,
  timeout => 120,
)
$server->run($justweather);
