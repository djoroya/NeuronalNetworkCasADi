function [IData,OData] = ex01()
%% Data 1
nSample = 100;

XData1 = zeros(1,nSample);
YData1 = zeros(1,nSample);
XData2 = zeros(1,nSample);
YData2 = zeros(1,nSample);

for i=1:nSample
    
    if rand < 0.5
        angle = 2*pi*rand();
        radius = normrnd(3,0.1);
        XData1(i) = radius*cos(angle);
        YData1(i) = radius*sin(angle);
    else
        angle = 2*pi*rand();
        radius = normrnd(0,0.1);
        XData1(i) = radius*cos(angle);
        YData1(i) = radius*sin(angle);        
    end
    %
    angle = 2*pi*rand();
    radius = normrnd(1,0.1);
    XData2(i) = radius*cos(angle);
    YData2(i) = radius*sin(angle);

    %
end

figure(1)
clf;hold on
plot(XData1,YData1,'r*')
plot(XData2,YData2,'b*')


IData = [[XData1;YData1],[XData2;YData2]];
OData = [zeros(1,nSample)  ones(1,nSample)];
end

