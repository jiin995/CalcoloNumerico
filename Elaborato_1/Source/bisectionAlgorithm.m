function [ x, output ]=bisectionAlgorithm(f,x0,TOL,NMAX,graf)
%bisectionAlgorithm Calcola lo zero di una funzione.
%   Calcola lo zero di una funzione in un dato intervallo utilizzando
%   l'algoritmo di bisezione. Si pu� scegliere il numero massimo di
%   iterazioni che pu� eseguire e la precisione del risultato.
%
%   x = bisectionAlgorithm(f,x0) cerca di trovare un punto x in cui 
%       f(x)=0 a meno di TOLF ( eps) , all'interno dell'intervallo 
%       specificato da x0. La soluzione si trova nel punto in cui f(x)
%       cambia segno:  gli estremi dell'intervallo devono essere  
%       necessariamente discordi.
%   
%   x = bisectionAlgorithm(f,x0,TOL) usa TOL per determinare
%       l'accuratezza della soluzione. Se non specificato, TOL=eps.
% 
%   x = bisectionAlgorithm(f,x0,TOL,NMAX) usa TOL per determinare 
%       l'accuratezza della soluzione e NMAX per individuare il numero 
%       massimo di iterazioni che l'algoritmo pu� compiere. Se non 
%       specificati, TOL=eps, NMAX=500.
%
%   x = bisectionAlgorithm(f,x0,TOL,NMAX,graf) restituisce anche una 
%       finestra con il grafico funzione e evidenzia lo zero trovato.
%        
%   [x, output] = bisectionAlgorithm(___) restituisce, oltre alla 
%       soluzione, una struttura output che contiene due campi: fx con
%       il valore assunto dall funzione in x, niter con il numero di 
%       iterazioni eseguite  dall'algoritmo per individuare la soluzione 
%       con quel grado di accuratezza.


%% Limitazioni
%   Si assume che la funzione f sia continua e limitata nell'intervallo di
%   partenza e deve assumere valori discordi negli estremi, questo assicura
%   che ci sia il passaggio per lo zero

%% Test sui parametri di input

%% Test f : 
%   deve essere un handle di funzione
%   Errore : 
%           bisectionAlgorithm:NoFunction

    if ~isa(f,'function_handle')
        error('bisectionAlgorithm:NoFunction',...
            'Il parametro f deve essere un handle di funzione e non %s.',class(f))
    end

%% Test x0 :
%   deve essere un intervallo da cui si parte con la prima iterazione.
%   Valuto prima la lunghezza dell'array, deve essere precisamente uguale 
%   a 2.
%   Se quest' ultima condizione � verificata, valuto la validit�
%   dell'intervallo, ovvero che non contenga inf e NaN.
%   Errore :
%           bisectionAlgorithm:MalformedX0

    if length(x0) ~= 2 || ~isnumeric(x0) || any(find(isinf(x0))) || any(find(isnan(x0))) || x0(1) == x0(2) 
        error('bisectionAlgorithm:MalformedX0',...
                'Il parametro x0 deve essere un array contenente gli estremi dell''intervallo di partenza finito e non nullo.')
    end
    
%% Test di esistenza degli zeri :
%   controllo che la funzione assumi valori discordi o nulli
%   agli estremi, in caso contrario � inutile proseguire con l'elaborazione
%   in quanto non esisterebbero zeri nell'intervallo dato in input.
%   Errore :
%           bisectionAlgorithm:NoZero

    if f(x0(1))*f(x0(2)) > 0
        error('bisectionAlgorithm:NoZero',...
                'La funzione deve assumere valori discordi agli estremi dell''intervallo x0 oppure uno di essi deve annullare la funzione.')
    end

%% Test sui parametri opzionali :
%   Nel caso NMAX e TOL siano passati in input ne controlliamo la validit�
%   rispetto le specifiche definite 

    switch nargin
        case 2
            NMAX = 500 ;
            TOL  = eps ;
        case 3
            NMAX = 500 ;
            controlTOL(TOL) ;
        case 4
            ontrolNMAX(NMAX) ;
            controlTOL(TOL) ;
        case 5 
            ontrolNMAX(NMAX) ;
            controlTOL(TOL) ;
            if ~ischar(graf)
                error('bisectionAlgorithm:bagGraf',...
                        'Il parametro graf deve essere un char e non un %s',class(graf))
            end
    end
    
    
