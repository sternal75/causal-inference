clear all;
close all;

% load input data tables
input_data = readtable('train.csv', 'ReadVariableNames', true);
input_data.id = [];
input_data.bmi(strcmp(input_data.bmi,'N/A')) = {''};
[input_data ind] = rmmissing(input_data);
input_data.bmi = cellfun(@str2num,input_data.bmi);


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% T = Smoking
% Y = Heart disease; Stroke
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% treatment - modified risk factor: smoking
% outcome - heart disease
result_heart_disease    = calc_ATT(input_data, 'smoking_status', 'heart_disease', 'smokes');
% outcome - heart disease
result_stroke           = calc_ATT(input_data, 'smoking_status', 'stroke', 'smokes');

figure;
subplot(1,3,1);
hold on;
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_treated));
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_untreated));
xlabel('Propensity score');
ylabel('Number of propensities (T=smoking)');
legend({' treated',' untreated'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
grid on;
box on;
hold off;

subplot(1,3,2);
hold on;
bar([result_heart_disease.IPW_result.att result_stroke.IPW_result.att; result_heart_disease.Slearner_result.att result_stroke.Slearner_result.att; result_heart_disease.Slearner_2d1_result.att result_stroke.Slearner_2d1_result.att; result_heart_disease.Tlearner_result.att result_stroke.Tlearner_result.att; result_heart_disease.matching_result.att result_stroke.matching_result.att]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('ATT (T=smoking)');
% legend({' heart disease',' stroke'}, 'Orientation', 'horizontal', 'Location', 'northoutside');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-0.01 0.08]);
grid on;
box on;
hold off;

subplot(1,3,3);
hold on;
bar([(result_heart_disease.IPW_result.odds_ratio-1)*100 (result_stroke.IPW_result.odds_ratio-1)*100; (result_heart_disease.Slearner_result.odds_ratio-1)*100 (result_stroke.Slearner_result.odds_ratio-1)*100; (result_heart_disease.Slearner_2d1_result.odds_ratio-1)*100 (result_stroke.Slearner_2d1_result.odds_ratio-1)*100; (result_heart_disease.Tlearner_result.odds_ratio-1)*100 (result_stroke.Tlearner_result.odds_ratio-1)*100; (result_heart_disease.matching_result.odds_ratio-1)*100 (result_stroke.matching_result.odds_ratio-1)*100]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('% Risk increase (T=smoking)');
% legend({' heart disease',' stroke'}, 'Orientation', 'horizontal', 'Location', 'northoutside');
legend({' heart disease',' stroke'}, 'FontSize',12);

set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-20 100]);
grid on;
box on;
hold off;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% T = hypertension
% Y = Heart disease; Stroke
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% treatment - modified risk factor: hypertension
% outcome - heart disease
result_heart_disease    = calc_ATT(input_data, 'hypertension', 'heart_disease', 0.5);
% outcome - stroke
result_stroke           = calc_ATT(input_data, 'hypertension', 'stroke', 0.5);

figure;
subplot(1,3,1);
hold on;
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_treated));
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_untreated));
xlabel('Propensity score');
ylabel('Number of propensities (T=hypertension)');
legend({' treated',' untreated'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
grid on;
box on;
hold off;

subplot(1,3,2);
hold on;
bar([result_heart_disease.IPW_result.att result_stroke.IPW_result.att; result_heart_disease.Slearner_result.att result_stroke.Slearner_result.att; result_heart_disease.Slearner_2d1_result.att result_stroke.Slearner_2d1_result.att; result_heart_disease.Tlearner_result.att result_stroke.Tlearner_result.att; result_heart_disease.matching_result.att result_stroke.matching_result.att]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('ATT (T=hypertension)');
% legend({' heart disease',' stroke'}, 'Orientation', 'horizontal', 'Location', 'northoutside');
legend({' heart disease',' stroke'}, 'FontSize',12);

set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-0.01 0.08]);
grid on;
box on;
hold off;

subplot(1,3,3);
hold on;
bar([(result_heart_disease.IPW_result.odds_ratio-1)*100 (result_stroke.IPW_result.odds_ratio-1)*100; (result_heart_disease.Slearner_result.odds_ratio-1)*100 (result_stroke.Slearner_result.odds_ratio-1)*100; (result_heart_disease.Slearner_2d1_result.odds_ratio-1)*100 (result_stroke.Slearner_2d1_result.odds_ratio-1)*100; (result_heart_disease.Tlearner_result.odds_ratio-1)*100 (result_stroke.Tlearner_result.odds_ratio-1)*100; (result_heart_disease.matching_result.odds_ratio-1)*100 (result_stroke.matching_result.odds_ratio-1)*100]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('% Risk increase (T=hypertension)');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-20 100]);
grid on;
box on;
hold off;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% T = residence type
% Y = Heart disease; Stroke
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% treatment - modified risk factor: residence type (rural/urban)
% outcome - heart disease
result_heart_disease    = calc_ATT(input_data, 'Residence_type', 'heart_disease', 'Urban');
% outcome - stroke
result_stroke           = calc_ATT(input_data, 'Residence_type', 'stroke', 'Urban');

