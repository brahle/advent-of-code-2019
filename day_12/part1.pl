#!/usr/bin/perl

@velocities = (
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
);

@positions = ();

foreach my $line (<>) {
    my ($x, $y, $z) = ($line =~ /<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/);
    push(@positions, [$x, $y, $z]);
}

for (my $n = 0; $n < 1000; ++$n) {
    for (my $i = 0; $i < 4; ++$i) {
        for (my $j = 0; $j < 3; ++$j) {
            my $delta = 0;
            for (my $k = 0; $k < 4; ++$k) {
                if ($positions[$i][$j] < $positions[$k][$j]) {
                    ++$delta;
                } elsif ($positions[$i][$j] > $positions[$k][$j]) {
                    --$delta;
                }
            }
            $velocities[$i][$j] += $delta;
        }
    }

    for (my $i = 0; $i < 4; ++$i) {
        for (my $j = 0; $j < 3; ++$j) {
            $positions[$i][$j] += $velocities[$i][$j];
        }
    }
}

$tot = 0;
for (my $i = 0; $i < 4; ++$i) {
    my $pot = 0;
    for (my $j = 0; $j < 3; ++$j) {
        print $positions[$i][$j], " ";
        $pot += abs($positions[$i][$j]);
    }
    my $kin = 0;
    for (my $j = 0; $j < 3; ++$j) {
        print $velocities[$i][$j], " ";
        $kin += abs($velocities[$i][$j]);
    }
    print "\n";
    $tot += $pot * $kin;
}
print "$tot\n"
