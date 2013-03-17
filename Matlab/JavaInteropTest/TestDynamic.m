clear java;
clc;
javaaddpath('../Java/JavaInteropDynamicTest/bin');
javaclasspath

%%
clc
q = InteropDynamicTest;
q.callInt(3)
w = char(q.callString('hello'))
q.callObject(q)
q.callVector([1, 2, 3])
q.callMatrix([1, 2; 3, 4])
q.callMultMatrix([1, 2; 3, 4], 3)
q.callMultStack(reshape([1:2^3], 2, 2, 2), 3)