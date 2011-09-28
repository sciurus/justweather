## Description
This program creates a weather page inspired by the simpleweather.com. I wrote the initial version in 2008 after that site shut down. It depends on Yahoo's weather API, which is only available for non-commercial use. 

## Usage
Justweather expect the foolowing directory structure for its web root. The zip folder needs to be writable by the user running justweather.

    ./app.psgi
    ./index.html
    ./justweather.xsl
    ./JustWeather.pm
    ./zip/

Starting the application is as simple as running plackup. This will start a PSGI server on port 5000. If you don't want to run a PSGI server, you can run justweather as a CGI script using app.cgi

If you'd like to take advantage of justweather's caching functionality, you should put another server in front of your PSGI server and configure it to serve the files in the zip directory. A working sample configuration for ngnix is included in justweather-nginx.conf. You will also want to clean the cache periodically; an example of how to do this in included in justweather-crontab.

## Requirements
  * Plack
  * LWP::Simple
  * XML::LibXML
  * XML::LibXSLT
