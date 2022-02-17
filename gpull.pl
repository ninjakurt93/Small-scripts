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
    'install|i' => \$install
) or die "Usage: $0 --dir \'/path/to/src\' --install";

my $pwd = dir($root);

my $subdirs = c $pwd->children();

$subdirs->grep(
    sub { $_->is_dir; }
)->each(
    sub {
        my $dir = $_;
        p $dir->basename;

        if ( git_exist($dir) ) {
            system("cd $dir; git pull;");
        }

        if ( $install && cpan_exist($dir) ) {
            system("cd $dir; cpm install;");
        }
        print "###################################\n";
    }
);

sub git_exist {
    my $dir = shift;
    my $exist;
    my $children = c $dir->children();
    $children->grep(
        sub { $_->basename =~ /^.git$/; }
    )->each(
        sub {
            $exist = 1;
        }
    );

    return $exist;
}

sub cpan_exist {
    my $dir = shift;
    my $exist;
    my $children = c $dir->children();
    $children->grep(
        sub { $_->basename =~ /^cpanfile$/; }
    )->each(
        sub {
            $exist = 1;
        }
    );

    return $exist;
}