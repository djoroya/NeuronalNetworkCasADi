import casadi.*
%% Definimos los inputas y ouptpus
dimInput = 3;
dimOutput = 1;
%% Data
XData = linspace(-2,2,10);
YData = (XData > -1) .*( XData<1);
%% Arquitectura de la red sera cuadrada
Nhiddenlayers = 3;
Nneurons = 4;
%% Cramos Variables simbolicas para los pesos y bias
weights = {};
bias = {};

weights{1} =  casadi.SX.sym('wI',[Nneurons dimInput]);
bias{1}    =  casadi.SX.sym('bI',[dimInput 1]); 

for ilayer = 1:Nhiddenlayers
       string = ['w',num2str(ilayer)];
       weights{ilayer+1} = casadi.SX.sym(string,[Nneurons Nneurons]); 
       string = ['b',num2str(ilayer)];
       bias{ilayer+1}    = casadi.SX.sym(string,[Nneurons 1]); 

end

weights{ilayer+2} =  casadi.SX.sym('wO',[dimOutput Nneurons]);
bias{ilayer+2}    =  casadi.SX.sym('bO',[dimOutput 1]); 

%% Funcion de activacion
sigmoi = @(x) 0.5 + 0.5*tanh(2*x); 
%% Variables simbolicas que representa cualquier dato de entrada y salida
XDataSym = casadi.SX.sym('XData',[dimInput]);
YDataSym = casadi.SX.sym('YData',[dimOutput]);
%% Termino de Perdidas 
J = sigmoi(weights{1}*XDataSym);
for ilayer = 1:Nhiddenlayers
   J = sigmoi(weights{ilayer+1}*J);
end
J = sigmoi(weights{ilayer+2}*J);
%% Colocamos todas las variables de optimizacion en un solo array
vars = weights{1}(:);
for ilayer = 1:Nhiddenlayers
    vars = [vars ; weights{ilayer+1}(:)];
end
vars = [vars; weights{ilayer+2}(:)];
%
vars = [vars; bias{1}(:)];
for ilayer = 1:Nhiddenlayers
    vars = [vars ; bias{ilayer+1}(:)];
end
vars = [vars; bias{ilayer+2}(:)];
%% Diferenciacion Automatica
dJdvar = gradient(J,vars);
%% Creamos Funciones para Coste y su derivada
dJfun = casadi.Function('dJ',{vars},{J});
dJdvarfun = casadi.Function('J',{vars},{dJdvar});
