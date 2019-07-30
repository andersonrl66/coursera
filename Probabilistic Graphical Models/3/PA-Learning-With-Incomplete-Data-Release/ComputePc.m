function Pc = ComputePc(ClassProb,N)
  
  K = size(ClassProb, 2);
  for i=1:K
      Pc(i)=sum(ClassProb(:,i))/N;
  end

end