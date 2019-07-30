function Pc = ComputePc_HMM(ClassProb,actionData)
  
  K = size(ClassProb, 2);
  L = size(actionData, 2);
  
  initialCP=zeros(1,K);
  for i=1:L
      initialCP=initialCP+ClassProb(actionData(i).marg_ind(1),:);
  end
  sumCP = sum(initialCP);
  for i=1:K
      Pc(i)=initialCP(i)/sumCP;
  end

end