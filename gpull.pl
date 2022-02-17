#!/usr/bin/perl
use strict;
use warnings;

use Mojo::Collection 'c';
use Path::Class;
use DDP;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);

my $root;
my $install;

GetOptions(
    'dir|d=s' => \$root,
    'install-pm|i' => \$install
) or die 'Usage: $0 --dir /path/to/src --install';

my $pwd = dir($root);

my $subdirs = c $pwd->children();

$subdirs->grep(
    sub { $_->is_dir; }
)->each(
    sub {
        my $dir = $_;
        p $dir->basename;
        system("cd $dir; git pull;");
        if ( $install ) {
            system("cd $dir; cpm install;");
        }
        print "###################################\n";
    }
);

