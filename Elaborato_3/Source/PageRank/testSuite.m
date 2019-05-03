%% Main function to generate tests
% Lanciare la simulazione con l'istruzione:
% results = runtests('testSuite.m');
function tests = testSuite
    tests = functiontests(localfunctions);
end

%% Test Functions
function testFunctionCase1(testCase)
% Configurazione parametri pageRank
%   - G ->  vuota

% Test specific code
    G = [];
    testCase.verifyError(@()PageRank(G),'PageRank:GInvalid')
end

function testFunctionCase2(testCase)
% Configurazione parametri pageRank
%   - G ->  non sparsa

% Test specific code
    G = rand(10,10);
    testCase.verifyError(@()PageRank(G),'PageRank:GInvalid')
end

function testFunctionCase3(testCase)
% Configurazione parametri pageRank
%   - G ->  non quadrata

% Test specific code
    G = rand(10,15);
    testCase.verifyError(@()PageRank(G),'PageRank:GInvalid')
end

function testFunctionCase4(testCase)
% Configurazione parametri pageRank
%   - G ->  not logical

% Test specific code
    G = round(sprand(10,10,0.2)*10);
    testCase.verifyWarning(@()PageRank(G),'PageRank:GInvalideElement')  
end

function testFunctionCase5(testCase)
% Configurazione parametri pageRank
%   - G ->  cantains INF

% Test specific code
    G = round(sprand(10,10,0.2)*10);
    G(1,1)=Inf;
    testCase.verifyWarning(@()PageRank(G),'PageRank:GInvalideElement')  
end

function testFunctionCase6(testCase)
% Configurazione parametri pageRank
%   - G ->  cantains NaN

% Test specific code
    G = round(sprand(10,10,0.2)*10);
    G(1,1)=NaN;
    testCase.verifyError(@()PageRank(G),'MATLAB:nologicalnan')  
end


function testFunctionCase7(testCase)
% Configurazione parametri pageRank
%   - G ->  valido
% Verifico che i self loop non influenzano l'esecuzione dell'algoritmo
    
    GLoop = round(sprand(10,10,0.2)*10) + spdiags(ones(10,1),0,10,10);
    G = GLoop - spdiags(GLoop,0,10,10);

    RLoop = PageRank(GLoop);
    R = PageRank(G);
    
    if abs(RLoop-R)<eps
        % passed
        verifyReturnsTrue(testCase,@true);
    else
        % not passed
        verifyReturnsTrue(testCase,@false);
    end
end

