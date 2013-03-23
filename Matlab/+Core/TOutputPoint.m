classdef TOutputPoint < Core.TConnectionPoint
    properties (Access = public)
        Others; % connected inputs
    end
    
    methods (Access = public)
        function this = TOutputPoint(name, type, component)
            this = this@Core.TConnectionPoint(name, type, component);
        end
        
        function PushData(this, data)
            for connectedInput = this.Others
                connectedInput.Component.Data = data;
            end
        end
    end
end