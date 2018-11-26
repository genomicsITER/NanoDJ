#!/bin/sh


#  Path to Canu.

syst=`uname -s`
arch=`uname -m | sed s/x86_64/amd64/`

bin="/home/jovyan/software/canu/$syst-$arch/bin"

if [ ! -d "$bin" ] ; then
  bin="/home/jovyan/software/canu"
fi

#  Report paths.

echo ""
echo "Found perl:"
echo "  " `which perl`
echo "  " `perl --version | grep version`
echo ""
echo "Found java:"
echo "  " `which java`
echo "  " `java -showversion 2>&1 | head -n 1`
echo ""
echo "Found canu:"
echo "  " $bin/canu
echo "  " `$bin/canu -version`
echo ""


#  Environment for any object storage.

export CANU_OBJECT_STORE_CLIENT=
export CANU_OBJECT_STORE_NAMESPACE=sample
export CANU_OBJECT_STORE_PROJECT=




#  Discover the job ID to run, from either a grid environment variable and a
#  command line offset, or directly from the command line.
#
if [ x$CANU_LOCAL_JOB_ID = x -o x$CANU_LOCAL_JOB_ID = xundefined -o x$CANU_LOCAL_JOB_ID = x0 ]; then
  baseid=$1
  offset=0
else
  baseid=$CANU_LOCAL_JOB_ID
  offset=$1
fi
if [ x$offset = x ]; then
  offset=0
fi
if [ x$baseid = x ]; then
  echo Error: I need CANU_LOCAL_JOB_ID set, or a job index on the command line.
  exit
fi
jobid=`expr $baseid + $offset`
if [ x$CANU_LOCAL_JOB_ID = x ]; then
  echo Running job $jobid based on command line options.
else
  echo Running job $jobid based on CANU_LOCAL_JOB_ID=$CANU_LOCAL_JOB_ID and offset=$offset.
fi

if [ $jobid -eq 1 ] ; then
  bat="001"
  job="001/000001"
  opt="-h 1-3604 -r 1-3604 --hashdatalen 4085118"
fi


if [ ! -d ./$bat ]; then
  mkdir ./$bat
fi


if [ -e $job.ovb ]; then
  exists=true
else
  exists=false
fi
if [ $exists = true ] ; then
  echo Job previously completed successfully.
  exit
fi


$bin/overlapInCore \
  -t 2 \
  -k 22 \
  -k ../0-mercounts/sample.ms22.dump \
  --hashbits 22 \
  --hashload 0.8 \
  --maxerate  0.12 \
  --minlength 50 \
  $opt \
  -o ./$job.ovb.WORKING \
  -s ./$job.stats \
  ../../sample.seqStore \
&& \
mv ./$job.ovb.WORKING ./$job.ovb


exit 0
