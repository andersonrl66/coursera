% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   D = I.DecisionFactors(1);
   U_factors = I.UtilityFactors;
   num_Utility = length(U_factors);
   if num_Utility > 0
     I.UtilityFactors = U_factors(1);
     EUF = CalculateExpectedUtilityFactor(I);
     for i=2:num_Utility
       I.UtilityFactors = U_factors(i);
       EUF2 = CalculateExpectedUtilityFactor(I);
       EUF = JointUtility(EUF,EUF2);
     endfor
   endif
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
