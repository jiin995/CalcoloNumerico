function [ x, output, graf ]=bisectionAlgorithm(f,x0,TOL,NMAX)
%bisectionAlgorithm : 
%    Calcola lo zero di una funzione in un dato intervallo utilizzando
%    l'algoritmo della bisezione. Si può scegliere il numero massimo di
%    iterazioni che può eseguire e la precisione del risultato
%
%   x = bisectionAlgorithm(f,x0) cerca di trovare un punto x in cui 
%       f(x)=0 a meno di TOLF, all'interno dell'intervallo specificato
%       da x0. La soluzione si trova nel punto in cui f(x) cambia segno: 
%       gli estremi dell'intervallo devono essere necessariamente 
%       discordi.
%   
%   x = bisectionAlgorithm(f,x0,TOL) usa TOL per determinare
%       l'accuratezza della soluzione. Se non specificato, TOL=eps.
% 
%   x = bisectionAlgorithm(f,x0,TOL,NMAX) usa TOL per determinare 
%       l'accuratezza della soluzione e NMAX per individuare il numero 
%       massimo di iterazioni che l'algoritmo può compiere. Se non 
%       specificati, TOL=eps, NMAX=500.
% 
%   [x, output] = bisectionAlgorithm(___) restituisce, oltre alla 
%       soluzione, una struttura output che contiene due campi: fx con
%       il valore della funzione in x, niter con il numero di iterazioni
%       eseguite  dall'algoritmo per individuare la soluzione con quel 
%       grado di accuratezza.

%   [x, output, graf] = bisectionAlgorithm(___) restituisce anche una 
%       variabile di tipo string, che indica l'avvenuto plotting del 
%       grafico funzione e dello zero trovato.
%        

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
            'Il parametro f deve essere un handle di funzione e non %s.',class(f));
    end

%% Test x0 :
%   deve essere un intervallo da cui si parte con la prima iterazione.
%   Valuto prima la lunghezza dell'array, deve essere precisamente uguale 
%   a 2.
%   Se quest' ultima condizione è verificata, valuto la validità
%   dell'intervallo, ovvero che non contenga inf e NaN.
%   Errore :
%           bisectionAlgorithm:MalformedX0

    if length(x0) ~= 2 || ~isnumeric(x0) || any(find(isinf(x0))) || any(find(isnan(x0))) || x0(1) == x0(2) 
        error('bisectionAlgorithm:MalformedX0',...
                'Il parametro x0 deve essere un array contenente gli estremi dell''intervallo di partenza finito e non nullo.');
    end
    
%% Test di esistenza degli zeri :
%   controllo che la funzione assumi valori discordi o nulli
%   agli estremi, in caso contrario è inutile proseguire con l'elaborazione
%   in quanto non esisterebbero zeri nell'intervallo dato in input.
%   Errore :
%           bisectionAlgorithm:NoZero

    if f(x0(1))*f(x0(2)) > 0
        error('bisectionAlgorithm:NoZero',...
                'La funzione deve assumere valori discordi agli estremi dell''intervallo x0 oppure uno di essi deve annullare la funzione.'); 
    end

%% Test sui parametri opzionali :
%   Nel caso NMAX e TOL siano passati in input ne controlliamo la validità
%   rispetto le specifiche definite 

    switch nargin
        case 2
            NMAX = 500 ;
            TOL  = eps ;
        case 3
            NMAX = 500 ;
            Control_TOL(TOL) ;
        case 4
            Control_NMAX(NMAX) ;
            Control_TOL(TOL) ;
    end
    
   %disp("TOL  : "+ TOL)
   %disp("NMAX : "+ NMAX)
    
%% Controllo se la funzione assume gli zeri agli estremi
%   Controllo se la funzione assume uno zero in uno degli estremi o entrambi
%   nel caso di entrambi x è un array di due elementi contenente gli estremi
%   dell'intervallo

    output.niter = 0;

    %extreme mi indica se ho trovato uno zero all'estremo dell'intervallo 
    % così da evitare di eseguire l'algoritmo di bisezione
    % posso controllare dopo il numero di parametro di uscita
    % senza dover gestire casi particolari
    extreme = 0;
    
    if abs(f(x0(1))) < eps &&  abs(f(x0(2))) < eps
        warning('bisectionAlgorithm:MultipleZero',...
                    'La funzione assume due zeri situati agli estremi dell''intervallo. x sarà un array di due elementi.')
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
%   Le condizioni di terminazione del ciclo sono:
%   - |b-a|/max(a,b) < TOL. Moltiplico per il max per evitare una eventuale
%       divisione per 0. 
%   - |f(c)| < TOLF, dove TOLF = eps ;
%   - n° iterazioni > NMAX ;

