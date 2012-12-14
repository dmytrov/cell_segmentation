classdef StackViewer < UI.Form
    properties (SetAccess = private, GetAccess = public)
        imStack = zeros(3,3,3);
        canvas;
        sliderFrame;
        btnChangeAxis;
        chboxGlobalScale;
        framePosition = [1, 1, 1];
        axisIndex = 3;
        imDynamicRange = [];
    end
    
    methods (Access = public)
        function obj = StackViewer(imStack)
            obj = obj@UI.Form(); 
            if (nargin > 0)
                obj.imStack = imStack;
            end
            
            winPos = get(obj.h, 'Position');
            set(obj.h, 'Position', [winPos(1:2), 800, 600]);
            winPos = get(obj.h, 'Position');
            
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
            
            obj.canvas = axes('units','pixels',...                                            
                ...%'position', [40, 60, winPos(3)-80, winPos(4)-100], ...
                'fontsize', 10, ...
                'nextplot', 'replacechildren');
            
            obj.DoLayout();
            
            imagesc(obj.imStack(:, :, 1));
            colorbar;
            axis image;
            
            addlistener(obj.sliderFrame, 'Value', 'PostSet', @(s,e) (obj.OnSlider(s, e)));
            %set(obj.slider, 'AdjustmentValueChangedCallback', {@OnSlider, obj})
            %set(obj.slider, 'Callback', {@OnSlider, obj});
            obj.ImageToScreen();
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
            set(obj.chboxGlobalScale, 'position', [winPos(3)-100, 60, 80, 20]);
            set(obj.canvas, 'position', [40, 60, winPos(3)-80, winPos(4)-100]);
        end
        
        function OnSlider(obj, handle, eventData)
            obj.framePosition(obj.axisIndex) = round(get(obj.sliderFrame, 'Value'));
            obj.ImageToScreen();
        end
        
        function ImageToScreen(obj)
            frameIndex = obj.framePosition(obj.axisIndex);
            if (isempty(obj.imDynamicRange))
                switch obj.axisIndex
                    case 1
                        imagesc(squeeze(obj.imStack(frameIndex, :, :)));
                    case 2
                        imagesc(squeeze(obj.imStack(:, frameIndex, :)));
                    case 3
                        imagesc(squeeze(obj.imStack(:, :, frameIndex)));    
                end
            else
                switch obj.axisIndex
                    case 1
                        imagesc(squeeze(obj.imStack(frameIndex, :, :)), obj.imDynamicRange);
                    case 2
                        imagesc(squeeze(obj.imStack(:, frameIndex, :)), obj.imDynamicRange);
                    case 3
                        imagesc(squeeze(obj.imStack(:, :, frameIndex)), obj.imDynamicRange);    
                end
            end
            axis image;
        end
        
        function OnChangeAxis(obj, handle, eventData)
            obj.axisIndex = mod(obj.axisIndex, 3) + 1;
            set(obj.sliderFrame, 'max', size(obj.imStack, obj.axisIndex), ...
                'val', obj.framePosition(obj.axisIndex), ...
                'SliderStep', [1/size(obj.imStack, obj.axisIndex), 1/size(obj.imStack, obj.axisIndex)]);
            set(obj.btnChangeAxis, 'String', ['Axis ', num2str(obj.axisIndex)]);
            obj.ImageToScreen();
        end
        
        function OnGlobalScale(obj, handle, eventData)
            checked = get(obj.chboxGlobalScale, 'Value');
            if (checked)
                obj.imDynamicRange = [min(obj.imStack(:)), max(obj.imStack(:))];
            else
                obj.imDynamicRange = [];
            end
            obj.ImageToScreen();
        end
    end
end














