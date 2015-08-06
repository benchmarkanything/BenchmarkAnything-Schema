use strict;
use warnings;
package BenchmarkAnything::Schema;
# ABSTRACT: Tooling to handle the "BenchmarkAnything" schema

sub valid_json_schema {
    my ($data_or_json) = @_;

    require File::Slurp;
    require File::ShareDir;
    require JSON::MaybeXS;
    require JSON::Schema;
    require Scalar::Util;

    my $data;
    my $ref = Scalar::Util::reftype($data_or_json);
    if ($ref and $ref =~ /^HASH|ARRAY$/) {
        $data = $data_or_json;
    } else {
        $data = JSON::MaybeXS::decode_json($data_or_json);
    }

    my $name = 'benchmark-anything-schema.json';
    my $fullname;

    # look into local repo's share/ (development) or final location (cpan installed)
    if (not $fullname = File::ShareDir::dist_file('BenchmarkAnything-Schema', $name)) {
        $fullname = "share/$name";
    }

    my $schema_json = File::Slurp::slurp($fullname);
    my $schema      = JSON::MaybeXS::decode_json($schema_json);
    my $validator   = JSON::Schema->new($schema);
    my $result      = $validator->validate($data);

    if (not $result) { # and $verbose
        print STDERR "Schema errors\n";
        print STDERR " - $_\n" foreach $result->errors;
    }

    return $result;
}

1;
