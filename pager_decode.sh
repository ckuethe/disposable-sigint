#!/bin/bash

# 2m amateur radio band
FREQ="144.575M"

#PPM="-p 22" # your device-specific value goes here
#MOD="-M fm" # default is "fm" (NBFM)
#GAIN="-g 38" # default to auto gain
#SQUELCH="-l 100" # play with squelch, maybe it doesn't matter
#FILTERS="-E dc" # optional DC blocking filter

PROTOS="-e -f alpha -c -a FLEX -a POCSAG2400 -a POCSAG1200 -a POCSAG512"
AR=22050 # multimon generally requires this sample rate

exec 2>/dev/null

rtl_fm -f $FREQ -s $AR $PPM $GAIN $SQUELCH $MOD $FILTERS - | \
	multimon-ng $PROTOS -q -t raw /dev/stdin | \
	sed --unbuffered -r \
		-e 's/^[A-Z0-9]*: *//' \
		-e 's/ *[Ff]unction: [0-9] */ /' \
		-e 's/<[A-Z]{3}>//g'
