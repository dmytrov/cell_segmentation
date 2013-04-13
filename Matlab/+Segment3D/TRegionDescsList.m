% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

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
        
        function AddRegionDesc(this, pixels, center, surface, type)
            id = length(this.RegionDesc) + 1;
            rd = Segment3D.TRegionDesc(id, pixels, center, surface, type);
            this.RegionDesc = [this.RegionDesc, rd];
            this.Pixels = [this.Pixels, pixels];
            this.PixelID = [this.PixelID, repmat(id, [1, size(pixels, 2)])];
            
            this.SearchStruct = [];
        end
        
        function [desc, pixels] = RemoveRegionDesc(this, id)
            desc = this.RegionDesc(id);
            this.RegionDesc = this.RegionDesc([1:id-1, id+1:end]);
            pixels = this.Pixels(:, this.PixelID == id);
            this.Pixels = this.Pixels(:, this.PixelID ~= id);
            this.PixelID = this.PixelID(this.PixelID ~= id);
            this.PixelID(this.PixelID > id) = this.PixelID(this.PixelID > id) - 1;
            
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