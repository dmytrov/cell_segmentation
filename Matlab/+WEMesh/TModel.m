classdef TModel < handle
    properties (SetAccess = public)        
        lVertices;
        lEdges;
        lFacets;
        ptCenter = [0, 0, 0]';
    end
    
    methods
        function obj = TModel()
            Init(obj)
        end
        
        function Init(obj)
            obj.lVertices = WEMesh.TVertex.empty;
            obj.lEdges = WEMesh.TEdge.empty;
            obj.lFacets = WEMesh.TFacet.empty;
            obj.ptCenter = [0, 0, 0]';
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
        
        function TriangulateAllFacets(obj)
            flOld = obj.lFacets;
            for facet = flOld
                TriangulateFacet(obj, facet);
            end
        end
        
        function TriangulateFacet(obj, facet)
            SetTags(facet.lEdges, nan);
            nEdges = size(facet.lEdges, 2);
            
            bFinished = 0;
            while (nEdges > 3) && (~bFinished)
                bFinished = 1;
                k = 1;
                edge = facet.lEdges(k);
                bFound = 0;
                while (~bFound) && (k <= nEdges)
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
                    obj.lEdges(end + 1).eNext = e1;
                    e3 = obj.lEdges(end);
                    obj.lEdges(end + 1).eNext = e2.eNext;
                    eOther = obj.lEdges(end);
                    e0.eNext = eOther;
                    eOther.eOpposite = e3;
                    e3.eOpposite = eOther;
                    e2.eNext = e3;
                    e3.vertex = v3;
                    eOther.vertex = v1;
                    eOther.facet = facet;
                    % Add new facet
                    obj.lFacets(end+1).lEdges = [e1, e2, e3]; 
                    faNew = obj.lFacets(end);
                    e1.facet = faNew;
                    e2.facet = faNew;
                    e3.facet = faNew;
                    % Remove e1 and e2 form the current facet edge list
                    nEdges = size(facet.lEdges, 2);
                    bOld = nan(1, nEdges);
                    for k = 1:nEdges
                        bOld(k) = (facet.lEdges(k) == e1) || (facet.lEdges(k) == e2);
                    end
                    facet.lEdges = facet.lEdges(~bOld);
                    facet.lEdges(end+1) = eOther;
                end
                nEdges = size(facet.lEdges, 2);
            end            
        end
        
        function DivideAllEdges(obj)
            SetTags(obj.lEdges, 0);
            SetTags(obj.lVertices, 0);
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
            vNew.tag = 1;
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

function SetTags(list, value)
    for item = list
        item.tag = value;
    end
end
