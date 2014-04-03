#!/usr/bin/perl
#
#  -- mplus font converter program
#

use open ":utf8";
use File::Copy;
use File::Path;

die "usage: make <jis-base-regular-bdf> <iso-eng-regular-bdf> <iso-eng-bold-bdf> <append-chars-both-bdf>" unless @ARGV == 4;

# make temp dir
unless (-d "temp") {
    mkdir "temp" or die "Error making dir temp";
}

# check file exists
foreach my $filename (@ARGV){
  die "File error $filename" unless -f $filename;
}

# jis2unicode japan font
print("Converting charset\n");
my $result = system "perl jis2unicode -b < $ARGV[0] > temp/r0.bdf"; 
if($result != 0){die "Error converting charset";}

print("Converting weight\n");
$result = system "perl mkbold temp/r0.bdf > temp/b0.bdf";
if($result != 0){die "Error converting weight";}

copy @ARGV[1], "temp/r1.bdf" or die $!;
copy @ARGV[2], "temp/b1.bdf" or die $!;
copy @ARGV[3], "temp/append.bdf" or die $!;

@ARGV[0] = "temp/" . @ARGV[0];

print("Processing medium\n");
combineBDF("temp/r0.bdf","temp/r1.bdf","temp/append.bdf","medium");
print("Processing bold\n");
combineBDF("temp/b0.bdf","temp/b1.bdf","temp/append.bdf","bold");

print("Converting BDF into PCF\n");
$result = system "bdftopcf out-medium.bdf > out-medium.pcf";
if($result != 0){die "Error converting into PCF";}
$result = system "bdftopcf out-bold.bdf > out-bold.pcf";
if($result != 0){die "Error converting into PCF";}

rmtree(["temp"]) or die "Error deleting dir temp";

print("Processing completed\n");

sub combineBDF{
  my $header = "";
  my @chardata = ();
  my $chars = 0;
  for(my $i=0;$i<3;$i++){
    my $filename = @_[$i];
    my $property = 0;
    open(my $fh, "<", $filename) or die "Cannot open $filename: $!";
    while(my $line = readline $fh){
      chomp $line;
      if($line =~ /^(START|END)FONT.*/){next;}
      if($line =~ /^FONT .*/){$property = 1;}
      if($line =~ /^CHARS .*/){
        @elem = split(/ /,$line);
        $chars += @elem[1]+0;
        next;
      }
      if($property){
        if($i == 0){
          $header = $header . $line ."\n";
        }
      }else{
        $chardata[$i] = $chardata[$i] . $line . "\n";
      }
      if($line =~ /^ENDPROPERTIES/){$property = 0;}
    }
    close $fh;
  }

  $header =~ s/CHARSET_REGISTRY .*/CHARSET_REGISTRY "iso10646"/m;
  $header =~ s/CHARSET_ENCODING .*/CHARSET_ENCODING "1"/m;
  $header =~ s/FOUNDRY .*/FOUNDRY "mplus-modified"/m;
  $header =~ s/FAMILY_NAME .*/FAMILY_NAME "mplus-modified"/m;
  $header =~ s/WEIGHT_NAME .*/WEIGHT_NAME "$_[3]"/m;
  $header =~ s/FONT .*/FONT -mplus-modified-gothic-$_[3]-R-normal--10-100-75-75-C-100-iso10646-1/m;

  open (FH, "> out-$_[3].bdf");
  print FH "STARTFONT 2.1\n$header"."CHARS $chars\n$chardata[0]"."$chardata[1]"."$chardata[2]ENDFONT\n";
  close(FH);
}

