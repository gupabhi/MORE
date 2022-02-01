function output = get_odor_properties(data, properties, savename, output_folder)

%% get odors cid
cids = read_csv('./input/2019_10_28_odor_cid.csv');
cids.odor = lower(cids.odor);
cids((sum(ismissing(cids),2)>0), :) = [];   % remove rows with NaN

%% get properties of all unique odors in the dataset
% odors = unique(data.odor);
% 
% flag = 1;
% for i = 1:size(odors,1)
%     fprintf('%d %s\n', i, odors{i});
%     
%     idx = strcmp(cids.odor, odors{i});
%     
%     if sum(idx) == 1
%         
%         prop = pubchem(cids.cid(idx), properties);
%  
%         % Initialize output table
%         while flag == 1
%             propNames = fieldnames(prop);
%             
%             T = cell2table(cell(size(odors,1),size(propNames,1) + 2));
%             T.Properties.VariableNames = horzcat({'odor', 'cid'}, propNames');
%             
%             flag = 0; 
%         end
%         
%         T.odor{i} = cids.odor{idx}; T.cid{i} = cids.cid(idx); 
%         for p = 1:size(propNames, 1)
%             propValue = prop.(propNames{p});
%             
%             if ~isnan(str2double(propValue))
%                 T.(propNames{p})(i) = {str2double(propValue)};
%             else
%                 T.(propNames{p})(i) = {propValue};
%             end       
%         end
%         
%     end
% 
% end
% emptyCells = cellfun(@isempty,T.odor); T(emptyCells, :) = [];
% save(sprintf('%s%s_odor_properties.mat', output_folder, savename), 'T');

load(sprintf('%s%s_odor_properties.mat', output_folder, savename), 'T');

%% add properties to input table
for i = 1:size(data,1)
   idx = strcmp(T.odor, data.odor(i));
   if sum(idx) == 1
       for j = 1:size(properties,2)
           data.(properties{j}){i} = T.(properties{j}){idx};
       end
   end
   
end
output = data;

newName = sprintf('%s_w_prop', savename);
a.(newName) = data;
save(sprintf('%s%s_w_prop.mat', output_folder, savename), '-struct', 'a',newName);

end

