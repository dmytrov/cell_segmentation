function res = Downsample2X(img)
    res = zeros(size(img)/2);

    q1 = 1:2:size(img, 1)-1;
    q2 = 1:2:size(img, 2)-1;
    q3 = 1:2:size(img, 3)-1;

    for k1 = 0:1
        for k2 = 0:1
            for k3 = 0:1
                res = res + img(q1+k1, q2+k2, q3+k3);
            end
        end
    end
    
    res = res / 8;

end