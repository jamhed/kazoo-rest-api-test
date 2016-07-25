package KZ;
use Exporter 'import';
@EXPORT = qw(login dump_json make_account make_user token id make_device make_conference make_callflow_user make_callflow_conference);
use strict;
use warnings;

use Furl;
use JSON;
use Digest::MD5 qw(md5_hex);

our $verbose = 0;
our $furl = Furl->new();

sub host { $ENV{SERVER} || "localhost:8000" }
sub uri ($) { sprintf("http://%s/%s", host, shift) }
sub token ($) { shift->{auth_token} }
sub id ($) { shift->{id} }

sub headers (;$) {
	my $auth = shift;
	my $common = ["Accept" => "application/json", "Content-Type" => "application/json"];
	$auth? [ "X-Auth-Token" => $auth, @$common ] : $common;
}

sub parse_reply ($) {
	my ($re) = @_;
	return from_json($re->content) if $re->is_success;
	printf STDERR "error url: %s code: %s response: %s\n", $re->request->uri, $re->code, $re->content;
	print $re->request->body;
	die;
}

sub dump_json ($) {
	my ($obj) = @_;
	print to_json($obj, { pretty => 1 });
	return $obj;
}

sub verbose ($) {
	my ($obj) = @_;
	return $verbose? dump_json($obj) : $obj;
}

sub login ($$$) {
	my ($name, $password, $account) = @_;
	my $auth = md5_hex("$name:$password");
	my $data = <<DATA;
{
	"data":{
		"credentials":"$auth",
		"account_name":"$account",
		"ui_metadata":{"ui":"kazoo-ui"}
	},
	"verb": "PUT"
}
DATA
	parse_reply $furl->put(uri "v1/user_auth", headers(), $data);
}

sub make_account ($$;$) {
	my ($auth, $name, $realm) = @_;
	$realm //= $name;
	my $data = <<DATA;
{
	"data":{
		"name":"$name",
		"realm": "$realm"
	}
}
DATA
	my $re = parse_reply $furl->put(uri "v2/accounts", headers $auth, $data);
	verbose $re->{data};
}


sub make_user ($$$$) {
	my ($auth, $account_id, $user_id, $domain) = @_;
	my $data = <<DATA;
{
	"data": {
		"name":"User $user_id",
		"first_name":"User",
		"last_name":"$user_id",
		"username":"user$user_id\@$domain",
		"password":"user${user_id}pas"
	}
}
DATA
	my $re = parse_reply $furl->put(uri "v2/accounts/$account_id/users", headers $auth, $data);
	verbose $re->{data};
}

sub make_device ($$$$) {
	my ($auth, $account_id, $owner_id, $id) = @_;
	my $data = <<DATA;
{
	"data":{
		"name":"Desk $id",
		"owner_id":"$owner_id", 
		"sip.username":"sip$id",
		"sip.password":"sip${id}pas${id}"
	}
}
DATA
  	my $re = parse_reply $furl->put(uri "v2/accounts/$account_id/devices", headers $auth, $data);
	verbose $re->{data};
}

sub make_conference ($$$$) {
	my ($auth, $account_id, $owner_id, $id) = @_;
	my $data = <<DATA;
{
	"data":{
		"name":"Conf $id",
		"owner_id":"$owner_id"
	}
} 
DATA
  	my $re = parse_reply $furl->put(uri "v2/accounts/$account_id/conferences", headers $auth, $data);
	verbose $re->{data};
}

sub make_callflow_conference ($$$$) {
	my ($auth, $account_id, $conf_id, $number) = @_;
	my $data = <<DATA;
{
	"data":{
		"flow":{
			"data":{
				"id":"$conf_id"
			},
			"module":"conference"
		},
		"numbers":["$number"]
	}
}
DATA
  	my $re = parse_reply $furl->put(uri "v2/accounts/$account_id/callflows", headers $auth, $data);
	verbose $re->{data};
}

sub make_callflow_user ($$$$) {
	my ($auth, $account_id, $user_id, $number) = @_;
	my $data = <<DATA;
{
	"data":{
		"flow":{
			"data":{
				"id": "$user_id",
				"can_call_self": false,
				"timeout": 20
			},
			"module": "user"
		},
		"numbers":["$number"]
	}
}
DATA
  	my $re = parse_reply $furl->put(uri "v2/accounts/$account_id/callflows", headers $auth, $data);
	verbose $re->{data};
}

1;
