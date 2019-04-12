function x = risolve(A, b, opt)
% risolve - Calcola la soluzione di un sistema lineare Ax = b.
%   x = risolve(A,b,opt) risolve il sistema di equazioni lineari A*x = b.
%   I parametri di inuput sono tutti obbligatori
%   A: Matrice dei coefficienti, deve essere una matrice quadrata piena.
%   b: vettore dei terminini noti deve essere un vettore colonna avente lo 
%   stesso numero di righe di A.
%   opt: tipo di matrice che individua l'algoritmo da utilizzare per 
%   risolvere il sistema, deve essere una struttura contenente almeno uno 
%   dei seguenti campi booleani:
%       - full : true se la matrice A � piena, false altrimenti.Il sistema
%                viene risolto utilizzando GAUSS con pivotig virtuale ;
%       - sup  : true se la matrice � triangolare superiore, false
%                altrimenti.Il sistema viene risolto utilizzando 
%                l'algoritmo di forward substitution ;
%       - inf  : true se la matrice � triangolare inferiore, false
%                altrimenti.Il sistema viene risolto utilizzando 
%                l'algoritmo di forward substitution ;
%   di questi campi, uno ed uno solo deve assumere volore true.
%   La soluzione calcolata � corretta a meno di un errore dovuto al
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
    else % opt.full == true
        x = gauss(A,b);
    end

end



%% definizione e implementazione di  CheckInput
function opt = checkInput(A,b,opt)
% Controlla che i parametri in input siano validi e ritorna opt che
% contiene un solo campo uguale a true.

%% Controllo sulla matrice A
%   A deve essere una matrice piena, quadrata composta da numeri reali. 
%   La matrice non deve essere singolare.
    
    if issparse(A)
        error('risolve:ANotFull',...
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
    if any(find(abs(diag(A)) < eps(norm(A))))==1
        error('risolve:ASingular','Matrice A singolare.');
    end
    
%% Controllo sul vettore b
% b deve essere un vettore colonna contenente numeri reali. Il numero
% di righe deve essere pari al numero di righe di A.
    
    if size(b,1) ~= size(A,1) || size(b,2)~=1
        error('risolve:bDimension',...
                'b deve essere un vettore colonna.');
    end
    
    if ~isnumeric(b) || any(find(isinf(b))) || any(find(isnan(b))) || ~isreal(b) || isempty(b)
        error('risolve:bInvalidValue',...
                'b deve contenere numeri reali e non deve essere vuota');
    end
    
%% Controllo su opt
% opt deve essere una struttura contenente tre campi booleani: full,
% sup, inf. Se uno � vero, gli altri due devono necessariamente essere
% falsi. L'utente pu� settare anche un solo parametro della struttura. Gli
% altri vengono settati in automatico.
    
    if ~isstruct(opt) || (~isfield(opt,'sup') && ~isfield(opt,'inf') && ~isfield(opt,'full'))
        error('risolve:optInvalid',...
                'La struttura inserita non � valida.');
    end
    
% controllo se i campi sono settati con valori logici , e se non sono
% settati li metto a false
    if ~isfield(opt,'sup')
        opt.sup = false;
    elseif ~islogical(opt.sup)
        error('risolve:optFieldNotValid',...
                'Il campo sup di opt contiene un valore non valido');
    end
    
    if ~isfield(opt,'inf')
        opt.inf = false;
    elseif ~islogical(opt.inf)
        error('risolve:optFieldNotValid',...
                'Il campo inf di opt contiene un valore non valido');
    end
    
    if ~isfield(opt,'full')
        opt.full = false;
    elseif ~islogical(opt.full)
        error('risolve:optFieldNotValid',...
                'Il campo full di opt contiene un valore non valido');
    end
    
% controllo che un solo campo di opt sia true
    if ((~opt.sup && ~opt.inf && opt.full) || (~opt.sup && opt.inf && ~opt.full) || (opt.sup && ~opt.inf && ~opt.full)) == 0
        error('risolve:optValueNotValid',...
                'Uno ed un solo campo deve essere true.');
    end
    
    if(length(fieldnames(opt))>3)
        warning('risolve:optTooLong',...
                    'E''stato inserito un campo non necessario nella struttura opt. Verr� ignorato.');
    end

%% Controllo che A sia del tipo specificato in opt
% Nel caso in cui opt sia settato male, viene forzato l'utilizo
% dell'algoritmo che meglio risolve quel sistema lineare.
%
% Warning :
%       - optWarning1 : A � triangolare superiore ma opt.sup~=1
%       - optWarning2 : A � triangolare inferiore ma opt.inf~=1
%       - optWarning3 : A � piena  ma opt.full~=1


% se � tringolare superiore ==> opt.sup=true
    if istriu(A)
        if opt.sup == false
            opt.sup = true;
            warning('risolve:optWarning1',...
                    'La matrice A � triangolare superiore, ma opt.sup=false. Verr� forzata la risoluzione mediante l''algoritmo di forward substitution.');
        end
        opt.inf = false;
        opt.full = false;
% altrimenti se � tringolare inferiore ==> opt.inf=true
    elseif istril(A)
        if opt.inf == false
            opt.int = true;
            warning('risolve:optWarning2',...
                    'La matrice A � triangolare inferiore, ma opt.inf=false. Verr� forzata la risoluzione mediante l''algoritmo di back substitution.');
        end
        opt.sup = false;
        opt.full = false;
% altrimenti se � piena ==> opt.full=true
    else
        if opt.full == false
            opt.full = true;
            warning('risolve:optWarning3',...
                   'La matrice A � piena, ma non opt.full=false. Verr� forzata la risoluzione mediante l''algoritmo di Gauss.');

        end
        opt.sup = false;
        opt.inf = false;
    end    
    
end

function x = backSubstitution(A,b)
% inizializzo le variabili 
    n=size(A,1);
    x = zeros(n,1);

% applico l'algoritmo 
    x(n,1)=b(n)/A(n,n);
    for i=n-1:-1:1
        x(i,1) = (b(i)- A(i,i+1:n)*x(i+1:n,1))/A(i,i);
    end
end

function x = forwardSubstitution(A,b)
% inizializzo le variabili 
    n = size(A,1);
    x = zeros(n,1);

% applico l'algoritmo 
    x(1,1)=b(1)/A(1,1);
    for i=2:n
        x(i,1) = (b(i)- A(i,1:i-1)*x(1:i-1,1))/A(i,i);
    end
end

function x = gauss(A,b)
    x=0;
end

