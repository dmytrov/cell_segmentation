% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef (Abstract) TPrior < handle
    methods (Access = public)
        function obj = TPrior()
            % nothing to initialize here
        end
    end
    methods (Abstract, Access = public)
        ValueAt(obj, x);
    end
end