function Scale(model, ptModelCenter, vFactor)
     for ve = model.lVertices
         v = ve.pt - ptModelCenter;
         ve.pt = v .* vFactor + ptModelCenter;
     end
end