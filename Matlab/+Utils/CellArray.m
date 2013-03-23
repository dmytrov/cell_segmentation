classdef CellArray < handle
    methods (Static = true, Access = public)
        function res = FindByName(array, name)
            for k = 1:numel(array)
                element = array{k};
                if (strcmp(element.Name, name))
                    res = element;
                    return;
                end
            end
            exception = MException('Utils:CellArrayFindByName', ['Name "', name, '" is not found']);
            throw(exception);
        end
    end
end
