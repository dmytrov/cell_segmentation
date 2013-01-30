% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

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
