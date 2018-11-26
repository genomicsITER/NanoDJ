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

if [ -e ../sample.ctgStore/seqDB.v001.tig -a -e ../sample.utgStore/seqDB.v001.tig ] ; then
  exit 0
fi

#
#  Check if the outputs exist.
#
#  The boilerplate function for doing this fails if the file isn't
#  strictly below the current directory, so some gymnastics is needed.
#

cd ..

if [ -e sample.ctgStore/seqDB.v001.tig ]; then
  exists=true
else
  exists=false
fi

if [ -e sample.utgStore/seqDB.v001.tig ]; then
  exists=true
else
  exists=false
fi

cd 4-unitigger

#
#  Run if needed.
#

if [ $exists = false ] ; then
  $bin/bogart \
    -S ../../sample.seqStore \
    -O    ../sample.ovlStore \
    -o     ./sample \
    -gs 2100000 \
    -eg 0.12 \
    -eM 0.12 \
    -mo 50 \
    -dg 6 \
    -db 6 \
    -dr 3 \
    -ca 2100 \
    -cp 200 \
    -threads 2 \
    -M 4 \
    -unassembled 2 0 1.0 0.5 3 \
    > ./unitigger.err 2>&1 \
  && \
  mv ./sample.ctgStore ../sample.ctgStore \
  && \
  mv ./sample.utgStore ../sample.utgStore
fi

if [ ! -e ../sample.ctgStore -o \
     ! -e ../sample.utgStore ] ; then
  echo bogart appears to have failed.  No sample.ctgStore or sample.utgStore found.
  exit 1
fi











if [ ! -e ../sample.ctgStore/seqDB.v001.sizes.txt ] ; then
  $bin/tgStoreDump \
    -S ../../sample.seqStore \
    -T ../sample.ctgStore 1 \
    -sizes -s 2100000 \
   > ../sample.ctgStore/seqDB.v001.sizes.txt
fi


exit 0
