function Pclg = ComputePclg(dataset, G, labels)

  N = size(dataset, 1);
  K = size(labels,2);

  Pclg=repmat(struct('mu_y',[],'sigma_y',[],'mu_x',[],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]),1,10);
  for i=1:10
      for j=1:K
          dtclass=[];
          dtpclass=[];
          for m=1:N
              if labels(m,j)==1
                  dtclass=[dtclass;dataset(m,i,1),dataset(m,i,2),dataset(m,i,3);];
              end
          end
          if G(i,1,j)==0
              [Pclg(i).mu_y(1,j),Pclg(i).sigma_y(1,j)]=FitGaussianParameters(dtclass(:,1));
              [Pclg(i).mu_x(1,j),Pclg(i).sigma_x(1,j)]=FitGaussianParameters(dtclass(:,2));
              [Pclg(i).mu_angle(1,j),Pclg(i).sigma_angle(1,j)]=FitGaussianParameters(dtclass(:,3));
          else
              for m=1:N
                  if labels(m,j)==1
                      dtpclass=[dtpclass;dataset(m,G(i,2,j),1),dataset(m,G(i,2,j),2),dataset(m,G(i,2,j),3);];
                  end
              end
              [beta,Pclg(i).sigma_y(1,j)]=FitLinearGaussianParameters(dtclass(:,1),dtpclass);
              Pclg(i).theta(j,1:4)=[beta(4),beta(1:3)'];
              [beta,Pclg(i).sigma_x(1,j)]=FitLinearGaussianParameters(dtclass(:,2),dtpclass);
              Pclg(i).theta(j,5:8)=[beta(4),beta(1:3)'];
              [beta,Pclg(i).sigma_angle(1,j)]=FitLinearGaussianParameters(dtclass(:,3),dtpclass);
              Pclg(i).theta(j,9:12)=[beta(4),beta(1:3)'];
          end
      end
  end
  
end