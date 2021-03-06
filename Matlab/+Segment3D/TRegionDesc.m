% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TRegionDesc < handle
    properties (Constant = true)
        UNCLASSIFIED    = 0;
        CELL            = 1;
        NOISE           = 2;
        VESSEL          = 3;
        AXON            = 4;
    end
    
    properties (Access = public)
        ID;             % global ID of the region
        Type;           % cell/vessel/axon/noise
        Center;
        Pixels;         % 3xN matrix
        SearchStruct;   % KD-tree
        Surface;        % isosurface, TIndexMesh
    end
    
    methods (Access = public)
        function this = TRegionDesc(id, pixels, center, surface, type)
            this.ID = id;
            this.Pixels = pixels;
            this.Type = type;
            this.Center = center;
            this.Surface = surface;
            this.SearchStruct = KDTreeSearcher(this.Pixels', 'Distance', 'euclidean', 'BucketSize', 50);            
        end
        
        function pt = NearestPoint(this, x)
            [idx, dist] = knnsearch(this.SearchStruct, x', 'k', 1);
            pt = this.Pixels(:, idx);
        end
    end
end