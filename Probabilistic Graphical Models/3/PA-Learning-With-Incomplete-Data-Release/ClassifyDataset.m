function [predicted_labels accuracy] = ClassifyDataset(datasetTest, PActions, ClassProbs, G)

numInstances = length(PActions);
for testcase=1:numInstances
  
  tloglikelihood = zeros(1, length(datasetTest));
  
  numActions = length(datasetTrain);
  for action = 1:numActions
  
    poseData = datasetTest.poseData(datasetTest.actionData(testcase).marg_ind, :, :);
    P = PActions{action};
    actionData = datasetTest.actionData(testcase);
    
  
    N = length(actionData.marg_ind);
    K = size(ClassProbs{action}, 2);
    numparts = size(datasetTest.poseData, 2);
  
    logEmissionProb = zeros(N, K);

    for example=1:N
      for k=1:K
      
        logEmissionProb(example, k) = 0;
      
        for part=1:numparts
        
          parentpart = 0;
          parentals = [];

          if G(part, 1) == 1
            parentpart = G(part, 2);
            parent_y = poseData(example, parentpart, 1);
            parent_x = poseData(example, parentpart, 2);
            parent_alpha = poseData(example, parentpart, 3);
            parentals = [ parent_y parent_x parent_alpha ];
          end
        
          if (parentpart == 0)
            pdf_y = lognormpdf(poseData(example, part, 1), P.clg(part).mu_y(k), P.clg(part).sigma_y(k));
            pdf_x = lognormpdf(poseData(example, part, 2), P.clg(part).mu_x(k), P.clg(part).sigma_x(k));
            pdf_angle = lognormpdf(poseData(example, part, 3), P.clg(part).mu_angle(k), P.clg(part).sigma_angle(k));

            logEmissionProb(example, k) = sum( [ logEmissionProb(example, k) pdf_y pdf_x pdf_angle ] );
          else
            mu = P.clg(part).theta(k, 1) + parentals * P.clg(part).theta(k, 2:4)';
            sigma = P.clg(part).sigma_y(k);
            pdf_y = lognormpdf(poseData(example, part, 1), mu, sigma);
          
            mu = P.clg(part).theta(k, 5) + parentals * P.clg(part).theta(k, 6:8)';
            sigma = P.clg(part).sigma_x(k);
            pdf_x = lognormpdf(poseData(example, part, 2), mu, sigma);
          
            mu = P.clg(part).theta(k, 9) + parentals * P.clg(part).theta(k, 10:12)';
            sigma = P.clg(part).sigma_angle(k);
            pdf_angle = lognormpdf(poseData(example, part, 3), mu, sigma);
          
            logEmissionProb(example, k) = sum( [ logEmissionProb(example, k) pdf_y pdf_x pdf_angle ] );
          end

        end
      end
    end

    factorList = repmat(struct ('var', [], 'card', [], 'val', []), 1, 2 * N );
    currentF = 1;
    
    % P(S_1)
    % factorList(currentF).var = [ actionData(action).marg_ind(1) ];
    factorList(currentF).var = 1;
    factorList(currentF).card = [ K ];
    factorList(currentF).val = log(P.c);
    assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
    currentF = currentF + 1;
    
    % P(S_i | S_i-1)
    
    for i=2:N
      this = actionData.marg_ind(i);
      prev = actionData.marg_ind(i-1);
      % factorList(currentF).var = [ prev this ];
      factorList(currentF).var = [i-1 i];
      factorList(currentF).card = [ K K ];
      factorList(currentF).val = log(P.transMatrix(:)');
      assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
      currentF = currentF + 1;
    end
    
    % P(P_j | S_j)
    % reduced to theta(S_j)

    for i = 1:N
      factorList(currentF).var = [i];
      factorList(currentF).card = [K];
      factorList(currentF).val = logEmissionProb(i, :);
      assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
      currentF = currentF + 1;
    end
    
    [Marginals PCalibrated] = ComputeExactMarginalsHMM(factorList);
  
    tloglikelihood(action) = logsumexp(PCalibrated.cliqueList(end).val);
    
  end
  
  [~, predicted_labels(testcase)] = max(tloglikelihood);
  
end

predicted_labels = predicted_labels';
accuracy = sum(predicted_labels == datasetTest.labels) / length(datasetTest.labels);