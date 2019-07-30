% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  EUF = struct('var', I.DecisionFactors.var, 'card', [2], 'val', [0 0]);
  
  U = I.UtilityFactors(1);
  F = [I.RandomFactors];
  D = I.DecisionFactors;
  factors_var = unique([F(:).var]);
  parents_var = D.var(1:end);
  num_factors = length(F);
  F_prod = F(1);
  for i=2:num_factors
      F_prod = FactorProduct(F_prod, F(i));
  end;
  F_prod = FactorProduct(F_prod, U);
  elimination_var = setdiff(factors_var, parents_var);
  EUF = FactorMarginalization(F_prod, elimination_var);

end  
