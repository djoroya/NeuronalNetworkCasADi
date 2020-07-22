import casadi.*
%% Definimos los inputas y ouptpus
dimInput = 3;
dimOutput = 2;
%% Data
XData = linspace(-2,2,10);
YData = (XData > -1) .*( XData<1);
%% Arquitectura de la red sera cuadrada
Nhiddenlayers = 3;
Nneurons = 4;
%% Cramos Variables simbolicas para los pesos y bias
weights = {};
bias = {};

% Los pesos y bias  input
weights{1} =  casadi.SX.sym('wI',[Nneurons dimInput]);
bias{1}    =  casadi.SX.sym('bI',[dimInput 1]); 
% Los pesos y bias intermendios
for ilayer = 1:Nhiddenlayers
       string = ['w',num2str(ilayer)];
       weights{ilayer+1} = casadi.SX.sym(string,[Nneurons Nneurons]); 
       string = ['b',num2str(ilayer)];
       bias{ilayer+1}    = casadi.SX.sym(string,[Nneurons 1]); 
end
% Los pesos y bias  outputs
weights{ilayer+2} =  casadi.SX.sym('wO',[dimOutput Nneurons]);
bias{ilayer+2}    =  casadi.SX.sym('bO',[dimOutput 1]); 

%% Funcion de activacion
sigmoi = @(x) 0.5 + 0.5*tanh(2*x); 
%% Variables simbolicas que representa cualquier dato de entrada y salida
XDataSym = casadi.SX.sym('XData',[dimInput]);
YDataSym = casadi.SX.sym('YData',[dimOutput]);
%% Termino de Perdidas =>  J = $(y_\omega(XData) - YData)^2$, 
% donde \omega son los parametros de la red (todos pesos y bias)
Yomega = sigmoi(weights{1}*XDataSym);
for ilayer = 1:Nhiddenlayers
   Yomega = sigmoi(weights{ilayer+1}*Yomega);
end
% Tenemos $y_\omega(XData)$
Yomega = sigmoi(weights{ilayer+2}*Yomega);
% entonces el termino de perdida es: 
J = (Yomega-YDataSym)'*(Yomega-YDataSym);

%% Colocamos todas las variables de optimizacion en un solo array
omegas = weights{1}(:);
for ilayer = 1:Nhiddenlayers
    omegas = [omegas ; weights{ilayer+1}(:)];
end
omegas = [omegas; weights{ilayer+2}(:)];
%
omegas = [omegas; bias{1}(:)];
for ilayer = 1:Nhiddenlayers
    omegas = [omegas ; bias{ilayer+1}(:)];
end
omegas = [omegas; bias{ilayer+2}(:)];
%% Diferenciacion Automatica
dJdw = gradient(J,omegas);
%% Creamos Funciones para Coste y su derivada
J_fun     = casadi.Function('J',{omegas,XDataSym,YDataSym},{J});
dJdw_fun = casadi.Function('dJ',{omegas,XDataSym,YDataSym},{dJdvar});
