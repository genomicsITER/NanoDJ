
unset multiplot

set terminal png size 1024,1024
set output 'sample.ms16.histogram.png'

set multiplot

#  Distinct-vs-total full size plot

set origin 0.0,0.0
set size   1.0,1.0

set xrange [0.5:1.0]
set yrange [0.0:1.0]

unset ytics
set y2tics 0.1

plot [0.5:1.0] 'sample.ms16.histogram' using 3:4 with lines title 'Distinct-vs-Total'

#  Distinct-vs-total zoom in lower left corner

set origin 0.05,0.10
set size   0.40,0.40

set xrange [0.975:1.0]
set yrange [0.4:0.80]

unset ytics
set y2tics 0.1

plot [0.975:1.0] 'sample.ms16.histogram' using 3:4 with lines title 'Distinct-vs-Total'

#  Histogram in upper left corner

set origin 0.05,0.55
set size   0.40,0.40

set xrange [0:200]
set yrange [0:30000000]

unset ytics
set y2tics 10e6
unset mytics

plot [0:200] 'sample.ms16.histogram' using 1:2 with lines title 'Histogram'
