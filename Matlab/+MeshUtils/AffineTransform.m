function AffineTransform(model, mRotation, vTranslation)
	ptCenter = model.ptCenter;
    MeshUtils.Translate(model, -ptCenter);    
    for ve = model.lVertices(1:model.nVertices)
        ve.pt = mRotation * ve.pt;
    end
    MeshUtils.Translate(model, ptCenter + vTranslation);    
end