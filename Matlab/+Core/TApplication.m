classdef TApplication < handle
    properties (Access = public)
        Name;
        PipelineBuilders;
        Pipeline;
        MessageLog;
    end
    
    methods (Access = public)
        function this = TApplication(name)
            this.Name = name;
            this.PipelineBuilders = cell(1, 0);
            this.MessageLog = Core.TMessageLog();
            this.MessageLog.PrintToConsole = true;
        end                
        
        function AddPipelineBuilder(this, builder)
            this.PipelineBuilders = [this.PipelineBuilders; {builder}];
        end
        
        function BuildPipelineByName(this, name)
            builder = Utils.CellArray.FindByName(this.PipelineBuilders, name);
            if (isvalid(this.Pipeline))
                delete(this.Pipeline);
            end
            this.Pipeline = builder.Build();
        end
        
    end
end