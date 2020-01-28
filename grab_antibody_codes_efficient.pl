#Barcode structure: 
#R1 ^[16] = cell barcode
#R2 ^10[15] = antibody barcode
#I1 = umi.

if (@ARGV !=2 ) {die "Usage: grab_antibody_codes_efficient.pl Read1.fastq Read2.fastq.\n";}


%refcodes =();
open($ifh1, "/home/wizard/Tallulah/HumanLiverDeepDive/100819QG_TotalSeq-C_human_Panel_list.csv") or die $!;
<$ifh1>; # header
while(<$ifh1>) {
  chomp;
  @stuff = split(/\t/);
  $code =$stuff[4];
  $code =~ s/"//g;
#  print $stuff[2]."\t".$code."\n";
  $refcodes{$code}=0;
}
close($ifh1);

%ref =();
%out =();
open($ifh, $ARGV[1]) or die $!;
my $umi = "";
while (<$ifh>) {
    chomp;
    if ($_ =~ /^\@/){
      @stuff = split(/\s+/);
      $umi = $stuff[1];
      $umi =~/.+:([ATCG]+)/;
      $umi = $1;
      my $seq = <$ifh>;
      my $antibody = substr($seq, 10, 15);
      if (exists($refcodes{$antibody})) {
        $refcodes{$antibody}++;
        $out{$stuff[0]}->{umi}=$umi;
        $out{$stuff[0]}->{antibody}=$code;
        #print $stuff[0]."\t".$umi."\t".$antibody."\n";
        next;
      }

      foreach my $code (keys(%refcodes)) {
        if ($seq =~ $code) {
          $refcodes{$code}++;
          $out{$stuff[0]}->{umi}=$umi;
          $out{$stuff[0]}->{antibody}=$code;
#          print $stuff[0]."\t".$umi."\t".$code."\n";
          next;
        }
      }
    }
}

close($ifh);

open($ifh2, $ARGV[0]) or die $!;
my $cellcode = "";
while (<$ifh2>) {
    chomp;
    if ($_ =~ /^\@/){
      @stuff = split(/\s+/);
      my $seq = <$ifh2>;
      my $barcode = substr($seq, 0, 16);
      $out{$stuff[0]}->{barcode}=$barcode;
    }
}
close($ifh2);

my $count = 0;
foreach my $read (keys(%out)) {
  if (exists($out{$read}->{barcode}) && 
      exists($out{$read}->{umi}) && 
      exists($out{$read}->{antibody})) {
    print $read."\t".$out{$read}->{barcode}."\t".$out{$read}->{umi}."\t".$out{$read}->{antibody}."\n";
    $count++;
  }
}

print $count;

#foreach my $code (keys(%refcodes)) {
#  print STDERR ($code." ".$refcodes{$code}."\n");
#}

