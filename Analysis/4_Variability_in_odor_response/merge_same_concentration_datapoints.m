%% Merge odor datapoints with same concentration 
% Input: table with odor data
% Ouput: table with merged odor data
function out_data = merge_same_concentration_datapoints(data)

data.reference = string(data.reference);

out_data = array2table(zeros(0,size(data.Properties.VariableNames,2)));
out_data.Properties.VariableNames = data.Properties.VariableNames;
    
concs = unique(data.concentration);
for i = 1:size(concs,1)
   conc_data = data(data.concentration == concs(i), :);
   
   if size(conc_data,1) > 1
      row = conc_data(1,:);
      row.response = mean(conc_data.response);
      row.reference = strjoin(conc_data.reference, ',');
      
      out_data = [out_data; row]; 

   else

      row = conc_data(1,:);
      out_data = [out_data; row];
   end
end

end
