# rmsnormalize
Command line tool that limits an audio file using Waves L3 Ultramaximizer to a target RMS.

## Requirements
- sox
- MrsWatson
- python
- Waves L3 Ultramaximizer

## Caveats

Currently only works on signed-int 2-channel little-endian files (so most AIFF and WAV files should work).

## Usage

$ rmsnormalize.sh \<INPUT_FILENAME> \<TARGET_RMS>

## Example (yielding around -6 RMS for heat_seeker.wav)

$ rmsnormalize.sh heat_seeker.wav -6.0

## Todo

Make project single-file python script.

## Notes

Kudos to @alexras for his vst2preset.py script.

