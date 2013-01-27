function pt = GetCenter(model)
     pt = [0, 0, 0]';
     for ve = model.lVertices(1:model.nVertices)
         pt = pt + ve.pt;
     end
     pt = pt / model.nVertices;
end