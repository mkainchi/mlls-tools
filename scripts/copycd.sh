#!/bin/bash

cdname=$1
clean=$2

cddev=$(mount |grep -i $cdname |cut -d " " -f 1)

echo "Variables : cdname:$cdname cddev:$cddev"

udisksctl unmount -b $cddev

rm -f -r $cdname.*

echo "./cdrdao read-cd --read-raw --datafile $cdname.bin --driver generic-mmc:0x20000 --device $cddev $cdname.toc"
./cdrdao read-cd --read-raw --datafile "$cdname.bin" --driver generic-mmc:0x20000 --device $cddev "$cdname.toc"

./toc2cue $cdname.toc $cdname.cue

if [ -z "$clean" ]; then
rm -f -r *.toc toc2cue cdrdao bchunk bin2iso 7z about_cdrtools.txt
fi

