function sysResult = sistemaEpidemia(t, y, a , b)
% Function che descrive il modello di diffusione di un epidemia.
% Input :
%           - t: indica l'istante o gli istanti di tempo in cui si vogliono
%                 valutare i valori assenti dal sistema
%           - y: Vettore delle funzioni che descrivono l'andamento.
%           - a : costante di contagio
%           - b : costante di guarigione

   % derivate prime che descrivono l'andamento delle tre variabili di 
   % stato del sistema 
   
   % Suscettibili
    DerS= -a*y(1)*y(2);
   % Infetti
    DerI = a*y(1)*y(2) -b*y(2);
   % Rimossi
    DerR = b*y(2);
    
    sysResult = [DerS DerI DerR]';
end

