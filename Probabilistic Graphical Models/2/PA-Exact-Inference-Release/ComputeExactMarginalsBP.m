%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = CreateCliqueTree(F, E);
P = CliqueTreeCalibrate(P, isMax);

vars = unique(cat(1,P.cliqueList.var));
N = length(vars);
M = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
numCliques = length(P.cliqueList);
for i=1:N
  for j=1:numCliques
    if (ismember(vars(i),P.cliqueList(j).var)) 
      if (!isMax) 
        M(i) = FactorMarginalization(P.cliqueList(j),setdiff(P.cliqueList(j).var,vars(i)));
        M(i).val = M(i).val / sum (M(i).val);
      else
        M(i) = FactorMaxMarginalization(P.cliqueList(j),setdiff(P.cliqueList(j).var,vars(i)));
      endif
      break;
    endif
  endfor
endfor
      
  