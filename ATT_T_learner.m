function [result Y_estimated] = ATT_T_learner(covariates, T, Y, ind_of_treated, ind_of_untreated)
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
    x = [ones(size(x,1),1) x];
    
    % fit a linear regression model, separately for treated and non
    % treated
    b0 = regress(Y(ind_of_untreated),x(ind_of_untreated,:));
    b1 = regress(Y(ind_of_treated),x(ind_of_treated,:));
    
    % predict the outcome
    f_xi_t0 = x*b0;
    f_xi_t1 = x*b1;
    
    % calculate ATT
    result.att = sum(f_xi_t1(ind_of_treated) - f_xi_t0(ind_of_treated))/length(ind_of_treated);
    result.odds_ratio = (sum(f_xi_t1(ind_of_treated))/length(ind_of_treated)) / (sum(f_xi_t0(ind_of_treated))/length(ind_of_treated));
    
    Y_estimated(ind_of_treated,1)     = f_xi_t1(ind_of_treated);
    Y_estimated(ind_of_untreated,1)   = f_xi_t0(ind_of_untreated);    
end

