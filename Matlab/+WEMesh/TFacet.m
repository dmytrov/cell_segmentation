classdef TFacet < handle
    properties (SetAccess = public)        
        lEdges;
        tag;
    end
    
    methods
        function obj = TFacet()
            if (nargin ~= 0)
            end
            obj.lEdges = WEMesh.TEdge.empty;
            obj.tag = nan;
        end
    end
end
