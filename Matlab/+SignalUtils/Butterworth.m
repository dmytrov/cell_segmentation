function res = Butterworth(x, fSampling, fCutoff, mode)
    fNyquist = fSampling / 2;
    order = 3;
    [b, a] = butter(order, fCutoff / fNyquist, mode); 
    res = filtfilt(b, a, x);
end