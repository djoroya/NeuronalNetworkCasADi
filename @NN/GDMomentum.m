function omega = GDMomentum(iNN,XData,YData)

    [~,nsamples] = size(XData);
    
    omega0 = iNN.NumParams.omega;
    
    import casadi.*
    
    %%
    figure(1)
    clf;hold on
    ip = plot(XData,full(iNN.Yomega(omega0,XData)));
    plot(XData,YData,'o')
    %%
    alpha = 0.2;
    beta = 0.8;
    m    = 0;
    omega = omega0;
    
    MaxIter = 10000;
    showbolean =  mod(1:MaxIter,50) == 0;

    for i = 1:MaxIter
        % Compute Gradient
        dLoss = sum(iNN.dLoss(omega,XData,YData),2)/nsamples;
        m     = beta*m + (1-beta)*dLoss;
        % update Parameters
        omega = omega - alpha*m;        
        % Compute Loss
        % Show
        if showbolean(i)
            fprintf(['iter:',num2str(i),'|dLoss:',num2str(full(norm(dLoss))),'\n'])
            %ip.YData = full(iNN.Yomega(omega,XData));
            %pause(0.01)
        end
    end
    omega = full(omega);
    iNN.NumParams.omega = full(omega)  ;

end

