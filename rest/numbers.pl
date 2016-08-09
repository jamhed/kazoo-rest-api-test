#!/usr/bin/env perl
use strict;
use warnings;
use KZ;

$KZ::verbose = 1;
my $auth = login 'admin', 'admin', 'admin';

add_spare_number token $auth, account_id $auth->{data}, "+14157775553";
