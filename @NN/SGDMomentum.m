function omega0 = SGDMomentum(iNN,XData,YData,MaxIter)

    [~,nsamples] = size(XData);
    
    omega0 = iNN.NumParams.omega;
    
    import casadi.*
    
    alpha0 = 1;
    
    
    MiniBatch = 20;
   
    showbolean =  mod(1:MaxIter,50) == 0;
    
    %%
%     figure(1)
%     clf;hold on
%     ip = plot(XData,full(iNN.Yomega(omega0,XData)));
%     plot(XData,YData,'o')

    rdin = zeros(MiniBatch,MaxIter);
    for i = 1:MaxIter
        rdin(:,i) = randsample(1:nsamples,MiniBatch,false)';
    end
    %%
    beta = 0.8;
    m = 0;
    %
    for i = 1:MaxIter
        %
        alpha = alpha0/i^(1/3);
        % Compute Gradient
        dLoss = (1/MiniBatch)*sum(iNN.dLoss(omega0,XData(:,rdin(:,i)),YData(:,rdin(:,i))),2);
        % momentum
        m = beta*m + (1-beta)*dLoss;
        % update Parameters
        omega0 = omega0 - alpha*m;        
        % Show
        if showbolean(i)
        fprintf(['iter:' ,num2str(i,'%.4d'), ...
                '| LenghtStep:',num2str(alpha,'%.4e'), ...
                '|dLoss:',num2str(full(norm(dLoss)),'%.4e'),'\n'])
%             ip.YData = full(iNN.Yomega(omega0,XData));
%             pause(0.01)
        end
    end
    iNN.NumParams.omega = full(omega0)  ;
    omega0 = full(omega0);
end

