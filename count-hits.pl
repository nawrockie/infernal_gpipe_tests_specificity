use strict;
use warnings;

my $usage = "usage: perl count-hits.pl <list of tblout files> <accession list file 1> <accession list file 2>\n";
if(scalar(@ARGV) != 3) { die $usage; }

my $idir = "/usr/local/infernal/1.1.1/bin";
my ($tblout_file, $accn1_file, $accn2_file) = (@ARGV);

# read accession list 1
my %accn1_H = ();
open(LIST, $accn1_file) || die "ERROR unable to open $accn1_file";
while(my $accn = <LIST>) { 
  chomp $accn;
  if($accn !~ m/^\#/ && $accn =~ m/\w/) { 
    $accn1_H{$accn} = 1; 
  }
}
close(LIST);

# read accession list 2
my %accn2_H = ();
open(LIST, $accn2_file) || die "ERROR unable to open $accn1_file";
while(my $accn = <LIST>) { 
  chomp $accn;
  if($accn !~ m/^\#/ && $accn =~ m/\w/) { 
    if(exists $accn1_H{$accn}) { die "ERROR read $accn in both $accn1_file and $accn2_file"; }
    $accn2_H{$accn} = 1; 
  }
}
close(LIST);

# read tblout list
my %ct1_H = ();
my %ct2_H = ();
my $tot_ct1 = 0;
my $tot_ct2 = 0;
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
      if   (exists ($accn1_H{$accn})) { $tot_ct1++; $ct1_H{$accn}++; }
      elsif(exists ($accn2_H{$accn})) { $tot_ct2++; $ct2_H{$accn}++; }
      #else { die "ERROR read accn not in either accession file: $accn\n"; }
    }
  }
  close(TBL);
}
close(LIST);

printf("# accession\taccn-listed-in-%s\taccn-listed-in-%s\n", $accn1_file, $accn2_file);
my @accn_A = sort ((keys (%accn1_H)), (keys (%accn2_H)));
my $nfam1 = 0;
my $nfam2 = 0;
my $ct1;
my $ct2;
foreach my $accn (@accn_A) { 
  if(exists $ct1_H{$accn}) { 
    $ct1 = $ct1_H{$accn};
    $nfam1++; 
  }
  else { 
    $ct1 = 0;
  }
  if(exists $ct2_H{$accn}) { 
    $ct2 = $ct2_H{$accn};
    $nfam2++; 
  }
  else { 
    $ct2 = 0;
  }
  if($ct1 > 0 || $ct2 > 0) { 
    printf("$accn\t%d\t%d\n", $ct1, $ct2);
  }
}
printf("total-hits\t%d\t%d\n", $tot_ct1, $tot_ct2);
printf("total-fams\t%d\t%d\n", $nfam1, $nfam2);

printf("# families with zero hits in both columns were not printed\n");
