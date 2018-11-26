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








if [ ! -e ./sample.unitigs.aligned.gfa ] ; then

  $bin/alignGFA \
    -T ../sample.utgStore 2 \
    -i ./sample.unitigs.gfa \
    -o ./sample.unitigs.aligned.gfa \
    -t 2 \
  > ./sample.unitigs.aligned.gfa.err 2>&1
fi


if [ ! -e ./sample.contigs.aligned.gfa ] ; then

  $bin/alignGFA \
    -T ../sample.ctgStore 2 \
    -i ./sample.contigs.gfa \
    -o ./sample.contigs.aligned.gfa \
    -t 2 \
  > ./sample.contigs.aligned.gfa.err 2>&1
fi


if [ ! -e ./sample.unitigs.aligned.bed ] ; then

  $bin/alignGFA -bed \
    -T ../sample.utgStore 2 \
    -C ../sample.ctgStore 2 \
    -i ./sample.unitigs.bed \
    -o ./sample.unitigs.aligned.bed \
    -t 2 \
  > ./sample.unitigs.aligned.bed.err 2>&1
fi


if [ -e ./sample.unitigs.aligned.gfa -a \
     -e ./sample.contigs.aligned.gfa -a \
     -e ./sample.unitigs.aligned.bed ] ; then
  echo GFA alignments updated.
  exit 0
else
  echo GFA alignments failed.
  exit 1
fi
