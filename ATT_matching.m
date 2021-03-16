function [result Y_treated_and_control] = ATT_matching(Y, e, ind_of_treated, ind_of_untreated)
    %calculate ATT per propensity score matching
    
    % go over all treated and find the nearest neighbour among the
    % untreated group
    e_treated   = e(ind_of_treated);
    e_untreated = e(ind_of_untreated);
    Y_untreated = Y(ind_of_untreated);
    nearest_neighbour_distance  = zeros(length(e_treated),1);
    nearest_neighbour_index     = zeros(length(e_treated),1);
    for(i=1:length(e_treated))
        current_e = e_treated(i);
        [nearest_neighbour_distance(i) nearest_neighbour_index(i)]= min(abs(current_e-e_untreated));
    end
    
    result.att = (sum(Y(ind_of_treated)-Y_untreated(nearest_neighbour_index)))/length(ind_of_treated);
    result.odds_ratio = (sum(Y(ind_of_treated))/length(ind_of_treated)) / (sum(Y_untreated(nearest_neighbour_index))/length(ind_of_treated));
    
    Y_treated_and_control = [Y(ind_of_treated) Y_untreated(nearest_neighbour_index)];
end

