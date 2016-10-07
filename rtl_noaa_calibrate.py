#!/usr/bin/env python

import os
import numpy as np
from rtlsdr import RtlSdr
from scipy.signal import welch as welch_psd

def compute_ppmcorr(freqs, psd, chanwidth = 25e3):
    outfreq = map(int,freqs)
    psd = list(psd)
    energy = sorted(list(zip(outfreq, psd)), key=lambda x: x[1], reverse=True)

    max_energy_freq = energy[0][0]
    
    desired_chan = round(max_energy_freq/chanwidth) * chanwidth
    freq_diff = desired_chan - max_energy_freq
    ppmcorr = int(round(freq_diff / desired_chan * 1e6))
    return ppmcorr

def main():
    r = RtlSdr()

    # 162.475MHz is the center of the NOAA band but is also a channel.
    # Pick something between channel 3 and 4
    Fc = 162.46325e6

    # Don't need more than 250kSps, but grab a little slush anyway
    Fs = 300e3

	# works for me.
    gain = 'auto'

    r.center_freq = Fc
    r.sample_rate = Fs
    r.gain = gain

    print "\nhardware freq: {0}MHz".format(r.center_freq/1e6)
    print "sample rate: {0}Msps".format(r.sample_rate/1e6)


    bs = 4096
    sigbuf = []
    for i in xrange(int(Fs/bs)):
        samps = r.read_samples(bs)
        sigbuf.append(samps)

    samples = np.concatenate(sigbuf)
    wfreqs, wpsd = welch_psd(samples, fs=Fs)
    print "\nRTL PPM correction: {0}".format(compute_ppmcorr(wfreqs+Fc, wpsd))


if __name__ == '__main__':
    main()
