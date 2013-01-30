% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef ModelViewer < UI.Form
    properties (Access = protected)
        canvas;
        models;        
    end
    
    methods (Access = public)
        function obj = ModelViewer()
            obj = obj@UI.Form(); 
            obj.models = WEMesh.TModel.empty;            
            obj.canvas = axes('units','pixels',...                                            
                'fontsize', 10, ...
                'nextplot', 'replacechildren');
            set(obj.h, 'Renderer', 'OpenGL')
            opengl hardware;
        end
        
        function SetModels(obj, models)
            obj.models = models;
            obj.DrawModels();
        end
        
        function DrawModels(obj)
            cla(obj.canvas);
            axis(obj.canvas, 'image');
            hold on;
            k = 1;
            for model = obj.models
                fprintf('Drawing model %d of %d\n', k, length(obj.models));
                model.plot(obj.canvas);
                k = k + 1;
            end
            hold off;
            set(obj.canvas, 'zdir', 'reverse')
            axis(obj.canvas, 'image');
            grid on;
        end
        
        function OnResizeFcn(obj, src, event)
            obj.DoLayout();
        end
        
        function DoLayout(obj)
            winPos = get(obj.h, 'Position');
            set(obj.canvas, 'position', [30, 30, winPos(3)-60, winPos(4)-60]);
        end
    end
end