% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TModel < handle
    properties (SetAccess = public)        
        nVerticesPreallocate;
        lVertices;
        nVertices;
        lEdges;
        nEdges;
        lFacets;
        nFacets;
        ptCenter = [0, 0, 0]';
        tag;
    end
    
    methods
        function obj = TModel(verticesPreallocate)
            obj.nVerticesPreallocate = verticesPreallocate;
            Init(obj)
        end
        
        function Init(obj)
            % Preallocate the lists
            obj.lVertices = WEMesh.TVertex.empty;
            obj.lVertices(obj.nVerticesPreallocate) = WEMesh.TVertex;
%             for k = 1:length(obj.lVertices)
%                 obj.lVertices(k) = WEMesh.TVertex;
%             end
            obj.nVertices = 0;
            
            obj.lEdges = WEMesh.TEdge.empty;
            obj.lEdges(6 * obj.nVerticesPreallocate) = WEMesh.TEdge;
%             for k = 1:length(obj.lEdges)
%                 obj.lEdges(k) = WEMesh.TEdge;
%             end
            obj.nEdges = 0;
            
            obj.lFacets = WEMesh.TFacet.empty;
            obj.lFacets(2 * obj.nVerticesPreallocate) = WEMesh.TFacet;
%             for k = 1:length(obj.lFacets)
%                 obj.lFacets(k) = WEMesh.TFacet;
%             end
            obj.nFacets = 0;
            
            obj.ptCenter = [0, 0, 0]';
        end
        
        function AddFacet(obj, v1, v2, v3)
            nEdgesOld = obj.nEdges;
            vert = [v1, v2, v3];
            % Add edges
            for k = 3:-1:1
                obj.lEdges(nEdgesOld + k).vertex = vert(k);
            end
            obj.nEdges = obj.nEdges + 3;
            edges = obj.lEdges(nEdgesOld + 1:nEdgesOld + 3);
            for k = 3:-1:1            
                % Add edges to vertices links
                edges(k).vertex = vert(k);
                % Add edges cyclic links on next edges
                edges(k).eNext = edges(mod(k, 3)+1);
                % Add vertices to edges links
                edges(k).vertex.lEdges(end+1) = edges(k);
            end
            % Add facet
            obj.nFacets = obj.nFacets + 1;
            obj.lFacets(obj.nFacets).lEdges = edges;           
            % Set opposite half-edges links
            for k = 1:3
                edge = edges(k); 
                edge.facet = obj.lFacets(obj.nFacets);
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
        
        function TriangulateAllFacets(obj)
            flOld = obj.lFacets;
            for facet = flOld
                TriangulateFacet(obj, facet);
            end
        end
        
        function TriangulateFacet(obj, facet)
            SetTags(facet.lEdges, length(facet.lEdges), nan);
            nFacetEdges = size(facet.lEdges, 2);
            
            bFinished = 0;
            while (nFacetEdges > 3) && (~bFinished)
                bFinished = 1;
                k = 1;
                edge = facet.lEdges(k);
                bFound = 0;
                while (~bFound) && (k <= nFacetEdges)
                    v1 = edge.eNext.vertex;
                    v2 = edge.eNext.eNext.vertex;
                    v3 = edge.eNext.eNext.eNext.vertex;
                    e0 = edge;
                    e1 = edge.eNext;
                    e2 = edge.eNext.eNext;
                    bFound = (v1.tag == 1) && (v2.tag == 0) && (v3.tag == 1);
                    edge = edge.eNext;
                    k = k + 1;
                end
                if bFound
                    bFinished = 0;
                    % Add 2 half-edges to make a triange
                    obj.nEdges = obj.nEdges + 1;
                    eLast = obj.lEdges(obj.nEdges);
                    eLast.eNext = e1;
                    e3 = obj.lEdges(obj.nEdges);
                    obj.nEdges = obj.nEdges + 1;
                    eLast = obj.lEdges(obj.nEdges);
                    eLast.eNext = e2.eNext;
                    eOther = obj.lEdges(obj.nEdges);
                    e0.eNext = eOther;
                    eOther.eOpposite = e3;
                    e3.eOpposite = eOther;
                    e2.eNext = e3;
                    e3.vertex = v3;
                    v3.lEdges(end+1) = e3;
                    eOther.vertex = v1;
                    v1.lEdges(end+1) = eOther;
                    eOther.facet = facet;
                    % Add new facet
                    obj.nFacets = obj.nFacets + 1;
                    faLast = obj.lFacets(obj.nFacets);
                    faLast.lEdges = [e1, e2, e3]; 
                    faNew = obj.lFacets(obj.nFacets);
                    e1.facet = faNew;
                    e2.facet = faNew;
                    e3.facet = faNew;
                    % Remove e1 and e2 form the current facet edge list
                    bOld = (facet.lEdges == e1) | (facet.lEdges == e2);
                    facet.lEdges = facet.lEdges(~bOld);
                    facet.lEdges(end+1) = eOther;
                end
                nFacetEdges = size(facet.lEdges, 2);
            end            
        end
        
        function DivideAllEdges(obj)
            SetTags(obj.lEdges, obj.nEdges, 0);
            SetTags(obj.lVertices, obj.nVertices, 0);
            nEdgesOld = obj.nEdges;
            for k = 1:nEdgesOld
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
            obj.nVertices = obj.nVertices + 1;
            obj.lVertices(obj.nVertices).pt = mean([v1.pt, v2.pt], 2);
            vNew = obj.lVertices(obj.nVertices);
            vNew.tag = 1;
            % Add new edge for e1
            obj.nEdges = obj.nEdges + 1;
            eLast = obj.lEdges(obj.nEdges);
            eLast.vertex = vNew;
            vNew.lEdges(end+1) = eLast;
            e1New = obj.lEdges(obj.nEdges);
            e1New.eNext = e1.eNext;
            e1.eNext = e1New;
            e1New.facet = e1.facet;
            e1New.facet.lEdges(end + 1) = e1New;
            % Add new edge for e2
            obj.nEdges = obj.nEdges + 1;
            eLast = obj.lEdges(obj.nEdges);
            eLast.vertex = vNew;
            vNew.lEdges(end+1) = eLast;
            e2New = obj.lEdges(obj.nEdges);
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
        
        function plot(obj, canvas)
            if (nargin < 2)
                canvas = gca;
            end
            axes(canvas);
            lPts = nan(3, obj.nVertices);
            for k = 1:obj.nVertices
                lPts(:, k) = obj.lVertices(k).pt;
            end
            plot3(lPts(1, :), lPts(2, :), lPts(3, :), '.r', 'MarkerSize', 5);
            hold on;
            for k = 1:obj.nFacets
                nFacetEdges = size(obj.lFacets(k).lEdges, 2);
                lPts = nan(3, nFacetEdges+1);
                edgeCurrent = obj.lFacets(k).lEdges(1);
                for k2 = 1:nFacetEdges+1
                    lPts(:, k2) = edgeCurrent.vertex.pt;
                    edgeCurrent = edgeCurrent.eNext;
                end
                lPts(:, end) = lPts(:, 1);
                vn = cross((lPts(:, 3) - lPts(:, 2)), (lPts(:, 1) - lPts(:, 2)));
                vn = vn / norm(vn);
                if (any(isnan(vn)))
                    vn = [0, 0, 0]';
                end
                lPts = lPts + 0.05 * repmat(vn, 1, nFacetEdges + 1);
                plot3(lPts(1, :), lPts(2, :), lPts(3, :));
            end
        end
    end
end

function SetTags(list, len, value)
    for item = list(1:len)
        item.tag = value;
    end
end
