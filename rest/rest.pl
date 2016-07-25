#!/usr/bin/perl -w
use strict;
use KZ;

$KZ::verbose = 1;

my $auth = login "admin", "admin", "admin";

make_std_account($auth, "cc1.kazoo");
make_std_account($auth, "cc2.kazoo");

sub make_std_account {
	my ($auth, $domain) = @_;
	my $acc = make_account token $auth, $domain;
	my $u1 = make_user token $auth, id $acc, 1, $domain;
	my $u2 = make_user token $auth, id $acc, 2, $domain;
	my $d1 = make_device token $auth, id $acc, id $u1, 1;
	my $d2 = make_device token $auth, id $acc, id $u2, 2;
	my $cf1 = make_callflow_user token $auth, id $acc, id $u1, "1001";
	my $cf2 = make_callflow_user token $auth, id $acc, id $u2, "1002";

	my $conf1 = make_conference token $auth, id $acc, id $u1, 1;
	my $cf3 = make_callflow_conference token $auth, id $acc, id $conf1, "2001";
}

