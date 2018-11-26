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
  rge="-b 1 -e 3604"
  job="000001"
fi


if [ x$job = x ] ; then
  echo Job partitioning error.  jobid $jobid is invalid.
  exit 1
fi

if [ ! -d ./blocks ]; then
  mkdir -p ./blocks
fi


if [ -e blocks/$job.dat ]; then
  exists=true
else
  exists=false
fi
if [ $exists = true ] ; then
  echo Job previously completed successfully.
  exit
fi

#  Remove any previous result.
rm -f ./blocks/$job.input.dat

$bin/sqStoreDumpFASTQ \
  -S ../../sample.seqStore \
  $rge \
  -nolibname \
  -noreadname \
  -fasta \
  -o ./blocks/$job.input \
|| \
mv -f ./blocks/$job.input.fasta ./blocks/$job.input.fasta.FAILED


if [ ! -e ./blocks/$job.input.fasta ] ; then
  echo Failed to extract fasta.
  exit 1
fi


echo ""
echo Starting mhap precompute.
echo ""

#  So mhap writes its output in the correct spot.
cd ./blocks

java -d64 -XX:ParallelGCThreads=2 -server -Xms3686m -Xmx3686m \
  -jar  $bin/../share/java/classes/mhap-2.1.3.jar  \
  --repeat-weight 0.9 --repeat-idf-scale 10 -k 16 \
  --store-full-id \
  --num-hashes 768 \
  --num-min-matches 2 \
  --ordered-sketch-size 1536 \
  --ordered-kmer-size 12 \
  --threshold 0.78 \
  --filter-threshold 0.0000001 \
  --min-olap-length 50 \
  --num-threads 2 \
  -f  ../../0-mercounts/sample.ms16.ignore.gz  \
  -p  ./$job.input.fasta  \
  -q  .  \
&& \
mv -f ./$job.input.dat ./$job.dat

if [ ! -e ./$job.dat ] ; then
  echo Mhap failed.
  exit 1
fi

#  Clean up, remove the fasta input
rm -f ./$job.input.fasta


exit 0
