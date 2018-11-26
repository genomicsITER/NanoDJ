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
  blk="000001"
  slf=""
  qry="000001"
fi


if [ x$qry = x ]; then
  echo Error: Job index out of range.
  exit 1
fi

if [ -e ./results/$qry.ovb ]; then
  echo Job previously completed successfully.
  exit
fi


if [ -e ./queries.tar -a ! -d ./queries ] ; then
  tar -xf ./queries.tar
fi

if [ ! -d ./results ]; then
  mkdir -p ./results
fi

if [ ! -d ./blocks ] ; then
  mkdir -p ./blocks
fi
for ii in `ls ./queries/$qry` ; do
  echo Fetch blocks/$ii
done


echo ""
echo Running block $blk in query $qry
echo ""

if [ ! -e ./results/$qry.mhap ] ; then
  java -d64 -XX:ParallelGCThreads=2 -server -Xms3686m -Xmx3686m \
    -jar  $bin/../share/java/classes/mhap-2.1.3.jar  \
    --repeat-weight 0.9 --repeat-idf-scale 10 -k 16 \
    --store-full-id \
    --num-hashes 768 \
    --num-min-matches 2 \
    --threshold 0.78 \
    --filter-threshold 0.0000001 \
    --ordered-sketch-size 1536 \
    --ordered-kmer-size 12 \
    --min-olap-length 50 \
    --num-threads 2 \
    -s  ./blocks/$blk.dat $slf  \
    -q  queries/$qry  \
  > ./results/$qry.mhap.WORKING \
  && \
  mv -f ./results/$qry.mhap.WORKING ./results/$qry.mhap
fi

if [   -e ./results/$qry.mhap -a \
     ! -e ./results/$qry.ovb ] ; then
  $bin/mhapConvert \
    -S ../../sample.seqStore \
    -o ./results/$qry.mhap.ovb.WORKING \
    ./results/$qry.mhap \
  && \
  mv ./results/$qry.mhap.ovb.WORKING ./results/$qry.mhap.ovb
fi

if [   -e ./results/$qry.mhap -a \
       -e ./results/$qry.mhap.ovb ] ; then
  rm -f ./results/$qry.mhap
fi

if [ -e ./results/$qry.mhap.ovb ] ; then
  mv -f ./results/$qry.mhap.ovb ./results/$qry.ovb
fi


exit 0
