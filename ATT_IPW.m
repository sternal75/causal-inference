function [result Y_adjusted] = ATT_IPW(Y, e, ind_of_treated, ind_of_untreated)
    %calculate ATT per IPW
    result.att = sum(Y(ind_of_treated))/length(ind_of_treated) - sum(Y(ind_of_untreated).*(e(ind_of_untreated)./(1-e(ind_of_untreated)))) / sum((e(ind_of_untreated)./(1-e(ind_of_untreated))));
    result.odds_ratio = (sum(Y(ind_of_treated))/length(ind_of_treated)) ./ (sum(Y(ind_of_untreated).*(e(ind_of_untreated)./(1-e(ind_of_untreated)))) / sum((e(ind_of_untreated)./(1-e(ind_of_untreated)))));
    
    
    Y_adjusted(ind_of_treated,1)     = Y(ind_of_treated)./e(ind_of_treated);
    Y_adjusted(ind_of_untreated,1)   = Y(ind_of_untreated)./(1-e(ind_of_untreated));
       
end

