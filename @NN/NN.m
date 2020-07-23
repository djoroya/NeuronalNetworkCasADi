classdef NN < handle
    %NN Red neuronal
    
    properties
        SymParms
        NumParams
        SymData
        activation
        Loss
        dLoss
        Yomega
    end
    
    methods
        function obj = NN(dimInput,dimOutput,Nhiddenlayers,Nneurons)
            import casadi.*

            %% Cramos Variables simbolicas para los pesos y bias
            weights = {};
            bias = {};

            % Los pesos y bias  input
            weights{1} =  casadi.SX.sym('wI',[Nneurons dimInput]);
            bias{1}    =  casadi.SX.sym('bI',[Nneurons 1]); 
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
            %% Colocamos todas las variables de optimizacion en un solo array
            omega = weights{1}(:);
            for ilayer = 1:Nhiddenlayers
                omega = [omega ; weights{ilayer+1}(:)];
            end
            omega = [omega; weights{end}(:)];
            %
            omega = [omega; bias{1}(:)];
            for ilayer = 1:Nhiddenlayers
                omega = [omega ; bias{ilayer+1}(:)];
            end
            omega = [omega; bias{end}(:)];
            

            %%
            %% Funcion de activacion
            obj.activation= @(x) 0.5 + 0.5*tanh(2*x); 
            %% Variables simbolicas que representa cualquier dato de entrada y salida
            IDataSym = casadi.SX.sym('XData',[dimInput]);
            ODataSym = casadi.SX.sym('YData',[dimOutput]);
            %% Termino de Perdidas =>  J = $(y_\omega(XData) - YData)^2$, 
            % donde \omega son los parametros de la red (todos pesos y bias)
            Yomega = obj.activation(weights{1}*IDataSym + bias{1});
            for ilayer = 1:Nhiddenlayers
               Yomega = obj.activation(weights{ilayer+1}*Yomega + bias{ilayer+1});
            end
            % Tenemos $y_\omega(XData)$
            Yomega = obj.activation(weights{end}*Yomega + bias{end});
            %%
            Yomega_fun = casadi.Function('Yomega',{omega,IDataSym},{Yomega});
            %%
            % entonces el termino de perdida es: 
            J = (Yomega-ODataSym)'*(Yomega-ODataSym) + 1e-3*(omega'*omega);
            %% Diferenciacion Automatica
            dJdw = gradient(J,omega);
            %% Creamos Funciones para Coste y su derivada
            J_fun     = casadi.Function('J', {omega,IDataSym,ODataSym} , {J});
            dJdw_fun = casadi.Function('dJ', {omega,IDataSym,ODataSym} , {dJdw});

            %% Iniciaizamos parámetros
            obj.NumParams.omega = 2*(0.5-rand(size(omega)));
            %% Save information in object
            
            obj.SymParms.weights = weights;
            obj.SymParms.bias    = bias;
            obj.SymParms.omega   = omega;
            
            obj.Yomega   = Yomega_fun;

            obj.Loss  = J_fun;
            obj.dLoss = dJdw_fun;
        end
        
    end
end

