function omega = GD(iNN,XData,YData)

    [~,nsamples] = size(XData);
    
    omega0 = iNN.NumParams.omega;
    
    import casadi.*
    MaxIter = 5000;

    showbolean =  mod(1:MaxIter,50) == 0;

    %%
%     figure(1)
%     clf;hold on
%     ip = plot(XData,full(iNN.Yomega(omega0,XData)));
%     plot(XData,YData,'o')
    %%
    alpha = 0.2;
    omega = omega0;
    for i = 1:MaxIter
        % Compute Gradient
        dLoss = sum(iNN.dLoss(omega,XData,YData),2)/nsamples;
        % update Parameters
        omega = omega - alpha*dLoss;        
        % Compute Loss
        % Show
        if showbolean(i)
        fprintf(['iter:' ,num2str(i,'%.4d'), ...
                '| LenghtStep:',num2str(alpha,'%.4e'), ...
                '|dLoss:',num2str(full(norm(dLoss)),'%.4e'),'\n'])
%             ip.YData = full(iNN.Yomega(omega0,XData));
%             pause(0.01)
        end
    end
    omega = full(omega);
    iNN.NumParams.omega = full(omega)  ;

end

