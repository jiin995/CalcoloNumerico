function relativeError = plotAccuracy_bisectionAlgorithm(f,x0,TOL)
% accuracy_bisectionAlgorithm : Ritorna l'errore relativo tra i risultati
% ottenuti con fzero e con bisectionAlgorithm al variare di TOL
%
    errors=zeros(1,length(TOL));
    
    % calcolo il numero di iterazioni
    for i = 1 : length(TOL)
        errors(i) = accuracy_bisectionAlgorithm(f,x0,TOL(i));
    end
    
    x = categorical(TOL);
    %errors = double(errors') ;
    plot(x,errors','LineWidth',2)
    %ordina l'asse x al contrario
    set ( gca, 'xdir', 'reverse' )
    %imposto i nomi alle etichette
    
    xlabel('TOL')
    ylabel('Errore relativo')
    %imposto titolo
    title('Errore relativo al variare di TOL')
    
end

function relativeError = accuracy_bisectionAlgorithm(f,x0,TOL)
% accuracy_bisectionAlgorithm : Ritorna l'errore relativo tra i risultati
% ottenuti con fzero e con bisectionAlgorithm al variare di TOL
%
    sol = bisectionAlgorithm(f,x0,TOL);
    options = optimset('TolX',TOL);
    fzeroSol = fzero(f,x0,options);
    relativeError = abs(sol - fzeroSol)/abs(fzeroSol); 
    
end
