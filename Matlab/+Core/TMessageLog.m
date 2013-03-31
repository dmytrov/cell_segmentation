classdef TMessageLog < handle
    properties (Access = public)
        CustomPrinter;
        PrintToConsole;
    end
    
    methods (Access = public)
        function this = TMessageLog()
            this.CustomPrinter = [];
            this.PrintToConsole = true;
        end
        
        function PrintLine(this, message)
            this.Print(sprintf('%s\n', message));
        end
        
        function Print(this, message)
            if (this.PrintToConsole)
                fprintf(message);
            end
            if (~isempty(this.CustomPrinter))
                this.CustomPrinter(message);            
            end
        end
    end
end