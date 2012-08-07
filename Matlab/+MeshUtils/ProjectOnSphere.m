function ProjectOnSphere(model, ptCenter, fRadius)
     for ve = model.lVertices
         v = ve.pt - ptCenter;
         v = v / norm(v);
         ve.pt = ptCenter + v * fRadius;
     end
end