#!/usr/bin/perl
use Mfrequest;
use strict;

# This program uses the Mfrequest module to download video links
# on youtube.
# Mfrequest or Mitady-Faroratra request  is a perl module which 
# parse an html page and more in order to get links.....
 
my $req = Mfrequest->new();

if( not defined($ARGV[0]))
{
	print "Missing argument:".$0." <url>\n";
	exit 1;
}

$req->mf_request($ARGV[0]);

my $regex = "href=\"(\/watch[^\"]*)\"";
my $paramtoparse = 1; # correspond to value in parenthesis (\/watch[^\"]*)
my $nbres = 1000;
my $baseurl = 'https://www.youtube.com'; # sometimes links are not absolute so we need url base

my $res = $req->mf_get_all($regex,$paramtoparse,$nbres);

foreach my $videolink (@$res){
	print $baseurl.$videolink;
	print "\n";
}

exit 0;
	
