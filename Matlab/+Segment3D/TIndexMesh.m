% Simple (vertex buffer + index buffer) matlab-style mesh
classdef TIndexMesh < handle
    properties (Access = public)
        lVertices;   % 3xN vertex buffer   
        lNormals;    % 3xN vertex normals buffer   
        lFacets;     % 3xM index buffer for facets
        ptBBMin;      % min of bounding box
        ptBBMax;      % max of bounding box
    end
    
    methods (Access = public)
        function this = TIndexMesh()
            this.lVertices = nan(3, 0);
            this.lFacets = nan(3, 0);
        end
        
        function InitFromFacetVertex(this, fv)
            this.lVertices = fv.vertices';
            this.lFacets = fv.faces';
            this.ComputeNormals();
            this.ComputeBoundingBox();
        end
        
        function ComputeBoundingBox(this)
            this.ptBBMin = min(this.lVertices, [], 2);
            this.ptBBMax = max(this.lVertices, [], 2);
        end
        
        function [bHit, ptHit] = RayHit(this, ptRay, vRay)
            ptHit = nan(3, 1);
            bHit = false;
            [~, bAABBHit] = Collision.VectorAABBIntersect(ptRay, vRay, this.ptBBMin, this.ptBBMax);
            if (~bAABBHit)
                return;
            end        
            % Check all facets
            for fa = this.lFacets
                pt1 = this.lVertices(:, fa(1));
                pt2 = this.lVertices(:, fa(2));
                pt3 = this.lVertices(:, fa(3));
                [ptHitCurrent, bHitCurrent] = Collision.VectorTraingleIntersect(ptRay, vRay, pt1, pt2, pt3);
                if (bHitCurrent)
                    if (~bHit)
                        bHit = true;
                        ptHit = ptHitCurrent;
                    else
                        if (norm(ptHitCurrent-vRay) < norm(ptHit-vRay))
                            ptHit = ptHitCurrent;
                        end
                    end
                end
            end
        end
        
        function ComputeNormals(this)
            this.lNormals = zeros(size(this.lVertices));
            nVertexToFacet = zeros(1, size(this.lVertices, 2));
            for fa = this.lFacets
                pt1 = this.lVertices(:, fa(1));
                pt2 = this.lVertices(:, fa(2));
                pt3 = this.lVertices(:, fa(3));
                vn = cross(pt3 - pt2, pt1 - pt2);
                vn = vn / norm(vn);
                for k = 1:3
                    ve = fa(k);
                    this.lNormals(:, ve) = this.lNormals(:, ve) + vn;
                    nVertexToFacet(ve) = nVertexToFacet(ve) + 1;
                end
            end            
            for k = size(this.lNormals, 2)
                vn = this.lNormals(:, k);
                this.lNormals(:, k) = vn / norm(vn);
            end
        end
        
        function InitFromWEMesh(this, model)
            this.lVertices = nan(3, model.nVertices);
            this.lFacets = nan(3, model.nFacets);
            for k = 1:model.nVertices
                model.lVertices(k).tag.index = 0;
            end
%             for k = 1:model.nFacets
%                 facet = model.lFacets(k);
%                 nFacetEdges = size(obj.lFacets(k).lEdges, 2);
%                 lPts = nan(3, nFacetEdges);
%                 edgeCurrent = obj.lFacets(k).lEdges(1);
%                 for k2 = 1:nFacetEdges
%                     lPts(:, k2) = edgeCurrent.vertex.pt;
%                     edgeCurrent = edgeCurrent.eNext;
%                 end
%                 vn = cross((lPts(:, 3) - lPts(:, 2)), (lPts(:, 1) - lPts(:, 2)));
%                 vn = vn / norm(vn);
%                 if (any(isnan(vn)))
%                     vn = [0, 0, 0]';
%                 end                
%                 facet.tag.vn = vn;
%             end
            iVertex = 1;
            for k = 1:model.nFacets
                nFacetEdges = size(model.lFacets(k).lEdges, 2);
                edgeCurrent = obj.lFacets(k).lEdges(1);
                for k2 = 1:min(3, nFacetEdges)
                    if (~edgeCurrent.vertex.tag.index)
                        edgeCurrent.vertex.tag.index = iVertex;
                        this.lVertices(:, iVertex) = edgeCurrent.vertex.pt;
%                         vn = [0, 0, 0]';
%                         for edge = edgeCurrent.vertex.lEdges
%                             vn = vn + edge.facet.tag.vn;
%                         end
%                         
%                         this.lNormals(:, iVertex) = vn / norm(vn);
                        iVertex = iVertex + 1;
                    end
                    this.lFacets(k2, k) = edgeCurrent.vertex.tag.index;
                    edgeCurrent = edgeCurrent.eNext;
                end                
            end
            this.ComputeNormals();
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