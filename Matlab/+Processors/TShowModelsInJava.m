classdef TShowModelsInJava < Core.TProcessor
    properties (Constant = true)
        IN_MODELS = 1;
    end
    
    methods (Access = public)
        function this = TShowModelsInJava(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Models', 'WEMesh List', this)];
            this.Outputs = [];
        end
    
        function BindJavaUI(this, ui)
            BindJavaUI@Core.TComponent(this, ui);
            this.PushModelsDataToUI();
        end
        
        function Run(this)
            Run@Core.TProcessor(this);
            this.PushModelsDataToUI();
        end
        
        function PushModelsDataToUI(this)
            if (isempty(this.ExternalUI))
                return;
            end
            
            this.ExternalUI.surfaces.clear();
            models = this.Inputs(this.IN_MODELS).PullData();            
            if (isempty(models))
                return;
            end
            
            fprintf('Pushing surfaces\n');
            k = 1;
            for model = models
                fprintf('Surface %d ', k);
                indexMesh = Segment3D.TIndexMesh();
                indexMesh.InitFromWEMesh(model);
                surface = de.unituebingen.cin.celllab.opengl.IndexMesh( ...
                    size(indexMesh.lVertices, 2), ...
                    size(indexMesh.lFacets, 2));
                
                surface.vertices = indexMesh.lVertices';
                surface.normals = indexMesh.lNormals';
                surface.facets = indexMesh.lFacets' - 1;                                
                this.ExternalUI.surfaces.add(surface);                
                fprintf('done\n');
                k = k + 1;
            end            
            this.ExternalUI.onNewSurfaces();
        end
    end    
end