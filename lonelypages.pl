#!/usr/bin/perl
# ./lonelypages.pl
# desc: a real dumb (no checks) script that deletes pages listed in lonelypages_delete
# by: Sahal Ansari github@sahal.info

use strict;
use warnings;
use MediaWiki::API;
# save your self a lot of headache and read about unicode in Perl
# http://www.ahinea.com/en/tech/perl-unicode-struggle.html
use utf8;
use Encode;
binmode(STDOUT, ":utf8");

my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = 'http://wiki.example.org/w/api.php';
$mw->login( { lgname => 'username', lgpassword => 'password' } );
$mw->{config}->{on_error} = \&on_error;

sub on_error {
	print "Error code: " . $mw->{error}->{code} . "\n";
#verbose errors
#	print $mw->{error}->{stacktrace}."\n";
#	die;
}

sub delete_article {
	(my $a_title) = @_;
        $mw->edit( {
                action => 'delete', title => $a_title, reason => 'AUTODELETE: SPAM' } ) 
		&& sleep(3);
}

# load lonelypages_delete into array @articles
my @articles;
open my $fh, "lonelypages_delete" or die $!;
while (my $line=<$fh>) {
	$line =~ s/\n//;
	$line = decode_utf8($line);
	push @articles, $line;
}

for (my $c = 0; $c <= scalar(@articles) - 1; $c ++) {
# also: started from the bottom
# for (my $c = scalar(@articles) - 1; $c >=0; $c --) {
	print "$articles[$c]" . " ";
	delete_article("$articles[$c]");
# be nice and rate limit yourself some more
#	sleep(1);
}

$mw->logout();
