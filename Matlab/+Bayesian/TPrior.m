% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef (Abstract) TPrior < handle
    methods (Access = public)
        function obj = TPrior()
            % nothing to initialize here
        end
    end
    methods (Access = public)
        function res = ValueAt(obj, x)
	   % dummy function for compatibility with old matlab versions
	   res = 0;
	end
    end
end