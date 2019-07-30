% quiz 7,8,9

function value = quiz()

   load TestI0.mat
   [MEU OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   % Connect test to decision
   D = struct('var', [9, 11], 'card', [2, 2], 'val', [1 0 0 1]);
   TestI0.DecisionFactors = D;
   % modifiy Random factor 10 - variable 11
   TestI0.RandomFactors(10).val = [0.75 0.25 0.001 0.999];
   [MEU_mod OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   U_gain = MEU_mod - MEU;
   value(1) = exp(U_gain/100) - 1;

   load TestI0.mat
   [MEU OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   % Connect test to decision
   D = struct('var', [9, 11], 'card', [2, 2], 'val', [1 0 0 1]);
   TestI0.DecisionFactors = D;
   % modifiy Random factor 10 - variable 11
   TestI0.RandomFactors(10).val = [0.999 0.001 0.25 0.75];
   [MEU_mod OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   U_gain = MEU_mod - MEU;
   value(2) = exp(U_gain/100) - 1;

   load TestI0.mat
   [MEU OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   % Connect test to decision
   D = struct('var', [9, 11], 'card', [2, 2], 'val', [1 0 0 1]);
    % modifiy Random factor 10 - variable 11
   TestI0.RandomFactors(10).val = [0.999 0.001 0.001 0.999];
   TestI0.DecisionFactors = D;
   [MEU_mod OptimalDecisionRule] = OptimizeWithJointUtility( TestI0 );
   U_gain = MEU_mod - MEU;
   value(3) = exp(U_gain/100) - 1;
   
end