% controllo se non ho trovato già uno zero nell'estremo
    if ~extreme
        
        % imposto gli estremi e trovo il primo punto di mezzo
        a = x0(1) ; b = x0(2);
        c = (a+b)/2;
        
        TOLF = eps;

        % controllare criterio di arresto 
        % dubbio abs(f(c)) >= 0  oppure abs(f(c)) >= eps
        % dobbiamo mettere eps(0) o 0?
        while ( abs(b-a) >= TOL*max(abs(a),abs(b)) && abs(f(c)) >= TOLF && output.niter <= NMAX )
            c = (a+b)/2;
            output.niter = output.niter + 1;

            if f(a) * f(c) < 0
                b = c;
            elseif f(b) * f(c) < 0
                a = c;
            end
        end
        % end while

        x = c;
    end
        
    % controllo se devo generare warning sul numero di iterazioni
    if  output.niter == 0 && ~extreme
        warning('bisectionAlgorithm:NoIterations',...
                'L''algoritmo non ha eseguito alcuna iterazione. Il valore ottenuto è poco accurato, si consiglia di aumentare il valore del parametro TOL. Visualizza la documentazione per ulteriori dettagli.');
    elseif output.niter == NMAX
        warning('L''algoritmo è terminato a causa del raggiungimento del numero massimo di iterazioni. E'' possibile che non sia stata raggiunta l''accuratezza desiderata.');
    end
    

%% Controllo di nargout :
%   solo se richiesto calcolo fx e il grafico

    switch nargout
        case 2
            output.fx = f(x);
        case 3
            output.fx = f(x);
            graf = genGraf(f,x0,c);   
    end

% end bisectionAlgorithm
end 

%% Controllo di validità di TOL :
%   Tol deve essere un numero positivo e non minore di eps

function TOL = Control_TOL (TOL)
    
    if ~isnumeric(TOL) || ~isscalar(TOL) || isnan(TOL) || isinf(TOL) || TOL <=0
        error('bisectionAlgorithm:InvalidTOL',...
                'Valore di tolleranza non valido deve essere un numero positivo.')
    end
    
    if TOL < eps
        warning('bisectionAlgorithm:TOLminEps',...
                    'Valore di tolleranza inferiore a eps, verrà usato eps')
        TOL = eps ;
    end
    

end

%% Controllo di validità di NMAX :
%   NMAX deve essere un numero maggiore di 2

function NMAX = Control_NMAX (NMAX)

    if ~isnumeric(NMAX) || ~isscalar(NMAX) || isnan(NMAX) || isinf(NMAX) || NMAX <2
        NMAX = 500 ;
        warning('bisectionAlgorithm:InvalidNMAX',...
                'Valore del numero di iterazioni non valido deve essere un intero maggiore di 1, verrà impostato quello di default ( 500 ).')
    end
    
    % NMAX è piccolo precisione non garantita
    if NMAX < 10
        warning('bisectionAlgorithm:WarningMinNMAX','Il numero di iterazioni specificato è molto piccolo, l''errore di calcolo potrebbe essere elevato');
    end
    
    % NMAX è grande limite di tempo non garantito
    if NMAX > 1000
    	warning('bisectionAlgorithm:WarningMaxNMAX','Il numero di iterazioni specificato è molto alto, l''esecuzione potrebbe essere più lenta');
    end    
end

%% Generazione del grafico :
%
function graf = genGraf(f,x,c)
% da implementare
    asc = linspace(x(1),x(2));
    plot(asc,f(asc),c,f(c),'*','LineWidth',2,'MarkerSize',10);
    grid on;
    title('Funzione f nell''intervallo x0');
    xlabel('x');
    ylabel('y');
    graf='Plotted';

end
