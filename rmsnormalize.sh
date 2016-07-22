#!/bin/sh

filename="$1"
target_rms="$2"

ext="${filename##*.}"
prefix="${filename%.*}"

sample_rate=`soxi $filename | \
  grep "Sample Rate" | \
  awk '{print $4}'`

precision=`soxi $filename | \
  grep "Precision" | \
  awk '{print $3}' | \
  sed 's/-bit//g'`

rms=`sox "$filename" -n stats 2>&1 | \
  grep "RMS lev dB" | \
  awk '{print $4}'`

threshold=`echo $target_rms $rms | \
  awk '{printf "%f",  - ($1 - $2)}'`

echo INFILE_RMS:  $rms
echo TARGET_RMS:  $target_rms
echo THRESHOLD:   $threshold

python build_fxp.py $threshold $filename.fxp

sox $filename \
  --bits $precision \
  --rate $sample_rate \
  --encoding signed-integer \
  --endian little \
  --channels 2 \
  $prefix.raw

mrswatson64 \
  --input $prefix.raw \
  --output $prefix.norm.raw \
  --plugin "WaveShell-VST 9.6:L3GS,$filename.fxp"

sox \
  --bits $precision \
  --rate $sample_rate \
  --encoding signed-integer \
  --endian little \
  --channels 2 \
  $prefix.norm.raw $prefix.norm.$ext

rm $filename.fxp
rm $prefix.raw
rm $prefix.norm.raw

