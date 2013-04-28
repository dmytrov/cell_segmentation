classdef TDLList < handle 
    properties (GetAccess = public, SetAccess = protected)
        First;
        Last;
        Count;
    end
    
    methods (Access = public)
        function this = TDLList()
            this.First = [];
            this.Last = [];
            this.Count = 0;            
        end
        
        function Add(this, node)
            if (this.Count == 0)
                this.First = node;
                this.Last = node;
            else
                node.Prev = this.Last;
                this.Last.Next = node;
                this.Last = node;
            end
            this.Count = this.Count + 1;
        end
        
        function Remove(this, node)
            if (this.First == node)
                this.First = this.First.Next;
                this.First.Prev = [];
            elseif (this.Last == node)
                this.Last = this.Last.Prev;
                this.Last.Next = [];
            else
                nodePrev = node.Prev;
                nodeNext = node.Next;
                nodePrev.Next = nodeNext;
                nodeNext.Prev = nodePrev;
            end
            this.Count = this.Count - 1;
        end
        
        function res = ByIndex(this, index)
            res = this.First;
            for k = 1:index-1
                res = res.Next;
            end
        end
    end
end