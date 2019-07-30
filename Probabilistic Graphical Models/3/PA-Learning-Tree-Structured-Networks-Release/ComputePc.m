function Pc = ComputePc(labels,N)
  
  K = size(labels,2);
  for i=1:K
      Pc(i)=sum(labels(:,i))/N;
  end

end