function [result Y_estimated] = ATT_S_learner(covariates, T, Y, ind_of_treated, ind_of_untreated)
    %calculate ATT per S-learner
    x = zeros(size(covariates,1), size(covariates,2));
    for(i=1:size(covariates,2))
        if(iscell(covariates{:,i}))
            x(:,i) = categorical(covariates{:,i});
        else
            x(:,i) = covariates{:,i};
        end    
    end
    % add a column of ones - to compute coefficient estimates for a model with a constant term (intercept)
    % and also add a column of treatment for the s-learner
    x_with_t = [ones(size(x,1),1) x T];
    
    % fit a linear regression model
    b = regress(Y,x_with_t);
    
    % predict the outcome
    f_xi_t0 = [ones(size(x,1),1) x zeros(size(x,1),1)]*b;
    f_xi_t1 = [ones(size(x,1),1) x ones(size(x,1),1)]*b;
    
    % calculate ATT
    result.att = sum(f_xi_t1(ind_of_treated) - f_xi_t0(ind_of_treated))/length(ind_of_treated);
    result.odds_ratio = (sum(f_xi_t1(ind_of_treated))/length(ind_of_treated)) / (sum(f_xi_t0(ind_of_treated))/length(ind_of_treated))
    
    Y_estimated(ind_of_treated,1)     = f_xi_t1(ind_of_treated);
    Y_estimated(ind_of_untreated,1)   = f_xi_t0(ind_of_untreated);
end

