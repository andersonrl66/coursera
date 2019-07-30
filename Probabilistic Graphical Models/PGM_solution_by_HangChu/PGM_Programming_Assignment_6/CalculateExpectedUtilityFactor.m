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
  F = I.RandomFactors;
  D = I.DecisionFactors(1);
  U = I.UtilityFactors(1);
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
F = [F,U];
allvars=[];
for i=1:length(F)
    allvars=[allvars,F(i).var];
end
allvars=unique(allvars);
Z=setdiff(allvars,D.var);
if ~isempty(Z)
    Fnew=VariableElimination(F,Z);
else
    Fnew=F;
end
Flast=Fnew(1);
if length(Fnew)>1
    for i=2:length(Fnew)
        Flast=FactorProduct(Flast,Fnew(i));
    end
end
EUF=Flast;

end  
