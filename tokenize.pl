#!/usr/bin/perl -w
use strict;

while(<>) {
    chomp;
    my ($id,$term,$scope,$term) = split(/\t/,$_);

    my $idspace = '';
    if ($id =~ m@^(\w+):@) {
        $idspace = $1;
    }
    else {
        next;
    }
    my $n = 0;
    while ($term =~ m@(\w+)(\W*)(.*)@) {
        my $w = $1;
        my $sp = $2;
        $term = $3;
        my $is_cap = $w =~ m@^[A-Z][a-z]@;
        my $is_num = $w =~ m@^[0-9]@;
        my $is_apos = $sp eq "'";
        $n++;
        next if $is_num;
        next if $w eq 'CamelHump';  # silly uberon joke
        print join("\t",
                   $idspace,
                   $id,
                   $w,
                   $term,
                   $scope,
                   $is_cap == 1 ? 'true' : 'false',
                   $n == 1 ? 'true' : 'false',
                   $n,
                   $is_apos ? 'true' : 'false')."\n";
        $n++;
    }
}
