function plotPerfomance(f,x0,TOL)
%plotPerfomance Plotta su un istogramma il numero di iterazioni neccessarie
%   per calcolare lo zero di una funzione utilizzando fzero e
%   bisectionAlgorithm al variare di tol.

    res_fzero=zeros(1,length(TOL));
    res_bisectionAlgorithm=zeros(1,length(TOL));
    
    % calcolo il numero di iterazioni
    for i = 1 : length(TOL)
        [~, output] = bisectionAlgorithm(f,x0,TOL(i));
        res_bisectionAlgorithm(i) = output.niter;
        
        %setto la tolleranza per fzero
        options = optimset('TolX',TOL(i));
        [~, ~, ~, output] = fzero(f,x0,options);
        res_fzero(i) = output.iterations;
    end
    
    data = [res_bisectionAlgorithm' res_fzero'];
    x = categorical(TOL);
    bar(x,data )
    %ordina l'asse x al contrario
    set ( gca, 'xdir', 'reverse' )
    %imposto i nomi alle etichette
    xlabel('TOL')
    ylabel('Numero di iterazioni')
    %imposto titolo
    title('Confronto numero di iterazioni tra fzero e bisectionAlgorithm al variare di TOL')
    %imposto la legenda
    legend(gca, 'Location', 'northwest')
    legend('bisectionAlgorithm','fzero')
end

