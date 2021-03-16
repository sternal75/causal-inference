function [propensity_score] = propensity_score(treatment, covariates)
    %calculate propensity score
    x = zeros(size(covariates,1), size(covariates,2));
    for(i=1:size(covariates,2))
        if(iscell(covariates{:,i}))
            x(:,i) = categorical(covariates{:,i});
        else
            x(:,i) = covariates{:,i};
        end    
    end
    
    % calculate propensity scores based on logistic regression for data table 1
    propensity_score = zeros(size(x,1),1);
    [B,dev,stats] = mnrfit(x,categorical(treatment));
    for(i=1:size(x,1))
        % p(T=1|x)
        probability_for_treatment = mnrval(B,x(i,:));
        propensity_score(i) = probability_for_treatment(2);
    end
    
end

