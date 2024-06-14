# DNS Lookup Script

This Perl script performs DNS lookups for specified domains, with support for multiple record types and input from a CSV file. The script uses the `Net::DNS`, `Getopt::Long`, `Text::CSV`, and `Term::ANSIColor` modules.

## Features

- Perform DNS lookups for A, MX, and all record types.
- Read domains from a CSV file or from standard input.
- Colorful output for better readability.

## Prerequisites

Ensure you have Perl installed along with the necessary modules. You can install the required modules using CPAN:

```bash
cpan Net::DNS Getopt::Long Text::CSV Term::ANSIColor

## Usage

Run the script with the following options:

  -A to lookup A records.
  -MX to lookup MX records.
  -ALL to lookup all record types (A, AAAA, MX, CNAME, NS, TXT, SRV).
  -csv <file> to read domains from a CSV file.

Example on csv

example.com
example.org
example.net
