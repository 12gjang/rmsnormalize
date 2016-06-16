#!/bin/sh

filename="$1"
target_rms="$2"

rms=`sox "$filename" -n stats 2>&1 | grep "RMS lev dB" | awk '{print $4}'`
threshold=`echo $target_rms $rms |  awk '{printf "%f",  - ($1 - $2)}'`
threshold_hex=`echo $threshold | xxd  -p`

hexdump -ve '1/1 "%.2X"' L3.fxp.template | \
  sed "s/5E/$threshold_hex/g" | xxd -r -p > $filename.fxp