%% Controllo se la funzione assume gli zeri agli estremi
%   Controllo se la funzione assume uno zero in uno degli estremi o 
%   entrambi nel caso di entrambi x � un array di due elementi contenente 
%   gli estremi dell'intervallo.

    output.niter = 0;

    % extreme mi indica se ho trovato uno zero all'estremo dell'intervallo 
    % cos� da evitare di eseguire l'algoritmo di bisezione e 
    % posso controllare dopo il numero di parametro di ingressi per
    % generare opportunamente il grafico senza dover gestire casi 
    % particolari ( se facevo un return prima non potevo generare 
    % il grafico e dovevo generarlo prima del return ).
    extreme = 0;
    
    if abs(f(x0(1))) < eps &&  abs(f(x0(2))) < eps
        warning('bisectionAlgorithm:MultipleZero',...
                    'La funzione assume due zeri situati agli estremi dell''intervallo. x sar� un array di due elementi.')
        x = x0;
        extreme = 1;
    elseif abs(f(x0(1))) < eps
        x = x0(1);
        extreme = 1;
    elseif abs(f(x0(2))) < eps
        x = x0(2);
        extreme = 1;
    end
    
%% Algoritmo di bisezione
%   Se non ho gi� individuato lo zero negli estremi, uso l'algoritmo di
%   bisezione per trovare lo zero.


% controllo se non ho trovato gi� uno zero nell'estremo
    if ~extreme
        
        % imposto gli estremi e trovo il primo punto di mezzo
        a = x0(1) ; b = x0(2);
        c = (a+b)/2;

% TOLF=eps sempre allora possa rimuovere questa variabile inutile
%        TOLF = eps;

%   Le condizioni di terminazione del ciclo sono:
%   - |b-a|/max(a,b) < TOL. Moltiplico per il max per evitare una eventuale
%      divisione per 0. 
%   - |f(c)| < TOLF, dove TOLF = eps ;
%   - n� iterazioni > NMAX ;
        
        while ( abs(b-a) >= TOL*max(abs(a),abs(b)) && abs(f(c)) >= eps && output.niter <= NMAX )
            c = (a+b)/2;
            output.niter = output.niter + 1;

            if f(a) * f(c) < 0
                b = c;
            elseif f(b) * f(c) < 0
                a = c;
            end
        end % end while

        x = c;
    end %end if
    
    % controllo se devo generare warning sul numero di iterazioni
    if  output.niter == 0 && ~extreme
        warning('bisectionAlgorithm:NoIterations',...
                    'L''algoritmo non ha eseguito alcuna iterazione. Il valore ottenuto � poco accurato, si consiglia di aumentare il valore del parametro TOL. Visualizza la documentazione per ulteriori dettagli.')
    elseif output.niter == NMAX
        warning('bisectionAlgorithm:MaxIterations',...
                    'L''algoritmo � terminato a causa del raggiungimento del numero massimo di iterazioni. E'' possibile che non sia stata raggiunta l''accuratezza desiderata.')
    end
    

%% Controllo di nargout :
%   solo se richiesto calcolo fx e genero il grafico

    if nargout == 2
        output.fx = f(x);
    end
    
    if nargin==5 && ischar(graf)
        genGraf(f,x0,c);  
    end
% end bisectionAlgorithm
end 

%% Controllo di validit� di TOL :
%   Tol deve essere un numero positivo e non minore di eps
%   Errore :
%           bisectionAlgorithm:InvalidTOL

function TOL = controlTOL (TOL)
    
    if ~isnumeric(TOL) || ~isscalar(TOL) || isnan(TOL) || isinf(TOL) || TOL <=0
        error('bisectionAlgorithm:InvalidTOL',...
                'Valore di tolleranza non valido deve essere un numero positivo.')
    end
    
    if TOL < eps
        warning('bisectionAlgorithm:TOLminEps',...
                    'Valore di tolleranza inferiore a eps, verr� usato eps')
        TOL = eps ;
    end
    

end

%% Controllo di validit� di NMAX :
%   NMAX deve essere un numero maggiore di 2

function NMAX = ontrolNMAX (NMAX)

    if ~isnumeric(NMAX) || ~isscalar(NMAX) || isnan(NMAX) || isinf(NMAX) || NMAX <2
        NMAX = 500 ;
        warning('bisectionAlgorithm:InvalidNMAX',...
                    'Valore del numero di iterazioni non valido deve essere un intero maggiore di 1, verr� impostato quello di default ( 500 ).')
    end
    
    % NMAX � piccolo precisione non garantita
    if NMAX < 10
        warning('bisectionAlgorithm:WarningMinNMAX',...
                    'Il numero di iterazioni specificato � molto piccolo, l''errore di calcolo potrebbe essere elevato')
    end
    
    % NMAX � grande limite di tempo non garantito
    if NMAX > 1000
    	warning('bisectionAlgorithm:WarningMaxNMAX',...
                    'Il numero di iterazioni specificato � molto alto, l''esecuzione potrebbe essere pi� lenta')
    end    
end

%% Generazione del grafico :
%
function genGraf(f,x,c)
    % Creo i punti dell'asse delle ascisse
    asc = linspace(x(1),x(2));
    % Plotto la funzione evidenziando lo zero
    plot(asc,f(asc),c,f(c),'*','LineWidth',2,'MarkerSize',10);
    % abilito la griglia e metto i titoli
    grid on;
    title('Funzione f nell''intervallo x0');
    xlabel('x');
    ylabel('y');
end