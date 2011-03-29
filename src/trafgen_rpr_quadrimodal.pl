#!/usr/bin/perl

# netsniff-ng - the packet sniffing beast
# Copyright 2011 Daniel Borkmann <daniel@netsniff-ng.org>
# Subject to the GPL.
# Configuration file generator for trafgen.
# Generates RPR Quadrimodal packet distribution (64:50, 512:15, 1518:15, 9218:20)
# In lengths the Frame Check Sequence of 4 Byte is not counted

use warnings;
use strict;

my %conf = (
	60   => 50, # 64   - 4
	508  => 15, # 512  - 4
	1514 => 15, # 1518 - 4
	9214 => 20  # 9218 - 4 ??? to be fixed
);

print "# Run in round-robin mode with trafgen!\n";
print "# E.g. trafgen --dev eth0 --conf <this-as-file> --bind 0\n\n";

my $sum = 0;
foreach (values(%conf)) {
	$sum = $sum + $_;
}

for (my $pkt = 0; $pkt < $sum; ++$pkt) {
	my ($len, $done) = (0, 0);

	do {
		my @list = keys(%conf);
		my $index = int(rand(scalar(@list)));
		my $key = $list[$index];
		if ($conf{$key} > 0) {
			$conf{$key}--;
			$len = $key;
			$done = 1;
		}
	} while ($done == 0);

	print "\$P$pkt {\n";
	for (my $byte = 0; $byte < $len;) {
		for (my $off = 0; $off < 13 && $byte < $len; ++$off, ++$byte) {
			my $cur = sprintf("0x%02x", int(rand(256)));
			print "$cur, ";
		}
		print "\n";
	}
	print "}\n\n";
}