figure;
subplot(1,3,1);
hold on;
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_treated));
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_untreated));
xlabel('Propensity score');
ylabel('Number of propensities (T=rural residence)');
legend({' treated',' untreated'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
grid on;
box on;
hold off;

subplot(1,3,2);
hold on;
bar([result_heart_disease.IPW_result.att result_stroke.IPW_result.att; result_heart_disease.Slearner_result.att result_stroke.Slearner_result.att; result_heart_disease.Slearner_2d1_result.att result_stroke.Slearner_2d1_result.att; result_heart_disease.Tlearner_result.att result_stroke.Tlearner_result.att; result_heart_disease.matching_result.att result_stroke.matching_result.att]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('ATT (T=rural residence)');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-0.01 0.08]);
grid on;
box on;
hold off;

subplot(1,3,3);
hold on;
bar([(result_heart_disease.IPW_result.odds_ratio-1)*100 (result_stroke.IPW_result.odds_ratio-1)*100; (result_heart_disease.Slearner_result.odds_ratio-1)*100 (result_stroke.Slearner_result.odds_ratio-1)*100; (result_heart_disease.Slearner_2d1_result.odds_ratio-1)*100 (result_stroke.Slearner_2d1_result.odds_ratio-1)*100; (result_heart_disease.Tlearner_result.odds_ratio-1)*100 (result_stroke.Tlearner_result.odds_ratio-1)*100; (result_heart_disease.matching_result.odds_ratio-1)*100 (result_stroke.matching_result.odds_ratio-1)*100]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('% Risk increase (T=rural residence)');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-20 100]);
grid on;
box on;
hold off;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% T = avg glucose level
% Y = Heart disease; Stroke
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% treatment - modified risk factor: average glucose levels
% outcome - heart disease
result_heart_disease    = calc_ATT(input_data, 'avg_glucose_level', 'heart_disease', 200);
% outcome - stroke
result_stroke           = calc_ATT(input_data, 'avg_glucose_level', 'stroke', 200);

