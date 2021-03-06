% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef StackProfileViewer < UI.StackViewer 
    properties (SetAccess = protected, GetAccess = public)
        ray;
    end
    
    methods (Access = public)
        function obj = StackProfileViewer(imStack)
            obj = obj@UI.StackViewer(imStack);
            obj.canvas(2) = axes('units','pixels',...                                            
                'fontsize', 10, ...
                'nextplot', 'replacechildren');
            plot(obj.canvas(2), [], 'Parent', obj.canvas(2));
            set(obj.hImage, 'HitTest', 'off');
            set(obj.canvas(1), 'ButtonDownFcn',  @(s,e) (obj.OnImageClick(s, e)));
            %set(obj.canvas(1), 'ButtonDownFcn',  @(s,e) (obj.OnImageClick(s, e)));
            obj.DoLayout();
        end
        
        function OnImageClick(obj, src, event)
            pos = get(obj.canvas(1), 'CurrentPoint');
            x = round(pos(1, 1));
            y = round(pos(1, 2));
            switch obj.axisIndex
                case 1
                    obj.ray = squeeze(obj.imStack(:, x, y));
                case 2
                    obj.ray = squeeze(obj.imStack(x, :, y));
                case 3
                    obj.ray = squeeze(obj.imStack(x, y, :));    
            end
            obj.ray = obj.ray(:);
            rayGrad = gradient(obj.ray);
            sigma = 5;
            k = normpdf(-3*sigma:3*sigma, 0, sigma);
            rayConv = conv(rayGrad, k, 'same');
            %rayConv2 = gradient(conv(obj.ray, k, 'same'));
            profiles = [obj.ray, rayGrad, rayConv];
            plot(obj.canvas(2), profiles, 'Parent', obj.canvas(2));
            legend(obj.canvas(2), 'ray', 'ray grad', 'ray grad conv');
            title(obj.canvas(2), ['Ray at pt (', num2str(x), ', ', num2str(y), ')']);
            if (obj.IsGlobalScale)
                ylim(obj.canvas(2), obj.imDynamicRange + [-10, 0]);
            else
                ylim(obj.canvas(2), 'auto');
            end            
        end
    end
end