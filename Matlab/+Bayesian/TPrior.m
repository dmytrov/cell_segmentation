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