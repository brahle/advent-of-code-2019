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

@initial_velocities = map { [@$_] } @velocities;
@initial_positions = map { [@$_] } @positions;

@cycle_length = (-1, -1, -1);

for (my $n = 0; $n < 100000000; ++$n) {
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


    my $checked = 0;
    for (my $k = 0; $k < 3; ++$k) {
        if ($cycle_length[$k] == -1) {
            $checked = 1;
            my $ok = 1;
            for (my $i = 0; $i < 4; ++$i) {
                if ($positions[$i][$k] != $initial_positions[$i][$k]) {
                    $ok = 0;
                } else {
                }
                if ($velocities[$i][$k] != $initial_velocities[$i][$k]) {
                    $ok = 0;
                }
            }
            if ($ok) {
                $cycle_length[$k] = $n;
            }
        }
    }

    if ($n % 10000 == 0) {
        print $n, " ", $cycle_length[0], " ", $cycle_length[1] , " ", $cycle_length[2], "\n";
    }
    last if $checked == 0;
}

for (my $i = 0; $i < 3; ++$i) {
    print ++$cycle_length[$i], " "
}
print "\n";

sub gcd {
    my ($a, $b) = @_;
    return $b if ($a == 0);
    return $a if ($b == 0);
    return gcd($b, $a % $b);
}

$ret = 1;
for (my $i = 0; $i < 3; ++$i) {
    my $g = gcd($ret, $cycle_length[$i]);
    $ret = $ret / $g * $cycle_length[$i];
}
print "$ret\n";
