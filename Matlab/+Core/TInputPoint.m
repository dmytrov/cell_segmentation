classdef TInputPoint < Core.TConnectionPoint
    properties (Access = public)
        Other;
    end
    
    methods (Access = public)
        function this = TInputPoint(name, type, component)
            this = this@Core.TConnectionPoint(name, type, component);
        end
        
        function ConnectTo(this, output)
            if (~isa(output, 'Core.TOutputPoint'))
                exception = MException('TInputPoint:ConnectTo', 'Argument is not a Core.TOutputPoint object');
                throw(exception);
            end
            if (~strcmp(this.Type, '') && ~strcmp(this.Type, output.Type))
                exception = MException('TInputPoint:ConnectTo', ...
                    ['Data types "', this.Type, '" and "', output.Type, '" do not match']);
                throw(exception);
            end
            this.Other = output;
            output.Others = [output.Others, this];
            if (strcmp(this.Type, ''))
                this.Type = output.Type;
            end
            this.Component.OnInputConnected();
        end
        
        function Disconnect(this)
            if (~isempty(this.Other))
                output = this.Other;
                output.Others = output.Others(output.Others ~= this);
                this.Other = [];
            end
        end
    end
end