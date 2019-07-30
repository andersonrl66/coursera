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
  D = I.DecisionFactors(1);
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
if length(I.UtilityFactors)==1
    [MEU OptimalDecisionRule]=OptimizeMEU(I);
else
    allEUFs=repmat(struct('var',0,'card',0,'val',0),1,length(I.UtilityFactors));
    for k=1:length(I.UtilityFactors)
        Inow=I;
        Inow.UtilityFactors=I.UtilityFactors(k);
        EUF=CalculateExpectedUtilityFactor(Inow);
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
        allEUFs(k)=newEUF;
    end
    newEUF.val=zeros(1,prod(newEUF.card));
    for k=1:length(I.UtilityFactors)
        newEUF.val=newEUF.val+allEUFs(k).val;
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
end
