% plot scatter plot between a property(like: molecular weight) of odor and response of the ORs
function plot_prop_resp(prop_data, resp_data, scatter_dot_size, color, specie, output)

num_OR = size(resp_data,2);
prop = prop_data.Properties.VariableNames(1,1); prop = prop{1};

mkdir(sprintf('%s%s', output, prop));
output_folder = sprintf('%s%s/', output, prop);

% for i = 1:num_OR
%     OR = resp_data.Properties.VariableNames(1, i); OR = OR{1};
%     x = table2array(prop_data(:, prop)); 
%     y = table2array(resp_data(:, OR));
%     
%     save_name = OR;
%     Title = OR; x_label = prop; y_label = 'Odorant receptor response';
%     scatter_plot(cell2mat(x), y, scatter_dot_size, color, Title, x_label, y_label, save_name, output_folder)
% end
all_prop = table2array(repmat(prop_data(:, prop), 1, num_OR));
all_resp = table2array(resp_data);

save_name = sprintf('%s_%s', specie, 'all_ORs');
Title = save_name; x_label = prop; y_label = 'Odorant receptor response';
plot_scatter(cell2mat(all_prop(:)), all_resp(:), scatter_dot_size, color, Title, x_label, y_label, save_name, output_folder)

end

