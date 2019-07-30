function [PActions loglikelihoods ClassProbs PairProbs] = TrainModel(datasetTrain, G, maxIter)

numInstances = length(datasetTrain);
for action=1:numInstances
  [P loglikelihood ClassProb PairProb] = EM_HMM(datasetTrain(action).actionData, datasetTrain(action).poseData, G, datasetTrain(action).InitialClassProb, datasetTrain(action).InitialPairProb, maxIter);
  PActions{action} = P;
  loglikelihoods{action} = loglikelihood;
  ClassProbs{action} = ClassProb;
  PairProbs{action} = PairProb;
end