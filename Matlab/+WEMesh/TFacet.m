% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

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
