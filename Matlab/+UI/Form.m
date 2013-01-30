classdef Form < handle
    properties (SetAccess = private, GetAccess = public)
        h
    end
    
    methods (Access = public)
        function obj = Form()
            obj.h = figure();
            set(obj.h, 'ToolBar', 'figure');
            set(obj.h, 'Position', [200, 200, 800, 600]);
            %set(obj.h, 'CloseRequestFcn', @(src, event)(OnCloseRequest(obj, src, event)));
            set(obj.h, 'DeleteFcn', @(src, event)(OnDeleteFcn(obj, src, event)));
            set(obj.h, 'ResizeFcn', @(src, event)(OnResizeFcn(obj, src, event)));
        end

        function delete(obj)
            try
                if (~isempty(obj.h))
                    close(obj.h);
                end
            catch err
            end
        end
    %end
    
    %methods 
%         function OnCloseRequest(obj, src, event)
%             return 
%         end

        function OnDeleteFcn(obj, src, event)
            obj.h = [];
        end
        
        function OnResizeFcn(obj, src, event)
            % to be overloaded in derived classes
        end
        
    end
    
end