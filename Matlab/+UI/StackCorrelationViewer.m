% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef StackCorrelationViewer < UI.StackViewer 
    properties (SetAccess = protected, GetAccess = public)
        ray = [];
        btnDown = 0;
    end
    
    properties (Access = public)
        corrRadius = 65;
    end
    
    methods (Access = public)
        function obj = StackCorrelationViewer(imStack)
            obj = obj@UI.StackViewer(imStack);
            obj.canvas(2) = axes('units','pixels',...                                            
                'fontsize', 10, ...
                'nextplot', 'replacechildren');
            plot(obj.canvas(2), [], 'Parent', obj.canvas(2));
            set(obj.hImage, 'HitTest', 'off');
            set(obj.canvas(1), 'ButtonDownFcn', @(s,e) (obj.OnImageButtonDown(s, e)));
            set(obj.h, 'WindowButtonUpFcn',   @(s,e) (obj.OnImageButtonUp(s, e)));
            obj.DoLayout();
        end
        
        function OnImageButtonDown(obj, src, event)
            obj.btnDown = 1;
            obj.DrawCorrelations();
        end
        
        function OnImageButtonUp(obj, src, event)
            obj.btnDown = 0;
        end
        
        function OnMouseMoveFcn(obj, src, event)
            if (obj.btnDown)
                obj.DrawCorrelations();
            end
        end
        
        function DrawCorrelations(obj)
            pos = get(obj.canvas(1), 'CurrentPoint');
            x = round(pos(1, 1));
            y = round(pos(1, 2));
            if ((x >= 1) && (x <= size(obj.imStack, 1)) && (y >= 1) && (y <= size(obj.imStack, 2)))
                switch obj.axisIndex
                    case 1
                        obj.ray = squeeze(obj.imStack(:, x, y));
                    case 2
                        obj.ray = squeeze(obj.imStack(x, :, y));
                    case 3
                        obj.ray = squeeze(obj.imStack(x, y, :));    
                end
                obj.ray = obj.ray(:);

                [sx, sy, sz] = size(obj.imStack);
                iRegionX = (max(1, x - obj.corrRadius):min(sx, x + obj.corrRadius));
                iRegionY = (max(1, y - obj.corrRadius):min(sy, y + obj.corrRadius));
                regionReshaped = reshape(permute(obj.imStack(iRegionX, iRegionY, :), [3, 1, 2]), sz, []);
                regionReshaped = bsxfun(@minus, regionReshaped, mean(regionReshaped, 1));
                vPt = obj.ray;
                vPt = vPt - mean(vPt);
                c = vPt' * regionReshaped;
                c = reshape(c, length(iRegionX), length(iRegionY));
                % Normalize c to get correlation coefficient
                autoVariance = reshape(sqrt(sum(regionReshaped .* regionReshaped, 1)), length(iRegionX), length(iRegionY));
                vPtVariance = sqrt(vPt' * vPt);
                c = c ./ autoVariance ./ vPtVariance;
                c(obj.corrRadius + min(1, (x-obj.corrRadius)), obj.corrRadius + min(1, (y-obj.corrRadius))) = 0;
                if (obj.IsGlobalScale())
                    imagesc(c', 'Parent', obj.canvas(2), [-1, 1]);
                else
                    imagesc(c', 'Parent', obj.canvas(2));
                end
                axis(obj.canvas(2), 'image');
                set(obj.canvas(2), 'YDir', 'normal');
            end
        end
        
    end
end







