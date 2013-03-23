classdef TApplication < handle
    properties (Access = public)
        Name;
        PipelineBuilders;
        Pipeline;
    end
    
    methods (Access = public)
        function this = TApplication(name)
            this.Name = name;
            this.PipelineBuilders = cell(1, 0);
        end                
        
        function AddPipelineBuilder(this, builder)
            this.PipelineBuilders = [this.PipelineBuilders; {builder}];
        end
        
        function BuildPipelineByName(this, name)
            builder = Utils.CellArray.FindByName(this.PipelineBuilders, name);
            this.Pipeline = builder.Build();
        end
        
        function Run(this)
            this.Pipeline.Run(this.Pipeline.Components{end});
        end
    end
end