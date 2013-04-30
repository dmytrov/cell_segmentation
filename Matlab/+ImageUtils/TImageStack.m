classdef TImageStack < handle
    properties (Access = public)
        Data;
    end
    
    methods (Access = public)
        function this = TImageStack(data)
            this.SetData(data);
        end
        
        function SetData(this, data)
            this.Data = data;
        end
    end
end