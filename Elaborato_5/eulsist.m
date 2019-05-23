function [t,y] = eulsist(fun,t0,tf,y0,h)
% Risolve con il metodo di Eulero un sistema di equazioni differenziali
%y'=fun(t,y(t)) dall'istante t0 a tf con passo h e y0 vettore di valori iniziali
%in output si ha il vettore t dei punti e y matrice con numero di colonne =
%dimensione del sistema, colonna k= sol. approssimate nel punto t k
% fun deve ritornare un vettore della stessa lunghezza di y0
    t=t0:h:tf;
    t(1) = t0; y(1,:)=y0;
    for k=1:length(t)-1
        k1=fun(t(k),y(k,:));
        y(k+1,:)=y(k,:)+h*k1;
    end
end