#!/bin/bash

MY_PID=$$
LOG=$(date +acars_%Y%m%d%H%M%S.txt)

#		pri	sec	tert	usa1	usa2	usa3	
FREQS_US='	131.55	130.025	129.125	130.425	130.45	131.125	130.575'

#		pri	sec	tert	eu1	eu2	eu3
FREQS_EU='	131.550	130.025	129.125	131.725	131.525 131.850'

FREQ_SITA='136.700 136.750 136.800 136.850 136.925'

# Device specific calibration value 
PPM=22

F=$FREQS_US
if tty -s ; then
	touch ~/$LOG
	tail -n -200 -f ~/${LOG} & 
	exec 2>/dev/null
fi

# this requires ckuethe's patched acarsdec which supports more than 4
# channels and includes tunings for the Allwinner R8 (Cortex-A8)
acarsdec -p $PPM -g 1000 -l ${LOG} -r 0 $F || kill -TERM -$MY_PID $MY_PID

