function x = risolve(A, b, opt)
%risolve - Calcola la soluzione di un sistema lineare Ax = b.
% Output :
%           - x : soluzione del sistema di equazioni tale che A*x = b.
% Nota : I parametri di inuput sono tutti obbligatori.
% Input :  
%           - A   : Matrice dei coefficienti, deve essere una matrice 
%                   quadrata piena, triangolare inferiore o superiore.
%           - b   : vettore dei terminini noti, deve essere un vettore  
%                   colonna avente lo stesso numero di righe di A.
%           - opt : tipo di matrice che individua l'algoritmo da utilizzare  
%                   per risolvere il sistema, deve essere una struttura 
%                   contenente almeno uno dei seguenti campi booleani:
%               - full: true se la matrice A è piena, false altrimenti. Il 
%                       sistema viene risolto utilizzando GAUSS con pivotig 
%                       virtuale ;
%               - sup : true se la matrice è triangolare superiore, false
%                       altrimenti.Il sistema viene risolto utilizzando 
%                       l'algoritmo di forward substitution ;
%               - inf: true se la matrice è triangolare inferiore, false
%                      altrimenti.Il sistema viene risolto utilizzando 
%                      l'algoritmo di forward substitution ;
%                      di questi campi, uno ed uno solo deve assumere  
%                      valore true.
%   La soluzione calcolata è corretta a meno di un errore dovuto al
%   malcondizionamento della matrice A (vedi cond, rcond)

%% Controllo dei parametri in ingresso
% sono tutti obbligatori e A deve essere una matrice, b un vettore colonna
% e opt una struttura contenente i capi specificati.
    if nargin < 3
        error('risolve:narginNotValid',...
                'Non ci sono abbastanza argomenti di input.');
    end
    
    opt = checkInput(A,b,opt);
    
    if opt.sup == true
        x = backSubstitution(A,b);
    elseif opt.inf == true
        x = forwardSubstitution(A,b);
    elseif opt.full == true
        x = gaussSolve(A,b);
    end
end



%% Definizione e implementazione di  CheckInput
function opt = checkInput(A,b,opt)
% Controlla che i parametri in input siano validi e ritorna opt che
% contiene un solo campo uguale a true.

%% Controllo sulla matrice A
%   A deve essere una matrice piena, quadrata composta da numeri reali. 
%   La matrice non deve essere singolare.
    
    if issparse(A)
        error('risolve:ANotMatrix',...
                'La matrice A deve essere piena.');
    end
    
    if size(A,1) ~= size(A,2)
        error('risolve:ANotSquare',...
                'Matrice A deve essere quadrata.');
    end
    
    if ~isnumeric(A) || any(find(isinf(A))) || any(find(isnan(A))) || ~isreal(A) || isempty(A)
        error('risolve:AInvalidValue',...
                'A deve essere una matrice di reali e non vuona.');
    end
    
% verifico che A non sia singolare e quindi il sistema ammette un unica
% soluzione in quanto il numero di eq coincide con il numero di variabili
% vedo se la diagonale ha uno zero, test valido per verificare che 
% le matrici diagonali non siano singolari, altrimenti calcolo il
% terminante e vedo se è diverso da 0
%% Da controllare se conviene metterlo qui o nelle funzioni di risoluzione
%  del sistema
%     if (any(find(abs(diag(A)) < eps(norm(A))))==1 || det(A) ~= eps)
%         error('risolve:ASingular','Matrice A singolare.');
%     end
    
%% Controllo sul vettore b
% b deve essere un vettore colonna contenente numeri reali. Il numero
% di righe deve essere pari al numero di righe di A.
    
    if size(b,1) ~= size(A,1) || size(b,2)~=1
        error('risolve:bInvalidDimension',...
                'b deve essere un vettore colonna della stessa dimensione di A.');
    end
    
    if ~isnumeric(b) || any(find(isinf(b))) || any(find(isnan(b))) || ~isreal(b) || isempty(b)
        error('risolve:bInvalidValue',...
                'b deve contenere numeri reali e non deve essere vuota');
    end
    
%% Controllo su opt
% opt deve essere una struttura contenente tre campi booleani: full,
% sup, inf. Se uno è vero, gli altri due devono necessariamente essere
% falsi. L'utente può settare anche un solo parametro della struttura. Gli
% altri vengono settati in automatico.
% Warning :
%       - optTooLong        : La struttura opt contiene più campi di quelli
%       richiesti, quelli in eccesso verranno ignorati.
% Errore :
%       - optInvalid        : opt non è una struttura valida
%       - optValueNotValid  : Un campo di opt contienere un valore non
%                             booleano
%       - optMultipleTrue   : Più campi di opt contengono il valore true

    if ~isstruct(opt) || (~isfield(opt,'sup') && ~isfield(opt,'inf') && ~isfield(opt,'full'))
        error('risolve:optInvalid',...
                'La struttura inserita non è valida.');
    end
    
