function relativeError = accuracy_bisectionAlgorithm(f,x0,TOL)
% accuracy_bisectionAlgorithm : Ritorna l'errore relativo tra i risultati
% ottenuti con fzero e con bisectionAlgorithm al variare di TOL
%
    sol = bisectionAlgorithm(f,x0,TOL);
    options = optimset('TolX',TOL);
    fzeroSol = fzero(f,x0,options);
    relativeError = abs(sol - fzeroSol)/abs(fzeroSol); 
    
end
