function [x,niter,resrel] = jacobi(A,b,TOL,MAXITER)
%jacobi - Calcola la soluzione di un sistema lineare Ax = b con A sparsa.
%   Calcola la soluzione di un sistema lineare Ax=b con A sparsa, 
%   utilizzando l'algoritmo iterativo di Jacobi. La soluzione sarà fornita
%   con un certo grado di accuratezzae che dipenderà dagli elementi che 
%   compongono la matrice A ( Deve essere ben condizionata ), 
%   dalla tolleranza richiesta e dal numero massimo di iterazioni che si 
%   vuol far eseguire all'algoritmo a fine di ottenere una soluzione più 
%   accurata. 
%   
%   x = jacobi(A,b): risolve il sistema di equazioni lineari A*x = b. 
%       A ( matrice dei coefficienti ) deve essere una matrice quadrata 
%       sparsa, b ( vettore dei termini noti ) deve essere un 
%       vettore colonna avente lo stesso numero di righe di A.
%       La soluzione è corretta a meno di un errore dovuto agli elementi
%       che compongono la matrice A e di conseguenza al
%       malcondizionamento della matrice A.
%   
%   x = jacobi(A,b,TOL): usa TOL per determinare l'accuratezza della 
%       soluzione. Se non specificato, TOL=1e-6.
%   
%   x = jacobi(A,b,TOL,MAXITER): usa TOL per determinare l' 
%       accuratezza della soluzione e 
%       MAXITER per fissare il numero massimo di iterazioni che 
%       l'algoritmo può compiere idipendentemente dal fatto che abbia 
%       trovato una soluzione accurata o meno. Se non specificati, 
%       TOL=1e-6  e MAXITER=500.
%   
%   [x,niter] = jacobi(___) : restituisce, oltre alla soluzione del sistema
%       lineare, anche il numero di iterazioni eseguite per ottenere la
%       soluzione con il grado di accuratezza richiesto.
%
%   [x,niter,resrel] = jacobi(___) : restituisce, oltre alla soluzione del 
%       sistema lineare e il numero di iterazioni, anche il residuo
%       relativo calcolato come norm(b-A*x)/norm(b).

%% Controllo di validità dei paramentri in input e settaggio di default dei parametri omessi

    n=checkA(A);
    checkB(b,n);
    switch nargin
        case 4
            TOL = checkTol(TOL);       
            checkMAXITER(MAXITER);        
        case 3
            %  MAXITER di default
            MAXITER = 500;
            checkTol(TOL);
        case 2
            % setto TOL e MAXITER di default
            TOL = 1e-6;
            MAXITER = 500;
        otherwise
            error('jacobi:Nargin','Il numero di parametri di input inseriti non è valido.');
    end
    
%% Jacobi

% Inizializzazione    
% sparsa della matrice 1/diag(A)
    x = zeros(n,1);
    DInv = sparse(1:n,1:n,1./diag(A)); 
    
% Matrice di iterazione,anche essa sparsa
    Bj = speye(n,n) - DInv*A;
    
% Controllo sulla validità di TOLX alla prima iterazione del ciclo
    TOLX = checkUnderflowTOLX(TOL,x);
    
    NITER=0; err=Inf;
    
% Inizio con le iterazioni, fino a quando non ho un errore < TOLX e fino a 
% quando non supero il numero massimo di iterazioni 

    while err > TOLX && NITER < MAXITER
        % Salvo il valore della soluzione al passa precedente per poter calcolare l'errore
        xPrecedente = x; 
        
        % Formula scalare
        % x = (b-((A-diag(dA))*x))./dA; 
        
        % Formula matriciale, 
        x = Bj*x + DInv*b;
        
        % Errore assoluto
        err = norm(x-xPrecedente,Inf);
        
        % Aggiorno le informazioni per le prossime iterazioni
        TOLX = checkUnderflowTOLX(TOL,x);
        NITER = NITER + 1;
    end


% La funzione ha raggiunto il numero massimo di iterazioni e quindi non
% sta ancora convergendo alla soluzione con l'accuratezza richiesta in
% questo caso, viene anche calcolatoil residuo relativo

    if  MAXITER == NITER 
        resrel = norm(b-A*x,Inf)/norm(b,Inf);
        warning('jacobi:NonConvergence',...
                    'Il numero di iterazioni effettuate non è sufficiente per raggiungere l''accuratezza desiderata. NITER=%d, RESIDUO RELATIVO=%s',NITER,resrel)
    end
    
 
    if nargout == 2
        niter = NITER;
    end
    
% Il residuo relativo viene calcolato solo se l'utente specifica il
% parametro di output.
    if nargout == 3
        niter = NITER;
        resrel = norm(b-A*x,Inf)/norm(b,Inf); 
    end
end


