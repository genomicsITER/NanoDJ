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

if [ $jobid -gt 1 ]; then
  echo Error: Only 1 partitions, you asked for $jobid.
  exit 1
fi

if [ $jobid -eq 1 ] ; then
  bgn=1
  end=3604
fi

jobid=`printf %04d $jobid`

if [ -e "./results/$jobid.cns" ] ; then
  echo Job finished successfully.
  exit 0
fi

if [ ! -d "./results" ] ; then
  mkdir -p "./results"
fi




seqStore="../../sample.seqStore"


$bin/falconsense \
  -S $seqStore \
  -C ../sample.corStore \
  -R ./sample.readsToCorrect \
  -r $bgn-$end \
  -t  2 \
  -cc 0 \
  -cl 50 \
  -oi 0.5 \
  -ol 50 \
  -p ./results/$jobid.WORKING \
  -cns \
  > ./results/$jobid.err 2>&1 \
&& \
mv ./results/$jobid.WORKING.cns ./results/$jobid.cns \


exit 0
