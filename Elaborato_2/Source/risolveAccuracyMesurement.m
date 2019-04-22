function  risolveAccuracyMesurement(inf,sup)
%risolveAccuracyMesurement - salva su tre fogli di uno stesso file excel 
% i risultati delle prove di resolve, calcolate su sistemi generati
% casualmente,le cui soluzioni sono sempre vettori di elementi unitari.
% Le dimensioni delle matrici variano da inf a sup

%disattivo i warning, che generebbe writetable quando crea nuovi fogli 
    warning('off','all');
    if(inf <= sup && inf > 1 )

        result = struct('cond',zeros(1,1),'rcond',zeros(1,1), 'errore',zeros(1,1),'residuo',zeros(1,1));
        for i=inf:sup
            A = rand(i,i)*i*10;
            x = rand(i,1);
            b = A*x;
            result(i)=risolveAccuracy(A,b,x,'full');
        end
        writetable(  struct2table(result) , 'accuracyMesurement.xlsx','Sheet','Piena');
        
        for i=inf:sup
            A = triu(rand(i,i)*i);
            x = rand(i,1);
            b = A*x;
            result(i)=risolveAccuracy(A,b,x,'sup');
        end
        writetable( struct2table(result) ,'accuracyMesurement.xlsx','Sheet','Triangolare superiore');
        
        for i=inf:sup
            A = tril(rand(i,i)*i);
            x = rand(i,1);
            b = A*x;
            result(i)=risolveAccuracy(A,b,x,'inf');
        end
        writetable( struct2table(result),'accuracyMesurement.xlsx','Sheet','Triangolare inferiore');

    else
        error("inf deve essere maggiore di 1 e minore di sup");
    end
end