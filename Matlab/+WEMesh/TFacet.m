classdef TFacet < handle
    properties (SetAccess = public)        
        lEdges;
    end
    
    methods
        function obj = TFacet()
            if (nargin ~= 0)
            end
            obj.lEdges = WEMesh.TEdge.empty;
        end
    end
end
