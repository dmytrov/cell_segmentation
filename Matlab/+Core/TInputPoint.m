classdef TInputPoint < Core.TConnectionPoint
    properties (Access = public)
        Other;
    end
    
    methods (Access = public)
        function ConnectTo(this, output)
            if (~isa(output, Core.TOutputPoint))
                exception = MException('TInputPoint.ConnectTo', 'Argument is not a Core.TOutputPoint object');
                throw(exception);
            end
            this.Other = output;
            output.Others = [output.Others, this];
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