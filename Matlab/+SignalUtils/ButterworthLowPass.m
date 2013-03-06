function res = ButterworthLowPass(x, fSampling, fCutoff)
    res = SignalUtils.Butterworth(x, fSampling, fCutoff, 'low');
end