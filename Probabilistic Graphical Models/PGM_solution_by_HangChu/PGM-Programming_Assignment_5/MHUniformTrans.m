% MHUNIFORMTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the uniform proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function A = MHUniformTrans(A, G, F)

% Draw proposed new state from uniform distribution
A_prop = ceil(rand(1, length(A)) .* G.card);

p_acceptance = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pibefore=1;
piafter=1;
for i=1:length(F)
    F(i).val=F(i).val/sum(F(i).val);
    [disordered,inda,indb]=intersect([1:length(A)],F(i).var);
    pibefore=pibefore*GetValueOfAssignment(F(i),A(inda));
    piafter=piafter*GetValueOfAssignment(F(i),A_prop(inda));
end
p_acceptance=min([1,piafter/pibefore]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
    % disp('Accepted');
    A = A_prop;
end