clear all;
close all;

% load input data tables
input_data = readtable('train.csv', 'ReadVariableNames', true);

% name of the treatment and outcome variable names in the table
T_variable_name = 'smoking_status';
Y_variable_name = 'heart_disease';

input_data.bmi = [];         
[input_data ind] = rmmissing(input_data);

% covariates, treatment assignment and outcome of data table 1
ind_of_treated     = find(strcmp(input_data.(T_variable_name),'smokes'));
% ind_of_treated     = find((input_data.(T_variable_name)>250));
% ind_of_treated      = find(T==1);
ind_of_untreated   = find(~strcmp(input_data.(T_variable_name),'smokes'));
% ind_of_untreated   = find((input_data.(T_variable_name)<=250));

T                                           = zeros(size(input_data,1),1);
T(ind_of_treated)  = 1;
Y                                           = input_data.(Y_variable_name);
% remove irrelevant keep only the relevant covariates
X_covariates_table  = input_data;

X_covariates_table.(T_variable_name) = [];
X_covariates_table.(Y_variable_name) = [];


% calculate propensity scores based on logistic regression for data table 1
propensity_score_dataset = propensity_score(T, X_covariates_table);
figure;
hold on;
histogram(propensity_score_dataset(ind_of_treated));
histogram(propensity_score_dataset(ind_of_untreated));
xlabel('Propensity score');
ylabel('Number of propensities');
legend({'treated','non-treated'});
grid on;
box on;
hold off;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Inverse Propensity Score Weighting (IPW)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Y_treated = Y(ind_of_treated);
% propensity_score_dataset_treated = propensity_score_dataset(ind_of_treated);
[ATT_IPW_result Y_adjusted_IPW] = ATT_IPW(Y, propensity_score_dataset, ind_of_treated, ind_of_untreated);

fprintf('***************  ATT with IPW  **************************\n');
fprintf('dataset 1 = %.2f\n', ATT_IPW_result);
fprintf('*********************************************************\n\n');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% S-learner
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[ATT_Slearner_result Y_estimated_Slearner] = ATT_S_learner(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);

fprintf('***************  ATT with S-learner  ********************\n');
fprintf('dataset 1 = %.2f\n', ATT_Slearner_result);
fprintf('*********************************************************\n\n');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% S-learner - 2d+1
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[ATT_Slearner_2d1_result Y_estimated_Slearner_2d1] = ATT_S_learner_2d1(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);

fprintf('***************  ATT with S-learner 2d+1  ***************\n');
fprintf('dataset 1 = %.2f\n', ATT_Slearner_2d1_result);
fprintf('*********************************************************\n\n');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% T-learner
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[ATT_Tlearner_result Y_estimated_Tlearner] = ATT_T_learner(X_covariates_table, T, Y, ind_of_treated, ind_of_untreated);

fprintf('***************  ATT with T-learner  ********************\n');
fprintf('dataset 1 = %.2f\n', ATT_Tlearner_result);
fprintf('*********************************************************\n\n');


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Matching
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[ATT_matching_result Y_treated_and_control] = ATT_matching(Y, propensity_score_dataset, ind_of_treated, ind_of_untreated);

fprintf('***************  ATT with matching  ********************\n');
fprintf('dataset 1 = %.2f\n', ATT_matching_result);
fprintf('*********************************************************\n\n');


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

