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
P.edges=C.edges;
for i=1:length(C.factorList)
    for j=1:length(C.factorList(i).card)
        cardmat(C.factorList(i).var(j))=C.factorList(i).card(j);
    end
end

for i=1:length(C.factorList)
    for j=1:N
        dummy=intersect(C.nodes{j},C.factorList(i).var);
        if length(dummy)==length(C.factorList(i).var)
            ass(i)=j;
            break;
        end
    end
end

% howmuchfac=zeros(1,length(C.factorList));
% for i=1:length(C.factorList)
%     howmuchfac(i)=length(C.factorList(i).var);
% end
% [nouse,theorder]=sort(howmuchfac,'ascend');
% theassed=C.nodes;
% for i=1:N
%     theassed{i}=ones(1,length(C.nodes{i}));
% end
% for i=1:length(C.factorList)
%     eff=zeros(1,N);
%     for j=1:N
%         [dummy,thea,theb]=intersect(C.nodes{j},C.factorList(theorder(i)).var);
%         nowass=theassed{j};
%         if length(dummy)==length(C.factorList(theorder(i)).var)
%             eff(j)=sum(nowass(thea));
%         end
%     end
%     if sum(eff)==0
%        for j=1:N
%            dummy=intersect(C.nodes{j},C.factorList(theorder(i)).var);
%            if length(dummy)==length(C.factorList(theorder(i)).var)
%                ass(theorder(i))=j;
%                break;
%            end
%        end
%     else
%     theorder2=find(eff==max(eff));
%     ass(theorder(i))=theorder2(1);
%     nowass=theassed{theorder2(1)};
%     [dummy,thea,theb]=intersect(C.nodes{theorder2(1)},C.factorList(theorder(i)).var);
%     nowass(thea)=0;
%     theassed{theorder2(1)}=nowass;
%     end
% end
% ass

for i=1:N
    P.cliqueList(i).var=C.nodes{i};
    for j=1:length(P.cliqueList(i).var)
        P.cliqueList(i).card(j)=cardmat(P.cliqueList(i).var(j));
    end
    
    facnum=0;
    for j=1:length(C.factorList)
        if ass(j)==i
            facnum=facnum+1;
            fac(facnum)=j;
        end
    end
    
    if facnum==1
        theclique=C.factorList(fac(1));
    else
        theclique=C.factorList(fac(1));
        for j=1:(facnum-1)
            theclique=FactorProduct(theclique,C.factorList(fac(j+1)));
        end
    end
    
    if facnum==0
        P.cliqueList(i).val=ones(1,prod(P.cliqueList(i).card));
        break;
    end

    for j=1:prod(P.cliqueList(i).card)
        theass1=0;
        theass2=0;
        theass1=IndexToAssignment(j,P.cliqueList(i).card);
        for a1=1:length(theclique.var)
            for a2=1:length(P.cliqueList(i).var)
                if (theclique.var(a1))==(P.cliqueList(i).var(a2))
                    theass2(a1)=theass1(a2);
                end
            end
        end
        theind2=AssignmentToIndex(theass2,theclique.card);
        theval=theclique.val(theind2);
        P.cliqueList(i).val(j)=theval;
    end
end

end

