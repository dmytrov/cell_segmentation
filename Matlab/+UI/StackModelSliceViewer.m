classdef StackModelSliceViewer < UI.StackViewer 
    properties (Access = protected)
        zSlices;
    end
    
    methods (Access = public)
        function obj = StackModelSliceViewer(imStack)
            obj = obj@UI.StackViewer(imStack);
        end
        
        function SetModels(obj, models)
            obj.models = models;
            obj.PrecalculateSlices();
        end
        
        function PrecalculateSlices(obj)
            if (~isempty(obj.models) && ~isempty(obj.settings))
                axisIndex = 3;
                obj.zSlices = cell(1, size(obj.imStack, axisIndex));
                for k = 1:size(obj.imStack, axisIndex)
                    fprintf('Calculating slice %d of %d\n', k, size(obj.imStack, axisIndex));
                    obj.zSlices{k} = [];
                    vnPlane = [0, 0, 0]';
                    vnPlane(axisIndex) = 1;
                    ptPlane = obj.settings.PixToMicron(vnPlane * k);
                    for model = obj.models
                        section = Collision.MeshPlaneIntersect(model, ptPlane, vnPlane);
                        section = section ./ repmat(obj.settings.Resolution', [2, 1, size(section, 3)]);
                        section(:, axisIndex, :) = [];
                        obj.zSlices{k} = cat(3, obj.zSlices{k}, section);
                    end
                end
            end
        end
        
        function DrawModels(obj)
            if (obj.axisIndex == 3)
                hold on;
                frameIndex = obj.framePosition(obj.axisIndex);
                if ((obj.axisIndex == 3) && (~isempty(obj.zSlices)))
                    plot(obj.canvas(1), ...
                         squeeze(obj.zSlices{frameIndex}(:,1,:)), ...
                         squeeze(obj.zSlices{frameIndex}(:,2,:)), ...
                         'color', 'm');
                end
                hold off;
            else
                DrawModels@UI.StackViewer(obj);
            end
        end
    end
end