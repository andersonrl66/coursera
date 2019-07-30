function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = length(P.c);
predict=zeros(N,K);
likelihood=zeros(N,K);

if length(size(G))==2
  G = CreateSharedGraph(G,K);
end

likelihood = ComputeLikelihood(P, G, dataset);

for i=1:N
    predict_class=find(likelihood(i,:)==max(likelihood(i,:)));
    predict(i,predict_class)=1;
end

[~,temp1] = max(predict,[],2);
[~,temp2] = max(labels,[],2);
accuracy = sum(temp1==temp2)/N;

fprintf('Accuracy: %.2f\n', accuracy);