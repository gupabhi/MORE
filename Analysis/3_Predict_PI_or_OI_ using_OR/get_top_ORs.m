function corr_mat = get_top_ORs(data, color, tag_name, output_folder)

ors = data.Properties.VariableNames(1:end-3);

varTypes = {'string','double'}; varNames = {'or','r'};
corr_pi_or = table('Size',[size(ors,2) size(varNames,2)],'VariableTypes',varTypes,'VariableNames',varNames);

for i = 1:size(ors,2)
    
    [r_value,~] = corrcoef(data.response, table2array(data(:,ors{i})));
    corr_pi_or(i,'or') = ors(i);
    corr_pi_or(i,'r') = {r_value(1,2)};

end

corr_mat = corr_pi_or; 
corr_mat(:,'r') = array2table(abs(corr_mat{:,'r'})); 
corr_mat = sortrows(corr_mat,'r', 'descend');
% 
% x = categorical(table2array(corr_mat(:,'or'))); y = table2array(corr_mat(:,'r'));
% plot_bar(x, y, color, strcat(tag_name, '_OR'), 'OR', 'Correlation between Index and OR Responses', ...
%             strcat(tag_name, '_OR'), output_folder)

end

