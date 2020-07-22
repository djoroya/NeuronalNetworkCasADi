clear 
load('DigitDataset/DataSet.mat')
%%
XData1 = DataSet(1).XData(:,:,2);

Kernel = [-1 0  -1;
           0 1 0;
          -1 0  -1];

XData1conv = conv2(XData1,Kernel,'valid');
for it = 1:10
XData1conv = conv2(XData1conv,Kernel,'valid');
end

XData1conv2 = conv2(XData1conv,Kernel);

figure(2)
clf
subplot(2,1,1)
surf(XData1)
caxis([-200 200])
view(0,-90)
subplot(2,1,2)
surf(XData1conv2)
caxis([-200 200])
view(0,-90)
