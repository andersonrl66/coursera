function likelihood = ComputeLikelihood(P, G, dataset,ignoreClass)
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% likelihood: likelihood of the data (scalar)

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

for i=1:N
    for j=1:K
        somaclasse=0;
        for m=1:10
            clear somaparte;
            if G(m,1,j)==0 % only C as parent
                somaparte=lognormpdf(dataset(i,m,1),P.clg(m).mu_y(j),P.clg(m).sigma_y(j))+lognormpdf(dataset(i,m,2),P.clg(m).mu_x(j),P.clg(m).sigma_x(j))+lognormpdf(dataset(i,m,3),P.clg(m).mu_angle(j),P.clg(m).sigma_angle(j));
            else
                pvector=[1,dataset(i,G(m,2,j),1),dataset(i,G(m,2,j),2),dataset(i,G(m,2,j),3)];
                somaparte=lognormpdf(dataset(i,m,1),sum(P.clg(m).theta(j,1:4).*pvector),P.clg(m).sigma_y(j))+lognormpdf(dataset(i,m,2),sum(P.clg(m).theta(j,5:8).*pvector),P.clg(m).sigma_x(j))+lognormpdf(dataset(i,m,3),sum(P.clg(m).theta(j,9:12).*pvector),P.clg(m).sigma_angle(j));
            end
            somaclasse=somaclasse+somaparte;
        end
        if ignoreClass
          likelihood(i,j)=somaclasse;
        else
          likelihood(i,j)=somaclasse+log(P.c(j));
        end
    end
end
