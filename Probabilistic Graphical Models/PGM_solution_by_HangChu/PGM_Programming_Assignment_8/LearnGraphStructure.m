function [A W] = LearnGraphStructure(dataset)

% Input:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% A: maximum spanning tree computed from the weight matrix W
% W: 10 x 10 weight matrix, where W(i,j) is the mutual information between
%    node i and j. 
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1);
K = size(dataset,3);

W = zeros(10,10);
% Compute weight matrix W
% set the weights following Eq. (14) in PA description
% you don't have to include M since all entries are scaled by the same M
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE        
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:10
    for j=1:10
        parti=[];
        partj=[];
        for m=1:N
            parti=[parti;dataset(m,i,1),dataset(m,i,2),dataset(m,i,3);];
            partj=[partj;dataset(m,j,1),dataset(m,j,2),dataset(m,j,3);];
        end
        W(i,j)=GaussianMutualInformation(parti,partj);
    end
end
% Compute maximum spanning tree
A = MaxSpanningTree(W);