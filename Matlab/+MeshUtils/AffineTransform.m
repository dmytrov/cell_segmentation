% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function AffineTransform(model, mRotation, vTranslation)
	ptCenter = model.ptCenter;
    MeshUtils.Translate(model, -ptCenter);    
    for ve = model.lVertices(1:model.nVertices)
        ve.pt = mRotation * ve.pt;
    end
    MeshUtils.Translate(model, ptCenter + vTranslation);    
end