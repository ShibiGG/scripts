#!/usr/bin/perl
use strict;
use warnings;
use Net::DNS;
use Getopt::Long;
use Text::CSV;
use Term::ANSIColor;

# Command-line options
my ($a, $mx, $all, $csv_file);
GetOptions(
    'A'   => \$a,
    'MX'  => \$mx,
    'ALL' => \$all,
    'csv=s' => \$csv_file,
);

# Create a resolver object
my $resolver = Net::DNS::Resolver->new;

# Process CSV if specified
if ($csv_file) {
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
    open my $fh, "<:encoding(utf8)", $csv_file or die "Could not open '$csv_file' $!\n";
    while (my $row = $csv->getline($fh)) {
        my $domain = $row->[0];
        process_domain($domain);
    }
    close $fh;
} else {
    print color('bold yellow'), "Enter the DNS hostname to lookup: ", color('reset');
    my $domain = <STDIN>;
    chomp $domain;
    process_domain($domain);
}

# Process a single domain
sub process_domain {
    my ($domain) = @_;
    print color('bold green'), "Records for $domain:\n", color('reset');
    my @types = gather_types();
    foreach my $type (@types) {
        my $query = $resolver->query($domain, $type);
        if ($query) {
            foreach my $rr ($query->answer) {
                print_record($rr) if $rr->type eq $type;
            }
        } else {
            print color('bold red'), "Query failed for type $type: ", $resolver->errorstring, "\n", color('reset');
        }
    }
}

# Determine which types to query based on flags
sub gather_types {
    return ('A', 'MX') if $a && $mx;
    return ('A') if $a;
    return ('MX') if $mx;
    return ('A', 'AAAA', 'MX', 'CNAME', 'NS', 'TXT', 'SRV') if $all;
    return ('A');  # Default to A if no specific type is requested
}

# Print DNS record
sub print_record {
    my ($rr) = @_;
    print color('cyan'), $rr->string, "\n", color('reset');
}


