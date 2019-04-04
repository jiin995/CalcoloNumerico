function plotPerfomance(f,x0,TOL)
%plotPerfomance Plotta su un istogramma il numero di iterazioni neccessarie
%   per calcolare lo zero di una funzione utilizzando fzero e
%   bisectionAlgorithm al variare di TOL.

% Inizializzo i vettori dei risultati 
    res_fzero=zeros(1,length(TOL));
    res_bisectionAlgorithm=zeros(1,length(TOL));
    
% Calcolo il numero di iterazioni al variare della tolleranza
    for i = 1 : length(TOL)
        [~, output] = bisectionAlgorithm(f,x0,TOL(i));
        res_bisectionAlgorithm(i) = output.niter;
        
        %setto la tolleranza per fzero
        options = optimset('TolX',TOL(i));
        [~, ~, ~, output] = fzero(f,x0,options);
        res_fzero(i) = output.iterations;
    end
    
% Preparo l'istrogramma
    
    data = [res_bisectionAlgorithm' res_fzero'];
    x = categorical(TOL);
    bar(x,data )
% Ordino l'asse x in senso inverso
    set ( gca, 'xdir', 'reverse' )
% Imposto i nomi degli assi
    xlabel('TOL')
    ylabel('Numero di iterazioni')

    title('Confronto numero di iterazioni tra fzero e bisectionAlgorithm al variare di TOL')
% Imposto la legenda
    legend(gca, 'Location', 'northwest')
    legend('bisectionAlgorithm','fzero')
end