% controllo se i campi sono settati con valori logici , e se non sono
% settati li metto a false
    if ~isfield(opt,'sup')
        opt.sup = false;
    elseif ~islogical(opt.sup)
        error('risolve:optValueNotValid',...
                'Il campo sup di opt contiene un valore non valido');
    end
    
    if ~isfield(opt,'inf')
        opt.inf = false;
    elseif ~islogical(opt.inf)
        error('risolve:optValueNotValid',...
                'Il campo inf di opt contiene un valore non valido');
    end
    
    if ~isfield(opt,'full')
        opt.full = false;
    elseif ~islogical(opt.full)
        error('risolve:optValueNotValid',...
                'Il campo full di opt contiene un valore non valido');
    end
    
% controllo che un solo campo di opt sia true
    if ((~opt.sup && ~opt.inf && opt.full) || (~opt.sup && opt.inf && ~opt.full) || (opt.sup && ~opt.inf && ~opt.full)) == 0
        error('risolve:optMultipleTrue',...
                'Uno ed un solo campo deve essere true.');
    end
    
    if(length(fieldnames(opt))>3)
        warning('risolve:optTooLong',...
                    'E''stato inserito un campo non necessario nella struttura opt. Verrà ignorato.');
    end

%% Controllo che A sia del tipo specificato in opt
% Nel caso in cui opt sia settato male, viene forzato l'utilizo
% dell'algoritmo che meglio risolve quel sistema lineare.
%
% Warning :
%       - optWarning1 : A è triangolare superiore ma opt.sup~=1
%       - optWarning2 : A è triangolare inferiore ma opt.inf~=1
%       - optWarning3 : A è piena  ma opt.full~=1

% se è tringolare superiore ==> opt.sup=true
    if istriu(A)
        disp('triu');
        if opt.sup == false
           opt.sup = true;
           warning('risolve:optWarning1',...
                    'La matrice A è triangolare superiore, ma opt.sup=false. Verrà forzata la risoluzione mediante l''algoritmo di forward substitution. Si consiglia di visionare la documentazione di risolve.');
        end
        opt.inf = false;
        opt.full = false;
% altrimenti se è tringolare inferiore ==> opt.inf=true
    elseif istril(A)
                disp('tril');

        if opt.inf == false
           opt.int = true;
           warning('risolve:optWarning2',...
                    'La matrice A è triangolare inferiore, ma opt.inf=false. Verrà forzata la risoluzione mediante l''algoritmo di back substitution. Si consiglia di visionare la documentazione di risolve.');
        end
        opt.sup = false;
        opt.full = false;
% altrimenti se è piena ==> opt.full=true
    else 
        if opt.full == false
           opt.full = true;
           warning('risolve:optWarning3',...
                   'La matrice A è piena, ma non opt.full=false. Verrà forzata la risoluzione mediante l''algoritmo di Gauss. Si consiglia di visionare la documentazione di risolve.');

        end
        opt.sup = false;
        opt.inf = false;
    end    
    
end

%% Back Substitution
% Algoritmo per risolvere sistemi con matrice dei coefficienti di tipo 
% triangolare superiore
% Input  :
%           - A : matrice dei coefficienti
%           - b : vettore colonna dei termini noti
% Output :
%           - x : vettore tale che Ax=b
% Errore : 
%           - ASingular, la matrice A è singolare 
function x = backSubstitution(A,b)

% Controllo se A è singolare, se è vero è inutile proseguire
% Essendo A una matrice triangolare basta controllare che A non
% contenga 0 sulla diagonale, ma lavorando nel sistema F.P. . Confrontando
% gli elementi della diagonale con lo zero non otterremmo un programma
% robusto quindi bisogna sostituire il test con ... < eps(norm(A))
   if ( any(find(abs(diag(A)) < eps(norm(A))))==1 )
        error('risolve:ASingular','Matrice A singolare.');
   end
   
% inizializzo le variabili 
    n=size(A,1);
    x = zeros(n,1);

% applico l'algoritmo 
    x(n,1)=b(n)/A(n,n);
    for i=n-1:-1:1
        x(i,1) = (b(i)- A(i,i+1:n)*x(i+1:n,1))/A(i,i);
    end
end

%% Forward Substitution
% Algoritmo per risolvere sistemi con matrice dei coefficienti di tipo 
% triangolare inferiore
% Input  :
%           - A : matrice dei coefficienti
%           - b : vettore colonna dei termini noti
% Output :
%           - x : vettore tale che Ax=b
% Errore : 
%           - ASingular, la matrice A è singolare 
function x = forwardSubstitution(A,b)

