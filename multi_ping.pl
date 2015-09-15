#!/usr/bin/perl -w
use strict;
use POSIX ":sys_wait_h";
my @server = ('localhost', 'localhost', 'localhost');
$SIG{ALRM} = sub { die "Child may hang! \n"};
my @kid_pid_list;
foreach (@server){
    my $kid_pid;
    if($kid_pid = fork()){
        print "New a child: pid=$kid_pid \n";
        next;
    }
    die "Error: Failed to fork a child! \n" unless defined $kid_pid;
    # Child process
    push $$, @kid_pid_list;
    my $result = `ping -c 10 $_`;
    if ($result =~ /0\%/) {
        print "PID=$$ ping successul.\n";
        exit 0;
    } else {
        print "Error! \n";
        exit 1;
    }
}
my $alarm_time = 5;
eval {
    foreach (@kid_pid_list) {
        alarm $alarm_time;
        waitpid($_, 0);
        if($@ =~ /hang/) {
            print "Will kill child process, PID=$_ \n";
            `kill $_`;
        }
        $alarm_time = 0 if 0 != $alarm_time;
    }    
}
