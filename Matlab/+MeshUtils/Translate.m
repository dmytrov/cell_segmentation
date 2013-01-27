function Translate(model, v)
     for ve = model.lVertices(1:model.nVertices)
         ve.pt = ve.pt + v;
     end
     model.ptCenter = model.ptCenter + v;
end