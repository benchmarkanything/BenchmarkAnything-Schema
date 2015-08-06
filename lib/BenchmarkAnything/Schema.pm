use strict;
use warnings;
package BenchmarkAnything::Schema;
# ABSTRACT: Tooling to handle the "BenchmarkAnything" schema

=head1 SYNOPSIS

 require BenchmarkAnything::Schema;

 if (my $result = BenchmarkAnything::Schema::valid_json_schema($input_data__or__raw_json_text))
 {
     print "Data structure is valid BenchmarkAnything data.\n";
 } else {
     print STDERR "JSON schema errors:\n";
     print STDERR " - $_\n" foreach $result->errors;
 }

=cut

=head2 valid_json_schema($data_or_json)

Validate if $data_or_json conforms to the BenchmarkAnything schema.

Returns a L<JSON::Schema::Result|JSON::Schema::Result> object which is
overloaded to behave and stringify sensibly, and also provides error
details.

=cut

sub valid_json_schema {
    my ($data_or_json) = @_;

    require File::Slurp;
    require File::ShareDir;
    require JSON::MaybeXS;
    require JSON::Schema;
    require Scalar::Util;

    # decode JSON unless already given a HASH or ARRAY reference
    my $data;
    my $ref = Scalar::Util::reftype($data_or_json);
    if ($ref and $ref =~ /^HASH|ARRAY$/) {
        $data = $data_or_json;
    } else {
        $data = JSON::MaybeXS::decode_json($data_or_json);
    }

    my $schema_file = File::ShareDir::dist_file('BenchmarkAnything-Schema', 'benchmark-anything-schema.json');
    my $schema_json = File::Slurp::read_file($schema_file);
    my $schema      = JSON::MaybeXS::decode_json($schema_json);
    my $validator   = JSON::Schema->new($schema);
    my $result      = $validator->validate($data);

    return $result;
}

1;
