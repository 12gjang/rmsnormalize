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
  awk '{printf "%f",  - ($1 - $2)}' | \
  xxd -p`

hexdump -ve '1/1 "%.2X"' L3.fxb.template | \
  sed "s/5E/$threshold/g" | \
  xxd -r -p > $filename.fxb

sox $filename \
  --bits $precision \
  --rate $sample_rate \
  --encoding signed-integer \
  --endian little \
  $prefix.raw

mrswatson64 \
  --input $prefix.raw \
  --output $prefix.norm.raw \
  --plugin "WaveShell-VST 9.6:L3GS,$filename.fxb"

sox \
  --bits $precision \
  --rate $sample_rate \
  --encoding signed-integer \
  --endian little \
  $prefix.norm.raw $prefix.norm.$ext