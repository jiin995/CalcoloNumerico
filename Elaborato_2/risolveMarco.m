function x = risolveMarco(A, b, opt)
% risolve - Calcola la soluzione di un sistema lineare Ax = b.
%   x = risolve(A,b,opt) risolve il sistema di equazioni lineari A*x = b. A
%       deve essere una matrice quadrata, b deve essere un vettore colonna
%       avente lo stesso numero di righe di A. opt deve essere una struttura
%       contenente almeno uno dei seguenti campi booleani:
%           - full: true se la matrice A è piena, false altrimenti;
%           - sup: true se la matrice è triangolare superiore, false
%               altrimenti;
%           - inf: true se la matrice è triangolare inferiore, false
%               altrimenti;
%       La soluzione calcolata è corretta a meno di un errore dovuto al
%       malcondizionamento della matrice A (vedi cond, rcond)

    % I 3 parametri di ingresso sono tutti obbligatori
    if nargin < 3
        error('risolve:nargin','Numero di parametri di ingresso insufficiente.');
    end
    
    % Effettuando gli opportuni controlli, la struttura opt verrà modificata 
    % in maniera consistente con la matrice dei coefficienti.
    opt = check_input(A,b,opt);
    
    if opt.sup == true
        x = back_substitution(A,b);
    elseif opt.inf == true
        x = forward_substitution(A,b);
    else % opt.full == true
        x = lin_solve(A,b);
    end

end

function opt = check_input(A,b,opt)

    % A deve essere una matrice piena, quadrata composta da numeri reali. La matrice non
    % deve essere singolare.
    
    if issparse(A)
        error('risolve:ANotFull','Matrice A sparsa.');
    end
    
    if size(A,1) ~= size(A,2)
        error('risolve:ANotSquare','Matrice A non quadrata.');
    end
    
    if ~isnumeric(A) || any(find(isinf(A))) || any(find(isnan(A))) || ~isreal(A) || isempty(A)
        error('risolve:AInvalidValue','Uno o più valori inseriti in A non sono validi');
    end
    
    % La singolarità della matrice viene controllata nei rispettivi
    % algoritmi di risoluzione
    
    % __________________________________________________________________%
    % b deve essere un vettore colonna contenente numeri reali. Il numero
    % di righe deve essere pari al numero di righe di A, il numero di
    % colonne deve essere unitario.
    
    if size(b,1) ~= size(A,1) || size(b,2)~=1
        error('risolve:bDimension','Dimensione di b errata.');
    end
    
    if ~isnumeric(b) || any(find(isinf(b))) || any(find(isnan(b))) || ~isreal(b) || isempty(b)
        error('risolve:bInvalidValue','Uno o più valori inseriti in b non sono validi');
    end
    
    % ___________________________________________________________________%
    % opt è una struttura contenente tre campi booleani: full,
    % sup, inf. Se uno è vero, gli altri due devono necessariamente essere
    % falsi. L'utente può settare anche un solo parametro della struttura. Gli
    % altri vengono settati in automatico.
    
    if ~isstruct(opt) || (~isfield(opt,'sup') && ~isfield(opt,'inf') && ~isfield(opt,'full'))
        error('risolve:optNotStruct','La struttura inserita non è valida.');
    end
    
    if ~isfield(opt,'sup')
        opt.sup = false;
    elseif ~islogical(opt.sup)
        error('risolve:optNotValid','Un campo della struttura non è valido');
    end
    
    if ~isfield(opt,'inf')
        opt.inf = false;
    elseif ~islogical(opt.inf)
        error('risolve:optNotValid','Un campo della struttura non è valido');
    end
    
    if ~isfield(opt,'full')
        opt.full = false;
    elseif ~islogical(opt.full)
        error('risolve:optNotValid','Un campo della struttura non è valido');
    end
    
    if ((~opt.sup && ~opt.inf && opt.full) || (~opt.sup && opt.inf && ~opt.full) || (opt.sup && ~opt.inf && ~opt.full)) == 0
        error('risolve:optNotCoherent','I campi di opt non sono coerenti; uno ed un solo campo deve essere true.');
    end
    
    if(length(fieldnames(opt))>3)
        warning('risolve:optTooLong','E''stato inserito un campo non necessario nella struttura opt. Sarà ignorato.');
    end
    % ___________________________________________________________________%
    % Verifico che l'informazione contenuta in opt sia coerente con la
    % matrice che è stata passata
    
    if istriu(A)
        if opt.sup == false
            opt.sup = true;
            warning('risolve:optError1','La struttura opt è inconsistente; la matrice A è triangolare superiore');
        end
        opt.inf = false;
        opt.full = false;
    elseif istril(A)
        if opt.inf == false
            opt.int = true;
            warning('risolve:optError2','La struttura opt è inconsistente; la matrice A è triangolare inferiore');
        end
        opt.sup = false;
        opt.full = false;
    else
        if opt.full == false
            opt.full = true;
            warning('risolve:optError3','La struttura opt è inconsistente; la matrice A è piena');
        end
        opt.sup = false;
        opt.inf = false;
    end    
    
end

function x = back_substitution(A,b)
    % Verifico che la matrice è non singolare
    if any(find(abs(diag(A)) < eps(norm(A))))==1
        error('risolve:ASingular','Matrice A singolare.');
    end
    
    n=size(A,1);
    x = zeros(n,1);
    
    x(n,1)=b(n)/A(n,n);
    for i=n-1:-1:1
        x(i,1) = (b(i)- A(i,i+1:n)*x(i+1:n,1))/A(i,i);
    end
end

function x = forward_substitution(A,b)
    
    % Verifico che la matrice è non singolare
    if any(find(abs(diag(A)) < eps(norm(A))))==1
        error('risolve:ASingular','Matrice A singolare.');
    end
    
    n=size(A,1);
    x = zeros(n,1);
 
    x(1,1)=b(1)/A(1,1);
    for i=2:n
        x(i,1) = (b(i)- A(i,1:i-1)*x(1:i-1,1))/A(i,i);
    end
end

function x = lin_solve(A,b) 
    %LU factorization
    [A,piv]=LU_fact(A);

    n=size(A,1);
    %forward substitution
    y=zeros(1,n);
    y(1)=b(piv(1));
    for i=2:n
        y(i)=b(piv(i))- A(piv(i),1:i-1)*y(1:i-1)';
    end
    disp(A)
    disp(y)
    %back substitution
    x(n,1)=y(n)/A(piv(n),n); % Il risultato è un vettore colonna.
    for i=(n-1):-1:1
        x(i,1)=(y(i)-A(piv(i),(i+1):n)*x(i+1:n,1))/A(piv(i),i);
    end
end

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
    disp(A)
end