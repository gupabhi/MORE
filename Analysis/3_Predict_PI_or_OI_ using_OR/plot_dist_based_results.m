function plot_dist_based_results(pred_resp, act_resp, color, tagname, output_folder)

%% get shuffle control matrix
num_trial = 50;
[shuff_act_data, ~] = shuffle_matrices(act_resp, num_trial);

%% 
xlbl = ''; ylbl = 'Error w.r.t Actual Preference Index'; 
savename = sprintf('comparison_pred_act_%s', tagname);


ttl = '';
y = [shuff_act_data abs(pred_resp - act_resp)]; 
x = repmat({'Control' 'Predicted'}, size(y,1), 1);
z = repmat(1:size(y,1), 2, 1)';
plot_pairwise_comparison(x, y, z, ttl, xlbl, ylbl, color, savename, output_folder)

end

