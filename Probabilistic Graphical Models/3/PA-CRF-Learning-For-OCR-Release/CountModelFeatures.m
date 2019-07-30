function [modelFeatureCounts] = CountModelFeatures(featureSet,factors,theta)

  modelFeatureCounts = zeros(size(theta));
  for i=1:length(featureSet.features)
      
      for f = 1:length(factors)
          factorVar = factors(f).var;
          if(length(factorVar) ~= length(featureSet.features(i).var))
              continue;
          end;
          if all(sort(factorVar) == sort(featureSet.features(i).var))
              map = [];
              for j = 1:length(factorVar)
                  map(j) = find(factorVar == featureSet.features(i).var(j));
              end;
              idx = AssignmentToIndex(featureSet.features(i).assignment, factors(f).card);
              modelFeatureCounts(featureSet.features(i).paramIdx) = modelFeatureCounts(featureSet.features(i).paramIdx) + factors(f).val(idx);
              break;
          end;
      end;
  end;

end;