%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:N
    P.cliqueList(i).var = C.nodes{i};        
endfor


numFactors = length(C.factorList);
factorCliques=zeros(numFactors,1);
for f=1:numFactors
    factorVar = C.factorList(f).var;
    for c=1:N
        cliqueVar = C.nodes{c};
        if(all(ismember(factorVar, cliqueVar)))
            factorCliques(f) = c;
            break;
        endif
    endfor
endfor


for i=1:N
i
    factorInds = find(factorCliques == i);
    numFactorsClique = length(factorInds);
    if (numFactorsClique == 0)
      P.cliqueList(i).val(:) = 1;
    else
      fProd = C.factorList(factorInds(1));
      for j=2:numFactorsClique
          fClique = C.factorList(factorInds(j));
          fProd = FactorProduct(fProd,fClique);
      end;
      
%      ordenacao dos valores do produto de acordo com as variaveis      
%       [ismem, idx_ord] = ismember(P.cliqueList(i).var,fProd.var);
       [~, idx_ord] = sort(fProd.var);
       P.cliqueList(i).card = fProd.card(idx_ord);
       assignments = IndexToAssignment(1:prod(fProd.card), fProd.card);
       assignmentsOrd = assignments(:,idx_ord);
       inds_val_ord = AssignmentToIndex(assignmentsOrd, P.cliqueList(i).card);
       P.cliqueList(i).val(inds_val_ord) = fProd.val;

    endif

endfor

P.edges = C.edges;
