#!/usr/bin/perl
use Plack::Loader;
my $app = Plack::Util::load_psgi('app.psgi');
Plack::Loader->auto->run($app);
