#!/usr/bin/perl -w
use strict;
use POSIX ":sys_wait_h";
$SIG{ALRM} = 'IGNORE';
my @server = ('localhost', 'localhost', 'localhost');
foreach (@server){
    my $kid_pid;
    if($kid_pid = fork()){
        print "New a child: pid=$kid_pid \n";
        next;
    }
    die "Error: Failed to fork a child! \n" unless defined $kid_pid;
    # Child process
    my $result = `ping -c 1 $_`;
    if ($result =~ /0\%/) {
        print "PID=$$ ping successul.\n";
        exit 0;
    } else {
        print "Error! \n";
        exit 1;
    }
}
