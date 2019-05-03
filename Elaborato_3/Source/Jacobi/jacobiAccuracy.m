function accuracy = jacobiAccuracy(A,x,TOL,MAXITER)
%jacobiAccuracy - Calcola l'errore relativo della soluzione di un sistema 
%                  lineare con A sparsa  calcolata con risolve
%                 
% Utilizza jacobi per calcolare la soluzione di un sistemalineare la cui 
% matrice dei coefficienti A è sparsa, il vettore dei termini noti è b e 
% la soluzione è x.
% Input  :
%           - A : matrice dei coefficienti
%           - x : vettore delle soluzioni reali
% Output :
%           - Accuracy : struttura composta da tre campi :
%               - cond      : Indice di condizionamento della matrice A
%               - errore    : errore relativo tra la soluzione individuata
%                             utilizzando jacobi e quella vera del
%                             sistema.
%               - residuo   : norma della differenza di b-A*xJacobi sulla
%                             norma di b. (xJacobi = jacobi(a,b) )

    
% Calcolo il vettore dei termini noti a partire da A e x in modo tale da
% creare un sistema adHoc per eseguire i test
    b = A*x;
    
% prevedo di poter dare in input TOL e MAXITER
% in base ai parametri di input eseguo jacobi sul sistema in input
    switch nargin
        case 4 
            [xJacobi,niter,resRel] = jacobi(A,b,TOL,MAXITER);
        case 3
            [xJacobi,niter,resRel] = jacobi(A,b,TOL);
        case 2
            [xJacobi,niter,resRel] = jacobi(A,b);
    end
    
    accuracy.cond = condest(A);
    accuracy.erroreRel = norm(x-xJacobi,Inf)/norm(xJacobi,Inf);
    accuracy.residuoRel = resRel;
    accuracy.niter = niter;
    
    %Mostro il grafico della matrice A
    spy(A);
end

