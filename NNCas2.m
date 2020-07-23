clear all
import casadi.*

%% Take data
[IData,OData] = ex02();

%% Definimos los inputs y ouptpus
[dimInput,~] = size(IData);
[dimOutput,~] = size(OData);
%% 

%%
Nhiddenlayers = 2;
Nneurons = 5;

iNN = NN(dimInput,dimOutput,Nhiddenlayers,Nneurons);
%%
MaxIter = 4000;
omega = SGDMomentum(iNN,IData,OData,MaxIter);
%omega = SGDMiniBatch(iNN,IData,OData);
%omega = GD(iNN,IData,OData);

%%


N = 40;
xline = linspace(-5,5,N);
yline = linspace(-5,5,N);

allXY = zeros(2,N^2);

i = 0;
for ix = xline
   for iy = yline
      i = i + 1;
      allXY(:,i) = [ix,iy];
   end
end
%%
[~, nSample] = size(OData);
nSample = nSample/2;
figure(1)

clf
subplot(2,1,1)
hold on

[xms,yms] = meshgrid(xline, yline);

allOutput = full(iNN.Yomega(omega,allXY));
Z = griddata(allXY(1,:),allXY(2,:),allOutput(1,:),xms,yms);
surf(xms, yms, Z,'FaceAlpha',0.6);
shading interp
colorbar
caxis([0 1])
grid on
daspect([1 1 1])
colormap cool


scatter3(IData(1,1:nSample),IData(2,1:1:nSample),OData(1,1:nSample),'filled')
scatter3(IData(1,(nSample+1):end),IData(2,(nSample+1):end),OData(1,(nSample+1):end),'filled')

view(0,90)
title('Output 1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on

[xms,yms] = meshgrid(xline, yline);

allOutput = full(iNN.Yomega(omega,allXY));
Z = griddata(allXY(1,:),allXY(2,:),allOutput(2,:),xms,yms);
surf(xms, yms, Z,'FaceAlpha',0.6);
shading interp
colorbar
caxis([0 1])
grid on
daspect([1 1 1])
colormap cool

% datos
scatter3(IData(1,1:nSample)      , IData(2,1:1:nSample)     , OData(2,1:nSample)      ,'filled')
scatter3(IData(1,(nSample+1):end), IData(2,(nSample+1):end) , OData(2,(nSample+1):end),'filled')
title('Output 2')

view(0,90)

