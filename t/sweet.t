#!/usr/bin/env perl6

use v6;
use Test;
use Inline::Ruby::Sweet;

subtest {
  isa-ok !!'true':rb, True;
  isa-ok !!'false':rb, False;
  isa-ok +'5':rb, Int;
  isa-ok +'1.0':rb, Num;
  isa-ok ~'"foo"':rb, Str;
}, 'Ruby to Perl6 types';


isa-ok '5':rb, Inline::Ruby::RbObject, 'Things stay boxed by default';
isa-ok '5':rb + 2, Inline::Ruby::RbObject, 'Things stay boxed when primary';
isa-ok 2 + '5':rb, Int, 'Things unbox when secondary';

use csv:from<Ruby>;
my $data = CSV.read('t/input/hiya.csv');

is $data.gist, '«[["id", "name"], ["1", "andy"], ["2", "bella"], ["3", "chad"], ["4", "dua"]]»:rb', 'Gist generates deep data';

BEGIN { ruby_require 'json', :import<JSON> };
$data = JSON.parse("t/input/sample.json".IO.slurp);

is $data.length.gist, '«2»:rb', 'Method invocation';
is $data[0]["type"].gist, '«ClutterGroup»:rb', 'Array method index';
is $data[0]<type>.gist, '«ClutterGroup»:rb', 'Hash method index alias';

my $list = "[1,2,3]":rb;

# Have to do the +$n to prevent going back into ruby?
my $inclist = $list.map: -> $n { +$n + 1 };
is $inclist.gist, '«[2, 3, 4]»:rb', 'Map with block';

done-testing;

