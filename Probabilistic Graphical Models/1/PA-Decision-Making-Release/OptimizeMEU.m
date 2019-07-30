% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
  EUF = CalculateExpectedUtilityFactor(I);
%  PrintFactor(EUF);
  OptimalDecisionRule.var = EUF.var;
  OptimalDecisionRule.card = EUF.card;
  OptimalDecisionRule.val = zeros(size(EUF.val));
  if(length(D.var) > 1)
      for i=1:length(D.var)
          related_decision_var(i) = find(D.var == EUF.var(i));
      end;
      Inds_PaD = AssignmentToIndex(1:prod(D.card(2:end)), D.card(2:end));
      for i=1:size(Inds_PaD,1)
          assigns_D = [[1:D.card(1)]', repmat(Inds_PaD(i,:), length([1:D.card(1)]),1)];
          mapped_inds = AssignmentToIndex(assigns_D(:,related_decision_var), EUF.card);
          [meu_val,ind] = max(EUF.val(mapped_inds));
          OptimalDecisionRule.val(mapped_inds(ind)) = 1;
      end;
   else
      [meu_val, ind] = max(EUF.val);
      OptimalDecisionRule.val(ind) = 1;
    end;
    F = FactorProduct(OptimalDecisionRule, EUF);
    MEU = sum(F.val(:));

end
