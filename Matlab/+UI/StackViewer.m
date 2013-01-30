% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef StackViewer < UI.Form
    properties (SetAccess = protected, GetAccess = public)
        imStack = zeros(3,3,3);
        canvas;
        hImage;
        sliderFrame;
        btnChangeAxis;
        chboxGlobalScale;
        framePosition = [1, 1, 1];
        axisIndex = 3;
        imDynamicRange = [];
    end
    properties (Access = public)
        models;        
        settings;
    end
    
    methods (Access = public)
        function obj = StackViewer(imStack)
            obj = obj@UI.Form(); 
            if (nargin > 0)
                obj.imStack = imStack;
            end
            
            winPos = get(obj.h, 'Position');
            set(obj.h, 'Position', [winPos(1:2), 800, 600]);
            %winPos = get(obj.h, 'Position');
            
            obj.sliderFrame = uicontrol('style', 'slide', ...                                        
                'unit', 'pix', ...                           
                ...%'position', [20, 20, winPos(3)-140, 20], ...
                'min', 1, ...
                'max', size(obj.imStack, obj.axisIndex), ...
                'val', obj.framePosition(obj.axisIndex), ...
                'SliderStep', [1/size(obj.imStack, obj.axisIndex), 1/size(obj.imStack, obj.axisIndex)]);
            
            obj.btnChangeAxis = uicontrol('style', 'pushbutton', ...
                'unit', 'pix', ...
                ...%'position', [winPos(3)-100, 20, 80, 20], ...
                'String', ['Axis ', num2str(obj.axisIndex)], ...
                'Callback', @(o, e)(OnChangeAxis(obj, o, e)));
            
            obj.chboxGlobalScale = uicontrol('style', 'checkbox',  ...
                'unit', 'pix', ...
                ...%'position', [winPos(3)-100, 60, 80, 20], ...
                'String', 'Fix scale', ...
                'Callback', @(o, e)(OnGlobalScale(obj, o, e)));            
            
            obj.canvas(1) = axes('units','pixels',...                                            
                ...%'position', [40, 60, winPos(3)-80, winPos(4)-100], ...
                'fontsize', 10, ...
                'nextplot', 'replacechildren');
            
            obj.DoLayout();
            
            obj.hImage = imagesc(obj.imStack(:, :, 1));
            %colorbar;
            axis image;
            
            addlistener(obj.sliderFrame, 'Value', 'PostSet', @(s,e) (obj.OnSlider(s, e)));
            %set(obj.slider, 'AdjustmentValueChangedCallback', {@OnSlider, obj})
            %set(obj.slider, 'Callback', {@OnSlider, obj});
            obj.ImageToScreen();
            
            models = WEMesh.TModel.empty;
        end
                
        function delete(obj)
            
        end
    %end
    
    %methods
        function OnResizeFcn(obj, src, event)
            obj.DoLayout();
        end
        
        function DoLayout(obj)
            winPos = get(obj.h, 'Position');
            set(obj.sliderFrame, 'position', [20, 20, winPos(3)-140, 20]);
            set(obj.btnChangeAxis, 'position', [winPos(3)-100, 20, 80, 20]);
            set(obj.chboxGlobalScale, 'position', [winPos(3)-100, 50, 80, 20]);
            nCanvas = length(obj.canvas);
            q1 = linspace(0, winPos(3)-30, nCanvas + 1);
            for k = 1:nCanvas
                set(obj.canvas(k), 'position', [q1(k)+30, 90, ...
                                                q1(2)-30, winPos(4)-120]);
            end
        end
        
        function OnSlider(obj, handle, eventData)
            obj.framePosition(obj.axisIndex) = round(get(obj.sliderFrame, 'Value'));
            obj.ImageToScreen();
        end
        
        function DrawStack(obj)
            frameIndex = obj.framePosition(obj.axisIndex);
            clickFcn = get(obj.hImage, 'ButtonDownFcn');
            hitTest  = get(obj.hImage, 'HitTest');
            btnDownFcn = get(obj.canvas(1), 'ButtonDownFcn');
            switch obj.axisIndex
                case 1
                    slice = squeeze(obj.imStack(frameIndex, :, :));
                case 2
                    slice = squeeze(obj.imStack(:, frameIndex, :));
                case 3
                    slice = squeeze(obj.imStack(:, :, frameIndex));    
            end
            if (isempty(obj.imDynamicRange))
                obj.hImage = imagesc(slice', 'Parent', obj.canvas(1));
            else
                obj.hImage = imagesc(slice', 'Parent', obj.canvas(1), obj.imDynamicRange);
            end
            axis(obj.canvas(1), 'image');
            set(obj.hImage, 'ButtonDownFcn', clickFcn);
            set(obj.hImage, 'HitTest', hitTest);
            set(obj.canvas(1), 'ButtonDownFcn', btnDownFcn);
            set(gca,'YDir','normal');
        end
        
        function DrawModels(obj)
            frameIndex = obj.framePosition(obj.axisIndex);
            hitTest  = get(obj.hImage, 'HitTest');
            hold on;
            if (~isempty(obj.models) && ~isempty(obj.settings))
                vnPlane = [0, 0, 0]';
                vnPlane(obj.axisIndex) = 1;
                ptPlane = obj.settings.PixToMicron(vnPlane * frameIndex);
                for model = obj.models
                    section = Collision.MeshPlaneIntersect(model, ptPlane, vnPlane);
                    section = section ./ repmat(obj.settings.Resolution', [2, 1, size(section, 3)]);
                    section(:, obj.axisIndex, :) = [];
                    h = plot(obj.canvas(1), squeeze(section(:,1,:)), squeeze(section(:,2,:)), 'color', 'm');
                    set(h, 'HitTest', hitTest);            
                end
            end
            hold off;
        end
        
        function ImageToScreen(obj)
            DrawStack(obj);
            DrawModels(obj);
        end
        
        function OnChangeAxis(obj, handle, eventData)
            obj.axisIndex = mod(obj.axisIndex, 3) + 1;
            set(obj.sliderFrame, 'max', size(obj.imStack, obj.axisIndex), ...
                'val', obj.framePosition(obj.axisIndex), ...
                'SliderStep', [1/size(obj.imStack, obj.axisIndex), 1/size(obj.imStack, obj.axisIndex)]);
            set(obj.btnChangeAxis, 'String', ['Axis ', num2str(obj.axisIndex)]);
            obj.ImageToScreen();
        end
        
        function res = IsGlobalScale(obj)
            res = get(obj.chboxGlobalScale, 'Value');
        end
        
        function OnGlobalScale(obj, handle, eventData)
            if (obj.IsGlobalScale())
                obj.imDynamicRange = [min(obj.imStack(:)), max(obj.imStack(:))];
            else
                obj.imDynamicRange = [];
            end
            obj.ImageToScreen();
        end
    end
end














