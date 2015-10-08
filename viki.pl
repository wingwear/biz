###################################################################################
# This code is to find the number of response objects containing flag hd_true/hd_false 
# from the base url http://api.viki.io/v4/videos.json?app=100250a&per_page=10&page=
# plus increamenting page number
# 
####################################################################################

use strict;
use warnings;
use WWW::Mechanize;

# Create a new mechanize object
my $mech = WWW::Mechanize->new();
my $url_base = "http://api.viki.io/v4/videos.json?app=100250a&per_page=10&page=";
my $page_num = 1;	#init the page number
my $hd_true_count = 0;	#init the count for hd_true
my $hd_false_count = 0;	#init the count for hd_false
my $hd_true_pattern = '"hd":true';	#the hd_true pattern to match
my $hd_false_pattern = '"hd":false';	#the hd_false pattern to match


#start reading contents in url
while (1) {
	#form the complete url
	my $url = join('',$url_base,$page_num);
	# Associate the mechanize object with a URL
	$mech->get($url);
	# Get the content of the URL
	my $content = $mech->content;
	#check whether there is data available
	if ($content =~ m/"more":true/) {
		print "Reading data from page num $page_num \n";
		#find number of matches of "hd":true and increament
		my $this_hd_true_count = () = $content =~ m/$hd_true_pattern/g;
		$hd_true_count += $this_hd_true_count;
		#find number of matches of "hd":false and increament 
		my $this_hd_false_count = () = $content =~ m/$hd_false_pattern/g;
		$hd_false_count += $this_hd_false_count;
		print "There are $this_hd_true_count hd_true counts and $this_hd_false_count hd_false counts \n";
		#increament the page_num
		$page_num++;
	}
	else {
		#no more data available, break
		print "There are no more data available from page num $page_num, exiting\n";
		last;
	}
}
#print out number of response objects meeting requirements
print "Altogether there are $hd_true_count objects having flag hd set to TRUE".
" and $hd_false_count objects having flag hd set to FALSE \n";