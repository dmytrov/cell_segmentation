% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TVectorImageIntersectRes
    properties (SetAccess = public)        
        ptIntersectRes;
        imgCoords;
        imgValAtPt;
        dist;
    end
    
    methods (Access = public)
        function obj = TVectorImageIntersectRes(ptIntersectRes, imgCoords, imgValAtPt, dist)
            obj.ptIntersectRes = ptIntersectRes;
            obj.imgCoords = imgCoords;
            obj.imgValAtPt = imgValAtPt;
            obj.dist = dist;
        end
    end
end