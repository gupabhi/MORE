% Goal: check how close the predicted preference index (predicted using weights from the regression model)
%        to the actual preference index
% input: 'mat_reg' contains the regression matrix with PI and OR response; 
%        'mat_glm' contains the trained model output 
% output: plots of predicted and actual

function plot_pred_act_behvr(pred_regmat, color, save_tag_name, output_folder)

data_fields = fieldnames(pred_regmat);
for i = 1:size(data_fields)
   subdata_fields = fieldnames(pred_regmat.(data_fields{i})); 
   for j = 1:size(subdata_fields)
       pred_resp = pred_regmat.(data_fields{i}).(subdata_fields{j}).pred;
       act_resp = pred_regmat.(data_fields{i}).(subdata_fields{j}).response;
       
       ttl = sprintf('%s_%s_%s', data_fields{i}, subdata_fields{j}, save_tag_name);
       savename = sprintf('scatter_pred_act_PI_%s_%s_%s', data_fields{i}, subdata_fields{j}, save_tag_name);
       plot_scatter(act_resp, pred_resp, color, ttl, ...
                 'Actual preference index', 'Predicted preference index', savename, output_folder, 1);
    end
end

end

