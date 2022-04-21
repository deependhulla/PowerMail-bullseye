#!/bin/sh

#Perl for MailScanner Setup
#automate cpan
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan

perl -MCPAN -e "CPAN::Shell->force(qw(install Digest::SHA1 ));"
perl -MCPAN -e "CPAN::Shell->force(qw(install IP::Country ));"
perl -MCPAN -e "CPAN::Shell->force(qw(install Mail::SPF::Query ));"
perl -MCPAN -e "CPAN::Shell->force(qw(install Encoding::FixLatin ));"
#perl -MCPAN -e "CPAN::Shell->force(qw(install Bundle::CPAN ));"

