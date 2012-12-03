classdef Form < handle
    properties (SetAccess = private, GetAccess = public)
        h
    end
    
    methods
        function obj = Form()
            obj.h = figure();
            set(obj.h, 'Position', [200, 200, 800, 500]);
            %set(obj.h, 'CloseRequestFcn', @(src, event)(OnCloseRequest(obj, src, event)));
            set(obj.h, 'DeleteFcn', @(src, event)(OnDeleteFcn(obj, src, event)));
        end

%         function OnCloseRequest(obj, src, event)
%             return 
%         end

        function OnDeleteFcn(obj, src, event)
            obj.h = [];
        end
        
        function delete(obj)
            try
                if (~isempty(obj.h))
                    close(obj.h);
                end
            catch err
            end
        end
    end
    
end