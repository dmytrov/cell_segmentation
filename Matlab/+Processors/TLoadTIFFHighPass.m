classdef TLoadTIFFHighPass < Processors.TLoadTIFF
    methods (Access = public)
        function this = TLoadTIFFHighPass(name, pipeline)
            this = this@Processors.TLoadTIFF(name, pipeline);
        end
        
        function res = FilterData(this, data)
            data = FilterData@Processors.TLoadTIFF(this, data);
            order = 50;
            fNyquist = 1024/2;
            fCutoff = 10;
            b = fir1(order, fCutoff/fNyquist, 'high');
            h = freqz2( ftrans2(b), [size(data, 1), size(data, 2)]);
            for k = 1:size(data, 3)
                slice = data(:,:,k);
                sliceFT = fft2(slice);
                %DC = sliceFT(1,1);
                sliceFT = fftshift(sliceFT);
                sliceFTHigh = h .* sliceFT;
                sliceFTHigh = rot90(fftshift(rot90(sliceFTHigh,2)),2);        
                %sliceFTHigh(1,1) = DC;                                   
                sliceHigh = real(ifft2(sliceFTHigh));                       
                data(:,:,k) = sliceHigh;
            end
            res = data;
        end        
    end    
end