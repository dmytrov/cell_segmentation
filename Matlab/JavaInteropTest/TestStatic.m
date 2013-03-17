%%          QUICKSTART FOR JAVA INTEROPERABILITY IN MATLAB
%   Read http://undocumentedmatlab.com/blog/matlab-callbacks-for-java-events/
%   
%   Matlab code can handle Java events via callbacks. Handlers are called
%   asynchronously. Java class that provides events MUST be added to the
%   STATIC part of the matlab's java CLASSPATH, not to the DYNAMIC!!! Type
%--------------------------------------------------------------------------
%       edit('classpath.txt')
%--------------------------------------------------------------------------
%   to open and edit the classpath file.
%
%   Event publishers must implement add[eventListener](EventListener el) and 
%   remove[eventListener](EventListener el) methods. They are used by
%   matlab while setting 
%

%%
clc
clear java;

%%
w = InteropStaticTest();
get(w)
set(w, 'TestEventCallback', @(h, e)(fprintf('Event data: (%d, %d)\n', e.oldValue, e.newValue)));
w.notifyMyTest()
