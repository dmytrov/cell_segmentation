function pt = GetCenter(model)
     pt = [0, 0, 0]';
     for ve = model.lVertices
         pt = pt + ve.pt;
     end
     pt = pt / size(model.lVertices, 2);
end