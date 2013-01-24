classdef TRegionDescsList < handle
    properties (Access = public)
        RegionDesc;     % Array of TRegionDesc
        Pixels;         % 3xN matrix, all pixels (voxels)
        PixelID;        % Array of IDs for all pixels
        SearchStruct;   % KD-tree, contains all pixels
    end
    
    methods (Access = public)
        function this = TRegionDescsList()
            this.RegionDesc = [];
            this.Pixels = nan(3, 0);
            this.PixelID = [];
            this.SearchStruct = [];
        end
        
        function AddRegionDesc(this, pixels, center, type)
            id = length(this.RegionDesc) + 1;
            rd = Segment3D.TRegionDesc(id, pixels, center, type);
            this.RegionDesc = [this.RegionDesc, rd];
            this.Pixels = [this.Pixels, pixels];
            this.PixelID = [this.PixelID, repmat(id, [1, size(pixels, 2)])];
            
            this.SearchStruct = [];
        end
        
        function [pt, id] = NearestPoint(this, x)
            if (isempty(this.SearchStruct))
                this.SearchStruct = KDTreeSearcher(this.Pixels', 'Distance', 'euclidean', 'BucketSize', 50);
            end
            [index, distance] = knnsearch(this.SearchStruct, x', 'k', 1);
            pt = this.Pixels(:, index);
            id = this.PixelID(index);
        end        
        
    end
end