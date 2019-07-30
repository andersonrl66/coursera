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
EUF=CalculateExpectedUtilityFactor(I);
newEUF.var=D.var;
newEUF.card=D.card;
for i=1:length(EUF.var)
    for j=1:length(newEUF.var)
        if newEUF.var(j)==EUF.var(i)
            theind(i)=j;
        end
    end
end
for i=1:prod(newEUF.card)
    theass=IndexToAssignment(i,newEUF.card);
    newass=theass(theind);
    newind=AssignmentToIndex(newass,EUF.card);
    newEUF.val(i)=EUF.val(newind);
end

OptimalDecisionRule.var=newEUF.var;
OptimalDecisionRule.card=newEUF.card;
OptimalDecisionRule.val=zeros(1,prod(OptimalDecisionRule.card));
if length(OptimalDecisionRule.var)==1
    OptimalDecisionRule.val(find(newEUF.val==max(newEUF.val)))=1;
else
    for i=1:(prod(OptimalDecisionRule.card)/OptimalDecisionRule.card(1))
        nownums=newEUF.val(((i-1)*OptimalDecisionRule.card(1)+1):((i-1)*OptimalDecisionRule.card(1)+OptimalDecisionRule.card(1)));
        nowvals=zeros(1,OptimalDecisionRule.card(1));
        nowvals(find(nownums==max(nownums)))=1;
        OptimalDecisionRule.val(((i-1)*OptimalDecisionRule.card(1)+1):((i-1)*OptimalDecisionRule.card(1)+OptimalDecisionRule.card(1)))=nowvals;
    end
end
MEU=sum(newEUF.val.*OptimalDecisionRule.val);

end
