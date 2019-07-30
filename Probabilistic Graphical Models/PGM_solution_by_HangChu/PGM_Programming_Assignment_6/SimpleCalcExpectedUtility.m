% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allvars=[];
for i=1:length(F)
    allvars=[allvars,F(i).var];
end
allvars=unique(allvars);
Z=setdiff(allvars,U.var);
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
Flast.val=Flast.val/sum(Flast.val);
Ulast.var=Flast.var;
Ulast.card=Flast.card;
for i=1:length(U.var)
    for j=1:length(Ulast.var)
        if Ulast.var(j)==U.var(i)
            theind(i)=j;
        end
    end
end
for i=1:prod(Ulast.card)
    theass=IndexToAssignment(i,Ulast.card);
    newass=theass(theind);
    newind=AssignmentToIndex(newass,U.card);
    Ulast.val(i)=U.val(newind);
end
EU=sum(Flast.val.*Ulast.val);

end
