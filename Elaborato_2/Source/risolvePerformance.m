function risolvePerformance(inf, sup, matrix_type)
%PERFORMANCE_CALCULATOR - genera un grafico dove viene mostrato l'andamento
% del tempo richiesto per ottenere la soluzione di un sistema lineare
% utilizzando risolve e mldivide, al variare della dimensione delle matrici
% e vettori
%

    warning('off','all');
    if(inf <= sup && inf > 1 )
        
        % vettore he contiene i tempi misurati
        execTimes = zeros(2,(sup-inf));
        j=1;
        % vettore che contiene i valori delle dimension
        aDim = zeros(1,(sup-inf));
        for i=inf:sup
            A = rand(i); b = rand(i,1); 
            if strcmp(matrix_type,'inf')
                A = tril(A);
                opt.inf=true;
            elseif strcmp(matrix_type,'sup')
                A = triu(A);
                opt.sup=true;
            elseif strcmp(matrix_type,'full')
                opt.full=true;
            end
            f = @() risolve(A,b,opt); % handle to function
            f_m = @() A\b;
            execTimes(1,j) = timeit(f);
            execTimes(2,j) = timeit(f_m);
            aDim(j) = i;
            j = j+1;
        end
        
        % realizzazione dei grafico
        plot(aDim,execTimes(1,:),aDim,execTimes(2,:))
        title("Performance di risolve vs mldivide")
        xlabel('Dimensione di A')
        ylabel('Tempo di esecuzione (s)')
        legend('risolve','mldivide')    
    else
        error("inf deve essere maggiore di 1 e minore di sup");
    end
end

