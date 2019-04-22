function accuracy = risolveAccuracy(A,b,x,type)
%risoveAccuracy - Calcola l'errore relativo della soluzione calcolata con
%                 risolve
% Utilizza risolve per calcolare la soluzione di un sistema la cui matrice
% dei coefficienti è A, il vettore dei termini noti è b e la soluzione è x.
% Input  :
%           - A : matrice dei coefficienti
%           - b : vettore colonna dei termini noti
%           - x : vettore tale che Ax=b
% Output :
%           - Accuracy : struttura composta da tre campi :
%               - cond      : Indice di condizionamento della matrice A
%               - rcond     : Reciproco dell'indice di condizionamento 
%                             della matrice A
%               - errore    : errore relativo tra la soluzione individuata
%                             utilizzando resolve e quella vera del
%                             sistema.
%               - residuo   : norma della differenza di b-A*xRisolve sulla
%                             norma di b. (xRisolve = risolve(a,b,opt))
%                             Il residuo è sempre una quantità maggiore o
%                             uguale a 0, ma per matrici triangolari 
%                             superiori o inferiori il calcolo del residuo
%                             non ha senso, quindi si imposta il valore -1.
 

    if strcmp(type,'full')
        opt.full = true;
    elseif strcmp(type,'inf')
        opt.inf = true;
    elseif strcmp(type,'sup')
        opt.sup = true;
    else
        error("Type non valido");
    end
    
    accuracy.cond = cond(A);
    accuracy.rcond = rcond(A);
    xRisolve = risolve(A,b,opt);
    accuracy.errore = norm(x-xRisolve)/norm(x);
    
    if strcmp(type,'full')
        accuracy.residuo = (norm(b - A*xRisolve)/norm(b));
    else
        % valore non valido che segnala che la matrice dei coefficienti era
        % triangolare superiore o inferiore.
       accuracy.residuo = -1; 
    end
   
    
end
