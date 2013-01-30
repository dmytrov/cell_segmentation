% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TVertex < handle
    properties (SetAccess = public)
        pt; 
        lEdges;
        tag;
    end
    
    methods
        function obj = TVertex()
            if (nargin ~= 0)
            end
            obj.pt = [0, 0, 0]';
            obj.lEdges = WEMesh.TEdge.empty; 
            obj.tag = nan;
        end
    end
end