classdef TPipelineBuilder < handle
    properties (GetAccess = public, SetAccess = protected)
        Name;
    end
    
    methods (Access = public)
        function this = TPipelineBuilder(name)
            this.Name = name;
        end
        
        function res = Build(this)
            exception = MException('TPipelineBuilder:Build', [' Not overriden']);
            throw(exception);
        end
    end
end