#!/usr/bin/perl
while(<>) {
    chomp;
    s@\t.*@@;
    $lc = lc($_);
    print "print STDERR \"BAD ($lc): \$_\" if m\@\\s$lc\\s\@;\n";
}
