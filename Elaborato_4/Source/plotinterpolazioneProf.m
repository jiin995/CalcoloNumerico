function plotinterpolazioneProf
    % plotting interattivo con ginput
    hold on
    xx = [];yy=[]; % lista di nodi iniziale vuota.
    n = 0;
    axis tight;thisax=axis;    %fisso gli assi
    % inserimento nodi
    disp('bottone sinistro mouse aggiungi un nodo')
    disp('bottone destro mouse aggiunge ultimo nodo')
    bottone = 1;
    while bottone == 1
        [xi,yi,bottone] = ginput(1);
        plot(xi,yi,'bo','MarkerFaceColor','g','MarkerSize',8);axis(thisax);
        n = n+1;
        xx=[xx xi];yy= [yy yi];
    end 
    sceltamenu(xx,yy)
end
% sottofunzione sceltamenu
function sceltamenu(xx,yy)
scelta=menu('scegli interpolante','lineare','polinomio', 'spline nat','fine');
% Interpola con la lineare a tratti ,linea rossa,  Interpola con polinomio, 
%linea verde, Interpola con spline,linea blu
    if scelta==1
        t=linspace(xx(1),xx(end));
        pt=interp1(xx,yy,t);
        plot(t,pt,'r-','LineWidth',2);
    elseif scelta==2
        t=linspace(xx(1),xx(end));
        p=polyfit(xx,yy,length(xx)-1);
        pt=polyval(p,t);
        plot(t,pt,'g-','LineWidth',2);
    elseif scelta==3
        t = linspace(xx(1),xx(end));
        pp = csape(xx,yy,'second');
        s=ppval(pp,t);
        plot(t,s,'b-','LineWidth',2);
    elseif scelta==4
        return
    end
end