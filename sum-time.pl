$tot_secs = 0.;
my $nread = 0;
while($line = <>) { 
  chomp $line; 
  if($line =~ m/elapsed/) { 
    $hr = 0;
    $min = 0;
    $sec = 0;
    if($line =~ /\s+(\d+\:\d\d\.\d\d)elapsed/) { 
# 333.73user 2.77system 5:37.70elapsed 99%CPU (0avgtext+0avgdata 850496maxresident)k
      $elapsed = $1;
      ($min, $sec) = split(":", $elapsed);
    }
    elsif($line =~ /\s+(\d+\:\d+\:\d\d\.\d\d)elapsed/) { 
# 7632.56user 37.79system 2:07:59elapsed 99%CPU (0avgtext+0avgdata 7199680maxresident)k
      $elapsed = $1;
      ($hr, $min, $sec) = split(":", $elapsed);
    }
    $tot_secs += ($hr * 3600.) + ($min * 60.) + $sec;
    $nread++;
  }
}

$avg_secs = $tot_secs / $nread;

$tot_hours = int($tot_secs / 3600.);
$tot_secs -= ($tot_hours * 3600.);
$tot_mins  = int($tot_secs / 60.);
$tot_secs -= ($tot_mins * 60.);
  
printf("Total   time: %d:%2d:%5.2f (hh:mm:ss) ($nread genomes)\n", $tot_hours, $tot_mins, $tot_secs);

$avg_hours = int($avg_secs / 3600.);
$avg_secs -= ($avg_hours * 3600.);
$avg_mins  = int($avg_secs / 60.);
$avg_secs -= ($avg_mins * 60.);

printf("Average time: %2d:%2d:%5.2f (hh:mm:ss)\n", $avg_hours, $avg_mins, $avg_secs);
