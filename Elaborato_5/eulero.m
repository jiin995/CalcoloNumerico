function[t,u]=eulero(t0,T,h,f,y0)
%risolve un’equazione differenziale  y’=f(t,y(t)) con Eulero 
%nell’intervallo[to,T]con passo h e valore iniziale y0,in output si 
%ha il vettore t dei punti ed il vettore u della soluzione 
%approssimata nei punti t
    t=t0:h:T;
    u(1)=y0;
    for i=1:length(t)-1
        y=u;
        u=[u,y(i)+h*f(t(i),y(i))];
    end
end