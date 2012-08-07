function Translate(model, v)
     for ve = model.lVertices
         ve.pt = ve.pt + v;
     end
end