classdef T3DCellData < handle
    properties (Access = public)
        mModel;
        ptCenter;
        vAxes;
        fScale;  
        fUncertainty;
    end
    
	methods (Access = public)
        function this = T3DCellData(model)
            assert(isa(model, 'WEMesh.TModel'));
            this.mModel = model;
            this.ptCenter = MeshUtils.GetCenter(model);
            pts = nan(3, model.nVertices);
            for k = 1:model.nVertices
                pts(:, k) = model.lVertices(k).pt;                
            end
            pts(isnan(pts)) = 0;
            [this.vAxes, this.fScale] = MathUtils.GetPrincipalAxes(pts);            
            this.fUncertainty = nan;
            if (isfield(model.tag, 'fUncertainty'))
                this.fUncertainty = model.tag.fUncertainty;
            end
        end
        
        function s = ToString(this)
            s = '';
            s = [s, this.VectorToString(this.ptCenter)];
            s = [s, this.VectorToString(this.vAxes(:, 1))];
            s = [s, this.VectorToString(this.vAxes(:, 2))];
            s = [s, this.VectorToString(this.vAxes(:, 3))];
            s = [s, this.VectorToString(this.fScale)];
            s = [s, sprintf('%f', this.fUncertainty)];
        end
    end
    
    methods (Access = protected)
        function s = VectorToString(this, v)
            s = sprintf('%f\t%f\t%f\t', v(1), v(2), v(3));
        end
    end
end