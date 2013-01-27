function Scale(model, ptModelCenter, vFactor)
     for ve = model.lVertices(1:model.nVertices)
         v = ve.pt - ptModelCenter;
         ve.pt = v .* vFactor + ptModelCenter;
     end
end