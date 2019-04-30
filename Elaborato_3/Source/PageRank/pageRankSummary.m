function pageRankSummary(filename)
%% Controllo di validità di filename
    if ~isstring(filename) || isempty(strfind(filename,".mat"))
        error('PageRankSummary:filenameInvalid',...
                'filename deve essere una stringa che specifica il file .mat da cui caricare i dati ')
    end
    clear;
    load(filename)
    %whos
%% Controllo di validità di URL
% URL deve essere un cell array contente stringe quadrata sparsa, contenente elementi di tipo
% logical
    n = size(G,1);
    if exist('U','var')
        URL = U;
    end
    if exist('URL','var')
        if isempty(URL) || ~iscell(URL) || size(URL,1)~=n
            error('PageRankSummary:URLInvalid',...
                    'URL deve essere un cellarray, non vuoto e con la stessa dimensione di G');
        end
    else
        error('PageRankSummary:URLInvalid',...
                'cell array URL non presente');
    end
%% Preparazione per il calcolo del pageRank
    %il controllo di validità di G si lascia a PageRank
    if ~exist('G','var')
        error('PageRankSummary:URLInvalid',...
                'La matrice di adiagenza G non è presente in %s.mat',filename);
    end
    
    [R,OUT,IN]=PageRank(G);
    
    %Stampa del grafico che mostra la struttura di G
    fig1=figure('Name','Struttura di G','NumberTitle','off');
    spy(G)
    
    %Stampa del grafo associato
    graph = digraph(G');
    
    fig2=figure('Name','Grafo associato a G','NumberTitle','off');
    plot(graph,'NodeColor','r','EdgeColor', [.7 .7 .7],'MarkerSize',5,'ArrowSize',14); 
    axis off
    
    [R, OUTDEGREE, INDEGREE] = PageRank(G);
% Assegno le proprietà al grafo
    graph.Nodes.PageRank = R;
    graph.Nodes.InDegree = INDEGREE;
    graph.Nodes.OutDegree = OUTDEGREE;
    
%Ordino stampo la tabella con i primi 15 risultati in ordine decrescente
    [R, index] = sort(R,'descend');
    sites = URL(index(1:15));
    ID    = index(1:15);
    rank  = R(1:15);
    outdegree = OUTDEGREE(index(1:15));
    indegree = INDEGREE(index(1:15));
    T = table(ID,rank,outdegree,indegree,'RowNames',sites)
    
% Genero un grafico a barre dei risultati in base al rank
    fig3=figure('Name','Grafico a barre del rank dei primi 15 risultati','NumberTitle','off');
    bar(graph.Nodes.PageRank); 
    
%il sottografo costituito dai nodi con rank maggiore della media dei rank
    fig4=figure('Name','Sottografo dei nodi con rank maggiore della media','NumberTitle','off');
    H = subgraph(graph, find(graph.Nodes.PageRank > mean(graph.Nodes.PageRank)));
    plot(H,'NodeLabel',find(graph.Nodes.PageRank > mean(graph.Nodes.PageRank)),'NodeCData',H.Nodes.PageRank,'Layout','force'); 
    colorbar; 
    axis off;
end