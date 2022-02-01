function plot_correlation(predictions, num_shuffle, color, output_folder)
% Given all the predicted, actual, control respponses - plot correlation
% violin between pred/ctrl and actual responses for each odorant receptors

%% Initialize some variables
ORs = unique(predictions.OR);
num_ORs = size(ORs,1);
allVariablesName = predictions.Properties.VariableNames;

%% Compute correlation values
% corr_pred_act = cell2table(cell(0,3), 'VariableNames', {'OR', 'r', 'p'});
% corr_ctrl_act = cell2table(cell(0,2), 'VariableNames', {'OR', 'r'});
% 
% for i = 1:num_ORs
%     OR = ORs{i,1};
%     idx_OR = find(strcmp(predictions.OR, OR));
%     
%     %%% calculate [r,p] between pred and act
%     pred_resp = predictions.Pred(idx_OR,1);
%     act_resp = predictions.Act(idx_OR,1);
%     [r,p] = corrcoef(pred_resp, act_resp);
%     
%     % add to table
%     corr_pred_act = [corr_pred_act; {OR, r(1,2), p(1,2)}];
%     clearvars r p;
%     
%     %%% calculate [r,p] between all ctrls and act
%     corr_for_all_shuffle_trials = [];     % temperory variable to store all the r & p values
%     for j = 1:num_shuffle
%         shuffName = strcat('Shuffle', string(j));
%         idx_shuff_col = find(strcmp(allVariablesName, shuffName));
%         
%         ctrl_resp = predictions{idx_OR, idx_shuff_col};
%         [r,~] = corrcoef(ctrl_resp, act_resp);
%         corr_for_all_shuffle_trials = [corr_for_all_shuffle_trials; r(1,2)];
%     end
%     
%     % add to table
%     corr_ctrl_act = [corr_ctrl_act; {OR, mean(corr_for_all_shuffle_trials)}];
%     clearvars r p;
% end
% 
% save(strcat(output_folder, 'corr_pred_act.mat'), 'corr_pred_act');
% save(strcat(output_folder, 'corr_ctrl_act.mat'), 'corr_ctrl_act');
% 
load(strcat(output_folder, 'corr_pred_act.mat'), 'corr_pred_act');
load(strcat(output_folder, 'corr_ctrl_act.mat'), 'corr_ctrl_act');

%% Plot Violins
% % corrleation b/w predicted and actual
% input = corr_pred_act.r;
% bandwidth = 0.2;
% label = 'Corr(Pred,Actual)';
% savename = 'plot_violin_corr_pred_act';
% plot_violin(input, label, bandwidth, color.b, savename, output_folder)

% % correlation b/w control and actual
% input = corr_ctrl_act.r;
% bandwidth = 0.2;
% label = 'Corr(Ctrl,Actual)';
% savename = 'plot_violin_corr_ctrl_act';
% plot_violin(input, label, bandwidth, color.b, savename, output_folder)

% plot pairwise correlation 
x = repmat({'Ctrl', 'Pred'}, num_ORs, 1);
y = [corr_ctrl_act.r, corr_pred_act.r];
z = [corr_ctrl_act.OR, corr_pred_act.OR];
ttl = ''; xlbl = ''; ylbl = 'Correlation with Actual Response';
savename = 'plot_comparison_corr_pred_ctrl';
plot_paired_comparison(x, y, z, ttl, xlbl, ylbl, color.g, savename, output_folder)


end

