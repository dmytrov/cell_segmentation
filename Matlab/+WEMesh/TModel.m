classdef TModel < handle
    properties (SetAccess = public)        
        lVertices;
        lEdges;
        lFacets;
    end
    
    methods
        function obj = TModel()
            if (nargin ~= 0)
            end
            Init(obj)
        end
        
        function Init(obj)
            obj.lVertices = WEMesh.TVertex.empty;
            obj.lEdges = WEMesh.TEdge.empty;
            obj.lFacets = WEMesh.TFacet.empty;
        end
        
        function MakeTetrahedron(obj)
            Init(obj);
            
            % Add vertices
            obj.lVertices(4).pt = [ 1,  0, -1/sqrt(2)]';
            obj.lVertices(3).pt = [-1,  0, -1/sqrt(2)]';
            obj.lVertices(2).pt = [ 0,  1,  1/sqrt(2)]';
            obj.lVertices(1).pt = [ 0, -1,  1/sqrt(2)]';
            v4 = obj.lVertices(4);
            v3 = obj.lVertices(3);
            v2 = obj.lVertices(2);
            v1 = obj.lVertices(1);
            
            % Add faces
            AddFacet(obj, v1, v4, v2);
            AddFacet(obj, v3, v2, v4);
            AddFacet(obj, v3, v4, v1);
            AddFacet(obj, v1, v2, v3);  
        end
        
        function AddFacet(obj, v1, v2, v3)
            nEdges = size(obj.lEdges, 2);
            vert = [v1, v2, v3];
            % Add edges
            for k = 3:-1:1
                obj.lEdges(nEdges + k).vertex = vert(k);
            end
            edges = obj.lEdges(nEdges + 1:nEdges + 3);
            for k = 3:-1:1            
                % Add edges to vertices links
                edges(k).vertex = vert(k);
                % Add edges cyclic links on next edges
                edges(k).eNext = edges(mod(k, 3)+1);
                % Add vertices to edges links
                edges(k).vertex.lEdges(end+1) = edges(k);
            end
            % Add facet
            obj.lFacets(end+1).lEdges = edges;           
            % Set opposite half-edges links
            for k = 1:3
                edge = edges(k); 
                edge.facet = obj.lFacets(end);
                ve1 = edge.vertex;
                ve2 = edge.eNext.vertex;                
                for vertHalfEdge = ve2.lEdges
                    if (vertHalfEdge.eNext.vertex == ve1)
                        % Set mutual links
                        vertHalfEdge.eOpposite = edge;
                        edge.eOpposite = vertHalfEdge;
                        break;
                    end
                end
            end
        end
        
        function DivideAllEdges(obj)
            for edge = obj.lEdges
                edge.tag = 0;
            end
            nEdges = size(obj.lEdges, 2);
            for k = 1:nEdges
                e1 = obj.lEdges(k);
                if (e1.tag == 0)
                    e2 = e1.eOpposite;
                    DivideEdge(obj, e1);
                    e1.tag = 1;
                    e2.tag = 1;
                end
            end
        end
        
        function DivideEdge(obj, edge)
            e1 = edge;
            e2 = edge.eOpposite;
            v1 = e1.vertex;
            v2 = e2.vertex;
            % Add new point
            obj.lVertices(end + 1).pt = mean([v1.pt, v2.pt], 2);
            vNew = obj.lVertices(end);
            % Add new edge for e1
            obj.lEdges(end + 1).vertex = vNew;
            e1New = obj.lEdges(end);
            e1New.eNext = e1.eNext;
            e1.eNext = e1New;
            e1New.facet = e1.facet;
            e1New.facet.lEdges(end + 1) = e1New;
            % Add new edge for e2
            obj.lEdges(end + 1).vertex = vNew;
            e2New = obj.lEdges(end);
            e2New.eNext = e2.eNext;
            e2.eNext = e2New;
            e2New.facet = e2.facet;
            e2New.facet.lEdges(end + 1) = e2New;
            % Set mutual links for edges opponents
            e1.eOpposite = e2New;
            e2New.eOpposite = e1;
            e2.eOpposite = e1New;
            e1New.eOpposite = e2;
            
        end
        
        function plot(obj)
            nVerts = size(obj.lVertices, 2);
            lPts = nan(3, nVerts);
            for k = 1:nVerts
                lPts(:, k) = obj.lVertices(k).pt;
            end
            plot3(lPts(1, :), lPts(2, :), lPts(3, :), '.r', 'MarkerSize', 5);
            hold on;
            nFacets = size(obj.lFacets, 2);
            for k = 1:nFacets
                nEdges = size(obj.lFacets(k).lEdges, 2);
                lPts = nan(3, nEdges+1);
                edgeCurrent = obj.lFacets(k).lEdges(1);
                for k2 = 1:nEdges+1
                    lPts(:, k2) = edgeCurrent.vertex.pt;
                    edgeCurrent = edgeCurrent.eNext;
                end
                lPts(:, end) = lPts(:, 1);
                vn = cross((lPts(:, 3) - lPts(:, 2)), (lPts(:, 1) - lPts(:, 2)));
                vn = vn / norm(vn);
                if (any(isnan(vn)))
                    vn = [0, 0, 0]';
                end
                lPts = lPts + 0.05 * repmat(vn, 1, nEdges + 1);
                plot3(lPts(1, :), lPts(2, :), lPts(3, :));
            end
        end
    end
end
