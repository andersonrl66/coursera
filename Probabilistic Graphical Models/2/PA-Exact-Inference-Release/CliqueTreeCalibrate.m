%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[i, j] = GetNextCliques(P, MESSAGES);

while (i > 0)
 neighbours_i = find(P.edges(i,:));
 num_neighbours = length(neighbours_i);
 fresult = P.cliqueList(i);
 if (isMax)
   fresult.val = log(fresult.val);
 endif
 for neighbour = 1:num_neighbours
   if (neighbours_i(neighbour) != j)
     if !(isempty(MESSAGES(neighbours_i(neighbour),i).var))
        if !(isMax)
          fresult = FactorProduct(fresult,MESSAGES(neighbours_i(neighbour),i));
        else
          fresult = FactorSum(fresult,MESSAGES(neighbours_i(neighbour),i));
        endif
     endif
   endif  
 endfor
 m_var = setdiff(P.cliqueList(i).var, P.cliqueList(j).var);
 if !(isMax)
   % marginalization
   fresult = FactorMarginalization(fresult,m_var);
   % renormalization
   fresult.val = fresult.val / sum(fresult.val); 
 else
   fresult = FactorMaxMarginalization(fresult,m_var);
 endif
 MESSAGES(i,j) = fresult; 
 [i, j] = GetNextCliques(P, MESSAGES);
endwhile
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:N
   neighbours_i = find(P.edges(i,:));
   num_neighbours = length(neighbours_i);
   fresult = P.cliqueList(i);
   if (isMax)
     fresult.val = log(fresult.val);
   endif
   for neighbour = 1:num_neighbours
     if !(isempty(MESSAGES(neighbours_i(neighbour),i).var))
       if !(isMax)
         fresult = FactorProduct(fresult,MESSAGES(neighbours_i(neighbour),i));
       else
         fresult = FactorSum(fresult,MESSAGES(neighbours_i(neighbour),i));
       endif
     endif
   endfor
   P.cliqueList(i) = fresult;
endfor

return
