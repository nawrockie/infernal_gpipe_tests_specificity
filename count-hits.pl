use strict;
use warnings;

my $usage = "usage: perl count-hits.pl <list of tblout files> <list of accessions>\n";
if(scalar(@ARGV) != 2) { die $usage; }

my ($tblout_file, $accn_file) = (@ARGV);

# read accession list 1
my %accn_H = ();
open(LIST, $accn_file) || die "ERROR unable to open $accn_file";
while(my $accn = <LIST>) { 
  chomp $accn;
  if($accn !~ m/^\#/ && $accn =~ m/\w/) { 
    $accn_H{$accn} = 1; 
  }
}
close(LIST);

# read tblout list
my %ct_H = ();
my $tot_ct = 0;
open(LIST, $tblout_file) || die "ERROR unable to open $tblout_file";
while(my $tblout = <LIST>) { 
  chomp $tblout;
  if(! -s $tblout) { die "ERROR $tblout does not exist"; }
  open(TBL, $tblout) || die "ERROR unable to open $tblout"; 
  while(my $line = <TBL>) { 
##target name                    accession query name           accession mdl mdl from   mdl to seq from   seq to strand trunc pass   gc  bias  score   E-value inc description of target
##------------------------------ --------- -------------------- --------- --- -------- -------- -------- -------- ------ ----- ---- ---- ----- ------ --------- --- ---------------------
#gi|151558545|gb|ABDX01000026.1| -         5S_rRNA              RF00001    cm        1      119    35552    35435      -    no    1 0.52   0.0   69.5   4.5e-14 !   Clostridium perfringens CPE str. F4969 gcontig_1106202596940, whole genome shotgun sequence
    if($line !~ m/^\#/) { 
      my @elA = split(/\s+/, $line);
      my $accn = $elA[3];
      if   (exists ($accn_H{$accn})) { $tot_ct++; $ct_H{$accn}++; }
    }
  }
  close(TBL);
}
close(LIST);

printf("#accession         num-hits\n");
my @accn_A = sort (keys %accn_H);
my $nfam_with_hits = 0;
my $ct;
foreach my $accn (@accn_A) { 
  if(exists $ct_H{$accn}) { 
    $ct = $ct_H{$accn};
    $nfam_with_hits++; 
    if($ct > 0) { 
      printf("$accn              %6d\n", $ct);
    }
  }
}
printf("total-hits           %6d\n", $tot_ct);
printf("total-fams-with-hits %6d\n", $nfam_with_hits);
printf("# families with zero hits were not printed\n");
