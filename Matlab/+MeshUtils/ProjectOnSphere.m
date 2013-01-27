function ProjectOnSphere(model, ptModelCenter, fRadius)
     for ve = model.lVertices(1:model.nVertices)
         v = ve.pt - ptModelCenter;
         v = v / norm(v);
         ve.pt = ptModelCenter + v * fRadius;
     end
end