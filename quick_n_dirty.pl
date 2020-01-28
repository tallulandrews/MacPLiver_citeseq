
%refcodes =();
open($ifh1, "barcodes.tsv") or die $!;
#<$ifh1>; # header
while(<$ifh1>) {
  chomp;
#  @stuff = split(/\t/);
#  $code =$stuff[4];
  $code=$_;
  $code =~ s/"//g;
#  print $stuff[2]."\t".$code."\n";
  $refcodes{$code}=0;
}

%ref =();
my $count=0;
open($ifh, $ARGV[0]) or die $!;
my $umi = "";
while (<$ifh>) {
    chomp;
    if ($count > 10) {last;}
    if ($_ =~ /^\@/){
      @stuff = split(/\s+/);
      $umi = $stuff[1];
      $umi =~/.+:([ATCG]+)/;
      $umi = $1;
      my $seq = <$ifh>;
      foreach my $code (keys(%refcodes)) {
        if ($seq =~ $code) {
          $refcodes{$code}++;
          print $code."\n";
          print $seq."\n";
          $count++;

        }
      }
    }
}


foreach my $code (keys(%refcodes)) {
  print $code." ".$refcodes{$code}."\n";
}

