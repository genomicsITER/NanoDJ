set title 'trim5'
set xlabel 'length, bin width = 25'
set ylabel 'number'

binwidth=25
set boxwidth binwidth
bin(x,width) = width*floor(x/width) + binwidth/2.0

set terminal png size 1024,1024
set output './sample.1.trimReads.trim5.lg.png'
plot [] [0:] './sample.1.trimReads.trim5.dat' using (bin($1,binwidth)):(1.0) smooth freq with boxes title ''

set terminal png size 256,256
set output './sample.1.trimReads.trim5.sm.png'
replot
