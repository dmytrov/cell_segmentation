classdef TDLListNode < handle 
    properties (GetAccess = public, SetAccess = public)
        Data;
        Next;
        Prev;
    end
    
    methods (Access = public)
        function this = TDLListNode()
            this.Data = [];
            this.Next = [];
            this.Prev = [];            
        end
    end
end