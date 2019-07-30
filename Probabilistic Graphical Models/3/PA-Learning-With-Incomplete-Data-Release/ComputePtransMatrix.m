function PtransMatrix = ComputePtransMatrix(PairProb)

  K = sqrt(size(PairProb,2));
  transsum=zeros(1,K*K);
  for i=1:(K*K)
      transsum(1,i)=sum(PairProb(:,i));
  end
  transMat=reshape(transsum,K,K);
  transMat=transMat+size(PairProb,1)*0.05;
  for i=1:K
      for j=1:K
         PtransMatrix(i,j)=transMat(i,j)/sum(transMat(i,:));
      end
  end

end