#!/usr/bin/env perl

package JustWeather;

use strict;
use warnings;

use LWP::Simple;
use Plack::Request;
use Plack::Response;
use XML::LibXML;
use XML::LibXSLT;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    return $self;
}

sub run {
    my $self = shift;
    my $env  = shift;

    $self->{req} = Plack::Request->new($env);

    my $zip;

    # match path /zip/12345 or /zip/12345/ but no more than 5 digits
    if ( $self->{req}->path_info =~ /\/zip\/(\d{5})\/?$/ ) {
        $zip = $1;
    }
    else {
        return $self->error('Invalid zip code');
    }

    my $url   = "http://weather.yahooapis.com/forecastrss?p=$zip";
    my $cache = "zip/$zip.html";

    my $weather_rss = get($url);
    return $self->error('Could not load weather') unless defined $weather_rss;

    my $parser     = XML::LibXML->new();
    my $xslt       = XML::LibXSLT->new();
    my $source     = $parser->parse_string($weather_rss);
    my $style_doc  = $parser->parse_file('justweather.xsl');
    my $stylesheet = $xslt->parse_stylesheet($style_doc);
    my $xml        = $stylesheet->transform($source);
    my $html       = $stylesheet->output_as_chars($xml);

    open my $fh, '>', $cache or return $self->error('Could not write to cache');
    print $fh $html;
    close $fh;

    my $res = $self->{req}->new_response(200);
    $res->content_type('text/html');
    $res->body($html);

    return $res->finalize;
}

sub error {
    my $self        = shift;
    my $description = shift;

    my $html = "<html><head><title>Error</title></head>"
      . "<body>Error: $description</body></html>";

    my $res = $self->{req}->new_response(500);
    $res->content_type('text/html');
    $res->body($html);

    return $res->finalize;
}

1;
