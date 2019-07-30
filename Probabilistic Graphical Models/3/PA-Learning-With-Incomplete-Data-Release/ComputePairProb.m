function [PairProb loglikelihood ClassProb] = ComputePairProb(actionData,P,logEmissionProb,loglikelihoodin,ClassProbin,iter)

  L = size(actionData, 2);
  K = size(logEmissionProb,2);
  loglikelihood=loglikelihoodin;
  ClassProb = ClassProbin;
  for i=1:L
      tamMarg=length(actionData(i).marg_ind);
      clear F;
      F=repmat(struct('var',[],'card',[],'val',[]),1,1);
      F(1).var=1;
      F(1).card=K;
      F(1).val=log(P.c);
      for j=1:tamMarg
          F(j+1).var=j;
          F(j+1).card=K;
          F(j+1).val=logEmissionProb(actionData(i).marg_ind(j),:);
      end
      for j=1:tamMarg-1
          F(tamMarg+1+j).var=[j,j+1];
          F(tamMarg+1+j).card=[K,K];
          F(tamMarg+1+j).val=log(reshape(P.transMatrix,1,K*K));
      end
      [M,PCalibrated]=ComputeExactMarginalsHMM(F);
      for j=1:tamMarg
          ClassProb(actionData(i).marg_ind(M(j).var),1:K)=M(j).val;
      end
      for j=1:(tamMarg-1)
          PairProb(actionData(i).pair_ind(j),:)=PCalibrated.cliqueList(j).val;
      end
      loglikelihood(iter)=loglikelihood(iter)+logsumexp(PCalibrated.cliqueList(end).val);
  end
  sumProb1=logsumexp(ClassProb);
  for j=1:K
      ClassProb(:,j)=ClassProb(:,j)-sumProb1;
  end
  sumProb2=logsumexp(PairProb);
  for j=1:(K*K)
      PairProb(:,j)=PairProb(:,j)-sumProb2;
  end
  ClassProb=exp(ClassProb);
  PairProb=exp(PairProb);

end