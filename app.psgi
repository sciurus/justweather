#!/usr/bin/perl
use JustWeather;
my $jw = JustWeather->new;
my $app = sub { $jw->run(@_) };
