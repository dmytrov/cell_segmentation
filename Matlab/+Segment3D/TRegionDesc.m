% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TRegionDesc < handle
    properties (Constant = true)
        UNCLASSIFIED    = 0;
        CELL            = 1;
        VESSEL          = 2;
        AXON            = 3;
        NOISE           = 4;
    end
    
    properties (Access = public)
        ID;             % global ID of the region
        Type;           % cell/vessel/axon/noise
        Center;
        Pixels;         % 3xN matrix
        SearchStruct;   % KD-tree
    end
    
    methods (Access = public)
        function this = TRegionDesc(id, pixels, center, type)
            this.ID = id;
            this.Pixels = pixels;
            this.Type = type;
            this.Center = center;
            this.SearchStruct = KDTreeSearcher(this.Pixels', 'Distance', 'euclidean', 'BucketSize', 50);            
        end
        
        function pt = NearestPoint(this, x)
            [idx, dist] = knnsearch(this.SearchStruct, x', 'k', 1);
            pt = this.Pixels(:, idx);
        end
    end
end