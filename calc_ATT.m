function [result] = calc_ATT(input_data, T_variable_name, Y_variable_name, T_val)

    % covariates, treatment assignment and outcome of dataset
    if(isstr(T_val))
        ind_of_treated     = find(strcmp(input_data.(T_variable_name),T_val));
        ind_of_untreated   = find(~strcmp(input_data.(T_variable_name),T_val));
    else
        ind_of_treated     = find((input_data.(T_variable_name)>T_val));
        ind_of_untreated   = find((input_data.(T_variable_name)<=T_val));
    end
    
    

    T                                           = zeros(size(input_data,1),1);
    T(ind_of_treated)  = 1;
    Y                                           = input_data.(Y_variable_name);
    % remove irrelevant keep only the relevant covariates
    X_covariates_table  = input_data;

    X_covariates_table.(T_variable_name) = [];
    X_covariates_table.(Y_variable_name) = [];


    % calculate propensity scores based on logistic regression for dataset
    result.propensity_score = propensity_score(T, X_covariates_table);
    result.ind_of_treated   = ind_of_treated;
    result.ind_of_untreated = ind_of_untreated;
    

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % Inverse Propensity Score Weighting (IPW)
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [result.IPW_result Y_adjusted_IPW] = ATT_IPW(Y, result.propensity_score, ind_of_treated, ind_of_untreated);
    fprintf('IPW ATT = %.2f, odds ratio = %.2f\n', result.IPW_result.att, result.IPW_result.odds_ratio);

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % S-learner
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [result.Slearner_result Y_estimated_Slearner] = ATT_S_learner(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);
    fprintf('S-learner: ATT = %.2f, odds ratio = %.2f\n', result.Slearner_result.att, result.Slearner_result.odds_ratio);

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % S-learner - 2d+1
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [result.Slearner_2d1_result Y_estimated_Slearner_2d1] = ATT_S_learner_2d1(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);
    fprintf('S-learner 2d+1: ATT = %.2f, odds ratio = %.2f\n', result.Slearner_2d1_result.att, result.Slearner_2d1_result.odds_ratio);

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % T-learner
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [result.Tlearner_result Y_estimated_Tlearner] = ATT_T_learner(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);
    fprintf('T-learner: ATT = %.2f, odds ratio = %.2f\n', result.Tlearner_result.att, result.Tlearner_result.odds_ratio);


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % Matching
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [result.matching_result Y_treated_and_control] = ATT_matching(Y, result.propensity_score, ind_of_treated, ind_of_untreated);
    fprintf('matching: ATT = %.2f, odds ratio = %.2f\n', result.matching_result.att, result.matching_result.odds_ratio);


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    % my best estimate 
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [correlation_coef_IPW_pearson,PVAL_IPW] = corr(Y_adjusted_IPW,Y,'Type','Pearson');        
    [correlation_coef_Slearner_pearson,PVAL_Slearner] = corr(Y_estimated_Slearner,Y,'Type','Pearson');        
    [correlation_coef_Slearner_2d1_pearson,PVAL_Slearner] = corr(Y_estimated_Slearner_2d1,Y,'Type','Pearson');        
    [correlation_coef_Tlearner_pearson,PVAL_Tlearner] = corr(Y_estimated_Tlearner,Y,'Type','Pearson');        


    fprintf('***************  My best estimate dataset 1 ********************\n');
    fprintf('correlation of outcome and adjusted outcome by IPW = %.3f\n', correlation_coef_IPW_pearson);
    fprintf('correlation of outcome and estimated outcome by S-learner = %.3f\n', correlation_coef_Slearner_pearson);
    fprintf('correlation of outcome and estimated outcome by S-learner-2d1 = %.3f\n', correlation_coef_Slearner_2d1_pearson);
    fprintf('correlation of outcome and estimated outcome by T-learner = %.3f\n', correlation_coef_Tlearner_pearson);
    fprintf('****************************************************************\n\n');
end
