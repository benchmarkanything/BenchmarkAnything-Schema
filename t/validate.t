use Test::More 0.88;

require BenchmarkAnything::Schema;
require JSON::MaybeXS;
require JSON::Schema;
require File::Slurp;

# prefix "B.A.D." == "Benchmark Anything Data"

my $bad_json = File::Slurp::slurp('t/valid-benchmark-anything-data-01.json');
my $bad      = JSON::MaybeXS::decode_json($bad_json);

# --- basic structure validation before applying json schema ---

is (scalar(@{$bad->{BenchmarkAnythingData}}), 3,    "intro key with correct sub entries");

is ($bad->{BenchmarkAnythingData}[0]{NAME},     "benchmarkanything.test.metric", "entry 0 - NAME");
is ($bad->{BenchmarkAnythingData}[0]{VALUE},    27.34,                           "entry 0 - VALUE");
is ($bad->{BenchmarkAnythingData}[0]{keyword},  "affe",                          "entry 0 - keyword");

is ($bad->{BenchmarkAnythingData}[1]{NAME},     "benchmarkanything.test.metric", "entry 1 - NAME");
is ($bad->{BenchmarkAnythingData}[1]{VALUE},    34.56789,                        "entry 1 - VALUE");
is ($bad->{BenchmarkAnythingData}[1]{keyword},  "zomtec",                        "entry 1 - keyword");

is ($bad->{BenchmarkAnythingData}[2]{NAME},     "benchmarkanything.test.metric", "entry 2 - NAME");
is ($bad->{BenchmarkAnythingData}[2]{VALUE},    40,                              "entry 2 - VALUE");
is ($bad->{BenchmarkAnythingData}[2]{keyword},  "birne",                         "entry 2 - keyword");

# --- json schema validation ---

ok(BenchmarkAnything::Schema::valid_json_schema($bad),      "validated DATA against json schema");
ok(BenchmarkAnything::Schema::valid_json_schema($bad_json), "validated JSON against json schema");

done_testing;
