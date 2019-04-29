
function tests = testSuite
    tests = functiontests(localfunctions);
end

%% Test Functions
function testFunctionCase1(testCase)
% Configurazione parametri risolve
%   - A     ->  triangolare superiore
%   - b     ->  valido
%   - opt   ->  full=true

% Test specific code
    A = triu(rand(10));
    x = ones(10,1);
    b = A*x;
    opt.full=true;
    
    testCase.verifyWarning(@()risolve(A,b,opt),'risolve:optWarning1')
end

function testFunctionCase2(testCase)
% Configurazione parametri risolve
%   - A     -> triangolare superiore
%   - b     -> valido
%   - opt   -> full=true, sup=true

% Test specific code
    A = triu(rand(10));
    x = ones(10,1);
    b = A*x;
    opt.full=true;
    opt.sup=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:optMultipleTrue')
end

function testFunctionCase3(testCase)
% Configurazione parametri risolve
%   - A     -> triangolare superiore
%   - b     -> non valido
%   - opt   -> don't care

% Test specific code
    A = triu(rand(10));
    b = rand(11,1);
    opt.full=true;
    opt.sup=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:bInvalidDimension')
end

function testFunctionCase4(testCase)
% Configurazione parametri risolve
%   - A     -> triangolare inferiore
%   - b     -> valido
%   - opt   -> full=true

% Test specific code
    A = tril(rand(10));
    x = ones(10,1);
    b = A*x;
    opt.full=true;
    
    testCase.verifyWarning(@()risolve(A,b,opt),'risolve:optWarning2')
end

function testFunctionCase5(testCase)
% Configurazione parametri risolve
%   - A     -> triangolare inferiore
%   - b     -> valido
%   - opt   -> full=true, sup=true

% Test specific code
    A = tril(rand(10));
    x = ones(10,1);
    b = A*x;
    opt.full=true;
    opt.sup=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:optMultipleTrue')
end

function testFunctionCase6(testCase)
% Configurazione parametri risolve
%   - A     -> triangolare inferiore
%   - b     -> non valido
%   - opt   -> don't care

% Test specific code
    A = tril(rand(10));
    b = rand(11,1);
    opt.full=true;
    opt.sup=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:bInvalidDimension')
end

function testFunctionCase7(testCase)
% Configurazione parametri risolve
%   - A         -> triangolare inferiore singolare
%   - b         -> valido
%   - opt       -> inf = true

% Test specific code
    A = tril(rand(10));
    A(1,1)=0;
    x = ones(10,1);
    b = A*x;
    opt.inf=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:ASingular')
end

function testFunctionCase8(testCase)
% Configurazione parametri risolve
%   - A     ->  triangolare superiore, singolare
%   - b     ->  valido
%   - opt   -> sup = true

% Test specific code
    A = triu(rand(10));
    A(1,1)=0;
    x = ones(10,1);
    b = A*x;
    opt.sup=true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:ASingular')
end

function testFunctionCase9(testCase)
% Configurazione parametri risolve
%   - A     ->  piena 
%   - b     ->  valido
%   - opt   -> full = false, inf = true

% Test specific code
    A = rand(10);
    x = ones(10,1);
    b = A*x;
    opt.full=false;
    opt.inf = true;
    
    testCase.verifyWarning(@()risolve(A,b,opt),'risolve:optWarning3')
end

function testFunctionCase10(testCase)
% Configurazione parametri risolve
%   - A     -> piena 
%   - b     -> valido
%   - opt   -> full = true, sup = true

% Test specific code
    A = rand(10);
    x = ones(10,1);
    b = A*x;
    opt.full= true;
    opt.sup = true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:optMultipleTrue')
end

function testFunctionCase11(testCase)
% Configurazione parametri risolve
%   - A     -> piena 
%   - b     -> non valido
%   - opt   -> don't care

% Test specific code
    A = rand(10);
    b = rand(11,1);
    opt.full= true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:bInvalidDimension')
end

function testFunctionCase12(testCase)
% Configurazione parametri risolve
%   - A     ->  piena e singolare
%   - b     ->  don't care
%   - opt   -> don't care

% Test specific code
    A = rand(10);
    A(2,:)=0;
    x= ones(10,1);
    b = A*x;
    opt.full= true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:ASingular')
end

function testFunctionCase13(testCase)
% Configurazione parametri risolve
%   - A     ->  non quadrata
%   - b     ->  don't care
%   - opt   -> don't care

% Test specific code
    A = rand(7,8);
    x= ones(8,1);
    b = A*x;
    opt.full= true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:ANotSquare')
end

function testFunctionCase14(testCase)
% Configurazione parametri risolve
%   - A     -> matrice sparsa
%   - b     -> don't care
%   - opt   -> don't care

% Test specific code
    A = sprand(10,10,0.01);
    x= ones(10,1);
    b = A*x;
    opt.full= true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:ANotMatrix')
end

function testFunctionCase15(testCase)
% Configurazione parametri risolve
%   - A     -> piena
%   - b     -> valido
%   - opt   -> non valido

% Test specific code
    A = rand(10);
    x= ones(10,1);
    b = A*x;
    opt.testNotValid = true;
    
    testCase.verifyError(@()risolve(A,b,opt),'risolve:optInvalid')
end



