#!/bin/bash

cdname=$1
chemin=$2
methodname=$3
codecaudio=$4

methodname_1 () {
for f in *.wav 
do
finalname=$(printf "track%02d".wav $n)
echo "mv "$f" "$finalname""
mv "$f" "$finalname"
if [ $codecaudio = "flac" ] 
then
codec_flac
fi
((n++))
done
}

methodname_2 () {
for f in *.wav 
do
finalname=${f//.cdda} 
echo rename $f to $finalname
mv "$f" "$finalname"
if [ $codecaudio = "flac" ] 
then
codec_flac
fi
done
}

codec_flac () {
shortname=${finalname//.wav}
echo convert $finalname to $shortname.flac
./flac -s -f --best --delete-input-file $finalname
}


if [ ! -d "$chemin" ] 
then
echo création du chemin $chemin
mkdir -p "$chemin"
fi

cd "$chemin"
wget https://github.com/legluondunet/mlls-tools/raw/master/audiotools/audiotools.tar.xz
tar xfv audiotools.tar.xz

cddev=$(mount |grep -i $cdname |cut -d " " -f 1)
echo "les variables --> cdname:$cdname cddev:$cddev"
LD_LIBRARY_PATH=libs ./cdparanoia -BE -d $cddev


echo methodname est égal à $methodname
echo le format audio choisi est $codecaudio

if [ $methodname = 1 ] 
then 
	echo methodname est égal à 1
	n=1
	methodname_1
elif [ $methodname = 2 ] 
then
	echo methodname est égal à 2
	methodname_2
fi

rm -f -r cdparanoia flac lame metaflac libs audiotools.sh about_audiotools.txt audiotools.tar.xz

