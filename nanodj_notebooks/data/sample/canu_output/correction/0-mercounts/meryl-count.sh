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

if [ $jobid -gt 01 ]; then
  echo Error: Only 01 jobs, you asked for $jobid.
  exit 1
fi

jobid=`printf %02d $jobid`

#  If the meryl database exists, we're done.

if [ -e ./sample.$jobid.meryl/merylIndex ] ; then
  echo Kmers for batch $jobid exist.
  exit 0
fi

#  If the meryl output exists in the object store, we're also done.


if [ -e sample.$jobid.meryl.tar ]; then
  exist1=true
else
  exist1=false
fi
if [ $exist1 = true ] ; then
  echo Kmers for batch $jobid exist in the object store.
  exit 0
fi

#  Nope, not done.  Fetch the sequence store.


#  And compute.

/home/jovyan/software/canu/Linux-amd64/bin/meryl k=16 threads=2 memory=2 \
  count \
    segment=$jobid/01 ../../sample.seqStore \
    output ./sample.$jobid.meryl.WORKING \
&& \
mv -f ./sample.$jobid.meryl.WORKING ./sample.$jobid.meryl


exit 0
