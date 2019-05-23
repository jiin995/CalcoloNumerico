function simulazioneEpidemia(y0,t,b)

    figure('position', [0, 0, 800, 800])
    
    tutorial = uicontrol('Style','text',...
        'Position',[90 730 150 15],...
        'String','Scegliere il valore di a:');
    
    dropdown = uicontrol('Style', 'popup',...
           'String', {'0.005','0.01','0.05','0.1'},...
           'Position', [230 695 80 50],...
           'Callback', @update_a);    
       
    % primo modello con a iniziale 
    a = 0.005;
    update_model(y0,t,b,a);
    
    
    function update_a(source,event)
        idx = source.Value;
        switch idx
              case 1    
                  a = 0.005;
                  update_model(y0,t,b,a);
              case 2
                  a = 0.01;
                  update_model(y0,t,b,a);
              case 3
                  a = 0.05;
                  update_model(y0,t,b,a);
              case 4
                  a = 0.1;
                  update_model(y0,t,b,a);
        end
    end
end

function update_model(y0,t,b,a)
    
    % grafico delle soluzioni
    subplot(2,1,1);
    [t y] = ode45(@sistemaEpidemia, t, y0, [], a, b);   % risolvo con ode45
    plot(t, y(:,1),'-', t, y(:,2),'--', t, y(:,3), '*', 'LineWidth', 2), grid
    title(sprintf('Modello SIR, a = %g', a))
    legend('Suscettibili', 'Infetti', 'Immuni')
    xlabel('tempo')
    ylabel('individui')
    
    % grafico del picco di infetti
    subplot(2,1,2);
    I = y(:, 2);
    picco_index = find(I == max(I));    % trovo il picco massimo
    picco_massimo_y = I(picco_index);
    picco_massimo_x = t(picco_index);    
    plot(t,I,picco_massimo_x,picco_massimo_y,'d', 'LineWidth', 2), grid
    title(sprintf('Picco individui infetti, a = %g', a))
    legend('Individui infetti','picco massimo')
    xlabel('tempo')
    ylabel('individui infetti')
    text(picco_massimo_x+0.1,picco_massimo_y-8,["picco = "+num2str(floor(picco_massimo_y)),"t = "+num2str(picco_massimo_x)]);
    
end