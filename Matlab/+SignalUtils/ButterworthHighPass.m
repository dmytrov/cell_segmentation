function res = ButterworthHighPass(x, fSampling, fCutoff)
    res = SignalUtils.Butterworth(x, fSampling, fCutoff, 'high');
end