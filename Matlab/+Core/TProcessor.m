classdef TProcessor < Core.TComponent
    methods (Access = public)
        function this = TProcessor(name, pipeline)
            this = this@Core.TComponent(name, pipeline);
        end

        function CheckInputsConnected(this)
            for input = this.Inputs
                if (isempty(input.Other.Component))
                    exception = MException('TComponent:Run', ...
                        ['Componemt: ', this.Name, ', intput:' + input.Name, 'is not connected']);
                    throw(exception);
                end
            end
        end
        
        function CheckOutputsConnected(this)
            for output = this.Outputs
                if (isempty(output.Others.Component))
                    exception = MException('TComponent:Run', ...
                        ['Componemt: ', this.Name, ', output:' + output.Name, 'is not connected']);
                    throw(exception);
                end
            end
        end
        
        function Run(this)
            this.CheckInputsConnected();
            this.CheckOutputsConnected();
        end

    end
end
