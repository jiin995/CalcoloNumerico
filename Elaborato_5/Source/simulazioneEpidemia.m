function simulazioneEpidemia(y0,t,a,b)
    
    hFig = figure(3);
    set(hFig, 'Position', [40 40 1000 700])

    % risolvo con ode45
    [t y] = ode45(@sistemaEpidemia, t, y0, [], a, b);   
    
    % grafico dell'andamento degli individui suscettibili, infetti e immuni
    subplot(2,1,1);
    plot(t, y(:,1),'-', t, y(:,2),'--', t, y(:,3), '*', 'LineWidth', 2), grid
    title(sprintf('Modello SIR, a = %g', a))
    legend('Suscettibili di infezione', 'Infetti', 'Immuni (Guariti)')
    xlabel('Tempo')
    ylabel('Individui')
    
    % grafico del picco di infetti
    subplot(2,1,2);
    
    %trovo il picco degli infetti
    indexPiccoInfetti = find(y(:, 2) == max(y(:,2)));    % trovo il picco massimo
    maxInfetti = y(indexPiccoInfetti,2);
    maxInfettiTime = t(indexPiccoInfetti);
    
    % Plotto la soluzione
    plot(t,y(:,2),maxInfettiTime,maxInfetti,'d', 'LineWidth', 2), grid
    title(sprintf('Picco individui infetti, a = %g', a))
    legend('Individui infetti','Picco massimo infetti')
    xlabel('Tempo')
    ylabel('Individui infetti')
    text(maxInfettiTime-(maxInfettiTime/4),maxInfetti-(maxInfetti/3),["Picco= "+num2str(floor(maxInfetti)),"t = "+num2str(maxInfettiTime)]);
    
end