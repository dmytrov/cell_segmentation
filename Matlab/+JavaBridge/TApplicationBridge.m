classdef TApplicationBridge < handle
    properties (Access = public)
        Application;
    end
    
    methods (Access = public)
        function this = TApplicationBridge(application)
            this.Application = application;
        end
    end
end