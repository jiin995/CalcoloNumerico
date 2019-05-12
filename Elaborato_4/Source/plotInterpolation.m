function plotInterpolation
    x = []; y = []; t = []; p1 = []; p2 = []; p3 = []; 
    button = 1;
    axis tight; thisax=axis    

%% Creazione figure and axes 
    f = figure('Name','Interpolazione punti','NumberTitle','off',...
        'Visible','on','position',[200 200 700 400]);
    ax = axes('Units','pixels');
    ax.Position = [30 75 600 280];
    hold on
    
%% Controlli UI
    takePointsButtons = uicontrol('Style', 'pushbutton', 'String',...
        'Seleziona punti','Position', [30 20 120 20],...
        'Callback', @takePoints);  
					
    label = uicontrol('Style','text',...
        'Position',[150 18 200 20],...
        'String','Seleziona il tipo di interpolazione');
    
    comboBox = uicontrol('Style', 'popup',...
        'String', {'Lineare','Polinomio','Spline naturale','Tutte'},...
        'Position', [350 20 100 20],...
        'Callback', @interpola);   

    resetButton = uicontrol('Style', 'pushbutton', 'String', 'Reset data',...
        'Position', [470 20 100 20],...
        'Callback', @reset); 
    
    closeButton = uicontrol('Style', 'pushbutton', 'String', 'Chiudi Finestra',...
        'Position', [570 20 100 20],...
        'Callback', 'delete(gcf)'); 

    function takePoints(source,event)

        while button == 1
            [xi,yi,button] = ginput(1);
            p=plot(xi,yi,'bo','MarkerFaceColor','b','MarkerSize',5);
            axis(thisax);
            x = [x xi]; y = [y yi];
        end
        t = linspace(x(1),x(length(x)));

    end

    function interpola(source,event)
        idx = source.Value;
        maps = source.String;
        switch idx
              case 1
                  set(p1,'Visible','on');
                  set(p2,'Visible','off');
                  set(p3,'Visible','off');
                  pt = interp1(x,y,t);
                  p1 = plot(t,pt,'r-','LineWidth',2);
              case 2
                  set(p1,'Visible','off');
                  set(p2,'Visible','on');
                  set(p3,'Visible','off');
                  pt = polyval(polyfit(x,y,length(x)-1),t);
                  p2 = plot(t,pt,'g-','LineWidth',2);
              case 3
                  set(p1,'Visible','off');
                  set(p2,'Visible','off');
                  set(p3,'Visible','on');
                  s = ppval(csape(x,y,'second'),t);
                  p3 = plot(t,s,'b-','LineWidth',2);
              case 4
                  set(p1,'Visible','on');
                  set(p2,'Visible','on');
                  set(p3,'Visible','on');
                  pt = interp1(x,y,t);
                  p1 = plot(t,pt,'r-','LineWidth',2,'DisplayName','Lineare');
                  pt = polyval(polyfit(x,y,length(x)-1),t);
                  p2 = plot(t,pt,'g-','LineWidth',2,'DisplayName','Polinomiale');
                  s = ppval(csape(x,y,'second'),t);
                  p3 = plot(t,s,'b-','LineWidth',2,'DisplayName','Spline naturale');
                  legend([p1,p2,p3],{'Lineare','Polinomiale','Spline'})
         end
    end

    function reset(source,event)
        clear ax;
        ax = axes('Units','pixels');
        ax.Position = [30 75 600 280];
        hold on
        button=1;
        x(:,:)=[]; y(:,:)=[];
         
    end
end