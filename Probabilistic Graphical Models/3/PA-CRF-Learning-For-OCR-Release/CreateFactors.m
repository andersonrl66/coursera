function [factors,thetaQuant] = CreateFactors(featureSet,y,theta)

% Create factors from features

n = length(y);
Fc(n) = EmptyFactorStruct();
Fc(n).var = n;
Fc(n).card = [26];
Fc(n).val = zeros(1,26);
for i=1:n-1
    Fc(i) = EmptyFactorStruct();
    Fc(i).var = i;
    Fc(i).card = 26;
    Fc(i).val = zeros(1,26); 
    Fy(i) = EmptyFactorStruct();
    Fy(i).var = [i, i+1];
    Fy(i).card = [26, 26];
    Fy(i).val = zeros(1,26*26);
end;
factors = [Fc, Fy];

thetaQuant = zeros(size(theta));
for f = 1:length(factors)
    factorVar = factors(f).var;
    for i=1:length(featureSet.features)
        if(length(factorVar) ~= length(featureSet.features(i).var))
            continue;
        end;
        if all(sort(factorVar) == sort(featureSet.features(i).var))
            if(all(y(featureSet.features(i).var) == featureSet.features(i).assignment))
                thetaQuant(featureSet.features(i).paramIdx) = thetaQuant(featureSet.features(i).paramIdx) + 1;
            end;
            map = [];
            for j = 1:length(factorVar)
                map(j) = find(factorVar == featureSet.features(i).var(j));
            end;
            idx = AssignmentToIndex(featureSet.features(i).assignment(map), factors(f).card);
            factors(f).val(idx) = factors(f).val(idx) + theta(featureSet.features(i).paramIdx);
        end;
    end;
end;

for i=1:length(factors)
    factors(i).val = exp(factors(i).val);
end;