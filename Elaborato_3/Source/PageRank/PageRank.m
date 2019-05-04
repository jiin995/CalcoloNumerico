function [Rank,OUT,IN] = PageRank(G)
% PageRank - calcola il PageRank secondo l'algoritmo di Google per 
%       l’ordinamento delle pagine web.
%
%   [R OUT IN] = PageRank(G) calcola il rank delle pagine web di cui 
%                G rappresenta la matrice di adiacenza.
%
%   Input :
%       - G : deve essere una matrice quadrata sparsa, costituita da 
%           elementi logical (ogni elemento della matrice deve essere 0 
%           o 1). 
%   Output
%       - R     : vettore dei rank delle pagine ;
%       - OUT   : outdegree delle pagine, link uscenti dalla pagina i ;
%       - IN    : indegree  delle pagine, link che puntano alla pagina i.
    
%% Controllo di validità di G
% G deve essere una matrice quadrata sparsa, contenente elementi di tipo
% logical
    n = size(G,1);
    
    if isempty(G) || ~issparse(G) || size(G,2)~=n
        error('PageRank:GInvalid',...
                'La matrice di adiacenza G deve essere quadrata e sparsa');
    end
    
% Converte gli elementi ~=0 in true e quelli uguali a 0 in false
    if ~islogical(G)
        warning('PageRank:GInvalideElement',...
                'I valori della matrice G saranno considerati come logical.');
        G = logical(G);
    end


%% Inizializzazione e definzione dei parametri standard per l'algoritmo
    TOL = 1e-7;

%% Risolvo problema dei self loop
% Per rimuovere i problemi dei self loop, basta porre a 0 gli elementi
% sulla diagonale principale di G, lo faccio solo se trovo un elemento ~=0
% sulla diagonale sennò sarebbe inutile
    if any(find(abs(diag(G)) ~= 0))
        G = spdiags(zeros(n,1),0,G);
    end
%% dangling node
% risolvo il problema dei dangling node, ponendo come 1/n gli elementi
% delle colonne nulle.
% e: è il vettore colonna di elementi unitari per cui sarà moltiplicato 
% il fattore "correttivo" per i rank-sink
    e=ones(n,1);
% Soluzione iniziale
    Rank=ones(n,1)/n;
    
% Calcola tutti gli Nj per ogni colonna, determinando il vettore 
% degli outdegree
    N = full(sum(G));

% z_j = (1-p)/n se N_j ~= 0, 
%       1/n     se N_j == 0 (dangling nodes)
% metto 0.15 perchè come è fissato 0.85 lo è anche lui, infatti sarebbe
% inutile prevedere un cambio di questi valori in quanto si è visto che essi
% sono i migliori per ottenere un buon calcolo del rank
    z = (0.15)/n *(N~=0) + (N==0)/n;

% Calcolo la matrice diagonale (la memorizzo come un vettore)
% Uso N come se fosse la matrice D, per evitare di fare assegnazioni 
% inutili
    N(N~=0)=1./N(N~=0);

%% Implementazione dell'algoritmo pagerank
    TOLX = checkUnderflowTOLX(TOL,Rank);
    
% L'espressione viene calcolata solo una volta
    pGD = 0.85*G.*N;
    
% inizializzazione per il primo passo iterativo
    err=Inf; NITER=0;
    
% NITER=200 è l'uscita di sicurezza dal ciclo, basterebbero 100 iterazioni
% ma per richiesta impostiamo il criterio di arresto di sicurezza a 200
    while err > TOLX || NITER == 200 
        NITER=NITER+1;
        
% Salvo il valore del Rank al passo precedente per poter calcolare l'errore
        RankOld = Rank; 

%Calcolo del rank 
        Rank=pGD*RankOld+e*z*RankOld;
        
% Errore assoluto
        err = norm(Rank-RankOld,Inf);
        TOLX = checkUnderflowTOLX(TOL,Rank);
    end
    
%Calcolo gli ingree e gli outgree
    IN  = full(sum(G,2));
    OUT = full(sum(G,1))';

end

%% Test Underflow TOLX
%   TOLX =  TOL*norm(x,Inf) non deve essere minore di realmin. Controllo
%   necessario perchè durante le iterazioni TOL quantità già piccola viene
%   moltiplicato per la norma di x, e potrebbe accadere che il valore sia
%   notevolmente piccolo , inferiore a realmin e quindi tolx verrebbe 
%   settato a 0 e l'algoritmo non convergerebbe mai, quindi preveniamo
%   questa situazione effettuando il controllo.

function TOLX = checkUnderflowTOLX(TOL,x)
    TOLX = TOL*norm(x,Inf);
    if TOLX < realmin
        TOLX = realmin;
    end
end
