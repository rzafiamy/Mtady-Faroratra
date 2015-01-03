#!/usr/bin/perl -w

use strict;
use LWP::UserAgent;
use LWP::Simple;

package Mfrequest;

###################################################################
# This module allows you to download files using HTTP request
# by a simplest way. 
# 	author : Z. Rija
# 	e-mail: tgv4world@gmail.com
###################################################################


#_____________________________________________
# Constructor of class 
# PARAM:
#_____________________________________________
sub new {
	
	my ($class) = @_;
	my $this = {};
	bless($this,$class);	
	$this->{USER_AGENT} = LWP::UserAgent->new( agent => 'Mozilla/5.0 (X11; Linux 
x86_64; rv:28.0) Gecko/20100101 Firefox/28.0');
	$this->{MATCHED}=();
	
	return $this;
}

#_________________________________________________________
# Send request HEAD and GET
#_________________________________________________________
sub mf_request{
	my ($this,$url) = @_;
	
	$this->{URL} = $url;
	
	# head request
	$this->{HEAD_REQUEST}=HTTP::Request->new( "HEAD" => $this->{URL} );
	$this->{HEAD_RESULT} = $this->{USER_AGENT}->request($this->{HEAD_REQUEST})
	|| die "Error";
	
	# importants information  
	$this->{HEAD_INFO} = $this->{HEAD_RESULT}->as_string();
	$this->{CODE} = $this->{HEAD_RESULT}->code();
	$this->{CONTENT_LENGTH} = $this->{HEAD_RESULT}->content_length();
	$this->{CONTENT_TYPE} = $this->{HEAD_RESULT}->content_type();
	
	# get request
	$this->{PAGE_REQUEST} = HTTP::Request->new( "GET" => $this->{URL} );
	$this->{PAGE_RESULT} =$this->{USER_AGENT}->request($this->{PAGE_REQUEST})
	|| die "Error";
	$this->{PAGE_CONTENT} = ${$this->{PAGE_RESULT}->content_ref()};
	$this->{CODE} = $this->{PAGE_RESULT}->code();
		
}

#_________________________________________________________
# Get all parsed results
# Generic function
# returns reference to array @
#_________________________________________________________
sub mf_get_all{
	my ($this,$regex,$position,$limit) = @_;
	
	my $i=0;
	my @matched = ();
	my @argum = ();

	my $page = $this->{PAGE_CONTENT};
	$page =~ s/\s//g;
	
	my %visited = ();	
	
	while((length($page)>0)&&($i<$limit)){
	  
	  if($page =~ /$regex/){
		$page = $';
		
		@argum = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
		if($position >=1 and $position<=9){
			if($visited{$argum[$position-1]} != 5 ){
				push @matched,$argum[$position-1];
				$visited{$argum[$position-1]} = 5;
			}		  
		  $i++;
		}
	  }
	  else{
		last;
	  }
	}
		
	$this->{MATCHED} = \@matched;
	
	return $this->{MATCHED};
}


#_______________________________________________________
# Get head info
# return @(head_info,code,content_length,content_type)
#_______________________________________________________
sub mf_get_head_info{
	my($this) = @_;
	
	return ($this->{HEAD_INFO},
			$this->{CODE},
			$this->{CONTENT_LENGTH},
			$this->{CONTENT_TYPE});
}

#_______________________________________________________
# Get page
# return @(code,page_content)
#_______________________________________________________
sub mf_get_page{
	
	my($this) = @_;
		
	return ($this->{CODE},
			$this->{PAGE_CONTENT});
}
1;
