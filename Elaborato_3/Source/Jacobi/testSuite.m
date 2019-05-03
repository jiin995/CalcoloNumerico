%% Main function to generate tests
% Lanciare la simulazione con l'istruzione:
% results = runtests('testSuite.m');
function tests = test_suite
    tests = functiontests(localfunctions);
end

%% Test Functions

function testFunctionCase1(testCase)
% Configurazione parametri jacobi
%   - A         -> non quadrata
%   - b         -> valido
%   - TOL       -> indifferente
%   - MAXITER   -> indifferente

% Test specific code
    A = sprand(10,15,0.1);
    x= ones(15,1);
    b = A*x;
    
    testCase.verifyError(@()jacobi(A,b),'jacobi:ANotSquare')
end

function testFunctionCase2(testCase)
% Configurazione parametri jacobi
%   - A         -> zero sulla diagonale
%   - b         -> valido
%   - TOL       -> indifferente
%   - MAXITER   -> indifferente

% Test specific code
    A = sprand(15,15,0.1);
    A(1,1) = 0;
    x= ones(15,1);
    b = A*x;
    
    testCase.verifyError(@()jacobi(A,b),'jacobi:AZeroOnDiag')
end

function testFunctionCase3(testCase)
% Configurazione parametri jacobi
%   - A         -> non sparsa
%   - b         -> valido
%   - TOL       -> indifferente
%   - MAXITER   -> indifferente

% Test specific code
    A = rand(15);
    x= ones(15,1);
    b = A*x;
    
    testCase.verifyError(@()jacobi(A,b),'jacobi:ANotSparse')
end

function testFunctionCase4(testCase)
% Configurazione parametri jacobi
%   - A         ->  valida
%   - b         ->  valido
%   - TOL       -> TOL > 1
%   - MAXITER   -> indifferente

% Test specific code
    A = sprand(10,10,0.1) + speye(10,10);
    x= ones(10,1);
    b = A*x;
    TOL = 10;
    testCase.verifyWarning(@()jacobi(A,b,TOL),'jacobi:TOLtooHigh')
end

function testFunctionCase5(testCase)
% Configurazione parametri jacobi
%   - A         -> valida
%   - b         -> valido
%   - TOL       -> TOL < eps
%   - MAXITER   -> indifferente

% Test specific code
    
    A = sprand(10,10,0.1) + speye(10,10);
    x= ones(10,1);
    b = A*x;
    TOL = 1*10^-18;
    testCase.verifyWarning(@()jacobi(A,b,TOL),'jacobi:TOLminEPS')
end

function testFunctionCase6(testCase)
% Configurazione parametri jacobi
%   - A         -> valida
%   - b         -> valido
%   - TOL       -> TOL < 0
%   - MAXITER   -> indifferente

% Test specific code
    A = sprand(10,10,0.1) + speye(10,10);
    x= ones(10,1);
    b = A*x;
    TOL = -1;
    testCase.verifyError(@()jacobi(A,b,TOL),'jacobi:InvalidTOL')
end

function testFunctionCase7(testCase)
% Configurazione parametri jacobi
%   - A         -> valida
%   - b         -> non valido
%   - TOL       -> indifferente
%   - MAXITER   -> indifferente

% Test specific code
    
    A = sprand(10,10,0.1) + speye(10,10) ;
    b = rand(10);
    
    testCase.verifyError(@()jacobi(A,b),'jacobi:bInvalidDimension')
end



function testFunctionCase8(testCase)
% Configurazione parametri jacobi
%   - A         -> valida
%   - b         -> valido
%   - TOL       -> valido
%   - MAXITER   -> valido
%   L'algoritmo raggiunge il max numero di iterazioni

% Test specific code
    
    A = sprand(15,15,0.1) + speye(15,15) ;
    x= ones(15,1);
    b = A*x;
    TOL = 1e-7;
    MAXITER = 5;
    testCase.verifyWarning(@()jacobi(A,b,TOL,MAXITER),'jacobi:WarningMinMAXITER')
end

function testFunctionCase9(testCase)
% Configurazione parametri jacobi
%   - A         -> valida
%   - b         -> valido
%   - TOL       -> valido
%   - MAXITER   -> non valido

% Test specific code
    
    A = sprand(10,10,0.1) + speye(10,10) ;
    x= ones(10,1);
    b = A*x;
    TOL = 1e-7;
    MAXITER = -1;
    testCase.verifyWarning(@()jacobi(A,b,TOL,MAXITER),'jacobi:InvalidMAXITER')
end




