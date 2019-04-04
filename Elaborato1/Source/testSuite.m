%% Main function to generate tests
% Lanciare la simulazione con l'istruzione:
% results = runtests('test_suite.m');

function tests = test_suite
    tests = functiontests(localfunctions);
end

function setup(testCase)  % do not change function name
% set a new path, for example
    setGlobalParameter(@(x)(x.^2-2),[0,4]);
end

%% Function to access global parameter
function setGlobalParameter(f,r)
    global x; global y;
    x = f;
    y = r;
end

function [f,x0] = getGlobalParameter
    global x; global y;
    f = x;
    x0 = y;
end

%% Test Functions

function testFunctionCase1(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func              -> valido
%   - x0                -> valido
%   - TOL               -> empty
%   - NMAX              -> empty
%   - ip. teorema       -> verificate
%   - output parameter  -> 1

% Test specific code
    [f,x0] = getGlobalParameter;
    
    actSolution= bisectionAlgorithm(f,x0);
    expSolution= fzero(f,x0);
    
    abs_error= abs(actSolution-expSolution);
    if abs_error<= eps*max(actSolution,expSolution)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase2(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func              -> valido
%   - x0                -> valido
%   - TOL               -> empty
%   - NMAX              -> empty
%   - ip. teorema       -> verificate
%   - output parameter  -> 2

% Test specific code
    [f,x0] = getGlobalParameter;
    
    [~,out]= bisectionAlgorithm(f,x0);
    
    if isstruct(out)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase3(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func              -> valido
%   - x0                -> valido
%   - TOL               -> empty
%   - NMAX              -> empty
%   - ip. teorema       -> verificate
%   - output parameter  -> 2

% Test specific code
    [f,x0] = getGlobalParameter;
    
    [~,~]= bisectionAlgorithm(f,x0,1e-10,400,'g');

    figure2handle = findall(0,'Tag','figure1');

    if isempty(figure2handle)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase4(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> NON valido
%   - x0 -> valido
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [~,range] = getGlobalParameter;
    fun=[];
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:NoFunction')
end

function testFunctionCase5(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> INTERVALLO VUOTO
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,~] = getGlobalParameter;
    range=[];
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:MalformedX0')
end

function testFunctionCase6(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> INTERVALLO DI LUNGHEZZA SBAGLIATA
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,~] = getGlobalParameter;
    range = 1;
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:MalformedX0')
end

function testFunctionCase7(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> INTERVALLO NON NUMERICO
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,~] = getGlobalParameter;
    range = [1 'A'];
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:MalformedX0')
end

function testFunctionCase8(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> TOL < eps
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = 1*10^-18;
    testCase.verifyWarning(@()bisectionAlgorithm(fun,range,TOL),'bisectionAlgorithm:TOLminEps')
end

function testFunctionCase9(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> TOL > eps
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = 10^-6;
    actSolution= bisectionAlgorithm(fun,range,TOL);
    expSolution= fzero(fun,range);
    
    abs_error= abs(actSolution-expSolution);
    if abs_error<= TOL*max(actSolution,expSolution)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase10(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> TOL < 0
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = - eps;
    testCase.verifyError(@()bisectionAlgorithm(fun,range,TOL),'bisectionAlgorithm:InvalidTOL')
end

function testFunctionCase11(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> TOL not numeric
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = 'a';
    testCase.verifyError(@()bisectionAlgorithm(fun,range,TOL),'bisectionAlgorithm:InvalidTOL')
end

function testFunctionCase12(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> not numeric
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = 'a';
    testCase.verifyWarning(@()bisectionAlgorithm(fun,range,TOL,NMAX),'bisectionAlgorithm:InvalidNMAX')
end

function testFunctionCase13(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> NMAX < 0
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = -100;
    testCase.verifyWarning(@()bisectionAlgorithm(fun,range,TOL,NMAX),'bisectionAlgorithm:InvalidNMAX')
end

function testFunctionCase14(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> 0 < NMAX < 10
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = 5;
    testCase.verifyWarning(@()bisectionAlgorithm(fun,range,TOL,NMAX),'bisectionAlgorithm:WarningMinNMAX')
end

function testFunctionCase15(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> NMAX > 500
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = 750;
    
    actSolution= bisectionAlgorithm(fun,range,TOL,NMAX);
    expSolution= fzero(fun,range);
    
    abs_error= abs(actSolution-expSolution);
    if abs_error<= eps*max(actSolution,expSolution)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase16(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> NMAX > 1000
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = 1500;
    testCase.verifyWarning(@()bisectionAlgorithm(fun,range,TOL,NMAX),'bisectionAlgorithm:WarningMaxNMAX')
end

function testFunctionCase17(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> valido
%   - NMAX -> 0 < NMAX < 500
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    
    [fun,range] = getGlobalParameter;
    TOL = eps;
    NMAX = 250;
    
    actSolution= bisectionAlgorithm(fun,range,TOL,NMAX);
    expSolution= fzero(fun,range);
    
    abs_error= abs(actSolution-expSolution);
    if abs_error<= eps*max(actSolution,expSolution)
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

function testFunctionCase18(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> NON verificate
%   - output parameter -> 1

% Test specific code
    [fun,~] = getGlobalParameter;
    range= [-4,4];
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:NoZero')
end

function testFunctionCase19(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> OUT > 3

% Test specific code

%    Questo test non è stato implementato poichè Matlab controlla in automatico
%    il numero di parametri di output richiesti e restituisce error in caso
%    di incongruenza con quelli previsti.     
end

function testFunctionCase20(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> valido
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate, lo zero è un estremo di x0
%   - output parameter -> 1

% Test specific code
    
    fun = @(x)(x.^2 - 1);
    range = [0 1];
    
    [~,fx]= bisectionAlgorithm(fun,range);
    
    verifyEqual(testCase,fx.niter,0);
end

function testFunctionCase21(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> è un punto
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate, lo zero è il punto passato
%   - output parameter -> 1

% Test specific code
    
    [fun,~] = getGlobalParameter;
    range = [1 1];
    
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:MalformedX0')
end

function testFunctionCase22(testCase)
% Configurazione parametri bisectionAlgorithm
%   - func -> valido
%   - x0 -> non limitato
%   - TOL -> empty
%   - NMAX -> empty
%   - ip. teorema -> verificate
%   - output parameter -> 1

% Test specific code
    [fun,~] = getGlobalParameter;
    range=[0 Inf];
    testCase.verifyError(@()bisectionAlgorithm(fun,range),'bisectionAlgorithm:MalformedX0')
end