figure;
subplot(1,3,1);
hold on;
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_treated));
histogram(result_heart_disease.propensity_score(result_heart_disease.ind_of_untreated));
xlabel('Propensity score');
ylabel('Number of propensities (T=glucose>200)');
legend({' treated',' untreated'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
grid on;
box on;
hold off;

subplot(1,3,2);
hold on;
bar([result_heart_disease.IPW_result.att result_stroke.IPW_result.att; result_heart_disease.Slearner_result.att result_stroke.Slearner_result.att; result_heart_disease.Slearner_2d1_result.att result_stroke.Slearner_2d1_result.att; result_heart_disease.Tlearner_result.att result_stroke.Tlearner_result.att; result_heart_disease.matching_result.att result_stroke.matching_result.att]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('ATT (T=glucose>200)');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-0.01 0.08]);
grid on;
box on;
hold off;

subplot(1,3,3);
hold on;
bar([(result_heart_disease.IPW_result.odds_ratio-1)*100 (result_stroke.IPW_result.odds_ratio-1)*100; (result_heart_disease.Slearner_result.odds_ratio-1)*100 (result_stroke.Slearner_result.odds_ratio-1)*100; (result_heart_disease.Slearner_2d1_result.odds_ratio-1)*100 (result_stroke.Slearner_2d1_result.odds_ratio-1)*100; (result_heart_disease.Tlearner_result.odds_ratio-1)*100 (result_stroke.Tlearner_result.odds_ratio-1)*100; (result_heart_disease.matching_result.odds_ratio-1)*100 (result_stroke.matching_result.odds_ratio-1)*100]);
xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
xtickangle(45);
ylabel('% Risk increase (T=glucose>200)');
legend({' heart disease',' stroke'}, 'FontSize',12);
set(gcf,'color','w');
set(gca,'FontSize',17);
ylim([-20 100]);
grid on;
box on;
hold off;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% sensitivity analysis of glucose levels
% T = avg glucose level
% Y = Heart disease; Stroke
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% treatment - modified risk factor: smoking
% outcome - heart disease
step_for_sensitivity_analysis = 50;
result_heart_disease_with_glucose_level_filtering   = cell(0);
result_stroke_with_glucose_level_filtering          = cell(0);
figure;
cntr=1;
for(glucose_levels=120:step_for_sensitivity_analysis:270)
    input_data_with_glucose_level_filtering = input_data(input_data.avg_glucose_level<glucose_levels,:);
    % outcome - heart disease
    result_heart_disease_with_glucose_level_filtering{end+1}    = calc_ATT(input_data_with_glucose_level_filtering, 'avg_glucose_level', 'heart_disease', glucose_levels-step_for_sensitivity_analysis);    
    % outcome - stroke
    result_stroke_with_glucose_level_filtering{end+1}           = calc_ATT(input_data_with_glucose_level_filtering, 'avg_glucose_level', 'stroke', glucose_levels-step_for_sensitivity_analysis);    
    
    subplot(2,4,cntr);
    hold on;
    histogram(result_heart_disease_with_glucose_level_filtering{end}.propensity_score(result_heart_disease_with_glucose_level_filtering{end}.ind_of_treated));
    histogram(result_heart_disease_with_glucose_level_filtering{end}.propensity_score(result_heart_disease_with_glucose_level_filtering{end}.ind_of_untreated));
    xlabel('Propensity score');
    ylabel(sprintf('Number of propensities',glucose_levels));
    legend({sprintf(' %d<Glucose<%d', glucose_levels-step_for_sensitivity_analysis, glucose_levels),sprintf(' Glucose<%d', glucose_levels-step_for_sensitivity_analysis)}, 'FontSize',11);
    set(gcf,'color','w');
    set(gca,'FontSize',12);
    grid on;
    box on;
    hold off;

    subplot(2,4,cntr+4);
    hold on;
    bar([result_heart_disease_with_glucose_level_filtering{end}.IPW_result.att result_stroke_with_glucose_level_filtering{end}.IPW_result.att; result_heart_disease_with_glucose_level_filtering{end}.Slearner_result.att result_stroke_with_glucose_level_filtering{end}.Slearner_result.att; result_heart_disease_with_glucose_level_filtering{end}.Slearner_2d1_result.att result_stroke_with_glucose_level_filtering{end}.Slearner_2d1_result.att; result_heart_disease_with_glucose_level_filtering{end}.Tlearner_result.att result_stroke_with_glucose_level_filtering{end}.Tlearner_result.att; result_heart_disease_with_glucose_level_filtering{end}.matching_result.att result_stroke_with_glucose_level_filtering{end}.matching_result.att]);
    xticks([1 2 3 4 5]);
    xticklabels({'IPW' 'S-learner' 'S-learner 2d+1' 'T-learner' 'Matching'});
    xtickangle(45);
    ylabel(sprintf('ATT (T=%d<glucose<%d vs. <%d)', glucose_levels-step_for_sensitivity_analysis, glucose_levels, glucose_levels-step_for_sensitivity_analysis));
    legend({' heart disease',' stroke'}, 'FontSize',10);
    set(gcf,'color','w');
    set(gca,'FontSize',12);
    ylim([-0.01 0.1]);
    grid on;
    box on;
    hold off;

    cntr = cntr+1;    
end
