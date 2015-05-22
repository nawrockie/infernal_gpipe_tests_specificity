while($line = <>) { 
  chomp $line;
  $orig_file = $line;
  $new_file  = $line;
  $new_file =~ s/.tbl/.deoverlapped.tbl/;
  print "grep -v ^\# $orig_file | sort -k16,16g -k15,15rn | perl remove-overlaps.pl > $new_file\n";
}
