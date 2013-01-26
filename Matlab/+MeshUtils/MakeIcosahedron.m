function MakeIcosahedron(model)
    model.Init();

    phi = (1+sqrt(5))/2;
    % Add vertices
    % ( 0, ±1, ±?)
    model.lVertices(12).pt = [ 0, -1, -phi]';
    model.lVertices(11).pt = [ 0, -1,  phi]';
    model.lVertices(10).pt = [ 0,  1, -phi]';
    model.lVertices( 9).pt = [ 0,  1,  phi]';
    % (±1, ±?,  0)
    model.lVertices(8).pt = [-1, -phi, 0]';
    model.lVertices(7).pt = [-1,  phi, 0]';
    model.lVertices(6).pt = [ 1, -phi, 0]';
    model.lVertices(5).pt = [ 1,  phi, 0]';
    % (±?,  0, ±1)
    model.lVertices(4).pt = [-phi, 0, -1]';
    model.lVertices(3).pt = [ phi, 0, -1]';
    model.lVertices(2).pt = [-phi, 0,  1]';
    model.lVertices(1).pt = [ phi, 0,  1]';
        
    pts = nan(3, length(model.lVertices));
    for k = 1:length(model.lVertices)
        pts(:, k) = model.lVertices(k).pt;
    end
    
    % Add faces
    v = model.lVertices;
    addedFacets = zeros(1, length(v));
    for k1 = 1:length(v)
        for k2 = 1:length(v)
            for k3 = 1:length(v)
                if ((k1 ~= k2) && (k2 ~= k3) && (k1 ~= k3) && (all(addedFacets([k1, k2, k3]) < 5)))
                    ptsShifted = bsxfun(@minus, pts, v(k1).pt);
                    dotprod = cross((v(k2).pt-v(k1).pt), (v(k3).pt-v(k1).pt))' * ptsShifted;
                    if (all(dotprod <= 0))
                        model.AddFacet(v(k1), v(k2), v(k3));
                        addedFacets([k1, k2, k3]) = addedFacets([k1, k2, k3]) + 1;
                    end
                end
            end
        end
    end    
end