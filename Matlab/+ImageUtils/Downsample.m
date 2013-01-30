% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = Downsample(img, scaleX, scaleY, scaleZ)
    res = zeros(size(img)/2);

    q1 = 1:scaleX:size(img, 1)-1;
    q2 = 1:scaleY:size(img, 2)-1;
    q3 = 1:scaleZ:size(img, 3)-1;

    for k1 = 0:scaleX-1
        for k2 = 0:scaleY-1
            for k3 = 0:scaleZ-1
                res = res + img(q1+k1, q2+k2, q3+k3);
            end
        end
    end
    
    res = res / (scaleX * scaleY * scaleZ);
end