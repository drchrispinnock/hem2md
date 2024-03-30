#!/usr/bin/perl

use strict;
# Declare this script as UTF-8
use utf8;
use JSON;
use Getopt::Std;

# Declare output as UTF-8
binmode(STDOUT, ":utf8");

sub usage() {
    die "Usage: $0 [-nq] file\n";
}

my $warning=1;
my $htmlblkquote=0;

my %opts;
usage unless getopts('nqh', \%opts);
usage if (%opts{'h'});
$warning=0 if (%opts{'n'});
$htmlblkquote=1 if (%opts{'q'});

usage unless (@ARGV);

my $buffer;
my $lc=1;

# Parse input as UTF-8
#
open (IN, "<:encoding(UTF-8)", $ARGV[0]);
while(<IN>) {
	$buffer = $buffer.$_;
}
close IN;

my $json = JSON->new->allow_nonref;
my $hd = $json->decode( $buffer );

my $bl_hd = $hd->{'blocks'};
my $entitymap = $hd->{'entityMap'};

print "<!-- This file has been automatically generated by hem2md -->\n\n\n"
	if $warning;

# Traverse the Blocks
#
my $endlist = 0;

for my $k (@$bl_hd) {

	my $type = $k->{'type'};
	my $text = $k->{'text'};

	my @offset;
	my @do;
	my $idx = 0;

	if ($text) {

		my $idx = 0;

		# Find inline styles offsets for bold and italic
		#
		my $inl = $k->{'inlineStyleRanges'};
		my $accum = 0; # The string shifts as we go...

		for my $i (@$inl) {

			my $i_style = $i->{'style'};
			my $i_length = $i->{'length'};
			my $i_offset = $i->{'offset'};

			$offset[$idx] = $i_offset ;
			$offset[$idx+1] = $i_offset + $i_length;
			if ($i_style eq 'ITALIC') {
				$do[$idx] = "*";
				$do[$idx+1] = "*";
			} elsif ($i_style eq 'BOLD') {
				$do[$idx] = "**";
				$do[$idx+1] = "**";
			} elsif ($i_style eq 'UNDERLINE') {
				$do[$idx] = "____";
				$do[$idx+1] = "____";
			} elsif ($i_style eq 'CODE') {
				warn "Code not implemented yet\n";
			 	#  Do nothing for now
				$do[$idx] = "";
				$do[$idx+1] = "";

			} else {
				warn "Unknown style $i_style!\n";
			}

			$idx++;
			$idx++;
		}

		# Find Link offsets
		#
		my $entr = $k->{'entityRanges'};
		for my $e (@$entr) {

			my $e_key = $e->{'key'};
			my $e_length = $e->{'length'};
			my $e_offset = $e->{'offset'};

			next unless $entitymap->{$e_key}->{'type'};
			my $e_type = $entitymap->{$e_key}->{'type'};

			$offset[$idx] = $e_offset ;
			$offset[$idx+1] = $e_offset + $e_length;

			if ($e_type eq 'LINK') {
				my $link = $entitymap->{$e_key}->{'data'}->{'href'};

				$do[$idx] = "[";
				$do[$idx+1] = "]\($link\)";

			} else {

				warn "Unknown entity type $e_type\n";

			}
			$idx++;
			$idx++;
		}

		# Go through the string byte by byte and insert formatting
		#
		my $newtext;
		
		for (my $i = 0; $i <= length($text); $i++) {
			my $byte="";

			$byte = substr $text, $i, 1  if $i < length($text);
			for (my $j = 0; $j<(@offset); $j++) {
				$newtext = $newtext.$do[$j] if $offset[$j] == $i;
			}
			$newtext = $newtext.$byte;

		}

		$text = $newtext;

		print "# " if $type eq 'header-one';
		print "## " if $type eq 'header-two';
		print "### " if $type eq 'header-three';
		if ($type eq 'unordered-list-item') {
			print "- " if $type eq 'unordered-list-item';
			$endlist = 2;
		} elsif ($type eq 'ordered-list-item') {

			print "$lc".". ";
			$lc++;
			$endlist = 2;

		} else {
			# Reset counters
			$lc=1;
			$endlist = 1 if ($endlist == 2);
		}

		if ($type eq 'blockquote') {

			print "C> " if $htmlblkquote == 0;
			$text = "<blockquote>$text</blockquote>" if $htmlblkquote == 1;
			
		}

		if ($endlist == 1) {
			# Ensure there is a newline to break lists
			# from other text types
			print "\n";
			$endlist = 0;
		}

	}

	print "$text\n";
}
