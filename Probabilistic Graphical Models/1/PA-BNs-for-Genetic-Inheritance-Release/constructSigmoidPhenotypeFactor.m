function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% You can assume that there are only 2 genes involved in the CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: Cell array of weights, where each entry is an 1 x n 
%   of weights for the alleles for a gene (n is the number of alleles for
%   the gene)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the first parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor)
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the second parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor) -- Note that both copies of each gene are from the same person,
%   but each copy originally came from a different parent
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Note that computeSigmoid.m will be useful for this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.

numGenes = length(geneCopyVarOneList);
numAlleles = length(alleleWeights{1});
phenotypeFactor.var = [phenotypeVar geneCopyVarOneList' geneCopyVarTwoList'];
numVar = length(phenotypeFactor.var);
phenotypeFactor.card(1) = 2;
phenotypeFactor.card(2:numVar) = numAlleles;
    
phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));

numVal = length(phenotypeFactor.val);
for ind = 1:numVal
  assignment = IndexToAssignment(ind, phenotypeFactor.card);
  phenotype = assignment(1);
  z = 0;
  for i = 1:numGenes
    allele_i_p1 = assignment(1 + i);
    allele_i_p2 = assignment(1 + numGenes + i);
    w_p1 = alleleWeights{i}(allele_i_p1);
    w_p2 = alleleWeights{i}(allele_i_p2);
    z += w_p1 + w_p2;
  endfor
      
  
  if phenotype == 1
    z;
    computeSigmoid(z)  ; 
    phenotypeFactor.val(ind) = computeSigmoid(z);
  else
    1 - computeSigmoid(z);
    phenotypeFactor.val(ind) = 1 - computeSigmoid(z);  
  endif
endfor
% Replace the zeros in phentoypeFactor.val with the correct values.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%