% Controllo se A è singolare, se è vero è inutile proseguire
% Essendo A una matrice triangolare basta controllare che A non
% contenga 0 sulla diagonale, ma lavorando nel sistema F.P. . Confrontando
% gli elementi della diagonale con lo zero non otterremmo un programma
% robusto quindi bisogna sostituire il test con ... < eps(norm(A))
   if ( any(find(abs(diag(A)) < eps(norm(A))))==1 )
        error('risolve:ASingular','Matrice A singolare.');
   end

% inizializzo le variabili 
    n = size(A,1);
    x = zeros(n,1);

% applico l'algoritmo 
    x(1,1)=b(1)/A(1,1);
    for i=2:n
        x(i,1) = (b(i)- A(i,1:i-1)*x(1:i-1,1))/A(i,i);
    end
end


%% Gauss Solve
% Algoritmo per risolvere sistemi con matrice dei coefficienti di tipo 
% piena. Prima viene applicato l'algoritmo di Gauss e poi viene utilizzata
% la backSubstitution per trovare la soluzione del sistema
% Input  :
%           - A : matrice dei coefficienti
%           - b : vettore colonna dei termini noti
% Output :
%           - x : vettore tale che Ax=b
% Errore : 
%           - ASingular, la matrice A è singolare 
function x = gaussSolve(A,b)
% Ottengo A e b trasformati mediante l'applicazione dell'algoritmo di Gauss
    [A,b,piv] = gauss(A,b);
    n=size(A,1);
    x=zeros(n,1);
  
% Applico una versione modificata, per via della presenza di piv(i),
% dell'algoritmo della Back Substitution.
    x(n,1)=b(piv(n))/A(piv(n),n); 
    for i=(n-1):-1:1
        x(i,1)=(b(piv(i))-A(piv(i),(i+1):n)*x(i+1:n,1))/A(piv(i),i);
    end
end

%% Gauss
% Algoritmo di Gauss per trasformare una matrice dei coefficienti piena in
% una triangolare, o in particolare trasformarla in nella forma LU, e per
% trasformare il vettore dei termini noti, in modo tale da ottenere un
% sistema equivalente che ci permette di poter risolvere un sistema lineare
% che ha la matrice dei coefficienti piena.
% Input  :
%           - A     : matrice dei coefficienti 
%           - b     : vettore colonna dei termini noti
% Output :
%           - A     : matrice dei coefficienti
%           - b     : vettore colonna dei termini noti
%           - piv   : vettore di pivoting
% Errore : 
%           - ASingular, la matrice A è singolare 
function [A,b,piv] = gauss(A,b)
% visto che useremo spesso la dim di A lo salviamo in una variabile e 
% inizializzo piv
    n = size(A,1);
    piv = 1:n;
    
% confronto con questo e non con zero, perchè siamo in un sistema F.P. e lo
% zero non esiste quindi per rendere il nostro algoritmo più robusto
% facciamo il testo con eps(norm(A))
    zero = eps(norm(A));
    for k=1:n-1
        
% pivoting parziale per evitare divisioni per 0 o per numero molto piccoli
% che farebbero si che l'errore di R.O. aumenterebbe
% Determino il più piccolo r :|A(piv(r),k)|=max|A(piv(i),k|, i>=k
         r = find(abs(A(piv(1:n),k)) == max(abs(A(piv(k:n),k))), 1);

% Controllo se il pivot considerato è maggiore di eps(norm(A)), in caso
% contrario possiamo considerare A come una matrice singolare.
        if abs(A(piv(r),k)) > zero
            % se le righe sono diverse scambio
            if r ~= k
                piv([r k])=piv([k r]); 
            end
            % Applico le trasformazioni sfruttando la natura vettoriale del
            % matlab!
            A(piv(k+1:n),k) = A(piv(k+1:n),k)/A(piv(k),k);
            A(piv(k+1:n),k+1:n)=A(piv(k+1:n),k+1:n)-(A(piv(k+1:n),k)*A(piv(k),k+1:n));
            b(piv(k+1:n)) = b(piv(k+1:n)) - (b(piv(k))* A(piv(k+1:n),k));
        else
            error ('risolve:ASingular','Matrice A singolare. Non è possibile risolvere il sistema')
        end
    end
    
% controllo se l'ultimo elemento della nuova matrice è minore di eps, in
% caso positivo si ha che A è singolare
    if abs(A(piv(n),n)) <= zero 
        error('risolve:ASingular','Matrice A singolare. Non è possibile risolvere il sistema')
    end
    
end

