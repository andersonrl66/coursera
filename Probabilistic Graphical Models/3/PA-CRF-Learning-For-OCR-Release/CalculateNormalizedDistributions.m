function [factorsOut] = CalculateNormalizedDistributions(P,factorsIn)

  factorsOut = factorsIn;
  for f=1:length(factorsOut)
      for i=1:length(P.cliqueList)
          if(length(intersect(P.cliqueList(i).var, factorsOut(f).var)) == length(factorsOut(f).var))
              if(all(intersect(P.cliqueList(i).var, factorsOut(f).var) == factorsOut(f).var))
                  V = setdiff(P.cliqueList(i).var, factorsOut(f).var);
                  factorsOut(f) = FactorMarginalization(P.cliqueList(i), V);
                  factorsOut(f).val = factorsOut(f).val./sum(factorsOut(f).val);
                  break;
              end;
          end;
      end;
  end;

end;