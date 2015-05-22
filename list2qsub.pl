$usage = "usage: perl list2qsub.pl <list file> <output directory (must not yet exist)>";
if(scalar(@ARGV) != 2) { die $usage; }

my $idir      = "/usr/local/infernal/1.1.1/bin";
($listfile, $outdir) = (@ARGV);

if(-d $outdir) { die "ERROR $outdir directory already exists. Rename or remove it."; }
if(-e $outdir) { die "ERROR a file named $outdir already exists. Rename or remove it."; }

system("mkdir $outdir");

$cm_opts = "--noali --rfam --cpu 0 --nohmmonly --cut_ga";
#$cmfile  = "/home/nawrocke/db/rfam/rfam_12.0/Rfam.cm";
$cmfile  = "./Rfam.cm";

open(LIST, $listfile) || die "ERROR unable to open $listfile";
while($line = <LIST>) { 
#Actinobacillus_ureae_ATCC_25976	/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data19/Actinobacillus_ureae_ATCC_25976/244828-DENOVO-20150227-1622.1478424/output/bacterial_annot/AEVG01.annotation.nucleotide.fa
  ($gkey, $gfile) = split(/\s+/, $line);
  
  my $jobname  = "J." . $gkey;
  my $root     = $outdir . "/" . $gkey;
  my $tblout   = $root . ".tbl"; 
  my $errfile  = $root . ".err"; 
  my $timefile = $root . ".time"; 
  
  # use /usr/bin/time to time the execution time
  # don't save stdout
  # 144000 seconds is 40 hours
  printf("qsub -N $jobname -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e $errfile -l h_rt=144000,mem_free=8G,h_vmem=16G -m n \"/usr/bin/time $idir/cmsearch $cm_opts --tblout $tblout $cmfile $gfile > /dev/null 2> $timefile\"\n");
}  
