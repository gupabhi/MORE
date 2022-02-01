function plot_error(predictions, num_shuffle, color, output_folder)
% Given all the predicted, actual, control respponses - plot error
% violin between predicted and actual error for each odorant receptors

%% Initialize some variables
ORs = unique(predictions.OR);
num_ORs = size(ORs,1);

%% Compute error values
% error_pred = cell2table(cell(0,2), 'VariableNames', {'OR', 'Error'});
% error_ctrl = cell2table(cell(0,2), 'VariableNames', {'OR', 'Error'});
% 
% for i = 1:num_ORs
%     OR = ORs{i,1};
%     idx_OR = find(strcmp(predictions.OR, OR));
%     
%     % calculate predicted error
%     error = mean(predictions.D_Pred_Act(idx_OR, 1));
%     error_pred = [error_pred; {OR, error}];
%     
%     % calculate control error
%     error = mean(predictions.D_Ctrl_Act(idx_OR, 1));
%     error_ctrl = [error_ctrl; {OR, error}];
%     
% end
% 
% save(strcat(output_folder, 'error_pred.mat'), 'error_pred');
% save(strcat(output_folder, 'error_ctrl.mat'), 'error_ctrl');

load(strcat(output_folder, 'error_pred.mat'), 'error_pred');
load(strcat(output_folder, 'error_ctrl.mat'), 'error_ctrl');

%% Plot Violins
% % plot - (predicted_error - ctrl_error)
% input = error_pred.Error - error_ctrl.Error;
% bandwidth = 15;
% label = 'Error(Pred)- Error(Ctrl)';
% savename = 'plot_violin_error_pred_ctrl';
% plot_violin(input, label, bandwidth, color.b, savename, output_folder)

% plot pairwise correlation 
x = repmat({'Ctrl', 'Pred'}, num_ORs, 1);
y = [error_ctrl.Error, error_pred.Error];
z = [error_ctrl.OR, error_pred.OR];
ttl = ''; xlbl = ''; ylbl = 'Error';
savename = 'plot_comparison_error_pred_ctrl';
plot_paired_comparison(x, y, z, ttl, xlbl, ylbl, color.g, savename, output_folder)


end

