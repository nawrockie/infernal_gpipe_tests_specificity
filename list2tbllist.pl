$usage = "usage: perl list2tbllist.pl <list file> <directory with *.deoverlapped.tbl files>";
if(scalar(@ARGV) != 2) { die $usage; }

($listfile, $dir) = (@ARGV);

if(! -d $dir) { die "ERROR $dir directory does not exist."; }

open(LIST, $listfile) || die "ERROR unable to open $listfile";
while($line = <LIST>) { 
#Actinobacillus_ureae_ATCC_25976	/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data19/Actinobacillus_ureae_ATCC_25976/244828-DENOVO-20150227-1622.1478424/output/bacterial_annot/AEVG01.annotation.nucleotide.fa
  ($gkey, $gfile) = split(/\s+/, $line);

  my $deoverlapped_tbl_file = $dir . "/" . $gkey . ".deoverlapped.tbl";
  if(-e $deoverlapped_tbl_file) { 
    print $deoverlapped_tbl_file . "\n";
  }
}
close(LIST);
