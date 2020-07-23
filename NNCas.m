clear all
import casadi.*

%% Take data
[IData,OData] = ex01();


%% Definimos los inputs y ouptpus
[dimInput,~] = size(IData);
[dimOutput,~] = size(OData);
%% 

%%
Nhiddenlayers = 2;
Nneurons = 5;

iNN = NN(dimInput,dimOutput,Nhiddenlayers,Nneurons);
%%
omega = SGDMomentum(iNN,IData,OData);
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
figure(1)
clf
hold on

[xms,yms] = meshgrid(xline, yline);
Z = griddata(allXY(1,:),allXY(2,:),full(iNN.Yomega(omega,allXY)),xms,yms);
surf(xms, yms, Z,'FaceAlpha',0.6);
shading interp
colorbar
caxis([0 1])
grid on
daspect([1 1 1])
colormap cool
nSample = find(OData);
nSample = nSample(1) - 1;

scatter3(IData(1,1:nSample),IData(2,1:1:nSample),OData(1:nSample),'filled')
scatter3(IData(1,(nSample+1):end),IData(2,(nSample+1):end),OData((nSample+1):end),'filled')

view(0,90)

