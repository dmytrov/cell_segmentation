% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef Form < handle
    properties (SetAccess = private, GetAccess = public)
        h;
    end
    
    properties (Access = public)
        deleteOnClose = 1;
    end
    
    methods (Access = public)
        function obj = Form()
            obj.h = figure();
            set(obj.h, 'ToolBar', 'figure');
            set(obj.h, 'Position', [200, 200, 800, 600]);
            set(obj.h, 'DeleteFcn', @(src, event)(OnDeleteFcn(obj, src, event)));
            set(obj.h, 'ResizeFcn', @(src, event)(OnResizeFcn(obj, src, event)));
            set(obj.h, 'WindowButtonMotionFcn', @(src, event)(OnMouseMoveFcn(obj, src, event)));
        end

        function delete(obj)
            try
                %if (~isempty(obj.h))
                %    if (obj.deleteOnClose)
                        close(obj.h);
                %    else
                %        set(obj.h, 'Visible', 'off');
                %    end
                %end
            catch err
            end
        end

        function OnDeleteFcn(obj, src, event)
            obj.h = [];
        end
        
        function OnResizeFcn(obj, src, event)
            % to be overloaded in derived classes
        end
        
        function OnMouseMoveFcn(obj, src, event)
            % to be overloaded in derived classes
        end
        
    end
    
end