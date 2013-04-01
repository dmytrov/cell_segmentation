% Simple (vertex buffer + index buffer) matlab-style mesh
classdef TIndexMesh < handle
    properties (Access = public)
        lVertices;   % 3xN vertex buffer   
        lFacets;      % 3xM index buffer for facets
    end
    
    methods (Access = public)
        function this = TIndexMesh()
            this.lVertices = nan(3, 0);
            this.lFacets = nan(3, 0);
        end
        
        function InitFromFacetVertex(this, fv)
            this.lVertices = fv.vertices';
            this.lFacets = fv.faces';
        end
        
        function InitFromWEMesh(this, model)
            this.lVertices = nan(3, model.nVertices);
            this.lFacets = nan(3, model.nFacets);
            for k = 1:model.nVertices
                model.lVertices(k).tag.index = 0;
            end
            iVertex = 1;
            for k = 1:model.nFacets
                nFacetEdges = size(model.lFacets(k).lEdges, 2);
                edgeCurrent = obj.lFacets(k).lEdges(1);
                for k2 = 1:min(3, nFacetEdges)
                    if (~edgeCurrent.vertex.tag.index)
                        edgeCurrent.vertex.tag.index = iVertex;
                        this.lVertices(:, iVertex) = edgeCurrent.vertex.pt;
                        iVertex = iVertex + 1;
                    end
                    this.lFacets(k2, k) = edgeCurrent.vertex.tag.index;
                    edgeCurrent = edgeCurrent.eNext;
                end                
            end
        end
        
        function plot(this)
            fv.vertices = this.lVertices';
            fv.faces = this.lFacets';
            p = patch(fv);
            set(p, 'FaceColor', 'blue', 'EdgeColor', 'black');
            axis image;
            camlight;
            lighting gouraud;
        end
    end
end