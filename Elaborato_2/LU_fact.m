function [A,piv]= LU_fact(A)
    % precalcolo lo zero relativo della matrice in modo da ottimizzare le
    % prestazioni (il calcolo della norma è computazionalmente oneroso)
    zero = eps(norm(A)); 
    n=size(A,1);
    piv= 1:n;
    
    for k=1:n-1
        % Determino il più piccolo r tale che |A(piv(r),k)|=max|A(piv(i),k| con i>=k
        r = find(abs(A(piv(1:n),k)) == max(abs(A(piv(k:n),k))), 1); 
        if abs(A(piv(r),k)) > zero % Controllo se il pivot considerato è diverso da zero.
            if r ~= k
                piv([r k])=piv([k r]); %scambio virtuale delle righe
            end
            % Matrice L (salvata in place): A(piv(i),k) = A(piv(i),k)/A(piv(k),k), i=k+1,...,n
            A(piv((k+1):n),k) = A(piv((k+1):n),k)/A(piv(k),k);
            % Matrice U (salvata in place): A(piv(i),j) = A(piv(i),j) -
            % A(piv(i),k)*A(piv(k),j), i=k+1,...,n, j=k+1,...,n.
            A(piv((k+1):n),(k+1):n)=A(piv((k+1):n),(k+1):n)-(A(piv((k+1):n),k)*A(piv(k),(k+1):n));
        else
            error ('risolve:ASingular','sistema singolare.')
        end
    end
    if abs(A(piv(n),n)) <= zero %verifica singolarità matrice dei coefficienti per l'ultimo valore
        error('risolve:ASingular','sistema singolare')
    end
end