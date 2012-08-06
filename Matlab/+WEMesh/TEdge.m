classdef TEdge < handle
    properties (SetAccess = public)
        eNext; 
        eOpposite;
        vertex;
    end
    
    methods
        function obj = TEdge()
            if (nargin ~= 0)
            end
            obj.eNext = nan;
            obj.eOpposite = nan;
            obj.vertex = nan;
        end
    end
end
