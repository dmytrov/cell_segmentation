classdef TEdge < handle
    properties (SetAccess = public)
        eNext = nan; 
        eOpposite = nan;
        vertex = nan;
        facet = nan;
        tag = nan;
    end
    
    methods
        function obj = TEdge()
            
        end
    end
end
