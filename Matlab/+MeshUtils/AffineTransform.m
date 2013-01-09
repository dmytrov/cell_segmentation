function AffineTransform(model, mRotation, vTranslation)
	ptCenter = model.ptCenter;
    MeshUtils.Translate(model, -ptCenter);    
    for ve = model.lVertices
        ve.pt = mRotation * ve.pt;
    end
    MeshUtils.Translate(model, ptCenter + vTranslation);    
end