%% Controllo di validità per A :
%   A deve essere una matrice sparsa, quadrata, composta da numeri reali.
%   A non deve contenere elementi nulli sulla diagonale.
%   Errore :
%           jacobi:ANotSparse;
%           jacobi:ANotSquare;
%           jacobi:AInvalid;
%           jacobi:AZeroOnDiag.

function n = checkA(A)

    n = size(A,1);
    
    if ~issparse(A)
        error('jacobi:ANotSparse','La matrice A non è sparsa.');
    end
    
    if n ~= size(A,2)
        error('jacobi:ANotSquare','La matrice A non è quadrata.');
    end
    
    if ~isnumeric(A) || any(find(isinf(A))) || any(find(isnan(A))) || ~isreal(A) || isempty(A)
        error('jacobi:AInvalid','Uno o più valori di A non sono validi');
    end
    
    if any(find(abs(diag(A)) < eps(norm(A,Inf))))==1
        error('jacobi:AZeroOnDiag',...
                'La matrice A non deve contenere elementi nulli sulla diagonale principale.');
    end
    
end

%% Controllo di validità per b 
%   b deve essere un vettore colonna di dimensione pari a quella della
%   matrice A e deve contenere elementi reali.
%   Errore :
%           jacobi:bInvalidDimension;
%           jacobi:bInvalidValue.

function checkB(col,n)

    if size(col,1) ~= n || size(col,2)~=1
        error('jacobi:bInvalidDimension','Dimensione del vettore errata.');
    end
    
    if ~isnumeric(col) || any(find(isinf(col))) || any(find(isnan(col))) || ~isreal(col) || isempty(col)
        error('jacobi:bInvalidValue',...
                'Uno o più valori inseriti nel vettore colonna non sono validi');
    end
end

%% Controllo di validità per TOL :
%   Tol deve essere un numero positivo e non minore di eps
%   Errore :
%           jacobi:InvalidTOL.
%   Warning :
%           jacobi:TOLminEPS;
%           jacobi:TOLtooHigh.

function TOL = checkTol(TOL)
   
    if ~isscalar(TOL) || ~isnumeric(TOL) || isinf(TOL) || isnan(TOL) || TOL <= 0
        error('jacobi:InvalidTOL','TOL deve essere un numero positivo');
    end

    % Segnalo (eventualmente) che il TOL specificato è troppo piccolo
    if TOL < eps
        TOL = 1e-6;
        warning('jacobi:TOLminEPS',...
                'Valore di TOL inferiore a eps. Verrà usato il valore di default. TOL = 1e-6');
    end
    
    if TOL >= 1
        warning('jacobi:TOLtooHigh',...
                'Valore di TOL molto grande. Il risultato fornito potrebbe essere inaccurato. Si consiglia di leggere la documentazione.');
    end
end

%% Controllo di validità per MAXITER
%   MAXITER deve essere un intero positivo maggiore di 1
%   Warning :
%           jacobi:InvalidMAXITER;
%           jacobi:WarningMinMAXITER;
%           jacobi:WarningMaxMAXITER

function MAXITER = checkMAXITER(MAXITER)
    if ~isscalar(MAXITER) || ~isnumeric(MAXITER) || isinf(MAXITER) || isnan(MAXITER) || MAXITER < 2 || mod(MAXITER,1) > eps
        MAXITER=500;
    	warning('jacobi:InvalidMAXITER',...
                    'Valore del numero di iterazioni non valido deve essere un intero maggiore di 1, verrà impostato quello di default ( 500 ).')
    end
    
    % Segnalo se NMAX è piccolo, precisione non garantita
    if MAXITER < 10
        warning('jacobi:WarningMinMAXITER',...
                    'Il numero di iterazioni specificato è molto piccolo, l''errore di calcolo potrebbe essere elevato');
    end
    
    % Segnalo se NMAX è grande, tempo richiesto elevato
    if MAXITER > 10000
    	warning('jacobi:WarningMaxMAXITER',...
                    'Il numero di iterazioni specificato è molto alto, l''esecuzione potrebbe essere più lenta');
    end
    
end

%% Test Underflow TOLX
%   TOLX =  TOL*norm(x,Inf) non deve essere minore di realmin. Controllo
%   necessario perchè durante le iterazioni TOL quantità già piccola viene
%   moltiplicato per la norma di x, e potrebbe accadere che il valore sia
%   notevolmente piccolo , inferiore a realmin e quindi tolx verrebbe 
%   settato a 0 e l'algoritmo non convergerebbe mai, quindi preveniamo
%   questa situazione effettuando il controllo.
function TOLX = checkUnderflowTOLX(TOL,x)
    TOLX = TOL*norm(x,inf);
    if TOLX < realmin
        TOLX = realmin;
    end
end
