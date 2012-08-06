classdef TEdge < handle
    properties (SetAccess = public)
        eNext; 
        eOpposite;
        vertex;
        facet;
        tag;
    end
    
    methods
        function obj = TEdge()
            if (nargin ~= 0)
            end
            obj.eNext = nan;
            obj.eOpposite = nan;
            obj.vertex = nan;
            obj.facet = nan;
            obj.tag = nan;
        end
    end
end
