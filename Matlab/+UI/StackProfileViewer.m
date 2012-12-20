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
            set(obj.hImage, 'HitTest', 'off');
            set(obj.canvas(1), 'ButtonDownFcn',  @(s,e) (obj.OnImageClick(s, e)));
            %set(obj.canvas(1), 'ButtonDownFcn',  @(s,e) (obj.OnImageClick(s, e)));
            obj.DoLayout();
        end
        
        function OnImageClick(obj, src, event)
            pos = get(obj.canvas(1), 'CurrentPoint');
            x = round(pos(1, 2));
            y = round(pos(1, 1));
            switch obj.axisIndex
                case 1
                    obj.ray = squeeze(obj.imStack(:, x, y));
                case 2
                    obj.ray = squeeze(obj.imStack(x, :, y));
                case 3
                    obj.ray = squeeze(obj.imStack(x, y, :));    
            end
            plot(obj.canvas(2), [obj.ray, gradient(obj.ray)], 'Parent', obj.canvas(2));
            if (obj.IsGlobalScale)
                ylim(obj.canvas(2), obj.imDynamicRange + [-10, 0]);
            else
                ylim(obj.canvas(2), 'auto');
            end            
        end
    end
end